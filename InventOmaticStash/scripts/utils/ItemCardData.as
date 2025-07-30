package utils
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   
   public class ItemCardData
   {
      
      public static var itemCardEntries:Object = {};
      
      public function ItemCardData()
      {
         super();
      }
      
      public static function init() : void
      {
         BSUIDataManager.Subscribe("InventoryItemCardData",onInventoryItemCardDataUpdate);
      }
      
      public static function get(serverHandleId:uint) : Object
      {
         return itemCardEntries[serverHandleId];
      }
      
      public static function findItemCardValue(itemCards:Array, text:String) : Object
      {
         if(itemCards != null && itemCards.length > 0)
         {
            var i:int = 0;
            while(i < itemCards.length)
            {
               if(itemCards[i].text == text)
               {
                  return itemCards[i].value;
               }
               i++;
            }
         }
         return "";
      }
      
      public static function findResistanceValue(itemCards:Array, damageType:int) : int
      {
         if(itemCards != null && itemCards.length > 0)
         {
            var i:int = 0;
            while(i < itemCards.length)
            {
               if(itemCards[i].text == "$dr" && itemCards[i].damageType == damageType)
               {
                  return int(itemCards[i].value);
               }
               i++;
            }
         }
         return 0;
      }
      
      private static function onInventoryItemCardDataUpdate(e:FromClientDataEvent) : void
      {
         var data:Object = e.data;
         itemCardEntries[data.serverHandleID] = GlobalFunc.CloneObject(data);
      }
   }
}

