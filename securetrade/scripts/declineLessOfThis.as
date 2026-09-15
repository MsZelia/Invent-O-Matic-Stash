package
{
   import Shared.AS3.BCBasicMenuItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol297")]
   public dynamic class declineLessOfThis extends BCBasicMenuItem
   {
      
      public function declineLessOfThis()
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

