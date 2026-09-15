package
{
   import Shared.AS3.BCBasicModal;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol315")]
   public dynamic class modalConfirmPurchase extends BCBasicModal
   {
      
      public function modalConfirmPurchase()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11,21,this.frame22);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         stop();
      }
      
      internal function frame22() : *
      {
         stop();
      }
   }
}

