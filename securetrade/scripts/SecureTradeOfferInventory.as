package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol334")]
   public class SecureTradeOfferInventory extends SecureTradeInventory
   {
       
      
      public var Tooltip_mc:MovieClip;
      
      public var miniTooltip_mc:MovieClip;
      
      public var OfferCurrency_tf:TextField;
      
      public var OfferWeight_tf:TextField;
      
      public var OfferWeightIcon:MovieClip;
      
      private var m_menuMode:uint = 4294967295;
      
      private var m_subMenuMode:uint = 0;
      
      private var m_machineTypeMode:uint = 0;
      
      private var m_CarryWeightCurrent:Number = 0;
      
      private var m_CarryWeightMax:Number = 0;
      
      private var m_showTooltip:* = false;
      
      private var m_Currency:Number = 0;
      
      private var m_ownsVendor:Boolean = false;
      
      public function SecureTradeOfferInventory()
      {
         this.m_menuMode = 4294967295;
         super();
         this.Tooltip_mc.Tooltip_tf.text = "";
         this.miniTooltip_mc.textField_tf.text = "";
         this.m_Currency = 0;
         this.UpdateTooltipVisibility();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.OfferWeight_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.OfferCurrency_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Tooltip_mc.Tooltip_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.miniTooltip_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function set ShowAdditionalColumns(param1:Object) : void
      {
         var tf:TextField = null;
         var colCount:int = 0;
         var column:* = null;
         for(column in param1)
         {
            if(param1[column])
            {
               colCount++;
            }
         }
         var xPos:int = -50 - colCount * 45;
         for(column in param1)
         {
            if(param1[column])
            {
               switch(column)
               {
                  case COLUMN_LEVEL:
                     tf = this.zLevel_tf;
                     break;
                  case COLUMN_VALUE:
                     tf = this.zValue_tf;
                     break;
                  case COLUMN_WEIGHT:
                     tf = this.zWeight_tf;
                     break;
                  case COLUMN_STACK_WEIGHT:
                     tf = this.zStackWeight_tf;
                     break;
                  case COLUMN_VALUE_PER_WEIGHT:
                     tf = this.zValuePerWeight_tf;
                     break;
                  default:
                     tf = null;
               }
               if(tf != null)
               {
                  tf.x = xPos;
                  tf.visible = true;
                  if(param1[column] is String)
                  {
                     tf.text = param1[column];
                  }
                  xPos += 45;
               }
            }
         }
      }
      
      public function set ownsVendor(param1:Boolean) : *
      {
         this.m_ownsVendor = param1;
      }
      
      public function get carryWeightCurrent() : Number
      {
         return this.m_CarryWeightCurrent;
      }
      
      public function set carryWeightCurrent(param1:Number) : void
      {
         this.m_CarryWeightCurrent = param1;
         SetIsDirty();
      }
      
      public function get carryWeightMax() : Number
      {
         return this.m_CarryWeightMax;
      }
      
      public function set carryWeightMax(param1:Number) : void
      {
         this.m_CarryWeightMax = param1;
         SetIsDirty();
      }
      
      public function set currency(param1:Number) : void
      {
         this.m_Currency = param1;
         SetIsDirty();
      }
      
      public function get currency() : Number
      {
         return this.m_Currency;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
      }
      
      public function set menuMode(param1:uint) : void
      {
         this.m_menuMode = param1;
      }
      
      public function set subMenuMode(param1:uint) : void
      {
         this.m_subMenuMode = param1;
      }
      
      public function set machineTypeMode(param1:uint) : void
      {
         this.m_machineTypeMode = param1;
      }
      
      public function set showTooltip(param1:Boolean) : void
      {
         this.m_showTooltip = param1;
         this.UpdateTooltipVisibility();
      }
      
      public function set showCurrency(param1:Boolean) : void
      {
         this.OfferCurrency_tf.visible = param1;
         CurrencyIcon_mc.visible = param1;
      }
      
      public function set showCarryWeight(param1:Boolean) : void
      {
         this.OfferWeight_tf.visible = param1;
         this.OfferWeightIcon.visible = param1;
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
         this.OfferCurrency_tf.text = this.m_Currency.toString();
         this.OfferWeight_tf.text = this.m_CarryWeightCurrent + "/" + this.m_CarryWeightMax;
      }
      
      public function UpdateTooltips() : void
      {
         this.UpdateToolTipText();
         this.UpdateMiniTooltipText();
      }
      
      private function UpdateToolTipText() : void
      {
         this.Tooltip_mc.Tooltip_tf.text = "";
         var _loc1_:Object = ItemList_mc.List_mc.selectedEntry;
         if(this.m_menuMode == SecureTradeShared.MODE_NPCVENDING)
         {
            switch(this.m_subMenuMode)
            {
               case SecureTradeShared.SUB_MODE_LEGENDARY_VENDING_MACHINE:
                  if(_loc1_ != null)
                  {
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_VendingMachineLegendary";
                  }
                  else
                  {
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_LegendaryVendingMachineHint";
                  }
                  break;
               case SecureTradeShared.SUB_MODE_POSSUM_VENDING_MACHINE:
                  this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_PossumVendingMachineHint";
                  break;
               case SecureTradeShared.SUB_MODE_TADPOLE_VENDING_MACHINE:
                  this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_TadpoleVendingMachineHint";
            }
         }
         if(_loc1_ != null)
         {
            if(SecureTradeShared.IsCampVendingMenuType(this.m_menuMode) && this.m_ownsVendor)
            {
               switch(this.m_menuMode)
               {
                  case SecureTradeShared.MODE_VENDING_MACHINE:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_VendingMachine";
                     break;
                  case SecureTradeShared.MODE_DISPLAY_CASE:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_DisplayCase";
                     break;
                  case SecureTradeShared.MODE_FERMENTER:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Fermenter";
                     break;
                  case SecureTradeShared.MODE_REFRIGERATOR:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Refrigerator";
                     break;
                  case SecureTradeShared.MODE_FREEZER:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Freezer";
                     break;
                  case SecureTradeShared.MODE_RECHARGER:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Recharger";
                     break;
                  case SecureTradeShared.MODE_CAMP_DISPENSER:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Dispenser";
                     break;
                  case SecureTradeShared.MODE_ALLY:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Ally";
                     break;
                  case SecureTradeShared.MODE_PET:
                     this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_SlotTooltip_Pet";
               }
            }
            else if(_loc1_.declineReason != undefined && _loc1_.declineReason != -1)
            {
               this.Tooltip_mc.Tooltip_tf.text = "$SecureTrade_" + SecureTradeDeclineItemModal.REJECT_REASONS[_loc1_.declineReason];
            }
         }
      }
      
      private function UpdateMiniTooltipText() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.miniTooltip_mc.textField_tf.text = "";
         var _loc1_:Object = ItemList_mc.List_mc.selectedEntry;
         if(_loc1_ == null)
         {
            return;
         }
         if(this.m_menuMode == SecureTradeShared.MODE_CONTAINER || this.m_ownsVendor && SecureTradeShared.IsCampVendingMenuType(this.m_menuMode))
         {
            _loc2_ = _loc1_.vendingData;
            if(_loc2_.machineType != SecureTradeShared.MACHINE_TYPE_INVALID)
            {
               _loc3_ = null;
               if(_loc2_.machineType == SecureTradeShared.MACHINE_TYPE_ALLY)
               {
                  _loc3_ = "$SecureTrade_ItemSetToYourAlly";
               }
               else if(_loc2_.machineType == SecureTradeShared.MACHINE_TYPE_PET)
               {
                  _loc3_ = "$SecureTrade_ItemSetToYourPet";
               }
               else if(!_loc2_.isVendedOnOtherMachine)
               {
                  _loc3_ = "$SecureTrade_ItemSetToThisMachine";
               }
               else if(SecureTradeShared.DoesMachineTypeMatchMode(_loc2_.machineType,this.m_menuMode))
               {
                  _loc3_ = "$SecureTrade_ItemSetToAnotherMachine";
               }
               else
               {
                  _loc3_ = "$SecureTrade_ItemSetToAMachine";
               }
               _loc4_ = null;
               switch(_loc2_.machineType)
               {
                  case SecureTradeShared.MACHINE_TYPE_VENDING:
                     _loc4_ = "$SecureTrade_MachineTypeVendingMachine";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_DISPLAY:
                     _loc4_ = "$SecureTrade_MachineTypeDisplay";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_DISPENSER:
                     _loc4_ = "$SecureTrade_MachineTypeDispenser";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_FERMENTER:
                     _loc4_ = "$SecureTrade_MachineTypeFermenter";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_REFRIGERATOR:
                     _loc4_ = "$SecureTrade_MachineTypeRefrigerator";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_FREEZER:
                     _loc4_ = "$SecureTrade_MachineTypeFreezer";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_RECHARGER:
                     _loc4_ = "$SecureTrade_MachineTypeRecharger";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_ALLY:
                     _loc4_ = "$SecureTrade_ItemSetToYourAlly";
                     break;
                  case SecureTradeShared.MACHINE_TYPE_PET:
                     _loc4_ = "$SecureTrade_ItemSetToYourPet";
               }
               if(Boolean(_loc3_) && Boolean(_loc4_))
               {
                  this.miniTooltip_mc.textField_tf.text = GlobalFunc.LocalizeFormattedString(_loc3_,_loc4_);
               }
            }
            else if(_loc2_.isUsedOnOtherCampMachine)
            {
               this.miniTooltip_mc.textField_tf.text = "$SecureTrade_ItemSetToAnotherCampMachine";
            }
         }
      }
      
      private function UpdateTooltipVisibility() : void
      {
         if(this.m_showTooltip && !hasEventListener(BSScrollingList.SELECTION_CHANGE))
         {
            addEventListener(BSScrollingList.SELECTION_CHANGE,this.onTooltipSelectionChange);
         }
         else if(!this.m_showTooltip && hasEventListener(BSScrollingList.SELECTION_CHANGE))
         {
            removeEventListener(BSScrollingList.SELECTION_CHANGE,this.onTooltipSelectionChange);
         }
         this.Tooltip_mc.visible = this.m_showTooltip;
         this.miniTooltip_mc.visible = this.m_showTooltip;
      }
      
      private function onTooltipSelectionChange(param1:Event) : void
      {
         this.UpdateToolTipText();
         this.UpdateMiniTooltipText();
      }
   }
}
