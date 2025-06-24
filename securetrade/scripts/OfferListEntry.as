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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol180")]
   public class OfferListEntry extends ItemListEntry
   {
      
      public static var menuMode:uint = SecureTradeShared.MODE_INVALID;
      
      public static var ownsVendor:Boolean = false;
      
      public static var playerLevel:Number = 0;
      
      public static var playerCurrency:Number = 0;
      
      public static var currencyType:uint = SecureTradeShared.CURRENCY_CAPS;
      
      private static const CONDITION_SPACING:Number = 6;
      
      public static var ShowAdditionalColumns:Object = null;
       
      
      public var Price_tf:TextField;
      
      public var CurrencyIcon_mc:SWFLoaderClip;
      
      public var ConditionBar_mc:MovieClip;
      
      public var Icon_mc:SWFLoaderClip;
      
      public var IconBacker_mc:MovieClip;
      
      private var m_ConditionInitialX:Number = 0;
      
      private var m_LastCurrencyType:uint = 4294967295;
      
      private var m_CurrencyIconInstance:MovieClip;
      
      public var RarityIndicator_mc:MovieClip;
      
      public var RarityBorder_mc:MovieClip;
      
      public var RaritySelector_mc:MovieClip;
      
      private var zValue_tf:TextField;
      
      private var zWeight_tf:TextField;
      
      private var zLevel_tf:TextField;
      
      private var zStackWeight_tf:TextField;
      
      private var zValuePerWeight_tf:TextField;
      
      private var isAdditionalColumnsInit:Boolean = false;
      
      public function OfferListEntry()
      {
         this.m_LastCurrencyType = 4294967295;
         super();
         if(this.ConditionBar_mc != null)
         {
            this.m_ConditionInitialX = this.ConditionBar_mc.x;
         }
         if(this.Icon_mc)
         {
            this.Icon_mc.clipWidth = this.Icon_mc.width * (1 / this.Icon_mc.scaleX);
            this.Icon_mc.clipHeight = this.Icon_mc.height * (1 / this.Icon_mc.scaleY);
         }
         this.CurrencyIcon_mc.clipWidth = this.CurrencyIcon_mc.width * (1 / this.CurrencyIcon_mc.scaleX);
         this.CurrencyIcon_mc.clipHeight = this.CurrencyIcon_mc.height * (1 / this.CurrencyIcon_mc.scaleY);
         this.zValue_tf = newTf();
         this.zWeight_tf = newTf();
         this.zLevel_tf = newTf();
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
            var tf:TextField = null;
            var colCount:int = 0;
            var column:* = null;
            for(column in ShowAdditionalColumns)
            {
               if(ShowAdditionalColumns[column])
               {
                  colCount++;
               }
            }
            var xPos:int = -50 - colCount * 45;
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
         var _loc3_:Object;
         var _loc4_:*;
         var _loc5_:*;
         var _loc6_:String;
         var _loc7_:*;
         var isWtInt:Boolean;
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
         this.RaritySelector_mc.visible = false;
         if(this.m_LastCurrencyType != currencyType)
         {
            if(this.m_CurrencyIconInstance != null)
            {
               this.CurrencyIcon_mc.removeChild(this.m_CurrencyIconInstance);
               this.m_CurrencyIconInstance = null;
            }
            this.m_CurrencyIconInstance = SecureTradeShared.setCurrencyIcon(this.CurrencyIcon_mc,currencyType);
         }
         _loc3_ = param1.vendingData;
         _loc4_ = playerLevel >= param1.itemLevel;
         this.UpdateCurrency(param1);
         this.UpdateCampMachineIcon(param1);
         _loc5_ = false;
         switch(menuMode)
         {
            case SecureTradeShared.MODE_CONTAINER:
               _loc5_ = !_loc4_;
               break;
            case SecureTradeShared.MODE_VENDING_MACHINE:
               if(ownsVendor)
               {
                  _loc5_ = Boolean(_loc3_.isVendedOnOtherMachine);
               }
               else
               {
                  _loc5_ = param1.itemValue > playerCurrency || !_loc4_;
               }
               break;
            case SecureTradeShared.MODE_DISPLAY_CASE:
            case SecureTradeShared.MODE_ALLY:
            case SecureTradeShared.MODE_FERMENTER:
            case SecureTradeShared.MODE_REFRIGERATOR:
            case SecureTradeShared.MODE_FREEZER:
            case SecureTradeShared.MODE_RECHARGER:
            case SecureTradeShared.MODE_CAMP_DISPENSER:
            case SecureTradeShared.MODE_PET:
               _loc5_ = ownsVendor && Boolean(_loc3_.isVendedOnOtherMachine);
               break;
            case SecureTradeShared.MODE_NPCVENDING:
               if(param1.itemValue != null)
               {
                  _loc5_ = param1.itemValue > playerCurrency || !_loc4_;
               }
         }
         SetColorTransform(this.CurrencyIcon_mc,selected);
         if(selected)
         {
            textField.filters = [];
            this.CurrencyIcon_mc.filters = [];
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
         else
         {
            textField.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
            this.CurrencyIcon_mc.filters = textField.filters;
         }
         _loc6_ = textField.text;
         if(param1.isOffered == true)
         {
            if(param1.declineReason != -1)
            {
               GlobalFunc.SetText(textField,"$DECLINED",true);
               GlobalFunc.SetText(textField,textField.text.replace("{1}",_loc6_),true);
               _loc5_ = true;
            }
         }
         else if(param1.isRequested)
         {
            GlobalFunc.SetText(textField,"$REQUESTED_ITEM_NAME",true);
            GlobalFunc.SetText(textField,textField.text.replace("{1}",_loc6_),true);
         }
         if(_loc5_)
         {
            textField.textColor = GlobalFunc.COLOR_TEXT_UNAVAILABLE;
         }
         else
         {
            textField.textColor = selected ? 0 : uint(ORIG_TEXT_COLOR);
         }
         if(this.ConditionBar_mc != null)
         {
            if(this.CurrencyIcon_mc.visible)
            {
               this.ConditionBar_mc.visible = false;
            }
            else
            {
               this.UpdateConditionBar(param1);
            }
         }
         _loc7_ = new ColorTransform();
         this.RarityBorder_mc.visible = param1.nwRarity > -1 ? true : false;
         if(param1.nwRarity == 0)
         {
            textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_COMMON;
            _loc7_.color = GlobalFunc.COLOR_RARITY_COMMON;
            this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_COMMON);
         }
         else if(param1.nwRarity == 1)
         {
            textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_RARE;
            _loc7_.color = GlobalFunc.COLOR_RARITY_RARE;
            this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_RARE);
         }
         else if(param1.nwRarity == 2)
         {
            textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_EPIC;
            _loc7_.color = GlobalFunc.COLOR_RARITY_EPIC;
            this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_EPIC);
         }
         else if(param1.nwRarity == 3)
         {
            textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_RARITY_LEGENDARY;
            _loc7_.color = GlobalFunc.COLOR_RARITY_LEGENDARY;
            this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_LEGENDARY);
         }
         else
         {
            textField.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : GlobalFunc.COLOR_TEXT_BODY;
            _loc7_.color = GlobalFunc.COLOR_TEXT_BODY;
            this.RarityIndicator_mc.gotoAndStop(GlobalFunc.FRAME_RARITY_NONE);
         }
         this.RaritySelector_mc.RarityOverlay_mc.transform.colorTransform = _loc7_;
         this.RarityBorder_mc.transform.colorTransform = _loc7_;
         this.RarityIndicator_mc.transform.colorTransform = _loc7_;
      }
      
      private function UpdateCurrency(param1:Object) : *
      {
         var _loc2_:Object = param1.vendingData;
         this.CurrencyIcon_mc.visible = false;
         this.Price_tf.text = "";
         switch(menuMode)
         {
            case SecureTradeShared.MODE_CONTAINER:
            case SecureTradeShared.MODE_ALLY:
            case SecureTradeShared.MODE_VENDING_MACHINE:
            case SecureTradeShared.MODE_DISPLAY_CASE:
            case SecureTradeShared.MODE_CAMP_DISPENSER:
            case SecureTradeShared.MODE_FERMENTER:
            case SecureTradeShared.MODE_REFRIGERATOR:
            case SecureTradeShared.MODE_FREEZER:
            case SecureTradeShared.MODE_RECHARGER:
            case SecureTradeShared.MODE_PET:
               if(_loc2_.machineType == SecureTradeShared.MACHINE_TYPE_VENDING)
               {
                  this.CurrencyIcon_mc.visible = true;
                  this.Price_tf.text = _loc2_.price;
               }
               break;
            case SecureTradeShared.MODE_PLAYERVENDING:
               if(param1.itemValue != null && Boolean(param1.isOffered))
               {
                  this.CurrencyIcon_mc.visible = true;
                  this.Price_tf.text = param1.offerValue;
               }
               break;
            case SecureTradeShared.MODE_NPCVENDING:
               if(param1.itemValue != null)
               {
                  this.CurrencyIcon_mc.visible = true;
                  this.Price_tf.text = param1.itemValue;
               }
         }
         this.Price_tf.textColor = selected ? GlobalFunc.COLOR_TEXT_SELECTED : uint(ORIG_TEXT_COLOR);
         if(selected)
         {
            this.Price_tf.filters = [];
         }
         else
         {
            this.Price_tf.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
         }
      }
      
      private function GetCampMachineIconClip(param1:uint) : String
      {
         switch(param1)
         {
            case SecureTradeShared.MACHINE_TYPE_VENDING:
               return "IconV_Vendor";
            case SecureTradeShared.MACHINE_TYPE_DISPLAY:
               return "IconV_Display";
            case SecureTradeShared.MACHINE_TYPE_DISPENSER:
               return "IconV_Keg";
            case SecureTradeShared.MACHINE_TYPE_FERMENTER:
               return "IconV_Fermenter";
            case SecureTradeShared.MACHINE_TYPE_REFRIGERATOR:
               return "IconV_Refrigerator";
            case SecureTradeShared.MACHINE_TYPE_FREEZER:
               return "IconV_Refrigerator";
            case SecureTradeShared.MACHINE_TYPE_RECHARGER:
               return "IconV_Recharger";
            case SecureTradeShared.MACHINE_TYPE_ALLY:
               return "IconV_Ally";
            case SecureTradeShared.MACHINE_TYPE_PET:
               return "IconV_Dog";
            default:
               return null;
         }
      }
      
      private function UpdateCampMachineIcon(param1:Object) : *
      {
         if(!this.Icon_mc)
         {
            return;
         }
         var _loc2_:Object = param1.vendingData;
         var _loc3_:String = this.GetCampMachineIconClip(_loc2_.machineType);
         var _loc4_:* = menuMode == SecureTradeShared.MODE_CONTAINER || SecureTradeShared.IsCampVendingMenuType(menuMode) && ownsVendor;
         this.Icon_mc.visible = _loc4_ && Boolean(_loc3_);
         this.IconBacker_mc.visible = this.Icon_mc.visible;
         if(_loc4_ && Boolean(_loc3_))
         {
            this.Icon_mc.removeChildren();
            this.Icon_mc.setContainerIconClip(_loc3_);
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
