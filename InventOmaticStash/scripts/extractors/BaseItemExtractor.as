package extractors
{
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.*;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.JSONDecoder;
   import com.adobe.serialization.json.JSONEncoder;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.*;
   import utils.*;
   
   public class BaseItemExtractor
   {
      
      protected static var itemCardEntries:Object = {};
      
      protected static var DEFAULT_DELAY:Number = 1000;
      
      protected static var ITEM_CARD_ENTRY_DELAY_STEP:Number = 100;
      
      protected var secureTrade:Object;
      
      protected var playerInventory:Array = [];
      
      protected var stashInventory:Array = [];
      
      protected var version:Number;
      
      protected var modName:String;
      
      protected var _verboseOutput:Boolean = false;
      
      protected var _apiMethods:Array = [];
      
      protected var _additionalItemDataForAll:Boolean = false;
      
      protected var _filterTypes:Array = [];
      
      protected var _modNameToUse:String;
      
      protected var _extractConfig:*;
      
      public function BaseItemExtractor(param1:Object, param2:String, param3:Number)
      {
         super();
         this.secureTrade = param1;
         this.modName = param2;
         this.version = param3;
         this._modNameToUse = param2;
         GameApiDataExtractor.subscribeInventoryItemCardData(this.onInventoryItemCardDataUpdate);
      }
      
      protected static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      public function getExtractorName() : String
      {
         return this.modName + " v" + this.version;
      }
      
      public function init(extractConfig:Object) : void
      {
         this._verboseOutput = extractConfig.verboseOutput;
         this._apiMethods = extractConfig.apiMethods;
         this._additionalItemDataForAll = extractConfig.additionalItemDataForAll;
         if(extractConfig.types && extractConfig.types.length > 0)
         {
            this._filterTypes = extractConfig.types;
         }
         ITEM_CARD_ENTRY_DELAY_STEP = Parser.parsePositiveNumber(extractConfig.itemCardEntryDelayStep,ITEM_CARD_ENTRY_DELAY_STEP);
         this._extractConfig = extractConfig;
      }
      
      public function setInventory(param1:MovieClip) : void
      {
         var delay:Number;
         var parent:MovieClip = param1;
         this.playerInventory = [];
         this.stashInventory = [];
         if(!this.isSfeDefined())
         {
            this.ShowHUDMessage("SFE cannot be found. Items extraction cancelled.",true);
            Logger.get().error("SFE cannot be found. Items extraction cancelled.");
            return;
         }
         Logger.get().info("Item extractor selected: " + this.modName);
         Logger.get().info("Starting gathering items data from inventory!");
         delay = this.populateItemCards(parent,parent.PlayerInventory_mc,false,this.playerInventory);
         setTimeout(function():void
         {
            var delay2:Number;
            Logger.get().info("Starting gathering items data from stash!");
            delay2 = populateItemCards(parent,parent.OfferInventory_mc,true,stashInventory);
            setTimeout(function():void
            {
               Logger.get().info("Building output object...");
               try
               {
                  populateItemCardEntries(playerInventory);
                  populateItemCardEntries(stashInventory);
                  extractItems();
               }
               catch(e:Error)
               {
                  ShowHUDMessage("Error building output object " + e,true);
                  Logger.get().error("Error building output object " + e);
               }
            },delay2);
         },delay);
      }
      
      protected function populateItemCardEntries(param1:Array) : void
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
      
      protected function populateItemCards(param1:MovieClip, param2:SecureTradeInventory, param3:Boolean, param4:Array) : Number
      {
         var delay:Number = NaN;
         var parent:MovieClip = param1;
         var inventory:SecureTradeInventory = param2;
         var fromContainer:Boolean = param3;
         var output:Array = param4;
         var inv:Array = inventory.ItemList_mc.List_mc.MenuListData;
         delay = ITEM_CARD_ENTRY_DELAY_STEP;
         inv.forEach(function(param1:Object):void
         {
            var item:Object = param1;
            item.ItemCardEntries = [];
            if(isValidType(item))
            {
               if(Boolean(item.isLegendary) || _additionalItemDataForAll)
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
               else
               {
                  output.push(item);
               }
            }
         });
         return delay + DEFAULT_DELAY;
      }
      
      private function clone(param1:Object) : Object
      {
         var str:String = null;
         var object:Object = param1;
         try
         {
            str = toString(object);
            return new JSONDecoder(str,true).getValue();
         }
         catch(e:Error)
         {
            ShowHUDMessage("Error cloning object: " + e,true);
            Logger.get().error("Error cloning object: " + e);
         }
         return {};
      }
      
      public function extractItems() : void
      {
         var itemsModIni:Object = null;
         try
         {
            if(!this.isSfeDefined())
            {
               this.ShowHUDMessage("SFE cannot be found. Items extraction cancelled.",true);
               Logger.get().error("SFE cannot be found. Items extraction cancelled.");
               return;
            }
            this.ShowHUDMessage("Starting item extraction!",true);
            Logger.get().info("Starting item extraction!");
            itemsModIni = this.buildOutputObject();
            this.writeData(itemsModIni is String ? itemsModIni : toString(itemsModIni));
         }
         catch(e:Error)
         {
            ShowHUDMessage("Error extracting items(core): " + e,true);
            Logger.get().error("Error extracting items(core): " + e);
         }
      }
      
      public function set apiMethods(param1:Array) : void
      {
         this._apiMethods = param1;
      }
      
      public function set additionalItemDataForAll(param1:Boolean) : void
      {
         this._additionalItemDataForAll = param1;
      }
      
      public function set verboseOutput(param1:Boolean) : void
      {
         this._verboseOutput = param1;
      }
      
      public function buildOutputObject() : Object
      {
         return {
            "modName":this.modName,
            "version":this.version
         };
      }
      
      public function isSfeDefined() : Boolean
      {
         return this.secureTrade.__SFCodeObj != null && this.secureTrade.__SFCodeObj.call != null;
      }
      
      protected function writeData(param1:String) : void
      {
         var data:String = param1;
         try
         {
            if(this.isSfeDefined())
            {
               this.secureTrade.__SFCodeObj.call("writeItemsModFile",data);
               this.ShowHUDMessage("Done saving items!",true);
               Logger.get().info("Done saving items!");
            }
            else
            {
               this.ShowHUDMessage("Cannot find SFE, writing to file cancelled!",true);
               Logger.get().error("Cannot find SFE, writing to file cancelled!");
            }
         }
         catch(e:Error)
         {
            ShowHUDMessage("Error saving items! " + e,true);
            Logger.get().error("Error saving items! " + e);
         }
      }
      
      public function ShowHUDMessage(param1:String, param2:Boolean = false) : void
      {
         if(this._verboseOutput || param2)
         {
            GlobalFunc.ShowHUDMessage("[" + this.modName + " v" + this.version + "] " + param1);
         }
      }
      
      public function isValidMode(param1:uint) : Boolean
      {
         return false;
      }
      
      private function isValidType(item:Object) : Boolean
      {
         var matchingFilterFlags:Array = [];
         var i:int = 0;
         try
         {
            if(!Boolean(_filterTypes) || _filterTypes.length == 0)
            {
               return true;
            }
            while(i < _filterTypes.length)
            {
               matchingFilterFlags = matchingFilterFlags.concat(ItemTypes.ITEM_TYPES[_filterTypes[i]]);
               i++;
            }
            return matchingFilterFlags.indexOf(item.filterFlag) !== -1;
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error checking type",e);
         }
         return false;
      }
      
      public function getInvalidModeMessage() : String
      {
         return "Invalid mode";
      }
      
      public function showInvalidModeMessage() : void
      {
         this.ShowHUDMessage(this.getInvalidModeMessage());
      }
      
      private function onInventoryItemCardDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         itemCardEntries[_loc2_.serverHandleID] = this.clone(_loc2_);
      }
   }
}

