package
{
   import Shared.AS3.BCBasicMenuItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol281")]
   public dynamic class declineDontWantType extends BCBasicMenuItem
   {
      
      public function declineDontWantType()
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

