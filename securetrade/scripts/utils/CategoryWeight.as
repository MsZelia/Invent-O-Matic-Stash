package utils
{
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.ListFilterer;
   import Shared.GlobalFunc;
   import extractors.GameApiDataExtractor;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class CategoryWeight
   {
      
      private static var secureTrade:Object;
      
      private static var itemCardEntries:Object = {};
      
      private static const ITEM_FILTER_WEAPONS:uint = 4;
      
      private static const DEFAULT_DELAY:Number = 250;
      
      private static var ITEM_CARD_ENTRY_DELAY_STEP:Number = 50;
      
      private static var weaponWt:String = "";
      
      public function CategoryWeight()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         if(config.categoryWeightConfig && config.categoryWeightConfig.enabled)
         {
            secureTrade = param1;
            GameApiDataExtractor.subscribeInventoryItemCardData(onInventoryItemCardDataUpdate);
            secureTrade.OfferInventory_mc.OfferWeight_tf.width = config.categoryWeightConfig.weightLabelWidth;
            secureTrade.PlayerInventory_mc.PlayerWeight_tf.width = config.categoryWeightConfig.weightLabelWidth;
         }
      }
      
      private static function get config() : Object
      {
         return InventOmaticConfig.get();
      }
      
      private static function GetWeightInInventory(entries:Array) : Number
      {
         for each(var entry in entries)
         {
            if(entry.text == "$wt")
            {
               return Number(entry.value);
            }
         }
         return 0;
      }
      
      private static function GetWeightInStash(entries:Array) : Number
      {
         var wt:Number = 0;
         for each(var entry in entries)
         {
            if(entry.text == "$WeightInStash")
            {
               return Number(entry.value);
            }
            if(entry.text == "$wt")
            {
               wt = Number(entry.value);
            }
         }
         return wt;
      }
      
      public static function updateWeightLabels() : void
      {
         if(!secureTrade || !config.categoryWeightConfig || !config.categoryWeightConfig.enabled)
         {
            return;
         }
         var itemFilter:uint = uint(secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
         if(itemFilter != 0)
         {
            var t1:Number = getTimer();
            var tabWt:String = itemFilter == ITEM_FILTER_WEAPONS && weaponWt.length ? weaponWt : calcListWeight(secureTrade.PlayerInventory_mc.ItemList_mc.List_mc,false);
            secureTrade.PlayerInventory_mc.PlayerWeight_tf.text = secureTrade.PlayerInventory_mc.carryWeightCurrent + "/" + secureTrade.PlayerInventory_mc.carryWeightMax + " [" + tabWt + "]";
            tabWt = calcListWeight(secureTrade.OfferInventory_mc.ItemList_mc.List_mc,true);
            secureTrade.OfferInventory_mc.OfferWeight_tf.text = secureTrade.OfferInventory_mc.carryWeightCurrent + "/" + secureTrade.OfferInventory_mc.carryWeightMax + " [" + tabWt + "]";
            var t2:Number = getTimer();
            if(config.categoryWeightConfig.debug)
            {
               Logger.get().info("Tab weight calc in " + (t2 - t1) + "ms");
            }
         }
      }
      
      private static function calcListWeight(listMc:*, isStash:Boolean = false) : String
      {
         var entryList:* = listMc.entryList;
         var bailoutCounter:int = 5000;
         var tabWeight:Number = 0;
         var entry:Object = null;
         var filterer:ListFilterer = listMc.filterer;
         var idx:int = filterer.GetNextFilterMatch(-1);
         if(isStash)
         {
            while(idx != int.MAX_VALUE && Boolean(bailoutCounter--))
            {
               entry = entryList[idx];
               tabWeight += entry.weightInStash * entry.count;
               idx = filterer.GetNextFilterMatch(idx);
            }
         }
         else
         {
            while(idx != int.MAX_VALUE && Boolean(bailoutCounter--))
            {
               entry = entryList[idx];
               tabWeight += entry.weight * entry.count;
               idx = filterer.GetNextFilterMatch(idx);
            }
         }
         if(bailoutCounter <= 0)
         {
            Logger.get().warn("calcListWeight bailed out");
         }
         return int(tabWeight) == tabWeight ? tabWeight.toFixed(0) : tabWeight.toFixed(1);
      }
      
      private static function calcWeaponItemCards(inventory:Array) : void
      {
         var tabWeight:Number = 0;
         var count:int = 0;
         var i:int = 0;
         while(i < inventory.length)
         {
            var item:Object = inventory[i];
            if(itemCardEntries[item.serverHandleID])
            {
               count++;
               var weight:Number = Number(GetWeightInInventory(itemCardEntries[item.serverHandleID].itemCardEntries) || Number(item.weight));
            }
            else
            {
               weight = Number(item.weight);
            }
            tabWeight += weight * item.count;
            i++;
         }
         weaponWt = int(tabWeight) == tabWeight ? tabWeight.toFixed(0) : tabWeight.toFixed(1);
         if(config.categoryWeightConfig.debug)
         {
            Logger.get().info("weaponWt: " + weaponWt + " (" + count + " item cards)");
         }
      }
      
      public static function calculateWeaponCategoryWeight() : Number
      {
         var playerInv:Array;
         var delay:Number = 0;
         var itemFilter:uint = uint(secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
         if(itemFilter != 4)
         {
            return 0;
         }
         ITEM_CARD_ENTRY_DELAY_STEP = Number(config.categoryWeightConfig.itemCardDelay);
         playerInv = filterInventory(secureTrade.PlayerInventory_mc,[ITEM_FILTER_WEAPONS]);
         if(config.categoryWeightConfig.debug)
         {
            Logger.get().info("Gathering weights for " + playerInv.length + " weapons");
         }
         delay = populateItemCards(playerInv,false);
         if(config.categoryWeightConfig.debug)
         {
            Logger.get().info("Populating item cards...");
         }
         setTimeout(function():void
         {
            calcWeaponItemCards(playerInv);
         },delay);
         return delay;
      }
      
      private static function filterInventory(inventory:SecureTradeInventory, filters:Array) : Array
      {
         var output:Array = inventory.ItemList_mc.List_mc.MenuListData.filter(function(item:Object):Object
         {
            return filters.some(function(flag:int):Boolean
            {
               return item.filterFlag & flag;
            });
         });
         return output;
      }
      
      private static function populateItemCards(inventory:Array, fromContainer:Boolean) : Number
      {
         var delay:Number = ITEM_CARD_ENTRY_DELAY_STEP;
         inventory.forEach(function(item:Object):void
         {
            if(!itemCardEntries[item.serverHandleID])
            {
               setTimeout(function():void
               {
                  var itemCardData:Object = null;
                  try
                  {
                     secureTrade.selectedList = fromContainer ? secureTrade.OfferInventory_mc : secureTrade.PlayerInventory_mc;
                     secureTrade.selectedList.Active = true;
                     GameApiDataExtractor.selectItem(item.serverHandleID,fromContainer);
                  }
                  catch(e:Error)
                  {
                     Logger.get().errorHandler("Error getting data for item " + item.text,e);
                  }
               },delay);
               delay += ITEM_CARD_ENTRY_DELAY_STEP;
            }
         });
         return delay + DEFAULT_DELAY;
      }
      
      private static function clone(param1:Object) : Object
      {
         try
         {
            return GlobalFunc.CloneObject(param1);
         }
         catch(e:Error)
         {
            Logger.get().error("Error cloning object: " + e);
         }
         return {};
      }
      
      private static function onInventoryItemCardDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         itemCardEntries[_loc2_.serverHandleID] = clone(_loc2_);
      }
   }
}

