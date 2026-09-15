package
{
   import Shared.AS3.QuantityMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol311")]
   public dynamic class modalSetPrice extends QuantityMenu
   {
      
      public function modalSetPrice()
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

