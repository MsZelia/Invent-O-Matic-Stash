package
{
   import Shared.AS3.MenuComponent;
   import Shared.AS3.SWFLoaderClip;
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   public class SecureTradeInventory extends MenuComponent
   {
      
      public static const MOUSE_OVER:String = "SecureTradeInventory::MouseOver";
      
      public static var CurrencyLimitIndicator:Boolean = false;
      
      public static const COLUMN_LEVEL:String = "LEVEL";
      
      public static const COLUMN_VALUE:String = "VALUE";
      
      public static const COLUMN_WEIGHT:String = "WEIGHT";
      
      public static const COLUMN_STACK_WEIGHT:String = "STACK_WEIGHT";
      
      public static const COLUMN_VALUE_PER_WEIGHT:String = "VALUE_PER_WEIGHT";
      
      public var ItemList_mc:MenuListComponent;
      
      public var Header_mc:MovieClip;
      
      public var CurrencyIcon_mc:SWFLoaderClip;
      
      private var m_CurrencyIconInstance:MovieClip;
      
      public var zValue_tf:TextField;
      
      public var zLevel_tf:TextField;
      
      public var zWeight_tf:TextField;
      
      public var zStackWeight_tf:TextField;
      
      public var zValuePerWeight_tf:TextField;
      
      public function SecureTradeInventory()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         TextFieldEx.setTextAutoSize(this.Header_mc.Header_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         if(this.CurrencyIcon_mc)
         {
            this.CurrencyIcon_mc.clipWidth = this.CurrencyIcon_mc.width * (1 / this.CurrencyIcon_mc.scaleX);
            this.CurrencyIcon_mc.clipHeight = this.CurrencyIcon_mc.height * (1 / this.CurrencyIcon_mc.scaleY);
         }
         this.zLevel_tf = newTf();
         this.zValue_tf = newTf();
         this.zWeight_tf = newTf();
         this.zStackWeight_tf = newTf();
         this.zValuePerWeight_tf = newTf();
         this.zLevel_tf.text = "Lvl";
         this.zValue_tf.text = "±";
         this.zWeight_tf.text = "Wt";
         this.zStackWeight_tf.text = "Wt*";
         this.zValuePerWeight_tf.text = "±/lb";
      }
      
      private function newTf() : TextField
      {
         var tf:TextField = new TextField();
         tf.x = 0;
         tf.y = 30;
         tf.width = 45;
         tf.height = 30;
         TextFieldEx.setTextAutoSize(tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         tf.wordWrap = false;
         tf.multiline = false;
         var font:TextFormat = new TextFormat("$MAIN_Font",26,GlobalFunc.COLOR_TEXT_HEADER);
         tf.defaultTextFormat = font;
         font.align = "center";
         tf.setTextFormat(font);
         tf.selectable = false;
         tf.mouseWheelEnabled = false;
         tf.mouseEnabled = true;
         tf.visible = false;
         tf.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
         this.Header_mc.addChild(tf);
         return tf;
      }
      
      public function set header(param1:String) : void
      {
         this.Header_mc.Header_tf.text = param1;
      }
      
      private function onMouseOver(param1:MouseEvent) : *
      {
         dispatchEvent(new Event(MOUSE_OVER,true,true));
      }
      
      override public function set Active(param1:*) : void
      {
         connectButtonBar();
         _active = param1;
         this.ItemList_mc.Active = param1;
      }
      
      public function get selectedItemIndex() : Number
      {
         return this.ItemList_mc.selectedIndex;
      }
      
      public function set selectedItemIndex(param1:Number) : *
      {
         this.ItemList_mc.setSelectedIndex(param1);
      }
      
      override public function redrawUIComponent() : void
      {
         var _loc1_:SecureTrade = this.parent as SecureTrade;
         var _loc2_:uint = SecureTradeShared.CURRENCY_CAPS;
         if(Boolean(_loc1_) && Boolean(this.CurrencyIcon_mc))
         {
            _loc2_ = _loc1_.currencyType;
            if(this.m_CurrencyIconInstance != null)
            {
               this.CurrencyIcon_mc.removeChild(this.m_CurrencyIconInstance);
               this.m_CurrencyIconInstance = null;
            }
            this.m_CurrencyIconInstance = SecureTradeShared.setCurrencyIcon(this.CurrencyIcon_mc,_loc2_);
         }
      }
   }
}

