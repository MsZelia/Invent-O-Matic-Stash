package
{
   import Shared.AS3.SWFLoaderClip;
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol174")]
   public class PlayerListEntry extends ItemListEntry
   {
      
      public static var menuMode:uint = SecureTradeShared.MODE_INVALID;
      
      public static var showCurrency:Boolean = true;
      
      public static var playerLevel:Number = 0;
      
      public static var currencyType:uint = SecureTradeShared.CURRENCY_CAPS;
      
      private static const CONDITION_SPACING:Number = 6;
      
      public static var ShowAdditionalColumns:Object = null;
       
      
      public var Price_tf:TextField;
      
      public var CurrencyIcon_mc:SWFLoaderClip;
      
      public var ConditionBar_mc:MovieClip;
      
      public var RequestedTextField:TextField;
      
      private var m_ConditionInitialX:Number = 0;
      
      private var m_LastCurrencyType:uint = 4294967295;
      
      private var m_CurrencyIconInstance:MovieClip;
      
      public var RarityIndicator_mc:MovieClip;
      
      public var RarityBorder_mc:MovieClip;
      
      public var RaritySelector_mc:MovieClip;
      
      private var zValue_tf:TextField;
      
      private var zLevel_tf:TextField;
      
      private var zWeight_tf:TextField;
      
      private var zStackWeight_tf:TextField;
      
      private var zValuePerWeight_tf:TextField;
      
      private var isAdditionalColumnsInit:Boolean = false;
      
      public function PlayerListEntry()
      {
         this.m_LastCurrencyType = 4294967295;
         super();
         if(this.RequestedTextField)
         {
            TextFieldEx.setTextAutoSize(this.RequestedTextField,"shrink");
         }
         if(this.ConditionBar_mc != null)
         {
            this.m_ConditionInitialX = this.ConditionBar_mc.x;
         }
         if(this.CurrencyIcon_mc)
         {
            this.CurrencyIcon_mc.clipWidth = this.CurrencyIcon_mc.width * (1 / this.CurrencyIcon_mc.scaleX);
            this.CurrencyIcon_mc.clipHeight = this.CurrencyIcon_mc.height * (1 / this.CurrencyIcon_mc.scaleY);
         }
         this.zLevel_tf = newTf();
         this.zWeight_tf = newTf();
         this.zValue_tf = newTf();
         this.zStackWeight_tf = newTf();
         this.zValuePerWeight_tf = newTf();
      }
      
      private function newTf() : TextField
      {
         var tf:TextField = new TextField();
         tf.x = 0;
         tf.y = 0;
         tf.width = 45;
         tf.height = 28;
         TextFieldEx.setTextAutoSize(tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         if(false)
         {
            tf.autoSize = TextFieldAutoSize.LEFT;
         }
         tf.wordWrap = false;
         tf.multiline = false;
         var font:TextFormat = new TextFormat("$MAIN_Font",26,uint(ORIG_TEXT_COLOR));
         tf.defaultTextFormat = font;
         font.align = "center";
         tf.setTextFormat(font);
         tf.selectable = false;
         tf.mouseWheelEnabled = false;
         tf.mouseEnabled = false;
         tf.visible = false;
         tf.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
         addChild(tf);
         return tf;
      }
      
      private function initAdditionalColumns() : void
      {
         isAdditionalColumnsInit = true;
         if(ShowAdditionalColumns != null)
         {
            var xPos:int = 460;
            var tf:TextField = null;
            var column:* = null;
            for(column in ShowAdditionalColumns)
            {
               if(ShowAdditionalColumns[column])
               {
                  switch(column)
                  {
                     case SecureTradeInventory.COLUMN_LEVEL:
                        tf = this.zLevel_tf;
                        break;
                     case SecureTradeInventory.COLUMN_VALUE:
                        tf = this.zValue_tf;
                        break;
                     case SecureTradeInventory.COLUMN_WEIGHT:
                        tf = this.zWeight_tf;
                        break;
                     case SecureTradeInventory.COLUMN_STACK_WEIGHT:
                        tf = this.zStackWeight_tf;
                        break;
                     case SecureTradeInventory.COLUMN_VALUE_PER_WEIGHT:
                        tf = this.zValuePerWeight_tf;
                        break;
                     default:
                        tf = null;
                  }
                  if(tf != null)
                  {
                     tf.x = xPos;
                     tf.visible = true;
                     xPos += 45;
                  }
               }
            }
         }
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var isWtInt:Boolean;
         var _loc3_:* = undefined;
         super.SetEntryText(param1,param2);
         try
         {
            if(ShowAdditionalColumns != null)
            {
               if(!isAdditionalColumnsInit)
               {
                  initAdditionalColumns();
               }
               this.zLevel_tf.text = param1.itemLevel > 0 ? param1.itemLevel : "";
               isWtInt = param1.weight == int(param1.weight);
               this.zWeight_tf.text = isWtInt ? param1.weight : param1.weight.toFixed(2);
               this.zStackWeight_tf.text = isWtInt ? param1.count * param1.weight : (param1.count * param1.weight).toFixed(2);
               this.zValue_tf.text = param1.itemValue;
               this.zValuePerWeight_tf.text = int(param1.itemValue / param1.weight);
            }
         }
         catch(e:*)
         {
         }
         if(this.RaritySelector_mc)
         {
            this.RaritySelector_mc.visible = false;
         }
         if(Boolean(this.CurrencyIcon_mc) && Boolean(this.Price_tf))
         {
            if(this.m_LastCurrencyType != currencyType)
            {
               if(this.m_CurrencyIconInstance != null)
               {
                  this.CurrencyIcon_mc.removeChild(this.m_CurrencyIconInstance);
                  this.m_CurrencyIconInstance = null;
               }
               if(param1.isOffered)
               {
                  this.m_CurrencyIconInstance = SecureTradeShared.setCurrencyIcon(this.CurrencyIcon_mc,currencyType);
               }
            }
            if(param1.isOffered)
            {
               this.CurrencyIcon_mc.visible = true;
               this.Price_tf.text = param1.offerValue;
            }
            else
            {
               this.CurrencyIcon_mc.visible = false;
               this.Price_tf.text = "";
            }
            SetColorTransform(this.CurrencyIcon_mc,selected);
            this.Price_tf.textColor = this.selected ? GlobalFunc.COLOR_TEXT_SELECTED : uint(ORIG_TEXT_COLOR);
         }
         if(this.RequestedTextField != null)
         {
            this.RequestedTextField.textColor = this.selected ? GlobalFunc.COLOR_TEXT_SELECTED : uint(ORIG_TEXT_COLOR);
         }
         if(selected)
         {
            textField.filters = [];
            if(this.Price_tf)
            {
               this.Price_tf.filters = [];
            }
            if(this.CurrencyIcon_mc)
            {
               this.CurrencyIcon_mc.filters = [];
            }
            if(this.RaritySelector_mc)
            {
               if(param1.nwRarity > -1)
               {
                  border.visible = false;
                  this.RaritySelector_mc.visible = true;
               }
               else
               {
                  this.RaritySelector_mc.visible = false;
               }
            }
            if(this.RequestedTextField != null)
            {
               this.RequestedTextField.filters = [];
            }
         }
         else
         {
            textField.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
            if(this.Price_tf)
            {
               this.Price_tf.filters = textField.filters;
            }
            if(this.CurrencyIcon_mc)
            {
               this.CurrencyIcon_mc.filters = textField.filters;
            }
            if(this.RequestedTextField != null)
            {
               this.RequestedTextField.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
            }
         }
         if(playerLevel >= param1.itemLevel)
         {
            textField.textColor = selected ? 0 : uint(ORIG_TEXT_COLOR);
         }
         else
         {
            textField.textColor = selected ? GlobalFunc.COLOR_TEXT_UNAVAILABLE : GlobalFunc.COLOR_TEXT_UNAVAILABLE;
         }
         if(param1.isOffered == true && Boolean(param1.hasOwnProperty("declineReason")) && param1.declineReason != -1)
         {
            GlobalFunc.SetText(textField,"$DECLINED",true);
            GlobalFunc.SetText(textField,textField.text.replace("{1}",param1.text),true);
         }
         if(Boolean(param1.hasOwnProperty("isRequested")) && this.RequestedTextField != null)
         {
            this.RequestedTextField.visible = Boolean(param1.isRequested) && !param1.isOffered;
            this.RequestedTextField.text = "$REQUESTED";
         }
         if(this.ConditionBar_mc != null)
         {
            this.UpdateConditionBar(param1);
         }
         if(Boolean(this.RarityBorder_mc) && Boolean(this.RaritySelector_mc) && Boolean(this.RarityIndicator_mc))
         {
            _loc3_ = new ColorTransform();
            this.RarityBorder_mc.visible = param1.nwRarity > -1 ? true : false;
            if(param1.nwRarity == 0)
            {
               textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_COMMON;
               _loc3_.color = GlobalFunc.COLOR_RARITY_COMMON;
               this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_COMMON);
            }
            else if(param1.nwRarity == 1)
            {
               textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_RARE;
               _loc3_.color = GlobalFunc.COLOR_RARITY_RARE;
               this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_RARE);
            }
            else if(param1.nwRarity == 2)
            {
               textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_EPIC;
               _loc3_.color = GlobalFunc.COLOR_RARITY_EPIC;
               this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_EPIC);
            }
            else if(param1.nwRarity == 3)
            {
               textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_LEGENDARY;
               _loc3_.color = GlobalFunc.COLOR_RARITY_LEGENDARY;
               this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_LEGENDARY);
            }
            else
            {
               textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_TEXT_BODY;
               _loc3_.color = GlobalFunc.COLOR_TEXT_BODY;
               this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_NONE);
            }
            this.RaritySelector_mc.RarityOverlay_mc.transform.colorTransform = _loc3_;
            this.RarityBorder_mc.transform.colorTransform = _loc3_;
            this.RarityIndicator_mc.transform.colorTransform = _loc3_;
         }
      }
      
      private function UpdateConditionBar(param1:Object) : *
      {
         if(menuMode == SecureTradeShared.MODE_FERMENTER || menuMode == SecureTradeShared.MODE_REFRIGERATOR || menuMode == SecureTradeShared.MODE_FREEZER || menuMode == SecureTradeShared.MODE_RECHARGER)
         {
            GlobalFunc.updateConditionMeter(this.ConditionBar_mc,param1.currentHealth,param1.maximumHealth,param1.durability);
            if(this.CurrencyIcon_mc.visible)
            {
               this.ConditionBar_mc.x = this.Price_tf.x - this.ConditionBar_mc.width - CONDITION_SPACING;
            }
            else
            {
               this.ConditionBar_mc.x = this.m_ConditionInitialX;
            }
         }
         else
         {
            this.ConditionBar_mc.visible = false;
         }
      }
   }
}
