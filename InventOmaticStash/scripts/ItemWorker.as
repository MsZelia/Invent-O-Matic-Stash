package
{
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.JSONEncoder;
   import extractors.GameApiDataExtractor;
   import flash.utils.setTimeout;
   import utils.Logger;
   import utils.Parser;
   
   public class ItemWorker
   {
      
      public static const DIRECTION_TO_CONTAINER:String = "TO_CONTAINER";
      
      public static const DIRECTION_FROM_CONTAINER:String = "FROM_CONTAINER";
      
      private static var matchingID:int = -1;
      
      private static var characterName:String;
      
      private static var accountName:String;
      
      private static var containerName:String;
      
      private static var errorCode:String;
       
      
      private var secureTrade:Object;
      
      private var _queue:Vector.<Object>;
      
      private var _queueIndex:int;
      
      private var _queueDebug:Boolean;
      
      public function ItemWorker(param1:Object)
      {
         this.secureTrade = param1;
         _queue = new Vector.<Object>();
         super();
      }
      
      public static function get ContainerName() : String
      {
         return containerName;
      }
      
      public static function set ContainerName(name:String) : void
      {
         containerName = name;
      }
      
      public static function get AccountName() : String
      {
         if(!accountName)
         {
            accountName = GameApiDataExtractor.getAccountInfoData().name;
         }
         return accountName;
      }
      
      public static function get CharacterName() : String
      {
         if(!characterName)
         {
            characterName = GameApiDataExtractor.getCharacterInfoData().name;
         }
         return characterName;
      }
      
      private static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      public static function isMatchingString(param1:String, param2:String, param3:String) : Boolean
      {
         var itemName:String = param1;
         var stringToCompare:String = param2;
         var matchMode:String = param3;
         try
         {
            if(matchMode === MatchMode.ALL)
            {
               return true;
            }
            if(itemName.length < 1 || stringToCompare.length < 1)
            {
               return false;
            }
            switch(matchMode)
            {
               case MatchMode.EXACT:
                  return itemName === stringToCompare;
               case MatchMode.NOT_EXACT:
                  return itemName !== stringToCompare;
               case MatchMode.CONTAINS:
                  return itemName.toLowerCase().indexOf(stringToCompare.toLowerCase()) >= 0;
               case MatchMode.NOT_CONTAINS:
                  return itemName.toLowerCase().indexOf(stringToCompare.toLowerCase()) < 0;
               case MatchMode.STARTS:
                  return itemName.toLowerCase().indexOf(stringToCompare.toLowerCase()) === 0;
               default:
                  Logger.get().error("Invalid match mode: " + matchMode);
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error checking string match mode",e);
         }
         return false;
      }
      
      private static function isMatchingItemName(param1:String, config:Object, isAltItem:Boolean = false) : Boolean
      {
         var stringToCompare:String = null;
         var isMatching:Boolean = false;
         var matchMode:String = String(config.matchMode);
         var itemName:String = param1;
         var INVERSE:Boolean = matchMode === MatchMode.NOT_CONTAINS || matchMode === MatchMode.NOT_EXACT;
         var allMatch:Boolean = true;
         var itemNames:Array = [];
         var i:int = 0;
         while(i < config.itemNames.length)
         {
            if(_config.itemNamesGroupConfig[config.itemNames[i]] != null)
            {
               itemNames = itemNames.concat(_config.itemNamesGroupConfig[config.itemNames[i]]);
            }
            i++;
         }
         itemNames = config.itemNames.concat(itemNames);
         i = 0;
         while(i < itemNames.length)
         {
            if(isAltItem)
            {
               if(!config.altItemNames || config.altItemNames.length < i || config.altItemNames[i] == null || config.altItemNames[i].length == 0 || config.altItemNames[i] == "")
               {
                  return false;
               }
               stringToCompare = String(config.altItemNames[i]);
            }
            else
            {
               stringToCompare = String(itemNames[i]);
            }
            isMatching = isMatchingString(itemName,stringToCompare,matchMode);
            if(INVERSE)
            {
               if(!isMatching)
               {
                  allMatch = false;
                  return false;
               }
            }
            else if(isMatching)
            {
               matchingID = i;
               return true;
            }
            i++;
         }
         if(INVERSE)
         {
            return allMatch;
         }
         return isMatching;
      }
      
      private static function isMatchingType(param1:Object, param2:Object) : Boolean
      {
         var item:Object = param1;
         var config:Object = param2;
         var types:Array = config.types;
         var matchingFilterFlags:Array = [];
         var i:int = 0;
         try
         {
            if(!Boolean(types) || types.length == 0)
            {
               return true;
            }
            while(i < types.length)
            {
               matchingFilterFlags = matchingFilterFlags.concat(ItemTypes.ITEM_TYPES[types[i]]);
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
      
      private static function isValidTypeToScrap(param1:Object, param2:Object) : Boolean
      {
         var item:Object = param1;
         var config:Object = param2;
         var types:Array = config.types;
         var matchingFilterFlags:Array = [];
         var i:int = 0;
         try
         {
            while(i < types.length)
            {
               matchingFilterFlags = matchingFilterFlags.concat(ItemTypes.ITEM_TYPES[types[i]]);
               i++;
            }
            return matchingFilterFlags.indexOf(item.filterFlag) !== -1;
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error checking type for scrap",e);
         }
         return false;
      }
      
      private static function shouldScrap(param1:Object, param2:Object) : Boolean
      {
         var excluded:Array;
         var allMatch:Boolean;
         var matchMode:*;
         var INVERSE:Boolean = false;
         var item:Object = param1;
         var config:Object = param2;
         var matches:Boolean = false;
         var i:int = 0;
         if(!isValidTypeToScrap(item,config))
         {
            return false;
         }
         if(item.favorite && !Boolean(config.scrapFavorite))
         {
            return false;
         }
         if(item.equipState == 1 && !Boolean(config.scrapEquipped))
         {
            return false;
         }
         try
         {
            if(config.matchMode === MatchMode.NOT_CONTAINS)
            {
               INVERSE = true;
               matchMode = MatchMode.CONTAINS;
            }
            else if(config.matchMode === MatchMode.NOT_EXACT)
            {
               INVERSE = true;
               matchMode = MatchMode.EXACT;
            }
            else
            {
               matchMode = config.matchMode;
            }
            excluded = [];
            i = 0;
            while(i < config.excluded.length)
            {
               if(_config.itemNamesGroupConfig[config.excluded[i]] != null)
               {
                  excluded = excluded.concat(_config.itemNamesGroupConfig[config.excluded[i]]);
               }
               i++;
            }
            excluded = config.excluded.concat(excluded);
            i = 0;
            while(i < excluded.length)
            {
               matches = isMatchingString(item.text,excluded[i],matchMode);
               if(INVERSE)
               {
                  if(matches)
                  {
                     matchingID = i;
                     return true;
                  }
               }
               else if(matches)
               {
                  matchingID = i;
                  return false;
               }
               i++;
            }
            if(INVERSE)
            {
               return false;
            }
            return true;
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error checking items for scrapping",e);
         }
         return false;
      }
      
      private static function isItemMatchingConfig(param1:Object, param2:Object, isAlt:Boolean = false) : Boolean
      {
         param3 = String(param1.text);
         if(param3 == null || param3.length < 1 || param3 == "")
         {
            return false;
         }
         if(isAlt)
         {
            return isMatchingItemName(param3,param2,isAlt);
         }
         return isMatchingType(param1,param2) && isMatchingItemName(param3,param2);
      }
      
      public static function isTheSameCharacterName(sectionConfig:Object, debug:Boolean = false) : Boolean
      {
         if(sectionConfig.checkAccountName)
         {
            var configAccountNames:Array = [].concat(sectionConfig.accountName);
            if(configAccountNames.indexOf(AccountName) == -1)
            {
               if(debug)
               {
                  Logger.get().error("Account name not matching in config: " + AccountName + " != " + sectionConfig.accountName);
               }
               return false;
            }
         }
         if(sectionConfig.checkCharacterName)
         {
            var configCharacterNames:Array = [].concat(sectionConfig.characterName);
            if(configCharacterNames.indexOf(CharacterName) == -1)
            {
               if(debug)
               {
                  Logger.get().error("Character name not matching in config: " + CharacterName + " != " + sectionConfig.characterName);
               }
               return false;
            }
         }
         return true;
      }
      
      public static function isValidContainerName(sectionConfig:Object, debug:Boolean = false) : Boolean
      {
         if(sectionConfig.checkContainerName)
         {
            var configContainerNames:Array = [].concat(sectionConfig.containerName);
            if(configContainerNames.indexOf(ContainerName) == -1)
            {
               if(debug)
               {
                  Logger.get().error("Container name not matching in config: " + ContainerName + " != " + sectionConfig.containerName);
               }
               return false;
            }
         }
         return true;
      }
      
      private static function get _config() : Object
      {
         return InventOmaticConfig.get();
      }
      
      private function get _queueValid() : Boolean
      {
         return _queue && _queueIndex < _queue.length && _queue[_queueIndex];
      }
      
      private function get _stashInventory() : Array
      {
         return this.secureTrade.OfferInventory_mc.ItemList_mc.List_mc.MenuListData;
      }
      
      private function get _playerInventory() : Array
      {
         return this.secureTrade.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData;
      }
      
      private function get isSelectedContainer() : Boolean
      {
         return this.secureTrade.selectedList == this.secureTrade.OfferInventory_mc;
      }
      
      public function get _selectedEntry() : Object
      {
         return this.secureTrade.selectedListEntry;
      }
      
      private function getDestinationMap(source:Array) : *
      {
         if(source == null)
         {
            return {};
         }
         var map:* = {};
         var destination:Array = source == _playerInventory ? _stashInventory : _playerInventory;
         var i:int = 0;
         while(i < destination.length)
         {
            map[destination[i].text] = {
               "serverHandleID":destination[i].serverHandleID,
               "count":destination[i].count,
               "containerID":destination[i].containerID
            };
            i++;
         }
         return map;
      }
      
      private function findInDestination(source:Array, text:String) : *
      {
         if(source == null)
         {
            return null;
         }
         var destination:Array = source == _playerInventory ? _stashInventory : _playerInventory;
         var i:int = 0;
         while(i < destination.length)
         {
            if(text == destination[i].text)
            {
               return {
                  "serverHandleID":destination[i].serverHandleID,
                  "count":destination[i].count,
                  "containerID":destination[i].containerID
               };
            }
            i++;
         }
         return null;
      }
      
      private function transferSelected(config:Object) : uint
      {
         var ReturnDelay:uint = 0;
         var selectedItem:Object = this._selectedEntry;
         var fromContainer:Boolean = this.isSelectedContainer;
         var amount:int = 0;
         var isMatching:Boolean = false;
         var transferLegendary:int = 0;
         var delay:uint = 0;
         var repeat:uint = 1;
         _queue = new Vector.<Object>();
         try
         {
            if(selectedItem && config)
            {
               transferLegendary = int(config.transferLegendaries);
               if(!Boolean(config.transferFavorite) && selectedItem.favorite)
               {
                  if(config.debug)
                  {
                     Logger.get().error("Not transferring selected: Favorite");
                  }
                  return 0;
               }
               if(!Boolean(config.transferEquipped) && selectedItem.equipState == 1)
               {
                  if(config.debug)
                  {
                     Logger.get().error("Not transferring selected: Equipped");
                  }
                  return 0;
               }
               if(!Boolean(config.transferAssigned) && selectedItem.vendingData && selectedItem.vendingData.machineType != 0)
               {
                  if(config.debug)
                  {
                     Logger.get().error("Not transferring selected: Assigned");
                  }
                  return 0;
               }
               isMatching = isItemMatchingConfig(selectedItem,config);
               if(Boolean(transferLegendary) && selectedItem.numLegendaryStars >= transferLegendary || isMatching)
               {
                  amount = getAmount(int(config.amount),selectedItem.count);
                  if(amount != 0)
                  {
                     if(config.debug)
                     {
                        Logger.get().info("Selected item queued: " + selectedItem.text + " (" + amount + ")");
                     }
                     _queue.push({
                        "text":selectedItem.text,
                        "serverHandleID":selectedItem.serverHandleID,
                        "containerID":selectedItem.containerID,
                        "count":amount,
                        "fromContainer":fromContainer
                     });
                  }
                  else if(config.debug)
                  {
                     Logger.get().error("Not transferring selected: Amount 0");
                  }
               }
               else if(config.debug)
               {
                  Logger.get().error("Not transferring selected: Not matching");
               }
            }
            else
            {
               Logger.get().error("Not transferring selected: Invalid config/No selected item");
            }
            if(Parser.parseBoolean(config.testRun,false))
            {
               showTestRun("TRANSFER (" + config.name + ")");
               return 0;
            }
            delay = Parser.parsePositiveNumber(config.delay);
            repeat = Parser.parsePositiveNumber(config.repeat,1);
            ReturnDelay = delay * repeat * _queue.length;
            executeForQueue(transferQueued,delay,repeat,config.debug,config.showMessage,"Transferring selected");
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error ItemWorker transferSelected",e);
         }
         return ReturnDelay;
      }
      
      public function prepTransferConfig(sectionConfig:Object) : Object
      {
         var i:int = 0;
         var prepItemNames:Array = new Array(sectionConfig.itemNames.length);
         while(i < sectionConfig.itemNames.length)
         {
            prepItemNames[i] = new Array();
            if(sectionConfig.itemNames[i] is Array)
            {
               for each(item in sectionConfig.itemNames[i])
               {
                  prepItemNames[i].push(item);
               }
            }
            else if(sectionConfig.itemNames[i] is String)
            {
               prepItemNames[i].push(sectionConfig.itemNames[i]);
            }
            if(sectionConfig.altItemNames && sectionConfig.altItemNames.length > i)
            {
               if(sectionConfig.altItemNames[i] is Array)
               {
                  for each(item in sectionConfig.altItemNames[i])
                  {
                     prepItemNames[i].push(item);
                  }
               }
               else if(sectionConfig.altItemNames[i] is String)
               {
                  prepItemNames[i].push(sectionConfig.altItemNames[i]);
               }
            }
            i++;
         }
         return prepItemNames;
      }
      
      private function findMatches(inventory:Array, sectionConfig:Object) : Array
      {
         var index:int = 0;
         var indexNames:int = 0;
         var indexNamesAlts:int = 0;
         var item:Object = null;
         var isMatching:Boolean = false;
         errorCode = "newMatches";
         var newMatches:Array = new Array(sectionConfig.itemNames.length);
         errorCode = "transferTaggedForSearch";
         var transferTaggedForSearch:Boolean = Boolean(sectionConfig.transferTaggedForSearch);
         errorCode = "transferLegendaries";
         if(sectionConfig.transferLegendaries is Array)
         {
            errorCode = "transferLegendaries array";
            var transferLegendaries:Array = sectionConfig.transferLegendaries;
         }
         else if(sectionConfig.transferLegendaries is Number)
         {
            errorCode = "transferLegendaries number";
            transferLegendaries = [];
            var i:int = 1;
            while(i <= sectionConfig.transferLegendaries)
            {
               transferLegendaries.push(i);
               i++;
            }
         }
         else if(Boolean(sectionConfig.transferLegendaries))
         {
            errorCode = "transferLegendaries bool";
            transferLegendaries = [1,2,3,4,5];
         }
         else
         {
            errorCode = "transferLegendaries false";
            transferLegendaries = [];
         }
         sectionConfig.transferLegendaries = transferLegendaries;
         errorCode = "loop itemNames";
         while(indexNames < sectionConfig.itemNames.length)
         {
            indexNamesAlts = 0;
            errorCode = "loop newMatches " + indexNames;
            newMatches[indexNames] = new Array(sectionConfig.itemNames[indexNames].length);
            errorCode = "loop2 " + indexNames;
            while(indexNamesAlts < sectionConfig.itemNames[indexNames].length)
            {
               errorCode = "loop2 " + indexNames + " " + indexNamesAlts;
               newMatches[indexNames][indexNamesAlts] = new Array();
               indexNamesAlts++;
            }
            indexNames++;
         }
         errorCode = "loopInv";
         index = 0;
         while(index < inventory.length)
         {
            errorCode = "loopInv " + index;
            item = inventory[index];
            errorCode = "loopInv " + index + " check1";
            if(!Boolean(sectionConfig.transferFavorite) && item.favorite)
            {
               index++;
            }
            else if(!Boolean(sectionConfig.transferEquipped) && item.equipState == 1)
            {
               index++;
            }
            else if(!Boolean(sectionConfig.transferAssigned) && item.vendingData && item.vendingData.machineType != 0)
            {
               index++;
            }
            else
            {
               errorCode = "loopInv " + index + " check2";
               indexNames = 0;
               while(indexNames < sectionConfig.itemNames.length)
               {
                  errorCode = "loopInv " + index + " check2 " + indexNames;
                  indexNamesAlts = 0;
                  while(indexNamesAlts < sectionConfig.itemNames[indexNames].length)
                  {
                     errorCode = "loopInv " + index + " check2 " + indexNames + " " + indexNamesAlts;
                     isMatching = isMatchingType(item,sectionConfig) && isMatchingString(item.text,sectionConfig.itemNames[indexNames][indexNamesAlts],sectionConfig.matchMode);
                     if(isMatching || transferLegendaries.indexOf(item.numLegendaryStars) != -1 || transferTaggedForSearch && item.taggedForSearch)
                     {
                        newMatches[indexNames][indexNamesAlts].push(item);
                     }
                     indexNamesAlts++;
                  }
                  indexNames++;
               }
               index++;
            }
         }
         return newMatches;
      }
      
      private function transfer(param1:Array, param2:Boolean, param3:Object) : uint
      {
         var item:Object;
         var itemInDestination:Object;
         var invertDestination:Boolean;
         var filtered:Array;
         var j:int;
         var k:int;
         errorCode = "init";
         var ReturnDelay:uint = 0;
         var fromContainer:Boolean = param2;
         var config:Object = param3;
         var countItemsToTransfer:Boolean = false;
         var end:Boolean = false;
         var i:int = 0;
         var delay:uint = 0;
         var repeat:uint = 1;
         var amount:int = 0;
         var maxItems:int = 0;
         var amountItemsTransferred:int = 0;
         var amountStacksTransferred:int = 0;
         var singleItemPerName:Boolean = false;
         var inventory:Array = param1;
         _queue = new Vector.<Object>();
         var destinationMap:* = null;
         if(inventory && inventory.length > 0)
         {
            try
            {
               errorCode = "prep";
               config.itemNames = prepTransferConfig(config);
               errorCode = "filter";
               filtered = findMatches(inventory,config);
               errorCode = "amount";
               amount = Parser.parseNumber(config.amount,0);
               errorCode = "max";
               maxItems = int(config.maxItems);
               singleItemPerName = Boolean(config.singleItemPerName);
               matchingID = -1;
               if(maxItems > 0)
               {
                  countItemsToTransfer = true;
               }
               i = 0;
               amountStacksTransferred = 0;
               while(i < filtered.length)
               {
                  amountItemsTransferred = 0;
                  j = 0;
                  while(!end && j < filtered[i].length)
                  {
                     k = 0;
                     while(k < filtered[i][j].length)
                     {
                        errorCode = "item " + i + " " + j + " " + k;
                        item = filtered[i][j][k];
                        errorCode = "item amount " + i + " " + j + " " + k;
                        amount = getAmount(int(config.amount),item.count,singleItemPerName ? amountItemsTransferred : 0);
                        invertDestination = false;
                        itemInDestination = null;
                        if(config.exactAmountInDestination)
                        {
                           if(destinationMap == null)
                           {
                              destinationMap = getDestinationMap(inventory);
                           }
                           itemInDestination = destinationMap[item.text];
                           if(itemInDestination != null)
                           {
                              if(itemInDestination.count > config.amount)
                              {
                                 if(config.debug)
                                 {
                                    Logger.get().info("exactAmountInDestination: direction inverted for " + item.text);
                                 }
                                 invertDestination = true;
                                 amount = itemInDestination.count - config.amount;
                              }
                              else
                              {
                                 amount = Math.min(amount,config.amount - itemInDestination.count);
                              }
                           }
                        }
                        if(amount != 0)
                        {
                           errorCode = "item amount != 0 " + i + " " + j + " " + k;
                           amountStacksTransferred++;
                           if(countItemsToTransfer && amountStacksTransferred > maxItems)
                           {
                              i = int.MAX_VALUE - 1;
                              end = true;
                              break;
                           }
                           if(config.debug)
                           {
                              Logger.get().info("Item queued: " + item.text + " (" + amount + "/" + item.count + ")");
                           }
                           errorCode = "item amount != 0 push " + i + " " + j + " " + k;
                           if(invertDestination)
                           {
                              _queue.push({
                                 "text":item.text,
                                 "serverHandleID":itemInDestination.serverHandleID,
                                 "containerID":itemInDestination.containerID,
                                 "count":amount,
                                 "fromContainer":!fromContainer
                              });
                           }
                           else
                           {
                              _queue.push({
                                 "text":item.text,
                                 "serverHandleID":item.serverHandleID,
                                 "containerID":item.containerID,
                                 "count":amount,
                                 "fromContainer":fromContainer
                              });
                           }
                           amountItemsTransferred += amount;
                           if(config.amount > 0 && amountItemsTransferred >= config.amount)
                           {
                              if(singleItemPerName)
                              {
                                 j = int.MAX_VALUE - 1;
                                 break;
                              }
                           }
                        }
                        k++;
                     }
                     j++;
                  }
                  i++;
               }
               errorCode = "max check";
               if(countItemsToTransfer && amountStacksTransferred >= maxItems)
               {
                  if(config.debug)
                  {
                     Logger.get().info("Transfer maxItems limit reached: " + maxItems);
                  }
               }
               errorCode = "test";
               if(Parser.parseBoolean(config.testRun,false))
               {
                  showTestRun("TRANSFER (" + config.name + ")");
                  return 0;
               }
               delay = Parser.parsePositiveNumber(config.delay);
               repeat = Parser.parsePositiveNumber(config.repeat,1);
               ReturnDelay = delay * repeat * _queue.length;
               executeForQueue(transferQueued,delay,repeat,config.debug,config.showMessage,"Transferring");
            }
            catch(e:Error)
            {
               Logger.get().errorHandler("Error ItemWorker transfer " + errorCode,e);
            }
         }
         return ReturnDelay;
      }
      
      private function transferQueued() : void
      {
         if(!_queueValid)
         {
            return;
         }
         if(_queueDebug)
         {
            Logger.get().info("Transferring: " + _queue[_queueIndex].text + " (" + _queue[_queueIndex].count + ")");
         }
         GameApiDataExtractor.transferItem(_queue[_queueIndex],_queue[_queueIndex].fromContainer,_queue[_queueIndex].count);
         _queueIndex++;
      }
      
      private function getAmount(configAmount:int, itemCount:int, alreadyTransferred:int = 0) : int
      {
         var _amount:int = 0;
         if(!configAmount || isNaN(configAmount) || configAmount == 0)
         {
            _amount = itemCount;
         }
         else if(configAmount < 0)
         {
            if(itemCount > -configAmount)
            {
               _amount = itemCount + configAmount;
            }
            else
            {
               _amount = 0;
            }
         }
         else if(alreadyTransferred != 0)
         {
            if(configAmount - alreadyTransferred >= itemCount)
            {
               _amount = itemCount;
            }
            else
            {
               _amount = configAmount - alreadyTransferred;
            }
         }
         else if(configAmount >= itemCount)
         {
            _amount = itemCount;
         }
         else
         {
            _amount = configAmount;
         }
         return _amount;
      }
      
      private function scrap(param1:Object) : void
      {
         var i:int;
         var maxItems:int;
         var inventory:Array;
         var delay:uint = 0;
         var repeat:uint = 1;
         var config:Object = param1;
         var scrappedCount:int = 0;
         var subConfigIndex:int = 0;
         var end:Boolean = false;
         var countItemsToScrap:Boolean = false;
         var validConfigs:Array = [];
         _queue = new Vector.<Object>();
         try
         {
            inventory = this._playerInventory;
            if(inventory && inventory.length > 0)
            {
               maxItems = int(config.maxItems);
               if(maxItems > 0)
               {
                  countItemsToScrap = true;
               }
               subConfigIndex = 0;
               while(subConfigIndex < config.configs.length)
               {
                  if(isValidScrapConfig(subConfigIndex))
                  {
                     validConfigs.push(config.configs[subConfigIndex]);
                  }
                  subConfigIndex++;
               }
               i = 0;
               while(i < inventory.length && !end)
               {
                  if(inventory[i].scrapAllowed)
                  {
                     subConfigIndex = 0;
                     while(subConfigIndex < validConfigs.length)
                     {
                        if(Boolean(validConfigs[subConfigIndex].onlyLegendaries) && inventory[i].isLegendary || !Boolean(validConfigs[subConfigIndex].onlyLegendaries) && !inventory[i].isLegendary)
                        {
                           if(inventory[i].isLegendary && validConfigs[subConfigIndex].scrapByLegendaryStar != null)
                           {
                              if(validConfigs[subConfigIndex].scrapByLegendaryStar.indexOf(inventory[i].numLegendaryStars) == -1)
                              {
                                 subConfigIndex++;
                                 continue;
                              }
                           }
                           if(shouldScrap(inventory[i],validConfigs[subConfigIndex]))
                           {
                              if(config.debug)
                              {
                                 Logger.get().info("Item queued: " + inventory[i].text + " (" + inventory[i].count + ")");
                              }
                              _queue.push({
                                 "text":inventory[i].text,
                                 "serverHandleID":inventory[i].serverHandleID,
                                 "count":inventory[i].count
                              });
                              if(countItemsToScrap && ++scrappedCount >= maxItems)
                              {
                                 end = true;
                                 Logger.get().info("Scrap maxItems limit reached: " + maxItems);
                              }
                              break;
                           }
                        }
                        subConfigIndex++;
                     }
                  }
                  i++;
               }
               if(Parser.parseBoolean(config.testRun,true))
               {
                  showTestRun("SCRAP (" + config.name + ")");
                  return;
               }
               delay = Parser.parsePositiveNumber(config.delay);
               repeat = Parser.parsePositiveNumber(config.repeat,1);
               executeForQueue(scrapQueued,delay,repeat,config.debug,config.showMessage,"Scrapping");
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error ItemWorker scrap",e);
         }
      }
      
      private function showTestRun(name:String) : void
      {
         Logger.get().debugMode = true;
         Logger.get().info(name + " TEST RUN START");
         Logger.get().info(_queue.length + " items queued:");
         var items:String = "";
         for each(item in _queue)
         {
            items += item.text + " (" + item.count + (item.price != null ? " x" + item.price + "per" : "") + "), ";
         }
         items = items.substring(0,items.length - 2);
         Logger.get().info(items);
         Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + name);
         Logger.get().info(name + " TEST RUN FINISHED (scroll wheel is enabled in this window if text is off-screen)");
      }
      
      private function scrapQueued() : void
      {
         if(!_queueValid)
         {
            return;
         }
         if(_queueDebug)
         {
            Logger.get().info("Scrapping: " + _queue[_queueIndex].text + " (" + _queue[_queueIndex].count + ")");
         }
         GameApiDataExtractor.scrapItem(_queue[_queueIndex]);
         _queueIndex++;
      }
      
      private function npcSell(param1:Object) : void
      {
         var itemValue:Number;
         var vendorCurrency:Number;
         var playerCurrency:Number;
         var playerCurrencyMax:Number;
         var inventory:Array;
         var config:Object = param1;
         var end:Boolean = false;
         var countItemsToSell:Boolean = false;
         var i:int = 0;
         var itemsSold:int = 0;
         var configAmount:int = 0;
         var subConfigIndex:int = 0;
         var maxItems:int = 0;
         var delay:uint = 0;
         var repeat:uint = 1;
         var amountToSell:Number = 0;
         var validConfigs:Array = [];
         _queue = new Vector.<Object>();
         try
         {
            inventory = this._playerInventory;
            vendorCurrency = Number(this.secureTrade.OfferInventory_mc.currency);
            playerCurrency = Number(this.secureTrade.PlayerInventory_mc.currency);
            playerCurrencyMax = Number(this.secureTrade.PlayerInventory_mc.currencyMax);
            if(inventory && inventory.length > 0)
            {
               if(vendorCurrency == 0)
               {
                  Logger.get().info("Vendor has no currency left!");
                  return;
               }
               if(playerCurrency == playerCurrencyMax)
               {
                  Logger.get().info("Player already at max currency!");
                  return;
               }
               if(config.maxItems > 0)
               {
                  countItemsToSell = true;
               }
               while(subConfigIndex < config.configs.length)
               {
                  if(this.isValidNpcSellConfig(subConfigIndex))
                  {
                     validConfigs.push(config.configs[subConfigIndex]);
                  }
                  subConfigIndex++;
               }
               i = 0;
               while(i < inventory.length && !end)
               {
                  subConfigIndex = 0;
                  while(subConfigIndex < validConfigs.length)
                  {
                     if(isItemMatchingConfig(inventory[i],validConfigs[subConfigIndex]))
                     {
                        if(inventory[i].favorite && !Boolean(validConfigs[subConfigIndex].sellFavorite))
                        {
                           subConfigIndex++;
                           continue;
                        }
                        if(inventory[i].equipState == 1 && !Boolean(validConfigs[subConfigIndex].sellEquipped))
                        {
                           subConfigIndex++;
                           continue;
                        }
                        if(vendorCurrency == 0)
                        {
                           end = true;
                           Logger.get().info("Vendor has no currency left!");
                           break;
                        }
                        if(playerCurrency == playerCurrencyMax)
                        {
                           end = true;
                           Logger.get().info("Player reached max currency (" + playerCurrencyMax + ")!");
                           break;
                        }
                        configAmount = int(Parser.parseNumber(validConfigs[subConfigIndex].amount));
                        itemValue = Number(inventory[i].itemValue);
                        if(itemValue > 0)
                        {
                           maxItems = Math.min(Math.floor((playerCurrencyMax - playerCurrency) / itemValue),Math.floor(vendorCurrency / itemValue));
                        }
                        else
                        {
                           maxItems = 0;
                        }
                        if(configAmount != 0)
                        {
                           amountToSell = Math.min(getAmount(configAmount,inventory[i].count),maxItems);
                        }
                        else
                        {
                           amountToSell = Math.min(inventory[i].count,maxItems);
                        }
                        if(amountToSell > 0)
                        {
                           vendorCurrency -= amountToSell * itemValue;
                           playerCurrency += amountToSell * itemValue;
                           if(config.debug)
                           {
                              Logger.get().info("Item queued: " + inventory[i].text + " (" + amountToSell + "/" + inventory[i].count + ") for " + itemValue + " per; total: " + itemValue * amountToSell + "; currency after sale: vendor " + vendorCurrency + ", player " + playerCurrency);
                           }
                           _queue.push({
                              "text":inventory[i].text,
                              "serverHandleID":inventory[i].serverHandleID,
                              "count":amountToSell
                           });
                           if(countItemsToSell && ++itemsSold >= config.maxItems)
                           {
                              end = true;
                              Logger.get().info("NPC sell maxItems limit reached: " + config.maxItems);
                              break;
                           }
                        }
                     }
                     subConfigIndex++;
                  }
                  i++;
               }
               if(Parser.parseBoolean(config.testRun,false))
               {
                  showTestRun("SELL (" + config.name + ")");
                  return;
               }
               delay = Parser.parsePositiveNumber(config.delay);
               repeat = Parser.parsePositiveNumber(config.repeat,1);
               executeForQueue(sellQueued,delay,repeat,config.debug,config.showMessage,"Selling");
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error ItemWorker npcSell",e);
         }
      }
      
      private function sellQueued() : void
      {
         if(!_queueValid)
         {
            return;
         }
         if(_queueDebug)
         {
            Logger.get().info("Selling: " + _queue[_queueIndex].text + " (" + _queue[_queueIndex].count + ")");
         }
         GameApiDataExtractor.sellItem(_queue[_queueIndex]);
         _queueIndex++;
      }
      
      private function performContainerWeightCheck(param1:Object, param2:uint, param3:Object) : Boolean
      {
         return Boolean(param1.isWeightless) || param3.carryWeightMax <= 0 || param3.carryWeightCurrent + param1.weight * param2 <= param3.carryWeightMax;
      }
      
      private function campAssign(config:Object) : void
      {
         var amount:int;
         var selectedListEntry:Object;
         var i:int = 0;
         var end:Boolean = false;
         if(config.debug)
         {
            Logger.get().info("Camp assign");
         }
         try
         {
            selectedListEntry = this._selectedEntry;
            amount = Math.min(config.amount,selectedListEntry.count);
            if(config.debug)
            {
               Logger.get().info("Assigning: " + amount + " " + selectedListEntry.text);
            }
            while(i < amount)
            {
               setTimeout(function():void
               {
                  if(!end && performContainerWeightCheck(selectedListEntry,1,secureTrade.OfferInventory_mc))
                  {
                     if(!secureTrade.SlotInfo_mc.visible || secureTrade.SlotInfo_mc.AreSlotsFull() || selectedListEntry.currentHealth == -1 && (secureTrade.MenuMode == SecureTradeShared.MODE_FERMENTER || secureTrade.MenuMode == SecureTradeShared.MODE_REFRIGERATOR || secureTrade.MenuMode == SecureTradeShared.MODE_FREEZER))
                     {
                        end = true;
                        Logger.get().error("Unable to assign item");
                     }
                     else
                     {
                        GameApiDataExtractor.campAssignItem(selectedListEntry,false);
                     }
                  }
               },config.delay * i);
               i++;
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error ItemWorker campAssign",e);
         }
      }
      
      private function displayAssign(config:Object) : void
      {
         var delay:uint;
         var amount:int;
         var selectedListEntry:Object;
         var inventory:Array;
         var items:Vector.<Object> = new Vector.<Object>();
         var i:int = 0;
         var index:int = 0;
         var end:Boolean = false;
         if(config.debug)
         {
            Logger.get().info("Display assign");
         }
         try
         {
            amount = Parser.parseNumber(config.amount,0);
            selectedListEntry = this._selectedEntry;
            inventory = this._playerInventory;
            if(inventory && inventory.length > 0)
            {
               i = 0;
               while(i < inventory.length)
               {
                  index = 0;
                  if(inventory[i].text === selectedListEntry.text && inventory[i].filterFlag === selectedListEntry.filterFlag && inventory[i].equipState == 0 && !inventory[i].favorite)
                  {
                     while(index < inventory[i].count)
                     {
                        items.push(inventory[i]);
                        if(items.length == amount)
                        {
                           end = true;
                           break;
                        }
                        index++;
                     }
                     if(end)
                     {
                        break;
                     }
                  }
                  i++;
               }
            }
            if(config.debug)
            {
               Logger.get().info("Assigning " + items.length + " " + selectedListEntry.text);
            }
            i = 0;
            index = 0;
            end = false;
            while(i < items.length)
            {
               setTimeout(function():void
               {
                  if(!end && performContainerWeightCheck(selectedListEntry,1,secureTrade.OfferInventory_mc))
                  {
                     if(secureTrade.SlotInfo_mc.visible && !secureTrade.SlotInfo_mc.AreSlotsFull())
                     {
                        GameApiDataExtractor.displayAssignItem(items[index],false);
                     }
                     else
                     {
                        end = true;
                     }
                  }
                  ++index;
               },config.delay * i);
               i++;
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error ItemWorker displayAssign",e);
         }
      }
      
      private function isValidTransferConfig(config:Object, debug:Boolean = false) : Boolean
      {
         if(config && config.enabled && config.itemNames && config.itemNames.length > 0 && (Boolean(config.direction) || config.onlyHighlightedItem))
         {
            return isTheSameCharacterName(config,debug && config.debug) && isValidContainerName(config,debug && config.debug);
         }
         return false;
      }
      
      private function isValidScrapConfig(indexConfig:int = -1) : Boolean
      {
         var scrapConfig:Object = null;
         if(_config)
         {
            scrapConfig = _config.scrapConfig;
            if(scrapConfig && scrapConfig.enabled && scrapConfig.configs && scrapConfig.configs.length > 0)
            {
               if(indexConfig != -1)
               {
                  if(!(scrapConfig.configs.length > indexConfig && scrapConfig.configs[indexConfig].enabled && Boolean(scrapConfig.configs[indexConfig].types) && Boolean(scrapConfig.configs[indexConfig].excluded) && scrapConfig.configs[indexConfig].excluded.length > 0))
                  {
                     return false;
                  }
                  return isTheSameCharacterName(scrapConfig.configs[indexConfig],scrapConfig.debug);
               }
               return true;
            }
         }
         return false;
      }
      
      private function isValidLootConfig(subConfig:Object = null) : Boolean
      {
         var lootConfig:Object = null;
         if(_config)
         {
            lootConfig = subConfig != null ? subConfig : _config.lootConfig;
            if(lootConfig && lootConfig.enabled && lootConfig.itemNames && lootConfig.itemNames.length > 0)
            {
               return isTheSameCharacterName(lootConfig,lootConfig.debug);
            }
         }
         return false;
      }
      
      private function isValidNpcSellConfig(indexConfig:int = -1) : Boolean
      {
         var npcSellConfig:Object = null;
         if(_config)
         {
            npcSellConfig = _config.npcSellConfig;
            if(npcSellConfig && npcSellConfig.enabled && npcSellConfig.configs && npcSellConfig.configs.length > 0)
            {
               if(indexConfig != -1)
               {
                  if(!(npcSellConfig.configs.length > indexConfig && npcSellConfig.configs[indexConfig].enabled && Boolean(npcSellConfig.configs[indexConfig].itemNames) && npcSellConfig.configs[indexConfig].itemNames.length > 0))
                  {
                     return false;
                  }
                  return isTheSameCharacterName(npcSellConfig.configs[indexConfig],npcSellConfig.debug);
               }
               return true;
            }
         }
         return false;
      }
      
      private function isValidBuyConfig(indexConfig:int = -1) : Boolean
      {
         var buyConfig:Object = null;
         if(_config)
         {
            buyConfig = _config.buyConfig;
            if(buyConfig && buyConfig.enabled && buyConfig.configs && buyConfig.configs.length > 0)
            {
               if(indexConfig != -1)
               {
                  if(!(buyConfig.configs.length > indexConfig && buyConfig.configs[indexConfig].enabled && Boolean(buyConfig.configs[indexConfig].itemNames) && buyConfig.configs[indexConfig].itemNames.length > 0))
                  {
                     return false;
                  }
                  return isTheSameCharacterName(buyConfig.configs[indexConfig],buyConfig.debug);
               }
               return true;
            }
         }
         return false;
      }
      
      private function isValidCampAssignConfig() : Boolean
      {
         var config:Object = null;
         if(_config)
         {
            config = _config.campAssignConfig;
            if(config && config.enabled && config.amount && int(config.amount) > 0 && config.delay && int(config.delay) > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function lootItems() : void
      {
         if(this.isValidLootConfig())
         {
            Logger.get().info("Valid loot config");
            var config:Object = _config.lootConfig;
            if(config.configs)
            {
               var indexConfig:int = 0;
               var subConfig:Object = null;
               while(indexConfig < config.configs.length)
               {
                  subConfig = config.configs[indexConfig];
                  if(isValidLootConfig(subConfig))
                  {
                     Logger.get().info("Valid loot subconfig at index " + indexConfig);
                     config.itemNames = config.itemNames.concat(subConfig.itemNames);
                  }
                  indexConfig++;
               }
            }
            this.transfer(this._stashInventory,true,config);
         }
         else
         {
            Logger.get().error("Invalid loot config");
         }
      }
      
      private function isSelectedItemTransfer(config:Object) : Boolean
      {
         return Parser.parseBoolean(config.onlyHighlightedItem,false);
      }
      
      public function transferItems(keyCode:uint = 0, shift:Boolean = false) : void
      {
         var config:Object;
         var hotkeyMatch:Boolean;
         var execNext:*;
         var indexConfig:int = 0;
         var validConfigs:Array = [];
         while(indexConfig < _config.transferConfig.length)
         {
            config = _config.transferConfig[indexConfig];
            hotkeyMatch = keyCode == config.hotkey;
            if(hotkeyMatch && this.isValidTransferConfig(config,true))
            {
               Logger.get().info("Valid transfer config: " + config.name);
               validConfigs.push(config);
            }
            indexConfig++;
         }
         indexConfig = 0;
         execNext = function():void
         {
            if(indexConfig < validConfigs.length)
            {
               var delay:uint = 0;
               var configDelay:uint = 0;
               var config:Object = validConfigs[indexConfig];
               var delayStep:uint = Parser.parsePositiveNumber(config.delay);
               Logger.get().info("Executing transfer (" + delayStep + "ms delay): " + config.name);
               var direction:String = String(config.direction);
               var hotkeyMatch:Boolean = keyCode == config.hotkey;
               if(isSelectedItemTransfer(config))
               {
                  configDelay = transferSelected(config);
               }
               else if(DIRECTION_FROM_CONTAINER === direction ^ shift)
               {
                  configDelay = transfer(_stashInventory,true,config);
               }
               else if(DIRECTION_TO_CONTAINER === direction ^ shift)
               {
                  configDelay = transfer(_playerInventory,false,config);
               }
               delay = configDelay + delayStep;
               ++indexConfig;
               setTimeout(execNext,delay);
            }
         };
         execNext();
      }
      
      public function scrapItems() : void
      {
         var config:Object = _config.scrapConfig;
         if(!this.isValidScrapConfig())
         {
            Logger.get().error("Invalid scrap config: -1");
            return;
         }
         Logger.get().info("Valid scrap config");
         this.scrap(config);
      }
      
      public function npcSellItems() : void
      {
         var config:Object = _config.npcSellConfig;
         if(!this.isValidNpcSellConfig())
         {
            Logger.get().error("Invalid npcSell config: -1");
            return;
         }
         this.npcSell(config);
      }
      
      private function buy(config:Object) : void
      {
         var inventory:Array;
         var playerCurrency:Number;
         var currencyLeft:Number;
         var amount:int = 0;
         var amountItemsBought:int = 0;
         var delay:int = 0;
         var repeat:uint = 1;
         var i:int = 0;
         var subConfigIndex:int = 0;
         var price:uint = 0;
         var countItemsToBuy:Boolean = false;
         var endAll:Boolean = false;
         var isMatching:Boolean = false;
         var isNpcVendor:Boolean = true;
         var validConfigs:Array = [];
         try
         {
            inventory = this._stashInventory;
            playerCurrency = Number(this.secureTrade.PlayerInventory_mc.PlayerCurrency_tf.text.split("/")[0]);
            currencyLeft = playerCurrency;
            _queue = new Vector.<Object>();
            if(inventory && inventory.length > 0)
            {
               if(config.maxItems && !isNaN(config.maxItems) && config.maxItems > 0)
               {
                  countItemsToBuy = true;
               }
               subConfigIndex = 0;
               while(subConfigIndex < config.configs.length)
               {
                  if(isValidBuyConfig(subConfigIndex))
                  {
                     validConfigs.push(config.configs[subConfigIndex]);
                  }
                  subConfigIndex++;
               }
               i = 0;
               while(i < inventory.length && !endAll)
               {
                  subConfigIndex = 0;
                  while(subConfigIndex < validConfigs.length)
                  {
                     if(currencyLeft == 0)
                     {
                        if(config.debug)
                        {
                           Logger.get().info("Player has no currency left!");
                        }
                        endAll = true;
                        break;
                     }
                     if(countItemsToBuy && amountItemsBought >= config.maxItems)
                     {
                        if(config.debug)
                        {
                           Logger.get().info("Items queued reached maxItems: " + amountItemsBought);
                        }
                        endAll = true;
                        break;
                     }
                     isMatching = isItemMatchingConfig(inventory[i],validConfigs[subConfigIndex]);
                     if(isMatching)
                     {
                        price = uint(!!inventory[i].isOffered ? inventory[i].offerValue : inventory[i].itemValue);
                        amount = getAmount(int(validConfigs[subConfigIndex].amount),inventory[i].count);
                        if(price > 0)
                        {
                           amount = Math.min(Math.floor(currencyLeft / price),amount);
                        }
                        maxPrice = Parser.parsePositiveNumber(validConfigs[subConfigIndex].maxPrice);
                        if(price > maxPrice)
                        {
                           if(config.debug)
                           {
                              Logger.get().error("Not buying item: " + inventory[i].text + ", price (" + price + ") exceeding maxPrice (" + maxPrice + ")");
                           }
                        }
                        else
                        {
                           if(amount != 0)
                           {
                              currencyLeft -= amount * price;
                              amountItemsBought++;
                              if(inventory[i].isOffered)
                              {
                                 isNpcVendor = false;
                                 if(config.debug)
                                 {
                                    Logger.get().info("Item queued: " + inventory[i].text + " (" + amount + "/" + inventory[i].count + ") for " + price + " per, total: " + amount * price);
                                 }
                                 _queue.push({
                                    "serverHandleID":inventory[i].serverHandleID,
                                    "text":inventory[i].text,
                                    "count":amount,
                                    "price":price,
                                    "isNpcVendor":false
                                 });
                              }
                              else
                              {
                                 if(config.debug)
                                 {
                                    Logger.get().info("Item queued: " + inventory[i].text + " (" + amount + ") at " + price + ", total: " + amount * price);
                                 }
                                 _queue.push({
                                    "serverHandleID":inventory[i].serverHandleID,
                                    "text":inventory[i].text,
                                    "count":amount,
                                    "price":price,
                                    "isNpcVendor":true
                                 });
                              }
                              break;
                           }
                           if(config.debug)
                           {
                              Logger.get().error("Not buying item: " + inventory[i].text + ", amount is 0");
                           }
                        }
                     }
                     subConfigIndex++;
                  }
                  i++;
               }
               if(Parser.parseBoolean(config.testRun,false))
               {
                  showTestRun("BUY (" + config.name + ")");
                  return;
               }
               delay = isNpcVendor ? Parser.parsePositiveNumber(config.delayNpcVendor) : Parser.parsePositiveNumber(config.delayCampVendor,1500);
               repeat = Parser.parsePositiveNumber(config.repeat,1);
               executeForQueue(buyQueued,delay,repeat,config.debug,config.showMessage,"Buying");
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error ItemWorker npcBuy",e);
         }
      }
      
      private function executeForQueue(func:Function, delay:uint, repeat:uint, debug:Boolean, showMessage:*, actionName:String = "Exec") : void
      {
         var i:int;
         var loop:int;
         _queueDebug = debug;
         _queueIndex = 0;
         var DELAY:uint = 0;
         if(debug)
         {
            if(repeat > 1)
            {
               Logger.get().info(actionName + " " + _queue.length + " item(s) with delay: " + delay + "ms, repeat: " + repeat + " times");
            }
            else
            {
               Logger.get().info(actionName + " " + _queue.length + " item(s) with delay: " + delay + "ms");
            }
         }
         if(showMessage)
         {
            if(showMessage == "FULL")
            {
               GlobalFunc.ShowHUDMessage("[" + InventOmaticStash.FULL_MOD_NAME + "] " + actionName + " " + _queue.length + " items: " + _queue.map(function(x:Object):String
               {
                  return x.text + (x.count > 1 ? " (" + x.count + ")" : "");
               }).join(", "));
            }
            else
            {
               GlobalFunc.ShowHUDMessage("[" + InventOmaticStash.FULL_MOD_NAME + "] " + actionName + " " + _queue.length + " items");
            }
         }
         i = 0;
         loop = 0;
         while(loop < repeat)
         {
            i = 0;
            while(i < _queue.length)
            {
               if(delay > 0)
               {
                  setTimeout(func,DELAY + i * delay);
               }
               else
               {
                  func();
               }
               i++;
            }
            if(delay > 0)
            {
               DELAY += i * delay;
               setTimeout(function():*
               {
                  _queueIndex = 0;
               },DELAY);
               DELAY += 25;
            }
            else
            {
               _queueIndex = 0;
            }
            loop++;
         }
      }
      
      private function buyQueued() : void
      {
         if(!_queueValid)
         {
            return;
         }
         if(_queueDebug)
         {
            Logger.get().info("Buying: " + _queue[_queueIndex].text + " (" + _queue[_queueIndex].count + ") for " + _queue[_queueIndex].price * _queue[_queueIndex].count);
         }
         if(Boolean(_queue[_queueIndex].isNpcVendor))
         {
            GameApiDataExtractor.npcBuyItem(_queue[_queueIndex].serverHandleID,_queue[_queueIndex].count);
         }
         else
         {
            GameApiDataExtractor.campBuyItem(_queue[_queueIndex].serverHandleID,_queue[_queueIndex].count,_queue[_queueIndex].price);
         }
         _queueIndex++;
      }
      
      public function vendorBuyItems() : void
      {
         if(this.isValidBuyConfig())
         {
            if(_config.buyConfig.debug)
            {
               Logger.get().info("Valid buy config");
            }
            this.buy(_config.buyConfig);
         }
         else if(_config.debug)
         {
            Logger.get().error("Invalid buy config");
         }
      }
      
      public function campAssignItems() : void
      {
         if(this.isValidCampAssignConfig())
         {
            if(_config.campAssignConfig.debug)
            {
               Logger.get().info("Valid campAssign config");
            }
            if(this.secureTrade.MenuMode == SecureTradeShared.MODE_DISPLAY_CASE)
            {
               this.displayAssign(_config.campAssignConfig);
            }
            else
            {
               this.campAssign(_config.campAssignConfig);
            }
         }
         else
         {
            Logger.get().error("Invalid campAssign config");
         }
      }
   }
}
