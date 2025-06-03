package
{
   import Shared.AS3.BCBasicModal;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.ScrapComponentListStyle;
   import Shared.GlobalFunc;
   
   public class SecureTradeScrapConfirmModal extends BCBasicModal
   {
      
      private static const STATE_SCRAP:uint = 1;
      
      private static const STATE_SCRAP_ALL:uint = 2;
      
      private static const STATE_SCRAPBOX_TRANSFER_JUNK:uint = 3;
      
      private static const STATE_SCRAPBOX_SCRAP_TRANSFER_SELECTION:uint = 4;
      
      private static const EVENT_PREP_SCRAP_PROMPT:String = "Workbench::PrepScrapPrompt";
      
      private static const EVENT_PREP_AUTO_SCRAP:String = "Workbench::PrepAutoScrap";
      
      private static const EVENT_PREP_SCRAPBOX_TRANSFER:String = "Container::transferToScrapboxPrepDialog";
      
      private static const EVENT_SCRAP_ITEM:String = "Workbench::ScrapItem";
      
      private static const EVENT_SCRAP_ALL_JUNK:String = "Workbench::ScrapAllJunk";
      
      private static const EVENT_SCRAPBOX_TRANSFER_JUNK:String = "Container::transferToScrapboxConfirm";
      
      private static const EVENT_SCRAPBOX_SCRAP_TRANSFER_PREP:* = "Container::transferSelectionToScrapPrepDialog";
      
      private static const EVENT_SCRAPBOX_SCRAP_TRANSFER_CONFIRM:* = "Container::transferSelectionToScrapConfirm";
      
      public static const EVENT_CLOSED:String = "SecureTradeScrapConfirmModal::EVENT_CLOSED";
       
      
      private var m_State:uint = 0;
      
      private var m_ItemData:Object;
      
      private var m_ScrapQuantity:uint;
      
      private var m_BackgroundDefaultWidth:Number;
      
      public function SecureTradeScrapConfirmModal()
      {
         super();
         choiceButtonMode = BCBasicModal.BUTTON_MODE_BAR;
         this.m_BackgroundDefaultWidth = Background_mc.width;
      }
      
      override public function onAddedToStage() : void
      {
         StyleSheet.apply(ComponentList_mc,false,ScrapComponentListStyle);
         BSUIDataManager.Subscribe("ContainerOptionsData",this.OnContainerOptionsData);
      }
      
      public function OnContainerOptionsData(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         ComponentList_mc.entryList = _loc2_.scrapComponentArray.sortOn("text");
         ComponentList_mc.InvalidateData();
         ComponentList_mc.allowWheelScrollNoSelectionChange = ComponentList_mc.entryList.length > ScrapComponentListStyle.numListItems_Inspectable;
         SetIsDirty();
      }
      
      public function ShowScrapModal(param1:Object, param2:uint) : *
      {
         this.m_State = STATE_SCRAP;
         this.m_ScrapQuantity = param2;
         this.m_ItemData = {
            "text":param1.text,
            "serverHandleID":param1.serverHandleID,
            "favorite":param1.favorite,
            "isLegendary":param1.isLegendary,
            "isPremium":param1.isPremium
         };
         header = "$SCRAPTHISITEM";
         tooltip = param2 == 1 ? this.m_ItemData.text : this.m_ItemData.text + " (" + param2 + ")";
         m_AcceptButton.ButtonText = "$ACCEPT";
         m_CancelButton.ButtonText = "$CANCEL";
         Background_mc.width = this.m_BackgroundDefaultWidth;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PREP_SCRAP_PROMPT,{
            "serverHandleID":this.m_ItemData.serverHandleID,
            "quantity":param2
         }));
         stage.focus = ComponentList_mc;
         open = true;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
      }
      
      public function ShowScrapAllModal() : void
      {
         this.m_State = STATE_SCRAP_ALL;
         header = "$ConfirmScrapAll";
         tooltip = "";
         m_AcceptButton.ButtonText = "$ACCEPT";
         m_CancelButton.ButtonText = "$CANCEL";
         Background_mc.width = this.m_BackgroundDefaultWidth;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PREP_AUTO_SCRAP,{}));
         stage.focus = ComponentList_mc;
         open = true;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
      }
      
      public function ShowScrapboxTransferModal() : void
      {
         this.m_State = STATE_SCRAPBOX_TRANSFER_JUNK;
         header = "$ConfirmScrapAllStoreStashbox";
         tooltip = "";
         m_AcceptButton.ButtonText = "$ACCEPT";
         m_CancelButton.ButtonText = "$CANCEL";
         Background_mc.width = this.m_BackgroundDefaultWidth;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PREP_SCRAPBOX_TRANSFER,{}));
         stage.focus = ComponentList_mc;
         open = true;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
      }
      
      public function ShowScrapboxScrapTransferSelectionModal(param1:Object, param2:uint) : void
      {
         this.m_State = STATE_SCRAPBOX_SCRAP_TRANSFER_SELECTION;
         this.m_ScrapQuantity = param2;
         this.m_ItemData = {
            "text":param1.text,
            "clientHandleID":param1.clientHandleID,
            "serverHandleID":param1.serverHandleID,
            "favorite":param1.favorite,
            "isLegendary":param1.isLegendary,
            "isPremium":param1.isPremium
         };
         header = "$SCRAPANDSTASHTHISITEM";
         tooltip = param2 == 1 ? this.m_ItemData.text : this.m_ItemData.text + " (" + param2 + ")";
         m_AcceptButton.ButtonText = "$ACCEPT";
         m_CancelButton.ButtonText = "$CANCEL";
         Background_mc.width = this.m_BackgroundDefaultWidth;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAPBOX_SCRAP_TRANSFER_PREP,{
            "serverHandleID":this.m_ItemData.serverHandleID,
            "quantity":param2
         }));
         stage.focus = ComponentList_mc;
         open = true;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
      }
      
      public function HandlePrimaryAction() : *
      {
         open = false;
         switch(this.m_State)
         {
            case STATE_SCRAP:
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAP_ITEM,{
                  "serverHandleID":this.m_ItemData.serverHandleID,
                  "quantity":this.m_ScrapQuantity
               }));
               GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
               dispatchEvent(new CustomEvent(EVENT_CLOSED,{
                  "accepted":true,
                  "favorite":this.m_ItemData.favorite,
                  "isLegendary":this.m_ItemData.isLegendary,
                  "isPremium":this.m_ItemData.isPremium
               },true,true));
               break;
            case STATE_SCRAP_ALL:
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAP_ALL_JUNK,{}));
               GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
               dispatchEvent(new CustomEvent(EVENT_CLOSED,{"accepted":true},true,true));
               break;
            case STATE_SCRAPBOX_TRANSFER_JUNK:
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAPBOX_TRANSFER_JUNK,{}));
               GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
               dispatchEvent(new CustomEvent(EVENT_CLOSED,{"accepted":true},true,true));
               break;
            case STATE_SCRAPBOX_SCRAP_TRANSFER_SELECTION:
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAPBOX_SCRAP_TRANSFER_CONFIRM,{
                  "serverHandleID":this.m_ItemData.serverHandleID,
                  "quantity":this.m_ScrapQuantity
               }));
               GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
               dispatchEvent(new CustomEvent(EVENT_CLOSED,{"accepted":true},true,true));
         }
      }
      
      public function HandleSecondaryAction() : *
      {
         open = false;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
         dispatchEvent(new CustomEvent(EVENT_CLOSED,{"accepted":false},true,true));
      }
   }
}
