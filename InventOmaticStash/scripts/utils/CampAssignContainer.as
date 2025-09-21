package utils
{
   import Shared.AS3.Data.BSUIDataManager;
   
   public class CampAssignContainer
   {
      
      private static var OtherInventoryTypeData:*;
      
      public static const VENDOR:String = "VENDOR";
      
      public static const DISPLAY:String = "DISPLAY";
      
      public static const OTHER:String = "OTHER";
      
      public function CampAssignContainer()
      {
         super();
      }
      
      public static function init() : void
      {
         OtherInventoryTypeData = BSUIDataManager.GetDataFromClient("OtherInventoryTypeData").data;
      }
      
      public static function get MenuMode() : int
      {
         return OtherInventoryTypeData.menuType;
      }
      
      public static function get DefaultHeaderText() : String
      {
         return OtherInventoryTypeData.defaultHeaderText.toUpperCase();
      }
      
      public static function get AssignSlotsFilled() : int
      {
         if(OtherInventoryTypeData && OtherInventoryTypeData.slotDataA && OtherInventoryTypeData.slotDataA.length > 0)
         {
            var totalSlots:int = 0;
            var slotData:Object = null;
            for each(slotData in OtherInventoryTypeData.slotDataA)
            {
               totalSlots += slotData.slotCountFilled;
            }
            return totalSlots;
         }
         return 0;
      }
      
      public static function get AssignSlotsMax() : int
      {
         if(OtherInventoryTypeData && OtherInventoryTypeData.slotDataA && OtherInventoryTypeData.slotDataA.length > 0)
         {
            var totalSlots:int = 0;
            var slotData:Object = null;
            for each(slotData in OtherInventoryTypeData.slotDataA)
            {
               totalSlots += slotData.slotCountMax;
            }
            return totalSlots;
         }
         return 0;
      }
      
      public static function get AssignSlotsFree() : int
      {
         if(OtherInventoryTypeData && OtherInventoryTypeData.slotDataA && OtherInventoryTypeData.slotDataA.length > 0)
         {
            var totalSlots:int = 0;
            var totalSlotsFilled:int = 0;
            var slotData:Object = null;
            for each(slotData in OtherInventoryTypeData.slotDataA)
            {
               totalSlots += slotData.slotCountMax;
               totalSlotsFilled += slotData.slotCountFilled;
            }
            return totalSlots - totalSlotsFilled;
         }
         return 0;
      }
   }
}

