package extractors
{
   public class ItemExtractor extends BaseItemExtractor
   {
      
      public static const MOD_NAME:String = "Invent-O-Matic-Extractor";
      
      public function ItemExtractor(param1:Object)
      {
         super(param1,MOD_NAME,Version.ITEM_EXTRACTOR);
      }
      
      override public function buildOutputObject() : Object
      {
         var _loc1_:Object = super.buildOutputObject();
         var _loc2_:Object = GameApiDataExtractor.getCharacterInfoData();
         var _loc3_:Object = GameApiDataExtractor.getAccountInfoData();
         var _loc4_:Object = {};
         _loc4_.playerInventory = this.playerInventory;
         _loc4_.stashInventory = this.stashInventory;
         _loc4_.AccountInfoData = {"name":_loc3_.name};
         _loc4_.CharacterInfoData = {
            "name":_loc2_.name,
            "level":_loc2_.level
         };
         if(_verboseOutput)
         {
            _loc4_.fullGameData = GameApiDataExtractor.getFullApiData(this._apiMethods);
         }
         _loc1_.characterInventories = {};
         _loc1_.characterInventories[_loc2_.name] = _loc4_;
         return _loc1_;
      }
      
      override public function isValidMode(param1:uint) : Boolean
      {
         return true;
      }
      
      override public function getInvalidModeMessage() : String
      {
         return "Please, use this function only in your stash box.";
      }
   }
}

