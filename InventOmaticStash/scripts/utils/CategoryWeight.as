package utils
{
   import Shared.AS3.Data.FromClientDataEvent;
   import com.adobe.serialization.json.JSONDecoder;
   import com.adobe.serialization.json.JSONEncoder;
   import extractors.GameApiDataExtractor;
   import flash.display.MovieClip;
   import flash.utils.setTimeout;
   
   public class CategoryWeight
   {
      
      private static var itemCardEntries:Object = {};
      
      private static var DEFAULT_DELAY:Number = 1000;
      
      private static var ITEM_CARD_ENTRY_DELAY_STEP:Number = 50;
      
      private static const ITEM_FILTER_TO_GET_STASH_WEIGHT:Array = [4,8,32,64,8192,32768,270336];
      
      private static var INIT:Boolean = false;
      
      public static var categoryWeights:Object = {};
      
      public static var icategoryWeights:Object = {};
      
      private static var secureTrade:Object;
      
      private static var playerInventory:Array;
      
      private static var stashInventory:Array;
       
      
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
      
      private static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      private static function getSelectedTab() : int
      {
         return secureTrade.selectedTab;
      }
      
      private static function getPlayerInventory() : Array
      {
         return secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData;
      }
      
      private static function getOfferInventory() : Array
      {
         return secureTrade.OfferInventory_mc.ItemList_mc.List_mc.MenuListData;
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
         var itemFilter:int = int(secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
         if(secureTrade.OfferInventory_mc.ItemList_mc.List_mc.filterer.itemFilter > 1)
         {
            if(!INIT)
            {
               setTimeout(calculateInventoryWeight,10);
               INIT = true;
            }
            var wt:String = "";
            var sum:Number = -1;
            var isum:Number = -1;
            var filterName:String = ItemTypes.getName(itemFilter);
            if(config.categoryWeightConfig.debug)
            {
               Logger.get().info("Updating weight labels for: " + filterName + " " + toString(ItemTypes.ITEM_TYPES[filterName]));
            }
            for each(var filter in ItemTypes.ITEM_TYPES[filterName])
            {
               if(icategoryWeights[filter] != null)
               {
                  if(isum == -1)
                  {
                     isum = 0;
                  }
                  isum += icategoryWeights[filter];
               }
               if(categoryWeights[filter] != null)
               {
                  if(sum == -1)
                  {
                     sum = 0;
                  }
                  sum += categoryWeights[filter];
               }
            }
            wt = isum == -1 ? Buttons.getButtonKey(config.categoryWeightConfig.hotkey) : isum.toFixed(1);
            secureTrade.PlayerInventory_mc.PlayerWeight_tf.text = secureTrade.PlayerInventory_mc.carryWeightCurrent + "/" + secureTrade.PlayerInventory_mc.carryWeightMax + " [" + wt + "]";
            wt = sum == -1 ? Buttons.getButtonKey(config.categoryWeightConfig.hotkey) : sum.toFixed(1);
            secureTrade.OfferInventory_mc.OfferWeight_tf.text = secureTrade.OfferInventory_mc.carryWeightCurrent + "/" + secureTrade.OfferInventory_mc.carryWeightMax + " [" + wt + "]";
         }
         else
         {
            secureTrade.PlayerInventory_mc.PlayerWeight_tf.text = secureTrade.PlayerInventory_mc.carryWeightCurrent + "/" + secureTrade.PlayerInventory_mc.carryWeightMax;
            secureTrade.OfferInventory_mc.OfferWeight_tf.text = secureTrade.OfferInventory_mc.carryWeightCurrent + "/" + secureTrade.OfferInventory_mc.carryWeightMax;
         }
      }
      
      private static function getConfigTypes() : Array
      {
         var types:Array = [-1];
         var i:int = 0;
         while(i < config.categoryWeightConfig.itemCardFilters.length)
         {
            types = types.concat(ItemTypes.ITEM_TYPES[config.categoryWeightConfig.itemCardFilters[i]]);
            i++;
         }
         return types;
      }
      
      public static function calculateInventoryWeight(noItemCards:Boolean = true, currentTabOnly:Boolean = false) : void
      {
         var delay:Number;
         var _t:*;
         var parent:Object = secureTrade;
         stashInventory = [];
         playerInventory = [];
         var types:Array = new Array();
         ITEM_CARD_ENTRY_DELAY_STEP = Number(config.categoryWeightConfig.itemCardDelay);
         var itemFilter:int = int(secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
         if(currentTabOnly)
         {
            types = [itemFilter];
         }
         else
         {
            types = getConfigTypes();
         }
         if(config.categoryWeightConfig.debug)
         {
            Logger.get().info("Gathering item weights for types: " + toString(types));
         }
         if(!currentTabOnly)
         {
            delay = populateItemCards(parent,parent.PlayerInventory_mc,true,currentTabOnly ? types : [],false,false,playerInventory);
         }
         delay = populateItemCards(parent,parent.OfferInventory_mc,true,types,noItemCards,currentTabOnly,stashInventory);
         setTimeout(function():void
         {
            try
            {
               populateItemCardEntries(stashInventory);
               if(currentTabOnly)
               {
                  categoryWeights[itemFilter] = 0;
                  if(!currentTabOnly)
                  {
                     icategoryWeights[itemFilter] = 0;
                  }
               }
               else
               {
                  categoryWeights = {};
                  icategoryWeights = {};
               }
               extractItemWeights(false);
               extractItemWeights(true);
               if(config.categoryWeightConfig.debug)
               {
                  Logger.get().info("Finished calculating total weight per category");
               }
               updateWeightLabels();
            }
            catch(e:Error)
            {
               Logger.get().error("Error calculating total weight " + e);
            }
         },delay);
      }
      
      private static function extractItemWeights(param1:Boolean) : void
      {
         var fromContainer:Boolean = param1;
         var i:int = 0;
         var itemcards:int = 0;
         var index:int = fromContainer ? 1 : 0;
         var inventory:Array = fromContainer ? stashInventory : playerInventory;
         var output:Object = fromContainer ? categoryWeights : icategoryWeights;
         var getFunc:Function = fromContainer ? GetWeightInStash : GetWeightInInventory;
         while(i < inventory.length)
         {
            var item:Object = inventory[i];
            if(item.ItemCardEntries && item.ItemCardEntries.length > 0)
            {
               var weight:Number = getFunc(item.ItemCardEntries);
               itemcards++;
            }
            else
            {
               weight = Number(item.weight);
            }
            var filter:String = String(item.filterFlag - int(item.favorite));
            if(!output[filter])
            {
               output[filter] = 0;
            }
            output[filter] += Number(item.count * weight);
            i++;
         }
         if(config.categoryWeightConfig.debug)
         {
            Logger.get().info("Item weights extracted: " + itemcards + "/" + inventory.length + " = " + (inventory.length > 0 ? (100 * itemcards / inventory.length).toFixed(0) : "0") + "% of item card data loaded");
         }
      }
      
      private static function populateItemCardEntries(param1:Array) : void
      {
         var inventory:Array = param1;
         inventory.forEach(function(param1:Object):void
         {
            if(itemCardEntries[param1.serverHandleID])
            {
               param1.ItemCardEntries = itemCardEntries[param1.serverHandleID].itemCardEntries;
            }
         });
      }
      
      public static function calculateCurrentCategoryWeight(fromContainer:Boolean = true) : Number
      {
         var st_inventory:SecureTradeInventory;
         var inventory:Array;
         var delay:Number = 0;
         var i:int = 0;
         var types:Array = getConfigTypes();
         var itemFilter:int = int(secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
         var filterName:String = ItemTypes.getName(itemFilter);
         var getItemCards:Boolean = itemFilter == 4 || types.indexOf(itemFilter) != -1;
         ITEM_CARD_ENTRY_DELAY_STEP = Number(config.categoryWeightConfig.itemCardDelay);
         if(itemFilter < 4)
         {
            return;
         }
         if(fromContainer)
         {
            stashInventory = [];
            st_inventory = secureTrade.OfferInventory_mc;
            filterInventory(st_inventory,ItemTypes.ITEM_TYPES[filterName],false,stashInventory);
            inventory = stashInventory;
         }
         else
         {
            playerInventory = [];
            st_inventory = secureTrade.PlayerInventory_mc;
            filterInventory(st_inventory,ItemTypes.ITEM_TYPES[filterName],false,playerInventory);
            inventory = playerInventory;
         }
         if(config.categoryWeightConfig.debug)
         {
            Logger.get().info("Gathering item weights for current tab: " + filterName + " " + toString(ItemTypes.ITEM_TYPES[filterName]) + ", items: " + inventory.length + ", getItemCards: " + getItemCards);
         }
         if(getItemCards)
         {
            delay = populateItemCardsFiltered(fromContainer);
            if(config.categoryWeightConfig.debug)
            {
               Logger.get().info("Item cards populated");
            }
         }
         setTimeout(function():void
         {
            var filter:*;
            try
            {
               populateItemCardEntries(inventory);
               if(fromContainer)
               {
                  for each(filter in ItemTypes.ITEM_TYPES[filterName])
                  {
                     categoryWeights[filter] = 0;
                  }
               }
               else
               {
                  for each(filter in ItemTypes.ITEM_TYPES[filterName])
                  {
                     icategoryWeights[filter] = 0;
                  }
               }
               extractItemWeights(fromContainer);
               if(config.categoryWeightConfig.debug)
               {
                  Logger.get().info("Finished calculating total weight of current category");
               }
               updateWeightLabels();
            }
            catch(e:Error)
            {
               Logger.get().error("Error calculating total weight " + e);
            }
         },delay);
         return delay + ITEM_CARD_ENTRY_DELAY_STEP;
      }
      
      private static function filterInventory(param1:SecureTradeInventory, param2:Array, param3:Boolean, param4:Array) : void
      {
         var inventory:SecureTradeInventory = param1;
         var filter:Array = param2;
         var inverse:Boolean = param3;
         var output:Array = param4;
         var inv:Array = inventory.ItemList_mc.List_mc.MenuListData;
         inv.forEach(function(param1:Object):void
         {
            var item:Object = param1;
            if(filter.length > 0 && filter.indexOf(int((item.filterFlag | 1) ^ 1)) !== -1)
            {
               if(!inverse)
               {
                  output.push(item);
               }
            }
            else if(inverse)
            {
               output.push(item);
            }
         });
      }
      
      private static function populateItemCardsFiltered(param1:Boolean) : Number
      {
         var delay:Number = ITEM_CARD_ENTRY_DELAY_STEP;
         var fromContainer:Boolean = param1;
         var inventory:Array = fromContainer ? stashInventory : playerInventory;
         inventory.forEach(function(param1:Object):void
         {
            var item:Object = param1;
            item.ItemCardEntries = [];
            setTimeout(function():void
            {
               var itemCardData:Object = null;
               try
               {
                  secureTrade.selectedList = fromContainer ? secureTrade.OfferInventory_mc : secureTrade.PlayerInventory_mc;
                  secureTrade.selectedList.Active = true;
                  GameApiDataExtractor.selectItem(item.serverHandleID,fromContainer);
                  itemCardData = clone(GameApiDataExtractor.getInventoryItemCardData());
                  itemCardEntries[itemCardData.serverHandleID] = itemCardData;
               }
               catch(e:Error)
               {
                  Logger.get().errorHandler("Error getting data for item " + item.text,e);
               }
            },delay);
            delay += ITEM_CARD_ENTRY_DELAY_STEP;
         });
         return delay + DEFAULT_DELAY;
      }
      
      private static function populateItemCards(param1:MovieClip, param2:SecureTradeInventory, param3:Boolean, param4:Array, param5:Boolean, param6:Boolean, param7:Array) : Number
      {
         var delay:Number = NaN;
         var parent:MovieClip = param1;
         var inventory:SecureTradeInventory = param2;
         var fromContainer:Boolean = param3;
         var filter:Array = param4;
         var inverseFilter:Boolean = param5;
         var currentTabOnly:Boolean = param6;
         var output:Array = param7;
         var inv:Array = inventory.ItemList_mc.List_mc.MenuListData;
         delay = ITEM_CARD_ENTRY_DELAY_STEP;
         inv.forEach(function(param1:Object):void
         {
            var item:Object = param1;
            item.ItemCardEntries = [];
            if(filter.length > 0 && filter.indexOf(int((item.filterFlag | 1) ^ 1)) !== -1)
            {
               if(!inverseFilter)
               {
                  setTimeout(function():void
                  {
                     var itemCardData:Object = null;
                     try
                     {
                        parent.selectedList = inventory;
                        inventory.Active = true;
                        GameApiDataExtractor.selectItem(item.serverHandleID,fromContainer);
                        itemCardData = clone(GameApiDataExtractor.getInventoryItemCardData());
                        itemCardEntries[itemCardData.serverHandleID] = itemCardData;
                        output.push(item);
                     }
                     catch(e:Error)
                     {
                        Logger.get().errorHandler("Error getting data for item " + item.text,e);
                     }
                  },delay);
                  delay += ITEM_CARD_ENTRY_DELAY_STEP;
               }
            }
            else if(!currentTabOnly)
            {
               output.push(item);
            }
         });
         return delay + DEFAULT_DELAY;
      }
      
      private static function clone(param1:Object) : Object
      {
         var str:String = null;
         var object:Object = param1;
         try
         {
            str = String(toString(object));
            return new JSONDecoder(str,true).getValue();
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
