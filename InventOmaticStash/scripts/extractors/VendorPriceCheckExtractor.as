package extractors
{
   import Shared.AS3.SecureTradeShared;
   import flash.display.MovieClip;
   import flash.utils.setTimeout;
   import utils.Logger;
   
   public class VendorPriceCheckExtractor extends BaseItemExtractor
   {
      
      public static const MOD_NAME:String = "Invent-O-Matic-Vendor-Extractor";
      
      public function VendorPriceCheckExtractor(param1:Object)
      {
         super(param1,MOD_NAME,Version.VENDOR);
      }
      
      override public function buildOutputObject() : Object
      {
         var _loc1_:Object = super.buildOutputObject();
         _loc1_.characterInventories = {};
         var _loc2_:Object = {};
         _loc2_.stashInventory = this.stashInventory;
         _loc2_.AccountInfoData = {"name":secureTrade.m_DefaultHeaderText};
         _loc2_.CharacterInfoData = {};
         _loc1_.characterInventories["priceCheck"] = _loc2_;
         return _loc1_;
      }
      
      override public function setInventory(param1:MovieClip) : void
      {
         var delay:Number;
         var parent:MovieClip = param1;
         if(!isSfeDefined())
         {
            ShowHUDMessage("SFE cannot be found. Items extraction cancelled.",true);
            Logger.get().error("SFE cannot be found. Items extraction cancelled.");
            return;
         }
         Logger.get().info("Starting gathering items data from stash!");
         delay = populateItemCards(parent,parent.OfferInventory_mc,true,stashInventory);
         setTimeout(function():void
         {
            populateItemCardEntries(stashInventory);
            extractItems();
         },delay);
      }
      
      override public function isValidMode(param1:uint) : Boolean
      {
         return param1 === SecureTradeShared.MODE_PLAYERVENDING || param1 === SecureTradeShared.MODE_NPCVENDING || param1 === SecureTradeShared.MODE_VENDING_MACHINE;
      }
      
      override public function getInvalidModeMessage() : String
      {
         return "Please, use this function only in player\'s vendor!";
      }
   }
}

