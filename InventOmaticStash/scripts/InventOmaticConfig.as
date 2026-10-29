package
{
   import Shared.GlobalFunc;
   import utils.CampAssignContainer;
   import utils.Logger;
   import utils.Parser;
   
   public class InventOmaticConfig
   {
      
      private static var _config:Object;
      
      public static const DEFAULT_SHOW_BUTTON_STATE:Boolean = true;
      
      private static const _ID:String = "R_ID";
      
      private static const _AMOUNT:String = "R_AMOUNT";
      
      private static const AMOUNT:String = "{amount}";
      
      private static const TITLE_EXTRACT:String = "Extract Items";
      
      private static const TITLE_SCRAP:String = "AutoScrap";
      
      private static const TITLE_TRANSFER:String = "Trans_" + _ID;
      
      private static const TITLE_TRANSFER_SUBCONFIG:String = "Subconfig_" + _ID;
      
      private static const TITLE_LOOT:String = "AutoLoot";
      
      private static const TITLE_NPC_SELL:String = "AutoSell";
      
      private static const TITLE_ASSIGN:String = "Assign " + AMOUNT;
      
      private static const TITLE_BUY:String = "AutoBuy";
      
      private static const ARRAY_DESC:String = "[object Array]";
      
      private static var toggleDebugKeyCode:uint = 192;
      
      private static var extractKeyCode:uint = 79;
      
      private static var transferKeyCode:uint = 80;
      
      private static var lootKeyCode:uint = 70;
      
      private static var scrapKeyCode:uint = 71;
      
      private static var npcSellKeyCode:uint = 78;
      
      private static var buyKeyCode:uint = 66;
      
      private static var campAssignKeyCode:uint = 85;
      
      private static var lockAllKeyCode:uint = 75;
      
      private static var calculateCatWeightKeyCode:uint = 116;
      
      private static var swapToPlayerInventoryHotkey:uint = 0;
      
      private static var swapToContainerInventoryHotkey:uint = 0;
      
      private static var testRunHoldHotkey:uint = 0;
      
      private static var cancelCloseMenuHotkey:uint = 0;
      
      public function InventOmaticConfig()
      {
         super();
      }
      
      public static function get() : Object
      {
         return _config;
      }
      
      public static function get ToggleDebugKeyCode() : uint
      {
         return toggleDebugKeyCode;
      }
      
      public static function get ExtractKeyCode() : uint
      {
         return extractKeyCode;
      }
      
      public static function get TransferKeyCode() : uint
      {
         return transferKeyCode;
      }
      
      public static function get LootKeyCode() : uint
      {
         return lootKeyCode;
      }
      
      public static function get ScrapKeyCode() : uint
      {
         return scrapKeyCode;
      }
      
      public static function get NpcSellKeyCode() : uint
      {
         return npcSellKeyCode;
      }
      
      public static function get BuyKeyCode() : uint
      {
         return buyKeyCode;
      }
      
      public static function get CampAssignKeyCode() : uint
      {
         return campAssignKeyCode;
      }
      
      public static function get LockAllKeyCode() : uint
      {
         return lockAllKeyCode;
      }
      
      public static function get CalculateCatWeightKeyCode() : uint
      {
         return calculateCatWeightKeyCode;
      }
      
      public static function get SwapToPlayerInventoryHotkey() : uint
      {
         return swapToPlayerInventoryHotkey;
      }
      
      public static function get SwapToContainerInventoryHotkey() : uint
      {
         return swapToContainerInventoryHotkey;
      }
      
      public static function get TestRunHoldHotkey() : uint
      {
         return testRunHoldHotkey;
      }
      
      public static function get CancelCloseMenuHotkey() : uint
      {
         return cancelCloseMenuHotkey;
      }
      
      public static function init(jsonObject:*) : Object
      {
         var config:* = jsonObject;
         config.itemNamesGroupConfig = loadItemNamesGroupConfig(config.itemNamesGroupConfig);
         var itemGroups:Object = config.itemNamesGroupConfig;
         if(!config.extractConfig)
         {
            config.extractConfig = loadDefaultExtractConfig(config);
            setName(config.extractConfig,TITLE_EXTRACT);
         }
         else
         {
            config.extractConfig = loadExtractConfig(config.extractConfig);
         }
         if(config.scrapConfig)
         {
            config.scrapConfig = loadScrapConfig(itemGroups,config.scrapConfig);
            setName(config.scrapConfig,TITLE_SCRAP);
            setMaxItems(config.scrapConfig);
         }
         if(config.transferConfig)
         {
            config.transferConfig = loadTransferConfig(itemGroups,config.transferConfig);
         }
         else
         {
            config.transferConfig = [];
         }
         if(config.lootConfig)
         {
            setName(config.lootConfig,TITLE_LOOT);
            setMaxItems(config.lootConfig);
            config.lootConfig = loadLootConfig(itemGroups,config.lootConfig);
         }
         if(config.npcSellConfig)
         {
            config.npcSellConfig = loadNpcSellConfig(itemGroups,config.npcSellConfig);
            setName(config.npcSellConfig,TITLE_NPC_SELL);
            setMaxItems(config.npcSellConfig);
         }
         if(config.campAssignConfig)
         {
            config.campAssignConfig = loadAssignConfig(itemGroups,config.campAssignConfig);
         }
         else
         {
            config.campAssignConfig = {
               "enabled":false,
               "configs":[]
            };
         }
         if(config.buyConfig)
         {
            setName(config.buyConfig,TITLE_BUY);
            setMaxItems(config.buyConfig);
            config.buyConfig.ignoreItemNames = expandItemGroups(itemGroups,config.buyConfig.ignoreItemNames || []);
            for each(var c in config.buyConfig.configs)
            {
               c.itemNames = expandItemGroups(itemGroups,c.itemNames || []);
            }
         }
         if(config.protectionConfig)
         {
            if(config.protectionConfig.saleProtection)
            {
               config.protectionConfig.saleProtection.itemNames = expandItemGroups(itemGroups,config.protectionConfig.saleProtection.itemNames || []);
            }
            if(config.protectionConfig.scrapProtection)
            {
               config.protectionConfig.scrapProtection.itemNames = expandItemGroups(itemGroups,config.protectionConfig.scrapProtection.itemNames || []);
            }
            if(config.protectionConfig.transferProtection)
            {
               config.protectionConfig.transferProtection.itemNames = expandItemGroups(itemGroups,config.protectionConfig.transferProtection.itemNames || []);
            }
            if(config.protectionConfig.transferProtection && config.protectionConfig.transferProtection.disableForContainers)
            {
               for(c in config.protectionConfig.transferProtection.disableForContainers)
               {
                  config.protectionConfig.transferProtection.disableForContainers[c] = config.protectionConfig.transferProtection.disableForContainers[c].toUpperCase();
               }
            }
         }
         if(!config.localizationConfig)
         {
            config.localizationConfig = {};
         }
         config.categoryWeightConfig = loadCategoryWeightConfig(config.categoryWeightConfig);
         config.additionalColumnsConfig = loadAdditionalColumnsConfig(config.additionalColumnsConfig);
         config.defaultVendorItemPrice = loadDefaultVendorItemPriceConfig(config.defaultVendorItemPrice);
         initHotkeys(config);
         _config = config;
         return _config;
      }
      
      private static function initHotkeys(config:*) : void
      {
         if(config)
         {
            toggleDebugKeyCode = Parser.parseHotkey(config.toggleDebugHotkey,toggleDebugKeyCode);
            extractKeyCode = Parser.parseHotkey(config.extractConfig,extractKeyCode);
            lootKeyCode = Parser.parseHotkey(config.lootConfig,lootKeyCode);
            npcSellKeyCode = Parser.parseHotkey(config.npcSellConfig,npcSellKeyCode);
            if(config.protectionConfig)
            {
               lockAllKeyCode = Parser.parseHotkey(config.protectionConfig.itemLocking,lockAllKeyCode);
            }
            buyKeyCode = Parser.parseHotkey(config.buyConfig,buyKeyCode);
            calculateCatWeightKeyCode = Parser.parseHotkey(config.categoryWeightConfig,calculateCatWeightKeyCode);
            config.categoryWeightConfig.hotkey = calculateCatWeightKeyCode;
            for(var c in config.scrapConfig.configs)
            {
               config.scrapConfig.configs[c].hotkey = Parser.parseHotkey(config.scrapConfig.configs[c],scrapKeyCode);
            }
            for(c in config.transferConfig)
            {
               config.transferConfig[c].hotkey = Parser.parseHotkey(config.transferConfig[c],transferKeyCode);
            }
            for(c in config.campAssignConfig.configs)
            {
               config.campAssignConfig.configs[c].hotkey = Parser.parseHotkey(config.campAssignConfig.configs[c],campAssignKeyCode);
            }
            swapToPlayerInventoryHotkey = Parser.parseHotkey(config.swapToPlayerInventoryHotkey,0);
            swapToContainerInventoryHotkey = Parser.parseHotkey(config.swapToContainerInventoryHotkey,0);
            testRunHoldHotkey = Parser.parseHotkey(config.testRunHoldHotkey,0);
            cancelCloseMenuHotkey = Parser.parseHotkey(config.cancelCloseMenuHotkey,0);
         }
      }
      
      private static function setName(config:*, defaultName:String) : void
      {
         if(!config.name)
         {
            config.name = defaultName;
         }
      }
      
      private static function setMaxItems(config:*) : void
      {
         config.maxItems = Parser.parsePositiveNumber(config.maxItems);
      }
      
      private static function expandItemGroups(itemGroups:Object, originalNames:Array) : Array
      {
         var itemNames:Array = [];
         for each(var nameOrNames in originalNames)
         {
            if(nameOrNames is Array)
            {
               var resolvedChoices:Array = [];
               for each(var n in nameOrNames)
               {
                  resolvedChoices = resolvedChoices.concat(itemGroups[n] != null ? itemGroups[n] : [n]);
               }
               itemNames.push(resolvedChoices);
            }
            else
            {
               itemNames = itemNames.concat(itemGroups[nameOrNames] != null ? itemGroups[nameOrNames] : [nameOrNames]);
            }
         }
         return itemNames;
      }
      
      private static function loadDefaultExtractConfig(config:*) : *
      {
         var cnf:* = {};
         cnf.enabled = true;
         cnf.name = TITLE_EXTRACT;
         cnf.additionalItemDataForAll = config.additionalItemDataForAll;
         cnf.showButton = config.showExtractButton;
         cnf.hotkey = config.extractHotkey;
         cnf.verboseOutput = config.verboseOutput;
         cnf.apiMethods = config.apiMethods;
         cnf.useCustomFormat = false;
         cnf.customFormat = {};
         return cnf;
      }
      
      private static function loadExtractConfig(config:*) : *
      {
         var cnf:* = config;
         cnf.name = config.name != null ? config.name : TITLE_EXTRACT;
         if(cnf.enabled && cnf.useCustomFormat)
         {
            if(cnf.customFormat == null)
            {
               cnf.customFormat = {};
               cnf.customFormat.format = "json";
            }
            else
            {
               cnf.customFormat.delimiter = cnf.customFormat.delimiter != null ? cnf.customFormat.delimiter : ";";
               cnf.customFormat.delimiterLine = cnf.customFormat.delimiterLine != null ? cnf.customFormat.delimiterLine : "\n";
               cnf.customFormat.valueNotFound = cnf.customFormat.valueNotFound != null ? cnf.customFormat.valueNotFound : "";
               cnf.customFormat.displayColumnNames = cnf.customFormat.displayColumnNames != null ? cnf.customFormat.displayColumnNames : true;
               cnf.customFormat.columns = cnf.customFormat.columns != null && cnf.customFormat.columns.length > 0 ? cnf.customFormat.columns : ["text","count","itemType","itemLevel","numLegendaryStars","legendary_1","legendary_2","legendary_3","legendary_4","isTradable","weight","weightInStash","physical","energy","radiation","poison","fire","cryo","source","char","account"];
            }
         }
         return cnf;
      }
      
      private static function loadTransferConfig(itemGroups:Object, config:*) : *
      {
         if(!(config is Array))
         {
            config = [].concat(config);
         }
         var expandedConfigs:Array = [];
         for(var i in config)
         {
            var c:Object = config[i];
            setName(c,TITLE_TRANSFER);
            c.name = c.name.replace(_ID,i);
            setMaxItems(c);
            if(c.subconfigs != null && c.itemNames != null)
            {
               Logger.get().error("Transfer config " + c.name + ": Only one of itemNames or subconfigs allowed.");
            }
            else if(c.subconfigs == null && c.itemNames != null)
            {
               c.ignoreItemNames = expandItemGroups(itemGroups,c.ignoreItemNames || []);
               c.itemNames = expandItemGroups(itemGroups,c.itemNames);
               c.wasSubconfig = false;
               expandedConfigs.push(c);
            }
            else if(c.subconfigs != null && c.itemNames == null)
            {
               var first:Boolean = false;
               var j:int = 0;
               for each(var s in c.subconfigs)
               {
                  var expanded:Object = GlobalFunc.CloneObject(c);
                  if(!first)
                  {
                     first = true;
                     expanded.showButton = c.showButton;
                  }
                  else
                  {
                     expanded.showButton = false;
                     setName(s,TITLE_TRANSFER_SUBCONFIG);
                     expanded.name = c.name + "_" + s.name.replace(_ID,j);
                  }
                  expanded.enabled = s.enabled != null ? s.enabled : c.enabled;
                  expanded.debug = s.debug != null ? s.debug : c.debug;
                  expanded.testRun = s.testRun != null ? s.testRun : c.testRun;
                  expanded.amount = s.amount;
                  expanded.exactAmountInDestination = s.exactAmountInDestination;
                  expanded.types = s.types;
                  expanded.weaponTypes = s.weaponTypes;
                  expanded.matchMode = s.matchMode;
                  expanded.checkAccountName = s.checkAccountName;
                  expanded.accountName = s.accountName;
                  expanded.checkCharacterName = s.checkCharacterName;
                  expanded.characterName = s.characterName;
                  expanded.checkContainerName = s.checkContainerName;
                  expanded.containerName = s.containerName;
                  expanded.itemNames = expandItemGroups(itemGroups,s.itemNames || []);
                  expanded.ignoreItemNames = expandItemGroups(itemGroups,s.ignoreItemNames || []);
                  expanded.direction = s.direction;
                  expanded.wasSubconfig = true;
                  expandedConfigs.push(expanded);
                  j += 1;
               }
            }
         }
         return expandedConfigs;
      }
      
      private static function loadAssignConfig(itemGroups:Object, config:*) : *
      {
         if(!config.configs || !(config.configs is Array))
         {
            config.onlyHighlightedItem = true;
            config.configs = [].concat(config);
         }
         for(c in config.configs)
         {
            if(!config.configs[c].assignMode)
            {
               config.configs[c].assignMode = CampAssignContainer.OTHER;
            }
            setName(config.configs[c],TITLE_ASSIGN);
            config.configs[c].name = config.configs[c].name.replace(_AMOUNT,AMOUNT).replace(AMOUNT,config.configs[c].amount);
            if(config.configs[c].configs != null)
            {
               for each(var subconfig in config.configs[c].configs)
               {
                  subconfig.itemNames = expandItemGroups(itemGroups,subconfig.itemNames || []);
               }
            }
         }
         return config;
      }
      
      private static function loadNpcSellConfig(itemGroups:Object, config:*) : *
      {
         if(!config.configs)
         {
            config.configs = new Array(config);
         }
         else if(config.configs.length == 0)
         {
            config.enabled = false;
         }
         config.ignoreItemNames = expandItemGroups(itemGroups,config.ignoreItemNames || []);
         for each(var c in config.configs)
         {
            c.itemNames = expandItemGroups(itemGroups,c.itemNames || []);
         }
         return config;
      }
      
      private static function loadScrapConfig(itemGroups:Object, config:*) : *
      {
         if(!config)
         {
            config = {"enabled":false};
         }
         if(!config.configs)
         {
            config.configs = [].concat(config);
         }
         else if(config.configs.length == 0)
         {
            config.enabled = false;
         }
         if(!config.ignoreItemNames)
         {
            config.ignoreItemNames = [];
         }
         config.ignoreItemNames = expandItemGroups(itemGroups,config.ignoreItemNames);
         for(var c in config.configs)
         {
            setName(config.configs[c],TITLE_SCRAP);
            setMaxItems(config.configs[c]);
            if(config.configs[c].hotkey == null)
            {
               config.configs[c].hotkey = config.hotkey;
            }
            if(config.configs[c].name == null)
            {
               config.configs[c].name = config.name;
            }
            if(config.configs[c].debug == null)
            {
               config.configs[c].debug = config.debug;
            }
            if(config.configs[c].testRun == null)
            {
               config.configs[c].testRun = config.testRun;
            }
            if(config.configs[c].showButton == null)
            {
               config.configs[c].showButton = config.showButton;
            }
            if(config.configs[c].showMessage == null)
            {
               config.configs[c].showMessage = config.showMessage;
            }
            if(config.configs[c].repeat == null)
            {
               config.configs[c].repeat = config.repeat;
            }
            if(config.configs[c].delay == null)
            {
               config.configs[c].delay = config.delay;
            }
            config.configs[c].excluded = expandItemGroups(itemGroups,config.configs[c].excluded || []);
            if(config.configs[c].ignoreItemNames == null)
            {
               config.configs[c].ignoreItemNames = config.ignoreItemNames;
            }
            else
            {
               config.configs[c].ignoreItemNames = config.configs[c].ignoreItemNames.concat(config.ignoreItemNames);
            }
         }
         return config;
      }
      
      private static function loadLootConfig(itemGroups:Object, config:*) : *
      {
         if(!config.configs)
         {
            config.configs = [];
         }
         config.itemNames = expandItemGroups(itemGroups,config.itemNames || []);
         config.ignoreItemNames = expandItemGroups(itemGroups,config.ignoreItemNames || []);
         for each(var c in config.configs)
         {
            c.itemNames = expandItemGroups(itemGroups,c.itemNames || []);
         }
         return config;
      }
      
      private static function loadCategoryWeightConfig(config:*) : *
      {
         if(config)
         {
            if(config.enabled)
            {
               config.weightLabelWidth = Parser.parsePositiveNumber(config.weightLabelWidth,200);
               config.itemCardDelay = Parser.parsePositiveNumber(config.itemCardDelay,100);
            }
            return config;
         }
         var cnf:* = {};
         cnf.enabled = false;
         return cnf;
      }
      
      private static function loadItemNamesGroupConfig(config:*) : *
      {
         if(!config)
         {
            return {};
         }
         return config;
      }
      
      private static function loadAdditionalColumnsConfig(config:*) : *
      {
         if(!config)
         {
            return {"enabled":false};
         }
         config.enabled = Boolean(config.enabled);
         if(!config.columns)
         {
            config.columns = {};
         }
         config.offsetInventories = Parser.parseNumber(config.offsetInventories,125);
         return config;
      }
      
      private static function loadDefaultVendorItemPriceConfig(config:*) : *
      {
         if(config == null)
         {
            return {"enabled":false};
         }
         if(config is Number || config is String)
         {
            return {
               "enabled":true,
               "defaultValue":config,
               "itemNames":{},
               "categoryNames":{}
            };
         }
         if(!(config is Object))
         {
            return {"enabled":false};
         }
         if(config.defaultValue == null)
         {
            config.defaultValue = -1;
         }
         if(config.itemNames == null)
         {
            config.itemNames = {};
         }
         if(config.categoryNames == null)
         {
            config.categoryNames = {};
         }
         return config;
      }
   }
}

