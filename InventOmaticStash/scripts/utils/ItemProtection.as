package utils
{
   public class ItemProtection
   {
      
      private static const FAVORITE:String = "Favorite";
      
      private static const EQUIPPED:String = "Equipped";
      
      private static const NAMED:String = "Named";
      
      private static const MAX_CURRENCY:String = "Max Currency";
      
      private static var _protectionReason:String = "";
      
      private static var secureTrade:Object;
      
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
         if(itemProtection[item.serverHandleId] != null)
         {
            return itemProtection[item.serverHandleId];
         }
         if(config.equipped && item.equipState == 1)
         {
            _protectionReason = EQUIPPED;
            itemProtection[item.serverHandleId] = true;
            return true;
         }
         if(config.favorite && item.favorite)
         {
            _protectionReason = FAVORITE;
            itemProtection[item.serverHandleId] = true;
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
                  itemProtection[item.serverHandleId] = true;
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
         return false;
      }
   }
}
