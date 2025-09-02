package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.GlobalFunc;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol17")]
   public class QuantityMenu extends BSUIComponent
   {
      
      private static const LabelBufferX:* = 3;
      
      public static const QUANTITY_CHANGED:* = "QuantityChanged";
      
      public static const QUANTITY_INPUT_CHANGED:* = "QuantityInputChanged";
      
      public static const QUANTITY_INPUT_CANCELLED:* = "QuantityInputCancelled";
      
      private static const SCROLL_STARTSPEED:* = 300;
      
      private static const SCROLL_TIMECOEF:* = 1000;
      
      private static const SCROLL_MAX:* = 10;
      
      public static const INV_MAX_NUM_BEFORE_QUANTITY_MENU:uint = 5;
      
      public static const CONFIRM:String = "QuantityMenu::quantityConfirmed";
      
      public static const MAX:String = "QuantityMenu::quantityMaxed";
      
      public static const CANCEL:String = "QuantityMenu::quantityCancelled";
      
      public var Label_tf:TextField;
      
      public var Value_tf:TextField;
      
      public var ValueMin_tf:TextField;
      
      public var ValueMax_tf:TextField;
      
      public var TotalValue_tf:TextField;
      
      public var CapsLabel_tf:TextField;
      
      public var QuantityScrollbar_mc:Option_Scrollbar;
      
      public var Header_mc:MovieClip;
      
      public var Tooltip_mc:MovieClip;
      
      public var Value_mc:MovieClip;
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var QuantityBracketHolder_mc:MovieClip;
      
      private var bIsScrolling:Boolean;
      
      private var uiScrollStartTime:uint;
      
      private var uiScrollCurSpeed:uint;
      
      private var iScrollSpeed:int;
      
      protected var uiQuantity:uint;
      
      protected var uiMaxQuantity:uint;
      
      protected var uiMinQuantity:uint;
      
      protected var iArrowStepSize:int;
      
      protected var iShoulderStepSize:int;
      
      protected var iTriggerStepSize:int;
      
      private var fInventoryTarget:Number;
      
      protected var bOpened:Boolean;
      
      protected var prevFocusObj:InteractiveObject;
      
      protected var uiItemValue:uint = 0;
      
      protected var m_ValueList:Array;
      
      protected var m_AcceptButton:BSButtonHintData;
      
      protected var m_MaxButton:BSButtonHintData;
      
      protected var m_CancelButton:BSButtonHintData;
      
      public function QuantityMenu()
      {
         var _loc1_:Vector.<BSButtonHintData> = null;
         this.m_AcceptButton = new BSButtonHintData("$ACCEPT","Space","PSN_A","Xenon_A",1,this.onConfirm);
         this.m_MaxButton = new BSButtonHintData("$MAX","Q","PSN_L3","Xenon_L3",1,this.onMax);
         this.m_CancelButton = new BSButtonHintData("$CANCEL","TAB","PSN_B","Xenon_B",1,this.onCancel);
         super();
         this.uiScrollStartTime = 0;
         this.uiScrollCurSpeed = 1;
         this.iScrollSpeed = 1;
         this.uiQuantity = 1;
         this.uiMaxQuantity = 1;
         this.uiMinQuantity = 1;
         this.bOpened = false;
         this.bIsScrolling = false;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(Option_Scrollbar.VALUE_CHANGE,this.onValueChange);
         this.QuantityScrollbar_mc.removeEventListener(MouseEvent.CLICK,this.QuantityScrollbar_mc.onClick);
         this.QuantityScrollbar_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowMouseDown);
         if(this.Header_mc != null)
         {
            this.Label_tf = this.Header_mc.textField;
         }
         if(this.Value_mc != null)
         {
            this.Value_tf = this.Value_mc.Value_tf;
         }
         this.Value_tf.restrict = "0-9";
         mouseEnabled = false;
         mouseChildren = false;
         if(this.ButtonHintBar_mc != null)
         {
            _loc1_ = new Vector.<BSButtonHintData>();
            _loc1_.push(this.m_AcceptButton);
            _loc1_.push(this.m_MaxButton);
            _loc1_.push(this.m_CancelButton);
            this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
         }
         this.ShowMaxQuantityButton(false);
         this.Value_tf.addEventListener(MouseEvent.CLICK,this.onValueClicked);
      }
      
      private function onFireForgetEventUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         if(this.bOpened)
         {
            _loc2_ = param1.data.eventArray;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               switch(_loc2_[_loc3_].eventName)
               {
                  case QUANTITY_INPUT_CHANGED:
                     this.Value_tf.text = _loc2_[_loc3_].textData;
                     this.updateQuantityInput();
                     stage.focus = this;
                     break;
                  case QUANTITY_INPUT_CANCELLED:
                     stage.focus = this;
                     break;
               }
               _loc3_++;
            }
         }
      }
      
      public function set acceptButtonText(param1:String) : void
      {
         this.m_AcceptButton.ButtonText = param1;
      }
      
      public function set cancelButtonText(param1:String) : void
      {
         this.m_CancelButton.ButtonText = param1;
      }
      
      public function set tooltip(param1:String) : void
      {
         if(this.Tooltip_mc != null)
         {
            this.Tooltip_mc.textField.text = param1;
         }
      }
      
      public function get opened() : Boolean
      {
         return this.bOpened;
      }
      
      public function get quantity() : uint
      {
         if(this.m_ValueList != null)
         {
            return this.m_ValueList[this.uiQuantity];
         }
         return this.uiQuantity;
      }
      
      public function set quantity(param1:uint) : void
      {
         if(this.m_ValueList != null)
         {
            this.m_ValueList[this.uiQuantity] = param1;
         }
         else
         {
            this.uiQuantity = param1;
         }
      }
      
      public function get prevFocus() : InteractiveObject
      {
         return this.prevFocusObj;
      }
      
      public function get inTextInputMode() : Boolean
      {
         return Boolean(this.Value_tf) && stage.focus == this.Value_tf;
      }
      
      public function ShowMaxQuantityButton(param1:Boolean) : void
      {
         this.m_MaxButton.ButtonVisible = param1;
      }
      
      public function OpenMenuRange(param1:InteractiveObject, param2:String, param3:uint, param4:uint, param5:uint = 4294967295, param6:* = 0, param7:Boolean = false) : *
      {
         this.OpenMenu(param4,param1,param2,param6,param3,param5,param7);
      }
      
      public function OpenMenuList(param1:InteractiveObject, param2:String, param3:Array) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = uint(param3.length - 1);
         this.m_ValueList = param3;
         this.OpenMenu(_loc5_,param1,param2,0,_loc4_);
      }
      
      public function OpenMenu(param1:int, param2:InteractiveObject, param3:String = "", param4:* = 0, param5:uint = 1, param6:uint = 4294967295, param7:Boolean = false) : *
      {
         if(this.Value_tf)
         {
            this.Value_tf.addEventListener(FocusEvent.FOCUS_OUT,this.onValueInputFocusOut);
            this.Value_tf.addEventListener(FocusEvent.FOCUS_IN,this.onValueInputFocusIn);
            this.Value_tf.addEventListener(MouseEvent.MOUSE_OVER,this.onValueInputMouseOver);
            this.Value_tf.addEventListener(MouseEvent.MOUSE_OUT,this.onValueInputMouseOut);
         }
         if(param6 != uint.MAX_VALUE)
         {
            this.uiQuantity = param6;
         }
         else
         {
            this.uiQuantity = param1;
         }
         this.uiMinQuantity = param5;
         this.uiMaxQuantity = param1;
         this.QuantityScrollbar_mc.MinValue = param5;
         this.QuantityScrollbar_mc.MaxValue = param1;
         this.iArrowStepSize = 1;
         this.iShoulderStepSize = Math.max(param1 / 20,1);
         this.iTriggerStepSize = Math.max(param1 / 4,1);
         this.QuantityScrollbar_mc.StepSize = this.iArrowStepSize;
         this.QuantityScrollbar_mc.value = this.uiQuantity;
         this.uiItemValue = param4;
         if(param3.length)
         {
            GlobalFunc.SetText(this.Label_tf,param3,false);
         }
         if(this.QuantityBracketHolder_mc != null)
         {
            this.FitBrackets();
         }
         this.RefreshText();
         this.prevFocusObj = param2;
         this.updateInputButton();
         if(param7)
         {
            this.gotoAndPlay("rollOn");
         }
         else
         {
            this.alpha = 1;
         }
         mouseEnabled = true;
         mouseChildren = true;
         this.bOpened = true;
         this.Value_tf.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function CloseMenu(param1:Boolean = false) : *
      {
         if(this.Value_tf)
         {
            this.Value_tf.removeEventListener(FocusEvent.FOCUS_OUT,this.onValueInputFocusOut);
            this.Value_tf.removeEventListener(FocusEvent.FOCUS_IN,this.onValueInputFocusIn);
            this.Value_tf.removeEventListener(MouseEvent.MOUSE_OVER,this.onValueInputMouseOver);
            this.Value_tf.removeEventListener(MouseEvent.MOUSE_OUT,this.onValueInputMouseOut);
         }
         this.prevFocusObj = null;
         if(param1)
         {
            this.gotoAndPlay("rollOff");
         }
         else
         {
            this.alpha = 0;
         }
         this.stopScroll();
         this.bOpened = false;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function CancelTextInput() : void
      {
         stage.focus == this;
      }
      
      private function FitBrackets() : *
      {
         var _loc1_:Number = this.Label_tf.x + this.Label_tf.width * 0.5;
         var _loc2_:Number = this.Label_tf.textWidth;
         var _loc3_:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuLeftBracket_mc;
         var _loc4_:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuRightBracket_mc;
         var _loc5_:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuBottomBracket_mc;
         _loc3_.x = _loc1_ - _loc2_ * 0.5 - LabelBufferX - _loc3_.width - this.QuantityBracketHolder_mc.x;
         _loc4_.x = _loc1_ + _loc2_ * 0.5 + LabelBufferX + _loc4_.width - this.QuantityBracketHolder_mc.x;
         _loc5_.width = _loc4_.x - _loc3_.x;
         _loc5_.x = _loc1_ - _loc5_.width * 0.5 - this.QuantityBracketHolder_mc.x;
         if(this.QuantityScrollbar_mc.x < this.QuantityBracketHolder_mc.x + _loc3_.x + 20)
         {
            this.QuantityScrollbar_mc.x = this.QuantityBracketHolder_mc.x + _loc3_.x + 15;
            this.QuantityScrollbar_mc.width = _loc4_.x - _loc3_.x - 15;
         }
      }
      
      private function RefreshText() : *
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(stage.focus == null)
         {
            stage.focus = this;
         }
         var _loc1_:uint = this.uiMinQuantity;
         var _loc2_:uint = this.uiMaxQuantity;
         var _loc3_:uint = this.uiQuantity;
         if(this.m_ValueList != null)
         {
            _loc4_ = this.m_ValueList.length;
            _loc1_ = uint(this.m_ValueList[0]);
            _loc2_ = uint(this.m_ValueList[_loc4_ - 1]);
            _loc3_ = uint(this.m_ValueList[this.uiQuantity]);
         }
         if(this.ValueMin_tf != null)
         {
            GlobalFunc.SetText(this.ValueMin_tf,_loc1_.toString(),false);
         }
         if(this.ValueMax_tf != null)
         {
            GlobalFunc.SetText(this.ValueMax_tf,_loc2_.toString(),false);
         }
         if(this.Value_tf != null)
         {
            GlobalFunc.SetText(this.Value_tf,_loc3_.toString(),false);
         }
         this.QuantityScrollbar_mc.value = this.uiQuantity;
         if(this.TotalValue_tf != null)
         {
            _loc5_ = this.uiQuantity * this.uiItemValue;
            GlobalFunc.SetText(this.TotalValue_tf,_loc5_.toString(),false);
         }
      }
      
      private function modifyQuantity(param1:int) : *
      {
         var _loc2_:int = this.uiQuantity + param1;
         _loc2_ = Math.min(_loc2_,this.uiMaxQuantity);
         _loc2_ = Math.max(_loc2_,this.uiMinQuantity);
         if(this.uiQuantity != _loc2_)
         {
            this.uiQuantity = _loc2_;
            this.RefreshText();
            dispatchEvent(new CustomEvent(QUANTITY_CHANGED,_loc2_,true));
         }
      }
      
      public function updateQuantityInput() : Boolean
      {
         var _loc1_:Boolean = false;
         if(Boolean(this.Value_tf) && this.uiQuantity != uint(this.Value_tf.text))
         {
            this.quantityInput(uint(this.Value_tf.text));
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function quantityInput(param1:uint) : void
      {
         var _loc2_:* = Math.min(param1,this.uiMaxQuantity);
         _loc2_ = Math.max(_loc2_,this.uiMinQuantity);
         this.uiQuantity = _loc2_;
         this.RefreshText();
         dispatchEvent(new CustomEvent(QUANTITY_CHANGED,_loc2_,true));
      }
      
      private function stopScroll() : *
      {
         this.bIsScrolling = false;
         this.uiScrollCurSpeed = 1;
         removeEventListener(Event.ENTER_FRAME,this.onArrowTick);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      public function onKeyDown(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.RIGHT)
         {
            this.bIsScrolling = true;
            this.uiScrollStartTime = getTimer();
            this.iScrollSpeed = 1;
            this.modifyQuantity(1);
            this.fInventoryTarget = -1;
            addEventListener(Event.ENTER_FRAME,this.onArrowTick);
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         else if(param1.keyCode == Keyboard.LEFT)
         {
            this.bIsScrolling = true;
            this.uiScrollStartTime = getTimer();
            this.iScrollSpeed = -1;
            this.modifyQuantity(-1);
            this.fInventoryTarget = -1;
            addEventListener(Event.ENTER_FRAME,this.onArrowTick);
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         else if(param1.keyCode >= Keyboard.NUMBER_0 && param1.keyCode <= Keyboard.NUMBER_9 || param1.keyCode >= Keyboard.NUMPAD_0 && param1.keyCode <= Keyboard.NUMPAD_9)
         {
            if(this.Value_tf.selectionEndIndex - this.Value_tf.selectionBeginIndex == this.Value_tf.text.length)
            {
               this.Value_tf.text = "";
            }
            if(stage.focus != this.Value_tf)
            {
               this.Value_tf.text += String.fromCharCode(param1.charCode);
            }
            this.updateQuantityInput();
         }
         else if(param1.keyCode == Keyboard.BACKSPACE)
         {
            if(this.Value_tf.selectionEndIndex - this.Value_tf.selectionBeginIndex == this.Value_tf.text.length)
            {
               this.Value_tf.text = "";
            }
            else if(stage.focus != this.Value_tf)
            {
               if(this.Value_tf.text.length > 0)
               {
                  this.Value_tf.text = this.Value_tf.text.substr(0,this.Value_tf.text.length - 1);
               }
            }
            if(this.Value_tf.text.length > 0)
            {
               this.updateQuantityInput();
            }
         }
      }
      
      public function onValueClicked(param1:MouseEvent) : *
      {
         stage.focus = this;
         this.Value_tf.setSelection(0,this.Value_tf.text.length);
      }
      
      public function onKeyUp(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.RIGHT || param1.keyCode == Keyboard.LEFT)
         {
            this.stopScroll();
         }
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.SPACE)
         {
            if(this.Value_mc && stage.focus != this.Value_tf || !this.updateQuantityInput())
            {
               stage.focus = this;
               this.onConfirm();
            }
         }
         if(param1.keyCode == Keyboard.TAB || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(this.Value_mc) && stage.focus == this.Value_tf)
            {
               stage.focus = this;
            }
         }
      }
      
      private function onConfirm() : void
      {
         this.stopScroll();
         dispatchEvent(new Event(CONFIRM,true,true));
      }
      
      private function onMax() : void
      {
         this.stopScroll();
         dispatchEvent(new Event(MAX,true,true));
      }
      
      private function onCancel() : void
      {
         this.stopScroll();
         dispatchEvent(new Event(CANCEL,true,true));
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         if(param1.delta > 0)
         {
            this.modifyQuantity(this.iArrowStepSize);
         }
         else if(param1.delta < 0)
         {
            this.modifyQuantity(-this.iArrowStepSize);
         }
      }
      
      internal function onArrowMouseUp() : void
      {
         this.bIsScrolling = false;
         this.uiScrollCurSpeed = 1;
         removeEventListener(Event.ENTER_FRAME,this.onArrowTick);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
      }
      
      internal function onArrowTick(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if(this.bIsScrolling)
         {
            _loc2_ = getTimer() - this.uiScrollStartTime;
            if(_loc2_ > SCROLL_STARTSPEED)
            {
               this.uiScrollCurSpeed += int(Math.floor(this.uiScrollCurSpeed * (_loc2_ / SCROLL_TIMECOEF)));
               this.uiScrollCurSpeed = Math.min(this.uiScrollCurSpeed,SCROLL_MAX);
               if(this.fInventoryTarget > -1 && (this.uiQuantity + this.uiScrollCurSpeed * this.iScrollSpeed > this.fInventoryTarget && this.iScrollSpeed > 0 || this.uiQuantity + this.uiScrollCurSpeed * this.iScrollSpeed < this.fInventoryTarget && this.iScrollSpeed < 0))
               {
                  this.modifyQuantity(this.fInventoryTarget - this.uiQuantity);
                  this.onArrowMouseUp();
               }
               this.modifyQuantity(this.uiScrollCurSpeed * this.iScrollSpeed);
            }
         }
      }
      
      internal function onValueChange(param1:Event) : void
      {
         this.uiQuantity = this.QuantityScrollbar_mc.value;
         this.RefreshText();
      }
      
      public function onArrowMouseDown(param1:MouseEvent) : *
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc2_:Object = param1.target;
         if(param1.target as MovieClip)
         {
            _loc3_ = param1.target as MovieClip;
            if(_loc3_ == this.QuantityScrollbar_mc.RightCatcher_mc)
            {
               this.bIsScrolling = true;
               this.uiScrollStartTime = getTimer();
               this.iScrollSpeed = 1;
               _loc4_ = this.QuantityScrollbar_mc.Thumb_mc.x + this.QuantityScrollbar_mc.Thumb_mc.width / 2;
               this.fInventoryTarget = this.QuantityScrollbar_mc.CalcInventoryTarget(param1.currentTarget.mouseX);
               this.modifyQuantity(this.iArrowStepSize);
               _loc5_ = this.QuantityScrollbar_mc.Thumb_mc.x + this.QuantityScrollbar_mc.Thumb_mc.width / 2;
               stage.addEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
               if(_loc5_ - param1.currentTarget.mouseX > 0 == _loc4_ - param1.currentTarget.mouseX > 0)
               {
                  addEventListener(Event.ENTER_FRAME,this.onArrowTick);
               }
            }
            else if(_loc3_ == this.QuantityScrollbar_mc.LeftCatcher_mc)
            {
               this.bIsScrolling = true;
               this.uiScrollStartTime = getTimer();
               this.iScrollSpeed = -1;
               this.fInventoryTarget = this.QuantityScrollbar_mc.CalcInventoryTarget(param1.currentTarget.mouseX);
               _loc4_ = this.QuantityScrollbar_mc.Thumb_mc.x + this.QuantityScrollbar_mc.Thumb_mc.width / 2;
               this.modifyQuantity(-this.iArrowStepSize);
               _loc5_ = this.QuantityScrollbar_mc.Thumb_mc.x + this.QuantityScrollbar_mc.Thumb_mc.width / 2;
               stage.addEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
               if(_loc5_ - param1.currentTarget.mouseX > 0 == _loc4_ - param1.currentTarget.mouseX > 0)
               {
                  addEventListener(Event.ENTER_FRAME,this.onArrowTick);
               }
            }
         }
      }
      
      private function onValueInputFocusIn(param1:FocusEvent) : *
      {
         param1.stopPropagation();
         if(stage.focus != this.Value_tf)
         {
            stage.focus = this.Value_tf;
         }
         this.Value_mc.ValueInputBG_mc.gotoAndStop("selected");
         this.updateInputButton();
         BSUIDataManager.dispatchEvent(new CustomEvent("QuantityInput::StartEditText",{"currentText":this.Value_tf.text}));
      }
      
      private function onValueInputFocusOut(param1:FocusEvent) : *
      {
         param1.stopPropagation();
         this.updateInputButton();
         this.Value_mc.ValueInputBG_mc.gotoAndStop("default");
         BSUIDataManager.dispatchEvent(new CustomEvent("QuantityInput::EndEditText",{}));
         this.Value_tf.text = this.uiQuantity.toString();
         stage.focus = this;
      }
      
      private function onValueInputMouseOver(param1:MouseEvent) : *
      {
         this.Value_mc.ValueInputBG_mc.gotoAndStop("selected");
      }
      
      private function onValueInputMouseOut(param1:MouseEvent) : *
      {
         if(stage.focus != this.Value_tf)
         {
            this.Value_mc.ValueInputBG_mc.gotoAndStop("default");
         }
      }
      
      private function updateInputButton() : void
      {
         switch(uiController)
         {
            case PlatformChangeEvent.PLATFORM_PC_KB_MOUSE:
               if(Boolean(this.Value_mc) && Boolean(this.Value_mc.ValueFocusButton_mc))
               {
                  this.Value_mc.ValueFocusButton_mc.visible = false;
               }
               break;
            case PlatformChangeEvent.PLATFORM_PC_GAMEPAD:
            case PlatformChangeEvent.PLATFORM_PS4:
            case PlatformChangeEvent.PLATFORM_XB1:
               if(Boolean(this.Value_mc) && Boolean(this.Value_mc.ValueFocusButton_mc))
               {
                  this.Value_mc.ValueFocusButton_mc.visible = stage.focus != this.Value_tf;
               }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            if(param1 == "LShoulder")
            {
               this.modifyQuantity(-this.iShoulderStepSize);
               _loc3_ = true;
            }
            else if(param1 == "RShoulder")
            {
               this.modifyQuantity(this.iShoulderStepSize);
               _loc3_ = true;
            }
            else if(param1 == "LTrigger")
            {
               this.modifyQuantity(-this.iTriggerStepSize);
               _loc3_ = true;
            }
            else if(param1 == "RTrigger")
            {
               this.modifyQuantity(this.iTriggerStepSize);
               _loc3_ = true;
            }
            else if(param1 == "Q" && this.m_MaxButton.ButtonVisible)
            {
               this.onMax();
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      override public function SetPlatform(param1:uint, param2:Boolean, param3:uint, param4:uint) : void
      {
         super.SetPlatform(param1,param2,param3,param4);
         this.updateInputButton();
      }
   }
}

