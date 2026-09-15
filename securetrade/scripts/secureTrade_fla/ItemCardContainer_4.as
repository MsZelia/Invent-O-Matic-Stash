package secureTrade_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol359")]
   public dynamic class ItemCardContainer_4 extends MovieClip
   {
      
      public var Background_mc:MovieClip;
      
      public var ItemCard_mc:ItemCard;
      
      public function ItemCardContainer_4()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
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

