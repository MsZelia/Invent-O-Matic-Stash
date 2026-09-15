package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol31")]
   public class ScrapComponentListEntry extends BSScrollingListEntry
   {
      
      public function ScrapComponentListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         if(textField != null && param1 != null && Boolean(param1.hasOwnProperty("text")))
         {
            if(param2 == BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT)
            {
               TextFieldEx.setTextAutoSize(textField,"shrink");
            }
            else if(param2 == BSScrollingList.TEXT_OPTION_MULTILINE)
            {
               textField.autoSize = TextFieldAutoSize.LEFT;
               textField.multiline = true;
               textField.wordWrap = true;
            }
            if(param1.text != undefined)
            {
               _loc3_ = param1.count != 1 ? param1.text + " (" + param1.count + ")" : param1.text;
               GlobalFunc.SetText(textField,_loc3_,true);
            }
            else
            {
               GlobalFunc.SetText(textField," ",true);
            }
            textField.textColor = this.selected ? 0 : uint(ORIG_TEXT_COLOR);
         }
         if(border != null)
         {
            border.alpha = this.selected ? GlobalFunc.SELECTED_RECT_ALPHA : 0;
            if(textField != null && param2 == BSScrollingList.TEXT_OPTION_MULTILINE && textField.numLines > 1)
            {
               _loc4_ = textField.y - border.y;
               border.height = textField.textHeight + _loc4_ * 2 + 5;
            }
            else
            {
               border.height = ORIG_BORDER_HEIGHT;
            }
         }
      }
   }
}

