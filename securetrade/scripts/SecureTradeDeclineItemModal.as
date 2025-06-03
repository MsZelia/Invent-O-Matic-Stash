package
{
   import Shared.AS3.BCBasicMenu;
   import Shared.AS3.BCBasicMenuItem;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol295")]
   public class SecureTradeDeclineItemModal extends BCBasicMenu
   {
      
      public static const REJECT_REASONS:Array = ["DontWant","DontWantType","NotEnoughCaps","PriceTooHigh","MoreOfThis","LessOfThis"];
      
      public static const CONFIRM:String = "DeclineItemModal::declineConfirm";
      
      public static const ROWS:Number = 2;
      
      public static const COLUMNS:Number = 3;
       
      
      public var DeclineButtons_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      public var Tooltip_mc:MovieClip;
      
      public var ItemServerHandleID:Number = 0;
      
      public function SecureTradeDeclineItemModal()
      {
         addFrameScript(0,this.frame1,10,this.frame11,21,this.frame22);
         mouseEnabled = false;
         mouseChildren = false;
         m_Horizontal = true;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         super();
      }
      
      override protected function setActive(param1:Boolean) : void
      {
         super.setActive(param1);
         if(param1 != _active)
         {
            if(param1)
            {
               gotoAndPlay("rollOn");
            }
            else
            {
               gotoAndPlay("rollOff");
            }
            mouseEnabled = param1;
            mouseChildren = param1;
         }
      }
      
      override protected function onItemPress() : *
      {
         dispatchEvent(new Event(CONFIRM,true,true));
      }
      
      override public function onKeyDown(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.UP)
         {
            this.selectVerticalDelta(-1);
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            this.selectVerticalDelta(1);
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            this.selectHorizontalDelta(-1);
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            this.selectHorizontalDelta(1);
            param1.stopPropagation();
         }
      }
      
      private function selectVerticalDelta(param1:int) : void
      {
         selectedIndex = this.clampIndex(selectedIndex + param1 * COLUMNS);
      }
      
      private function selectHorizontalDelta(param1:int) : void
      {
         selectedIndex = this.clampIndex(selectedIndex + param1);
      }
      
      private function clampIndex(param1:int) : int
      {
         var _loc2_:int = param1;
         if(param1 < 0)
         {
            _loc2_ = 0;
         }
         else if(param1 > m_Entries.length - 1)
         {
            _loc2_ = selectedIndex;
         }
         return _loc2_;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.Header_mc.textField.text = "$DeclineItem";
         this.Tooltip_mc.textField.text = "$DeclineItemSetReason";
         var _loc1_:uint = 0;
         while(_loc1_ < REJECT_REASONS.length)
         {
            addItem(this.DeclineButtons_mc["ReasonButton_" + REJECT_REASONS[_loc1_]] as BCBasicMenuItem);
            _loc1_++;
         }
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
