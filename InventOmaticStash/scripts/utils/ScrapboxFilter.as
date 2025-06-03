package utils
{
   public class ScrapboxFilter
   {
      
      private static const EVENT_SCRAPBOX_SCRAP_TRANSFER_CONFIRM:* = "Container::transferSelectionToScrapConfirm";
       
      
      public function ScrapboxFilter()
      {
         super();
      }
      
      public static function init(config:Object) : void
      {
      }
      
      public static function ScrapAndTransferAll() : void
      {
      }
      
      public static function scrapTransfer(serverHandleID:Number, quantity:uint) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAPBOX_SCRAP_TRANSFER_CONFIRM,{
            "serverHandleID":serverHandleID,
            "quantity":quantity
         }));
      }
      
      public static function transfer(serverHandleID:Number, quantity:uint, containerID:Number) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
            "serverHandleID":serverHandleID,
            "quantity":quantity,
            "fromContainer":false,
            "containerID":containerID
         }));
      }
   }
}
