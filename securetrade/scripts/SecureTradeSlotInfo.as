package
{
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.SWFLoaderClip;
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol345")]
   public class SecureTradeSlotInfo extends BSUIComponent
   {
      
      private static const FRAME_NO_ICON:* = 1;
      
      private static const FRAME_ICON:* = 2;
      
      public var Header_mc:MovieClip;
      
      public var Icon_mc:SWFLoaderClip;
      
      public var Slot1_mc:MovieClip;
      
      public var Slot2_mc:MovieClip;
      
      private var m_MenuMode:uint = 4294967295;
      
      private var m_MenuSubMode:uint = 0;
      
      private var m_OwnsVendor:Boolean = false;
      
      private var m_SlotData:Array = null;
      
      private var m_SlotClips:Vector.<MovieClip>;
      
      public function SecureTradeSlotInfo()
      {
         var _loc1_:MovieClip = null;
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         gotoAndStop(FRAME_ICON);
         visible = false;
         mouseEnabled = false;
         mouseChildren = false;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Header_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.m_SlotClips = new <MovieClip>[this.Slot1_mc,this.Slot2_mc];
         for each(_loc1_ in this.m_SlotClips)
         {
            if(_loc1_)
            {
               TextFieldEx.setTextAutoSize(_loc1_.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            }
         }
         this.Icon_mc.clipWidth = this.Icon_mc.width * (1 / this.Icon_mc.scaleX);
         this.Icon_mc.clipHeight = this.Icon_mc.height * (1 / this.Icon_mc.scaleY);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("OtherInventoryTypeData",this.onOtherInvTypeDataUpdate);
      }
      
      private function onOtherInvTypeDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.m_SlotData = _loc2_.slotDataA;
         this.m_OwnsVendor = _loc2_.ownsVendor;
         this.m_MenuMode = _loc2_.menuType;
         this.m_MenuSubMode = _loc2_.menuSubType;
         visible = this.m_OwnsVendor && Boolean(this.m_SlotData) && this.m_SlotData.length > 0;
         if(visible)
         {
            this.Update();
         }
      }
      
      public function Update() : *
      {
         var _loc1_:Object = null;
         var _loc3_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:TextField = null;
         var _loc9_:String = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this.m_SlotData)
         {
            _loc2_.push({
               "slotType":_loc1_.slotType,
               "slotTypeText":_loc1_.slotTypeText,
               "slotCountFilled":_loc1_.slotCountFilled,
               "slotCountMax":_loc1_.slotCountMax
            });
         }
         _loc2_.sortOn("slotType");
         _loc3_ = int(_loc2_.length - 1);
         while(_loc3_ > 0)
         {
            _loc5_ = _loc2_[_loc3_ - 1];
            _loc6_ = _loc2_[_loc3_];
            if(_loc5_.slotType == _loc6_.slotType)
            {
               _loc5_.slotCountFilled += _loc6_.slotCountFilled;
               _loc5_.slotCountMax += _loc6_.slotCountMax;
               _loc2_.splice(_loc3_,1);
            }
            _loc3_--;
         }
         var _loc4_:uint = 2;
         _loc3_ = 0;
         while(_loc3_ < this.m_SlotClips.length)
         {
            _loc7_ = this.m_SlotClips[_loc3_] as MovieClip;
            if(_loc7_)
            {
               _loc8_ = _loc7_.Text_tf;
               _loc7_.visible = _loc3_ < _loc2_.length;
               if(_loc3_ < _loc2_.length)
               {
                  _loc1_ = _loc2_[_loc3_];
                  if(_loc1_.slotType == 0)
                  {
                     GlobalFunc.SetText(_loc8_,"$SecureTrade_ItemSlotCounts");
                     _loc9_ = _loc8_.text;
                     _loc9_ = _loc9_.replace("{1}",_loc1_.slotCountFilled);
                     _loc9_ = _loc9_.replace("{2}",_loc1_.slotCountMax);
                  }
                  else
                  {
                     GlobalFunc.SetText(_loc8_,"$SecureTrade_ItemSlotTypeAndCounts");
                     _loc9_ = _loc8_.text;
                     _loc9_ = _loc9_.replace("{1}",_loc1_.slotTypeText);
                     _loc9_ = _loc9_.replace("{2}",_loc1_.slotCountFilled);
                     _loc9_ = _loc9_.replace("{3}",_loc1_.slotCountMax);
                  }
                  GlobalFunc.SetText(_loc8_,_loc9_);
               }
            }
            _loc3_++;
         }
         this.Icon_mc.removeChildren();
         switch(this.m_MenuMode)
         {
            case SecureTradeShared.MODE_VENDING_MACHINE:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_VendingMachine");
               this.Icon_mc.setContainerIconClip("IconV_Vendor");
               break;
            case SecureTradeShared.MODE_DISPLAY_CASE:
               if(this.m_MenuSubMode == SecureTradeShared.SUB_MODE_ARMOR_RACK)
               {
                  GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Mannequin");
                  GlobalFunc.SetText(this.Slot1_mc.Text_tf,"$SecureTrade_SlotHeader_MannequinInfo");
               }
               else
               {
                  GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_DisplayCase");
               }
               this.Icon_mc.setContainerIconClip("IconV_Display");
               break;
            case SecureTradeShared.MODE_FERMENTER:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Fermenter");
               this.Icon_mc.setContainerIconClip("IconV_Fermenter");
               break;
            case SecureTradeShared.MODE_REFRIGERATOR:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Refrigerator");
               this.Icon_mc.setContainerIconClip("IconV_Refrigerator");
               break;
            case SecureTradeShared.MODE_FREEZER:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Freezer");
               this.Icon_mc.setContainerIconClip("IconV_Refrigerator");
               break;
            case SecureTradeShared.MODE_RECHARGER:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Recharger");
               this.Icon_mc.setContainerIconClip("IconV_Recharger");
               break;
            case SecureTradeShared.MODE_CAMP_DISPENSER:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Dispenser");
               this.Icon_mc.setContainerIconClip("IconV_Keg");
               break;
            case SecureTradeShared.MODE_ALLY:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Ally");
               GlobalFunc.SetText(this.Slot1_mc.Text_tf,"$SecureTrade_SlotHeader_AllyStats");
               this.Icon_mc.setContainerIconClip("IconV_Ally");
               break;
            case SecureTradeShared.MODE_PET:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"$SecureTrade_SlotHeader_Pet");
               GlobalFunc.SetText(this.Slot1_mc.Text_tf,"$SecureTrade_SlotHeader_PetStats");
               this.Icon_mc.setContainerIconClip("IconV_Dog");
            default:
               GlobalFunc.SetText(this.Header_mc.Text_tf,"");
         }
      }
      
      public function isSlotDataValid() : Boolean
      {
         return this.m_SlotData != null && this.m_SlotData.length > 0;
      }
      
      public function AreSlotsFull() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.m_SlotData)
         {
            if(_loc1_.slotCountFilled < _loc1_.slotCountMax)
            {
               return false;
            }
         }
         return true;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

