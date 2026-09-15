package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol245")]
   public class ItemCard_FireModeEntry extends ItemCard_Entry
   {
      
      public function ItemCard_FireModeEntry()
      {
         addFrameScript(0,this.frame1,1,this.frame2);
         super();
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         if(totalFrames > 1)
         {
            gotoAndStop(param1.difference != 0 ? "difference" : "default");
         }
         super.PopulateEntry(param1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

