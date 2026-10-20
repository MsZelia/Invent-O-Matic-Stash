package
{
   import Shared.AS3.MenuComponent;
   import Shared.AS3.SWFLoaderClip;
   import Shared.AS3.SecureTradeShared;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import scaleform.gfx.TextFieldEx;
   
   public class SecureTradeInventory extends MenuComponent
   {
      
      public static const MOUSE_OVER:String = "SecureTradeInventory::MouseOver";
      
      public var ItemList_mc:MenuListComponent;
      
      public var Header_mc:MovieClip;
      
      public var CurrencyIcon_mc:SWFLoaderClip;
      
      private var m_CurrencyIconInstance:MovieClip;
      
      public function SecureTradeInventory()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         TextFieldEx.setTextAutoSize(this.Header_mc.Header_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.CurrencyIcon_mc.clipWidth = this.CurrencyIcon_mc.width * (1 / this.CurrencyIcon_mc.scaleX);
         this.CurrencyIcon_mc.clipHeight = this.CurrencyIcon_mc.height * (1 / this.CurrencyIcon_mc.scaleY);
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
         var _loc1_:Object = this.parent as Object;
         var _loc2_:uint = SecureTradeShared.CURRENCY_CAPS;
         if(_loc1_)
         {
            _loc2_ = uint(_loc1_.currencyType);
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

