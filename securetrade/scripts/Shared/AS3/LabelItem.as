package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol194")]
   public class LabelItem extends MovieClip
   {
      
      private static const DEFAULT_MAX_TEXT_WIDTH:* = 130;
      
      private static const DEFAULT_MAX_TEXT_HEIGHT:* = 28;
      
      private static const DEFAULT_LABEL_BUFFER_X:Number = 8.35;
      
      private static const DEFAULT_LABEL_OFFSET_Y:Number = 4;
      
      private var DisplayText:String;
      
      private var AssociatedID:uint;
      
      public var Label_tf:TextField;
      
      protected var Selected:Boolean = false;
      
      protected var Enabled:Boolean = true;
      
      protected var Selectable:Boolean = true;
      
      protected var StringWidth:Number = 0;
      
      private var m_ForceUppercase:Boolean = true;
      
      public function LabelItem(param1:String, param2:uint, param3:Boolean)
      {
         super();
         this.m_ForceUppercase = param3;
         this.AssociatedID = param2;
         this.DisplayText = GlobalFunc.LocalizeFormattedString(param1);
         this.DisplayText = this.m_ForceUppercase ? this.DisplayText.toUpperCase() : this.DisplayText;
         TextFieldEx.setTextAutoSize(this.Label_tf,"shrink");
         GlobalFunc.SetText(this.Label_tf,this.DisplayText);
         if(this.textWidth > DEFAULT_MAX_TEXT_WIDTH)
         {
            this.Label_tf.width = DEFAULT_MAX_TEXT_WIDTH;
            if(this.textHeight > DEFAULT_MAX_TEXT_HEIGHT)
            {
               this.Label_tf.y -= DEFAULT_LABEL_OFFSET_Y;
            }
            GlobalFunc.SetText(this.Label_tf,this.DisplayText);
         }
         this.Selected = false;
      }
      
      public function get forceUppercase() : Boolean
      {
         return this.m_ForceUppercase;
      }
      
      public function set forceUppercase(param1:Boolean) : *
      {
         this.m_ForceUppercase = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this.Selectable;
      }
      
      public function set selectable(param1:Boolean) : *
      {
         this.Selectable = param1;
         this.selected = this.Selected;
      }
      
      public function get id() : uint
      {
         return this.AssociatedID;
      }
      
      public function get text() : String
      {
         return this.DisplayText;
      }
      
      public function get textWidth() : *
      {
         return this.Label_tf.textWidth;
      }
      
      public function get textHeight() : *
      {
         return this.Label_tf.textHeight;
      }
      
      public function set selected(param1:Boolean) : *
      {
         this.Selected = param1;
         this.colorUpdate();
      }
      
      public function set showAsEnabled(param1:Boolean) : *
      {
         this.Enabled = param1;
         this.colorUpdate();
      }
      
      public function set maxWidth(param1:*) : *
      {
         this.StringWidth = param1;
         this.Label_tf.width = this.maxWidth;
      }
      
      public function get maxWidth() : *
      {
         return this.StringWidth + 2 * DEFAULT_LABEL_BUFFER_X;
      }
      
      private function colorUpdate() : *
      {
         var _loc1_:* = 0;
         if(!this.Selected)
         {
            _loc1_ = this.Enabled && this.Selectable ? 16777163 : 5661031;
         }
         this.Label_tf.textColor = _loc1_;
         this.Label_tf.alpha = this.Selectable ? 1 : GlobalFunc.DIMMED_ALPHA;
      }
   }
}

