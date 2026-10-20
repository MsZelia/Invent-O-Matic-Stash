package utils
{
   public class ItemProtection
   {
      
      private static var secureTrade:Object;
      
      public static const FAVORITE:String = "Favorite";
      
      public static const EQUIPPED:String = "Equipped";
      
      public static const NAMED:String = "Named";
      
      public static const MAX_CURRENCY:String = "Max Currency";
      
      public static const KNOWN_LEGENDARY_MOD:String = "Known Legendary Mod";
      
      private static var _protectionReason:String = "";
      
      private static var itemProtection:* = {};
      
      public function ItemProtection()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         secureTrade = param1;
      }
      
      public static function get ProtectionReason() : String
      {
         return _protectionReason;
      }
      
      public static function isValidLockConfig(config:Object) : Boolean
      {
         if(!config || !config.itemLocking || !config.itemLocking.enabled)
         {
            return false;
         }
         if(config.saleProtection && config.saleProtection.enabled)
         {
            return true;
         }
         if(config.scrapProtection && config.scrapProtection.enabled)
         {
            return true;
         }
         if(config.transferProtection && config.transferProtection.enabled)
         {
            return true;
         }
         return false;
      }
      
      public static function isProtected(item:Object, config:Object) : Boolean
      {
         _protectionReason = "";
         if(!item || !config || !config.enabled)
         {
            return false;
         }
         if(config.containerName != null && config.disableForContainers != null && config.disableForContainers is Array)
         {
            if(config.disableForContainers.indexOf(config.containerName) != -1)
            {
               return false;
            }
         }
         if(itemProtection[item.serverHandleID] != null)
         {
            _protectionReason = itemProtection[item.serverHandleID];
            return itemProtection[item.serverHandleID];
         }
         if(config.equipped && item.equipState == 1)
         {
            _protectionReason = EQUIPPED;
            return true;
         }
         if(config.favorite && item.favorite)
         {
            _protectionReason = FAVORITE;
            return true;
         }
         if(config.named && config.itemNames && config.itemNames.length > 0 && config.matchMode)
         {
            var i:int = 0;
            var itemNames:Array = [];
            while(i < config.itemNames.length)
            {
               if(InventOmaticConfig.get().itemNamesGroupConfig[config.itemNames[i]] != null)
               {
                  itemNames = itemNames.concat(InventOmaticConfig.get().itemNamesGroupConfig[config.itemNames[i]]);
               }
               i++;
            }
            itemNames = config.itemNames.concat(itemNames);
            i = 0;
            while(i < itemNames.length)
            {
               if(ItemWorker.isMatchingString(item.text,itemNames[i],config.matchMode))
               {
                  _protectionReason = NAMED;
                  itemProtection[item.serverHandleID] = NAMED;
                  return true;
               }
               i++;
            }
         }
         if(config.maxCurrency && item.itemValue + secureTrade.PlayerInventory_mc.currency > secureTrade.PlayerInventory_mc.currencyMax)
         {
            _protectionReason = MAX_CURRENCY;
            return true;
         }
         if(config.knownLegendaryMods && LegendaryMods.isKnownModName(item.text))
         {
            _protectionReason = KNOWN_LEGENDARY_MOD;
            itemProtection[item.serverHandleID] = KNOWN_LEGENDARY_MOD;
            return true;
         }
         return false;
      }
   }
}

