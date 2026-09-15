package
{
   import Shared.AS3.BCBasicMenuItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol285")]
   public dynamic class declineNotEnoughCaps extends BCBasicMenuItem
   {
      
      public function declineNotEnoughCaps()
      {
         super();
         addFrameScript(4,this.frame5,9,this.frame10);
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame10() : *
      {
         stop();
      }
   }
}

