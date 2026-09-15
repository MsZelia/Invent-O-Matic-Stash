package
{
   import Shared.AS3.QuantityMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol308")]
   public dynamic class modalSetQuantity extends QuantityMenu
   {
      
      public function modalSetQuantity()
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

