package
{
   import utils.Parser;
   
   public class InventOmaticConfig
   {
      
      public static const DEFAULT_SHOW_BUTTON_STATE:Boolean = true;
      
      private static const _ID:String = "R_ID";
      
      private static const _AMOUNT:String = "R_AMOUNT";
      
      private static const TITLE_EXTRACT:String = "Extract Items";
      
      private static const TITLE_SCRAP:String = "AutoScrap";
      
      private static const TITLE_TRANSFER:String = "Trans_" + _ID;
      
      private static const TITLE_LOOT:String = "AutoLoot";
      
      private static const TITLE_NPC_SELL:String = "AutoSell";
      
      private static const TITLE_ASSIGN:String = "Assign " + _AMOUNT;
      
      private static const TITLE_BUY:String = "AutoBuy";
      
      private static const ARRAY_DESC:String = "[object Array]";
      
      private static var toggleDebugKeyCode:uint = 76;
      
      private static var extractKeyCode:uint = 79;
      
      private static var transferKeyCode:uint = 80;
      
      private static var lootKeyCode:uint = 70;
      
      private static var scrapKeyCode:uint = 73;
      
      private static var npcSellKeyCode:uint = 66;
      
      private static var buyKeyCode:uint = 75;
      
      private static var campAssignKeyCode:uint = 85;
      
      private static var calculateCatWeightKeyCode:uint = 116;
      
      private static var swapToPlayerInventoryHotkey:uint = 0;
      
      private static var swapToContainerInventoryHotkey:uint = 0;
      
      private static var _config:Object;
       
      
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
      
      public static function init(jsonObject:*) : Object
      {
         var config:* = jsonObject;
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
            config.scrapConfig = loadScrapConfig(config.scrapConfig);
            setName(config.scrapConfig,TITLE_SCRAP);
            setMaxItems(config.scrapConfig);
         }
         if(config.transferConfig)
         {
            config.transferConfig = loadTransferConfig(config.transferConfig);
            for(var c in config.transferConfig)
            {
               setName(config.transferConfig[c],TITLE_TRANSFER);
               config.transferConfig[c].name = config.transferConfig[c].name.replace(_ID,c);
               setMaxItems(config.transferConfig[c]);
            }
         }
         else
         {
            config.transferConfig = new Array();
         }
         if(config.lootConfig)
         {
            setName(config.lootConfig,TITLE_LOOT);
            setMaxItems(config.lootConfig);
            config.lootConfig = loadLootConfig(config.lootConfig);
         }
         if(config.npcSellConfig)
         {
            config.npcSellConfig = loadNpcSellConfig(config.npcSellConfig);
            setName(config.npcSellConfig,TITLE_NPC_SELL);
            setMaxItems(config.npcSellConfig);
         }
         if(config.campAssignConfig)
         {
            setName(config.campAssignConfig,TITLE_ASSIGN);
            config.campAssignConfig.name = config.campAssignConfig.name.replace(_AMOUNT,config.campAssignConfig.amount);
         }
         if(config.buyConfig)
         {
            setName(config.buyConfig,TITLE_BUY);
            setMaxItems(config.buyConfig);
         }
         if(config.protectionConfig)
         {
            if(config.protectionConfig.transferProtection && config.protectionConfig.transferProtection.disableForContainers)
            {
               for(c in config.protectionConfig.transferProtection.disableForContainers)
               {
                  config.protectionConfig.transferProtection.disableForContainers[c] = config.protectionConfig.transferProtection.disableForContainers[c].toUpperCase();
               }
            }
         }
         config.categoryWeightConfig = loadCategoryWeightConfig(config.categoryWeightConfig);
         config.itemNamesGroupConfig = loadItemNamesGroupConfig(config.itemNamesGroupConfig);
         initHotkeys(config);
         _config = config;
         return _config;
      }
      
      private static function initHotkeys(config:*) : void
      {
         if(config)
         {
            toggleDebugKeyCode = Parser.parsePositiveNumber(config.toggleDebugHotkey,toggleDebugKeyCode);
            extractKeyCode = Parser.parseHotkey(config.extractConfig,extractKeyCode);
            scrapKeyCode = Parser.parseHotkey(config.scrapConfig,scrapKeyCode);
            lootKeyCode = Parser.parseHotkey(config.lootConfig,lootKeyCode);
            npcSellKeyCode = Parser.parseHotkey(config.npcSellConfig,npcSellKeyCode);
            campAssignKeyCode = Parser.parseHotkey(config.campAssignConfig,campAssignKeyCode);
            buyKeyCode = Parser.parseHotkey(config.buyConfig,buyKeyCode);
            calculateCatWeightKeyCode = Parser.parseHotkey(config.categoryWeightConfig,calculateCatWeightKeyCode);
            for(var c in config.transferConfig)
            {
               config.transferConfig[c].hotkey = Parser.parseHotkey(config.transferConfig[c],transferKeyCode);
            }
            swapToPlayerInventoryHotkey = Parser.parsePositiveNumber(config.swapToPlayerInventoryHotkey,0);
            swapToContainerInventoryHotkey = Parser.parsePositiveNumber(config.swapToContainerInventoryHotkey,0);
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
      
      private static function loadTransferConfig(config:*) : *
      {
         if(Object.prototype.toString.call(config) != ARRAY_DESC)
         {
            return new Array(config);
         }
         return config;
      }
      
      private static function loadNpcSellConfig(config:*) : *
      {
         if(!config.configs)
         {
            config.configs = new Array(config);
         }
         else if(config.configs.length == 0)
         {
            config.enabled = false;
         }
         return config;
      }
      
      private static function loadScrapConfig(config:*) : *
      {
         if(!config.configs)
         {
            config.configs = new Array(config);
         }
         else if(config.configs.length == 0)
         {
            config.enabled = false;
         }
         return config;
      }
      
      private static function loadLootConfig(config:*) : *
      {
         if(!config.configs)
         {
            config.configs = [];
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
               config.itemCardDelay = Parser.parsePositiveNumber(config.itemCardDelay,75);
               config.itemCardFilters = config.itemCardFilters && config.itemCardFilters.length > 0 ? config.itemCardFilters : new Array();
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
   }
}
