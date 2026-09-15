package
{
   import Shared.GlobalFunc;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol13")]
   public class Option_Scrollbar extends MovieClip
   {
      
      public static const VALUE_CHANGE:String = "Option_Scrollbar::VALUE_CHANGE";
      
      public static const VALUE_CHANGE_FAILED:String = "Option_Scrollbar::VALUE_CHANGE_FAILED";
      
      private static const DEFAULT_ANIMATION:* = "Default";
      
      private static const HOVER_ANIMATION:* = "Hover";
      
      public var Track_mc:MovieClip;
      
      public var Thumb_mc:MovieClip;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      public var LeftCatcher_mc:MovieClip;
      
      public var RightCatcher_mc:MovieClip;
      
      public var BarCatcher_mc:MovieClip;
      
      private var m_bHasHoverAnimation:Boolean = false;
      
      private var fValue:Number;
      
      protected var fMinThumbX:Number;
      
      protected var fMaxThumbX:Number;
      
      protected var bDragging:Boolean = false;
      
      private var fMinValue:Number = 0;
      
      private var fMaxValue:Number = 1;
      
      private var fStepSize:Number = 0.05;
      
      private var iStartDragThumb:int;
      
      private var fStartValue:Number;
      
      public var bDisabled:Boolean = false;
      
      private var leftBuffer:Number;
      
      private var rightBuffer:Number;
      
      public function Option_Scrollbar()
      {
         var _loc5_:FrameLabel = null;
         super();
         this.fMinThumbX = this.Track_mc.x;
         this.fMaxThumbX = this.Track_mc.x + this.Track_mc.width - this.Thumb_mc.width;
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.Thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMouseDown);
         this.Thumb_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onThumbMouseOver);
         this.Thumb_mc.addEventListener(MouseEvent.MOUSE_OUT,this.onThumbMouseOut);
         this.leftBuffer = this.Track_mc.x - this.LeftCatcher_mc.x;
         this.rightBuffer = this.RightCatcher_mc.x + this.RightCatcher_mc.width - this.fMaxThumbX;
         var _loc1_:Array = this.Thumb_mc.currentLabels;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc5_ = _loc1_[_loc4_];
            if(_loc5_.name == HOVER_ANIMATION)
            {
               _loc2_ = true;
            }
            else if(_loc5_.name == DEFAULT_ANIMATION)
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         this.m_bHasHoverAnimation = _loc2_ && _loc3_;
      }
      
      public function get MinValue() : Number
      {
         return this.fMinValue;
      }
      
      public function set MinValue(param1:Number) : *
      {
         this.fMinValue = param1;
      }
      
      public function get MaxValue() : Number
      {
         return this.fMaxValue;
      }
      
      public function set MaxValue(param1:Number) : *
      {
         this.fMaxValue = param1;
      }
      
      public function get StepSize() : Number
      {
         return this.fStepSize;
      }
      
      public function set StepSize(param1:Number) : *
      {
         this.fStepSize = param1;
      }
      
      public function get value() : Number
      {
         return this.fValue;
      }
      
      public function set value(param1:Number) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.fValue = Math.min(Math.max(param1,this.fMinValue),this.fMaxValue);
         if(!this.bDragging)
         {
            if(this.fMinValue >= this.fMaxValue)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = (this.fValue - this.fMinValue) / (this.fMaxValue - this.fMinValue);
            }
            _loc3_ = _loc2_ * (this.fMaxThumbX - this.fMinThumbX);
            this.Thumb_mc.x = this.fMinThumbX + _loc3_;
            this.LeftCatcher_mc.width = this.leftBuffer + _loc3_ + this.Thumb_mc.width / 2;
            this.RightCatcher_mc.x = this.LeftCatcher_mc.x + this.LeftCatcher_mc.width;
            this.RightCatcher_mc.width = (1 - _loc2_) * (this.fMaxThumbX - this.fMinThumbX) + this.rightBuffer;
         }
      }
      
      public function CalcInventoryTarget(param1:Number) : *
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = -1;
         param1 -= this.Thumb_mc.width / 2;
         if(param1 >= this.fMinThumbX && param1 <= this.fMaxThumbX)
         {
            _loc3_ = (param1 - this.fMinThumbX) / (this.fMaxThumbX - this.fMinThumbX);
            _loc2_ = (this.fMaxValue - this.fMinValue) * _loc3_ + this.fMinValue;
         }
         return _loc2_;
      }
      
      public function Decrement() : *
      {
         if(!this.bDisabled)
         {
            this.value -= this.fStepSize;
            dispatchEvent(new Event(VALUE_CHANGE,true,true));
         }
         else
         {
            dispatchEvent(new Event(VALUE_CHANGE_FAILED,true,true));
         }
         GlobalFunc.PlayMenuSound("UIMenuQuantity");
      }
      
      public function Increment() : *
      {
         if(!this.bDisabled)
         {
            this.value += this.fStepSize;
            dispatchEvent(new Event(VALUE_CHANGE,true,true));
         }
         else
         {
            dispatchEvent(new Event(VALUE_CHANGE_FAILED,true,true));
         }
         GlobalFunc.PlayMenuSound("UIMenuQuantity");
      }
      
      public function HandleKeyboardInput(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.LEFT && this.value > 0)
         {
            this.Decrement();
         }
         else if(param1.keyCode == Keyboard.RIGHT && this.value < 1)
         {
            this.Increment();
         }
      }
      
      public function onClick(param1:MouseEvent) : *
      {
         if(param1.target == this.LeftCatcher_mc)
         {
            this.Decrement();
         }
         else if(param1.target == this.RightCatcher_mc)
         {
            this.Increment();
         }
         else if(param1.target == this.BarCatcher_mc)
         {
            if(!this.bDisabled)
            {
               this.value = (param1.currentTarget.mouseX - this.BarCatcher_mc.x) / this.BarCatcher_mc.width * (this.fMaxValue - this.fMinValue);
               dispatchEvent(new Event(VALUE_CHANGE,true,true));
            }
            else
            {
               dispatchEvent(new Event(VALUE_CHANGE_FAILED,true,true));
            }
            GlobalFunc.PlayMenuSound("UIMenuQuantity");
         }
      }
      
      private function onThumbMouseDown(param1:MouseEvent) : *
      {
         this.Thumb_mc.startDrag(false,new Rectangle(this.fMinThumbX,this.Thumb_mc.y,this.fMaxThumbX - this.fMinThumbX,0));
         this.bDragging = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMouseMove);
      }
      
      private function onThumbMouseOver(param1:MouseEvent) : *
      {
         this.Thumb_mc.gotoAndStop(HOVER_ANIMATION);
      }
      
      private function onThumbMouseOut(param1:MouseEvent) : *
      {
         this.Thumb_mc.gotoAndStop(DEFAULT_ANIMATION);
      }
      
      private function onThumbMouseMove(param1:MouseEvent) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this.bDisabled)
         {
            _loc2_ = this.Thumb_mc.x;
            _loc3_ = (_loc2_ - this.fMinThumbX) / (this.fMaxThumbX - this.fMinThumbX);
            this.value = this.MinValue + _loc3_ * (this.MaxValue - this.MinValue);
            dispatchEvent(new Event(VALUE_CHANGE,true,true));
         }
         else
         {
            dispatchEvent(new Event(VALUE_CHANGE_FAILED,true,true));
         }
      }
      
      private function onThumbMouseUp(param1:MouseEvent) : *
      {
         this.Thumb_mc.stopDrag();
         this.bDragging = false;
         GlobalFunc.PlayMenuSound("UIMenuQuantity");
         if(!this.bDisabled)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMouseMove);
            dispatchEvent(new Event(VALUE_CHANGE,true,true));
         }
         else
         {
            dispatchEvent(new Event(VALUE_CHANGE_FAILED,true,true));
         }
      }
   }
}

