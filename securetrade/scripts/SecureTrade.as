package
{
   import Map.CampBuilds.CampBuildsShared;
   import Shared.AS3.BCBasicModal;
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.AS3.IMenu;
   import Shared.AS3.QuantityMenu;
   import Shared.AS3.SWFLoaderClip;
   import Shared.AS3.SecureTradeShared;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.SecureTrade_ContainerListStyle;
   import Shared.AS3.Styles.SecureTrade_ItemCardStyle;
   import Shared.AS3.Styles.SecureTrade_PlayerListStyle;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol362")]
   public class SecureTrade extends IMenu
   {
      
      public static var time:Number = 0;
      
      public static var delta:Number = 0;
      
      private static const MODE_CONTAINER:uint = SecureTradeShared.MODE_CONTAINER;
      
      private static const MODE_PLAYERVENDING:uint = SecureTradeShared.MODE_PLAYERVENDING;
      
      private static const MODE_NPCVENDING:uint = SecureTradeShared.MODE_NPCVENDING;
      
      private static const MODE_VENDING_MACHINE:uint = SecureTradeShared.MODE_VENDING_MACHINE;
      
      private static const MODE_DISPLAY_CASE:uint = SecureTradeShared.MODE_DISPLAY_CASE;
      
      private static const MODE_FERMENTER:uint = SecureTradeShared.MODE_FERMENTER;
      
      private static const MODE_REFRIGERATOR:uint = SecureTradeShared.MODE_REFRIGERATOR;
      
      private static const MODE_FREEZER:uint = SecureTradeShared.MODE_FREEZER;
      
      private static const MODE_RECHARGER:uint = SecureTradeShared.MODE_RECHARGER;
      
      private static const MODE_CAMP_DISPENSER:uint = SecureTradeShared.MODE_CAMP_DISPENSER;
      
      private static const MODE_ALLY:uint = SecureTradeShared.MODE_ALLY;
      
      private static const MODE_PET:uint = SecureTradeShared.MODE_PET;
      
      private static const MODE_INVALID:uint = SecureTradeShared.MODE_INVALID;
      
      public static const EVENT_MENU_EXIT:String = "SecureTrade::ExitMenu";
      
      public static const EVENT_REQUEST_SORT:String = "SecureTrade::SortList";
      
      public static const EVENT_REQUEST_PURCHASE:String = "SecureTrade::RequestPurchase";
      
      public static const EVENT_DECLINE_ITEM:String = "SecureTrade::DeclineItem";
      
      public static const EVENT_CREATE_OFFER:String = "SecureTrade::CreateOffer";
      
      public static const EVENT_REMOVE_ITEM:String = "SecureTrade::RemoveItem";
      
      public static const EVENT_ITEM_SELECTED:String = "SecureTrade::OnItemSelected";
      
      public static const EVENT_REQUEST_ITEM:String = "SecureTrade::RequestItem";
      
      public static const EVENT_CANCEL_REQUEST_ITEM:String = "SecureTrade::CancelRequestItem";
      
      public static const EVENT_NPC_BUY_ITEM:String = "NPCVend::BuyItem";
      
      public static const EVENT_NPC_SELL_ITEM:String = "NPCVend::SellItem";
      
      public static const EVENT_TRANSFER_ITEM:String = "Container::TransferItem";
      
      public static const EVENT_TAKE_ALL:String = "Container::TakeAll";
      
      public static const EVENT_INSPECT_ITEM:String = "Container::InspectItem";
      
      public static const EVENT_STORE_ALL_JUNK:String = "Workbench::StoreAllJunk";
      
      public static const EVENT_TRANSFER_UNUSED_AMMO:String = "Container::TransferUnusedAmmo";
      
      public static const EVENT_CAMP_SELL_ITEM:String = "CampVend::SellItem";
      
      public static const EVENT_CAMP_DISPLAY_ITEM:String = "CampVend::DisplayItem";
      
      public static const EVENT_CAMP_BUY_ITEM:String = "CampVend::BuyItem";
      
      public static const EVENT_CAMP_REMOVE_ITEM:String = "CampVend::RemoveItem";
      
      public static const EVENT_CAMP_DISPLAY_DECORATE_ITEM_IN_SLOT:String = "CampDecorate::DisplayDecorateItemInSlot";
      
      public static const EVENT_CAMP_REMOVE_DECORATE_ITEM_IN_SLOT:String = "CampDecorate::RemoveDecorateItemInSlot";
      
      public static const EVENT_TRANSFER_TOO_HEAVY_ERROR:String = "SecureTrade::TransferTooHeavyError";
      
      public static const EVENT_DECLINE_ITEM_OPEN:String = "SecureTrade::DeclineItemOpen";
      
      public static const EVENT_CAMP_STOP_ITEM_PROCESSING:String = "CampVend::StopItemProcessing";
      
      public static const EVENT_SELL_FAVORITE_DECLINED:String = "NPCVend::SellFavoriteItemDeclined";
      
      public static const EVENT_TRADE_FAVORITE_DECLINED:String = "PlayerVend::TradeFavoriteItemDeclined";
      
      public static const SOF_ALPHABETICALLY:int = 0;
      
      public static const SOF_DAMAGE:int = 1;
      
      public static const SOF_ROF:int = 2;
      
      public static const SOF_RANGE:int = 3;
      
      public static const SOF_ACCURACY:int = 4;
      
      public static const SOF_VALUE:int = 5;
      
      public static const SOF_WEIGHT:int = 6;
      
      public static const SOF_STACKWEIGHT:int = 7;
      
      public static const SOF_SPOILAGE:int = 8;
      
      public static const MAX_SELL_PRICE:int = 40000;
      
      public static const FILTER_OPTION_NONE:int = 0;
      
      public static const FILTER_OPTION_THIS_MACHINE:int = 1;
      
      public static const FILTER_OPTION_THIS_MACHINE_AND_STASH:int = 2;
      
      public static const FILTER_OPTION_COUNT:int = 3;
      
      private static const FILTER_FAVORITES:* = 1 << 0;
      
      private static const FILTER_NEW_ID:* = 1 << 1;
      
      private static const FILTER_WEAPONS:* = 1 << 2;
      
      private static const FILTER_ARMOR:* = 1 << 3;
      
      private static const FILTER_APPAREL:* = 1 << 4;
      
      private static const FILTER_FOODWATER:* = 1 << 5;
      
      private static const FILTER_AID:* = 1 << 6;
      
      private static const FILTER_BOOKS:* = 1 << 10;
      
      private static const FILTER_MISC:* = 1 << 12;
      
      private static const FILTER_JUNK:* = 1 << 13;
      
      private static const FILTER_MODS:* = 1 << 14;
      
      private static const FILTER_AMMO:* = 1 << 15;
      
      private static const FILTER_HOLOTAPES:* = 1 << 16;
      
      private static const FILTER_CANAUTOSCRAP:* = 1 << 18;
      
      private static const FILTER_ALL:* = 4294967295;
      
      private static const STARTING_FOCUS_PREF_NONE:uint = 0;
      
      private static const STARTING_FOCUS_PREF_PLAYER:uint = 1;
      
      private static const STARTING_FOCUS_PREF_CONTAINER:uint = 2;
      
      public static const REFRESH_SELECTION_NONE:int = 0;
      
      public static const REFRESH_SELECTION_SERVER_ID:int = 1;
      
      public static const REFRESH_SELECTION_NAME_COUNT:int = 2;
      
      public static const HEIGHT_BUFFER:uint = 250;
       
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var PlayerInventory_mc:SecureTradePlayerInventory;
      
      public var OfferInventory_mc:SecureTradeOfferInventory;
      
      public var SlotInfo_mc:SecureTradeSlotInfo;
      
      public var ItemCardContainer_mc:MovieClip;
      
      public var ModalSetQuantity_mc:QuantityMenu;
      
      public var ModalSetPrice_mc:QuantityMenu;
      
      public var ModalDeclineItem_mc:SecureTradeDeclineItemModal;
      
      public var ItemPreview_mc:MovieClip;
      
      public var ModalConfirmPurchase_mc:BCBasicModal;
      
      public var ModalConfirmTakeAll_mc:BCBasicModal;
      
      public var ModalConfirmScrap_mc:SecureTradeScrapConfirmModal;
      
      public var CategoryBar_mc:LabelSelector;
      
      public var Header_mc:MovieClip;
      
      private var _OnQuantityConfirmedFn:Function = null;
      
      private var _OnSetPriceConfirmedFn:Function = null;
      
      private var ButtonPlayerInventory:BSButtonHintData;
      
      private var ButtonContainerInventory:BSButtonHintData;
      
      private var ButtonDecline:BSButtonHintData;
      
      private var ButtonToggleAssign:BSButtonHintData;
      
      private var ButtonOffersOnly:BSButtonHintData;
      
      private var InspectButton:BSButtonHintData;
      
      private var ScrapButton:BSButtonHintData;
      
      private var TakeAllButton:BSButtonHintData;
      
      private var StoreUnusedItemsButton:BSButtonHintData;
      
      private var SortButton:BSButtonHintData;
      
      private var ExitButton:BSButtonHintData;
      
      private var AcceptButton:BSButtonHintData;
      
      private var DeclineItemAcceptButton:BSButtonHintData;
      
      private var DeclineItemCancelButton:BSButtonHintData;
      
      private var ToggleShowMarkedItemsOnlyButton:BSButtonHintData;
      
      private var ShowHistoryButton:BSButtonHintData;
      
      private var ButtonHintDataV:Vector.<BSButtonHintData>;
      
      private const NO_FILTER_ID:int = -1;
      
      private const SCRAP_ITEM_COUNT_THRESHOLD:uint = 5;
      
      private const TRANSFER_ITEM_COUNT_THRESHOLD:uint = 4;
      
      private const WEAPONS_TAB_INDEX:* = 2;
      
      private const PLAYERVENDING_WEAPONS_TAB_INDEX:* = 1;
      
      private const JUNK_TAB_INDEX:* = 8;
      
      private const AMMO_TAB_INDEX:* = 10;
      
      private const DEFAULT_CATEGORY_BAR_SCALE:* = 1.1;
      
      private const CORPSE_LOOT_CATEGORY_BAR_SCALE:* = 1.15;
      
      private const ITEM_CARD_START_HEIGHT:Number = 82;
      
      private const ITEM_CARD_START_Y:Number = 338.8;
      
      private const ITEM_CARD_ENTRY_HEIGHT:Number = 40;
      
      private const ITEM_CARD_LABEL_START_Y:Number = 340.7;
      
      private const ITEM_CARD_DESCRIPTION_START_Y:Number = 240.05;
      
      private var maintainScrollPosition:Boolean = false;
      
      private var lastScrollPosition_Player:uint = 0;
      
      private var lastScrollPosition_Offer:uint = 0;
      
      private var maxtabs:uint = 14;
      
      private var defaultVendorItemPrice:int = -1;
      
      private var checkItemProtectionOnSelectionChange:Boolean = false;
      
      private var hideTakeAllConfirm:Boolean = false;
      
      private var m_IsOpen:Boolean = false;
      
      private var m_PreviousFocus:InteractiveObject;
      
      private var m_ItemFilters:Array;
      
      private var m_SelectedList:SecureTradeInventory;
      
      private var m_TabMax:* = 0;
      
      private var m_TabMin:* = 0;
      
      private var m_SelectedTab:int = 0;
      
      private var m_SelectedTabForceChange:Boolean = false;
      
      private var m_MenuMode:uint = 4294967295;
      
      private var m_SubMenuMode:uint = 0;
      
      private var m_CurrencyType:uint = 4294967295;
      
      private var m_DefaultHeaderText:String = "$CONTAINER";
      
      private var m_AcceptBtnText_Player:String = "$STORE";
      
      private var m_AcceptBtnText_Player_Assign:String = "$Assign";
      
      private var m_AcceptBtnText_Container:String = "$TAKE";
      
      private var m_TakeAllBtnText:String = "$TAKE ALL";
      
      private var m_scrapAllowedFlag:uint = 0;
      
      private var m_transferUnusedAmmoAllowed:Boolean = false;
      
      private var m_playerHasMiscItems:Boolean = false;
      
      private var m_playerHasAutoScrappableJunkItems:Boolean = false;
      
      private var m_isWorkbench:Boolean = false;
      
      private var m_isWorkshop:Boolean = false;
      
      private var m_isCamp:Boolean = false;
      
      private var m_isStash:Boolean = false;
      
      private var m_storageMode:uint = 0;
      
      private var m_onlyGivingAllowed:Boolean = false;
      
      private var m_onlyTakingAllowed:Boolean = false;
      
      private var m_SortFieldText:Array;
      
      private var m_PlayerInventorySortField:int = 0;
      
      private var m_OfferInventorySortField:int = 0;
      
      private var m_VendorSellOnly:Boolean = false;
      
      private var m_ModalActive:Boolean = false;
      
      private var m_ContainerEmpty:Boolean = false;
      
      private var m_PlayerInventoryEmpty:Boolean = false;
      
      private var m_TabEventName:String = "";
      
      private var m_PlayerConnected:Boolean = false;
      
      private var m_ProcessingItemEvent:Boolean = false;
      
      private var m_ToolTipDefaultHeight:Number;
      
      private var m_MyOffersData:Array;
      
      private var m_TheirOffersData:Array;
      
      private var m_PlayerInvData:Array;
      
      private var m_OtherInvData:Array;
      
      private var m_ContainerIDs:Array;
      
      private var m_NewItems:Array;
      
      private var m_ShowOffersOnly:Boolean = false;
      
      private var m_OwnsVendor:Boolean = false;
      
      private var m_ShowPlayerValueEntry:Boolean = true;
      
      private var m_IsFollowerOfZeus:Boolean = false;
      
      private var m_IgnorePlayerVendingItemPress:Boolean = true;
      
      private var m_DownEventRecieved:Boolean = false;
      
      private var m_InspectMode:Boolean = false;
      
      private var m_CorpseLootMode:Boolean = false;
      
      private var m_OnNewTab:Boolean = false;
      
      private var m_HasNewTab:Boolean = false;
      
      private var m_IsFilteredCategory:Boolean = false;
      
      private var m_IsScrapConfirmModalActive:Boolean = false;
      
      private var m_FilterItemsOption:int = 0;
      
      private var m_StartingFocusPref:int = 2;
      
      private var m_CurrencyIconConfirmPurchase:MovieClip;
      
      private var m_CurrencyIconSetPrice:MovieClip;
      
      private var m_SelectedItemOffered:Boolean = false;
      
      private var m_SelectedStackName:String = "";
      
      private var m_SelectedItemValue:Number = 0;
      
      private var m_SelectedItemCount:Number = 0;
      
      private var m_SelectedItemServerHandleId:Number = 0;
      
      private var m_SelectedItemIsPartialOffer:Boolean = false;
      
      private var m_RefreshSelectionOption:int = 0;
      
      public var modLoader:Loader;
      
      public var __SFCodeObj:Object;
      
      public function SecureTrade()
      {
         this.m_MenuMode = 4294967295;
         this.m_CurrencyType = 4294967295;
         this.__SFCodeObj = new Object();
         this.ButtonPlayerInventory = new BSButtonHintData("$TransferPlayerLabel","LT","PSN_L2_Alt","Xenon_L2_Alt",1,this.onSwapInventoryPlayer);
         this.ButtonContainerInventory = new BSButtonHintData("$TransferContainerLabel","RT","PSN_R2_Alt","Xenon_R2_Alt",1,this.onSwapInventoryContainer);
         this.ButtonDecline = new BSButtonHintData("$DECLINEITEM","R","PSN_X","Xenon_X",1,this.onDeclineItem);
         this.ButtonToggleAssign = new BSButtonHintData("$REMOVE","R","PSN_X","Xenon_X",1,this.onToggleAssign);
         this.ButtonOffersOnly = new BSButtonHintData("$OFFERSONLY","T","PSN_Y","Xenon_Y",1,this.onOffersOnly);
         this.InspectButton = new BSButtonHintData("$INSPECT","X","PSN_R3","Xenon_R3",1,this.onInspectItem);
         this.ScrapButton = new BSButtonHintData("$SCRAP","Space","PSN_A","Xenon_A",1,this.onScrapButton);
         this.TakeAllButton = new BSButtonHintData("$TAKE ALL","R","PSN_X","Xenon_X",1,this.onTakeAll);
         this.StoreUnusedItemsButton = new BSButtonHintData("$StoreAllJunk","T","PSN_Y","Xenon_Y",1,this.onStoreUnusedItems);
         this.SortButton = new BSButtonHintData("$SORT","Q","PSN_L3","Xenon_L3",1,this.onRequestSort);
         this.ExitButton = new BSButtonHintData("$EXIT","TAB","PSN_B","Xenon_B",1,this.onBackButton);
         this.AcceptButton = new BSButtonHintData("$STORE","Space","PSN_A","Xenon_A",1,this.onAccept);
         this.DeclineItemAcceptButton = new BSButtonHintData("$ACCEPT","Space","PSN_A","Xenon_A",1,this.onDeclineItemAccept);
         this.DeclineItemCancelButton = new BSButtonHintData("$CANCEL","TAB","PSN_B","Xenon_B",1,this.onBackButton);
         this.ToggleShowMarkedItemsOnlyButton = new BSButtonHintData("","T","PSN_Y","Xenon_Y",1,this.onToggleShowMarkedItemsOnlyButton);
         this.ShowHistoryButton = new BSButtonHintData("$CAMP_SLOTS_VENDING_HISTORY","V","PSN_Select","Xenon_Select",1,this.onShowHistory);
         this.ButtonHintDataV = new <BSButtonHintData>[this.AcceptButton,this.DeclineItemAcceptButton,this.DeclineItemCancelButton,this.ButtonDecline,this.ButtonToggleAssign,this.ScrapButton,this.InspectButton,this.ButtonPlayerInventory,this.ButtonContainerInventory,this.StoreUnusedItemsButton,this.TakeAllButton,this.SortButton,this.ButtonOffersOnly,this.ToggleShowMarkedItemsOnlyButton,this.ShowHistoryButton,this.ExitButton];
         this.m_SortFieldText = ["$SORT","$SORT_DMG","$SORT_ROF","$SORT_RNG","$SORT_ACC","$SORT_VAL","$SORT_WT","$SORT_SW","$SORT_SPL"];
         this.m_MyOffersData = new Array();
         this.m_TheirOffersData = new Array();
         this.m_PlayerInvData = new Array();
         this.m_OtherInvData = new Array();
         this.m_ContainerIDs = new Array();
         this.m_NewItems = new Array();
         super();
         addFrameScript(0,this.frame1,31,this.frame32,48,this.frame49,58,this.frame59,68,this.frame69);
         this.ButtonHintBar_mc.useVaultTecColor = true;
         this.m_ItemFilters = new Array();
         StyleSheet.apply(this.PlayerInventory_mc.ItemList_mc,false,SecureTrade_PlayerListStyle);
         StyleSheet.apply(this.OfferInventory_mc.ItemList_mc,false,SecureTrade_ContainerListStyle);
         StyleSheet.apply(this.ItemCardContainer_mc.ItemCard_mc,false,SecureTrade_ItemCardStyle);
         this.PlayerInventory_mc.ItemList_mc.List_mc.textOption_Inspectable = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
         this.OfferInventory_mc.ItemList_mc.List_mc.textOption_Inspectable = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
         this.ButtonHintBar_mc.SetButtonHintData(this.ButtonHintDataV);
         Extensions.enabled = true;
         addEventListener(FocusEvent.FOCUS_OUT,this.onFocusChange);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
         this.PlayerInventory_mc.ItemList_mc.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectedDataChanged);
         this.OfferInventory_mc.ItemList_mc.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectedDataChanged);
         addEventListener(BSScrollingList.PLAY_FOCUS_SOUND,this.onUserMovesListSelection);
         addEventListener(SecureTradeInventory.MOUSE_OVER,this.onListMouseOver);
         addEventListener(QuantityMenu.CONFIRM,this.onQuantityConfirm);
         addEventListener(QuantityMenu.MAX,this.onQuantityMax);
         addEventListener(QuantityMenu.CANCEL,this.onQuantityCancel);
         addEventListener(SecureTradeDeclineItemModal.CONFIRM,this.onDeclineItemConfirm);
         addEventListener(BCBasicModal.EVENT_CONFIRM,this.onConfirmModalConfirm);
         addEventListener(BCBasicModal.EVENT_CANCEL,this.onConfirmModalCancel);
         addEventListener(LabelSelector.LABEL_MOUSE_SELECTION_EVENT,this.OnLabelMouseSelection);
         addEventListener(SecureTradeScrapConfirmModal.EVENT_CLOSED,this.OnSecureTradeScrapConfirmModalClosed);
         this.m_ToolTipDefaultHeight = this.ModalConfirmPurchase_mc.Tooltip_mc.textField.height;
         this.ModalConfirmPurchase_mc.choiceButtonMode = BCBasicModal.BUTTON_MODE_LIST;
         this.ModalConfirmTakeAll_mc.choiceButtonMode = BCBasicModal.BUTTON_MODE_LIST;
         var _loc1_:SWFLoaderClip = this.ModalConfirmPurchase_mc.Value_mc.Icon_mc;
         _loc1_.clipWidth = _loc1_.width * (1 / _loc1_.scaleX);
         _loc1_.clipHeight = _loc1_.height * (1 / _loc1_.scaleY);
         _loc1_ = this.ModalSetPrice_mc.Value_mc.Icon_mc;
         _loc1_.clipWidth = _loc1_.width * (1 / _loc1_.scaleX);
         _loc1_.clipHeight = _loc1_.height * (1 / _loc1_.scaleY);
         this.ModalSetQuantity_mc.alpha = 0;
         this.loadMod("InventOmaticStash.swf");
      }
      
      private function loadMod(param1:String) : void
      {
         var modfile:String = param1;
         try
         {
            modLoader = new Loader();
            modLoader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
            modLoader.load(new URLRequest(modfile),new LoaderContext(false,ApplicationDomain.currentDomain));
            addChild(modLoader);
         }
         catch(e:Error)
         {
            GlobalFunc.ShowHUDMessage("Error loading mod: " + e);
         }
      }
      
      private function uncaughtErrorHandler(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:Error = null;
         var _loc3_:ErrorEvent = null;
         if(param1.error is Error)
         {
            _loc2_ = param1.error as Error;
            GlobalFunc.ShowHUDMessage("Error: " + _loc2_);
         }
         else if(param1.error is ErrorEvent)
         {
            _loc3_ = param1.error as ErrorEvent;
            GlobalFunc.ShowHUDMessage("Error: " + _loc3_);
         }
      }
      
      public function get CorpseLootMode() : Boolean
      {
         return this.m_CorpseLootMode;
      }
      
      public function get IsWorkbench() : Boolean
      {
         return this.m_isWorkbench;
      }
      
      public function get MenuMode() : uint
      {
         return this.m_MenuMode;
      }
      
      public function get OwnsVendor() : uint
      {
         return this.m_OwnsVendor;
      }
      
      public function set maxTabs(value:uint) : void
      {
         this.maxtabs = value;
      }
      
      public function get maxTabs() : uint
      {
         return this.maxtabs;
      }
      
      public function set CheckItemProtectionOnSelectionChange(value:Boolean) : void
      {
         this.checkItemProtectionOnSelectionChange = value;
      }
      
      public function set HideTakeAllConfirm(value:Boolean) : void
      {
         this.hideTakeAllConfirm = value;
      }
      
      public function set DefaultVendorItemPrice(value:int) : void
      {
         this.defaultVendorItemPrice = value;
      }
      
      public function set MaintainScrollPosition(value:uint) : void
      {
         this.maintainScrollPosition = value;
      }
      
      public function set CurrencyLimitIndicator(value:Boolean) : void
      {
         SecureTradeInventory.CurrencyLimitIndicator = true;
      }
      
      public function updateModButtons() : void
      {
         setTimeout(function():void
         {
            if(modLoader && modLoader.content)
            {
               modLoader.content.updateButtonHints();
            }
         },25);
      }
      
      public function updateModSelectedTab() : void
      {
         setTimeout(function():void
         {
            if(modLoader && modLoader.content)
            {
               modLoader.content.onSelectedTabChanged();
            }
         },25);
      }
      
      public function updateModHeaders() : void
      {
         setTimeout(function():void
         {
            if(modLoader && modLoader.content)
            {
               modLoader.content.updateModHeaders();
            }
         },25);
      }
      
      public function isItemProtected(item:Object, isSelectionChanged:Boolean = false) : Boolean
      {
         if(isSelectionChanged && !this.checkItemProtectionOnSelectionChange)
         {
            return false;
         }
         if(this.selectedList == this.PlayerInventory_mc && this.modLoader && this.modLoader.content && this.modLoader.content.isItemProtected(item))
         {
            return true;
         }
         return false;
      }
      
      public function isMaxCurrencyProtection() : Boolean
      {
         if(this.modLoader && this.modLoader.content && this.modLoader.content && this.modLoader.content.isMaxCurrencyProtection)
         {
            return true;
         }
         return false;
      }
      
      private function getLegendaryItemDescription(description:String) : String
      {
         if(!this.modLoader || !this.modLoader.content)
         {
            return description;
         }
         return this.modLoader.content.getLegendaryItemDescription(description);
      }
      
      private function formatLegendaryItemDescription(description_tf:*) : void
      {
         if(!this.modLoader || !this.modLoader.content)
         {
            return;
         }
         this.modLoader.content.formatLegendaryItemDescription(description_tf);
      }
      
      public function get ButtonHintData() : Vector.<BSButtonHintData>
      {
         return this.ButtonHintDataV;
      }
      
      public function showDurabilityValue(value:Boolean) : void
      {
         ItemCard_Entry.ShowDurability = value;
      }
      
      private function log(message:String) : void
      {
         if(!this.modLoader || !this.modLoader.content)
         {
            return;
         }
         this.modLoader.content.log(message);
      }
      
      public function set currencyType(param1:uint) : void
      {
         this.m_CurrencyType = param1;
         PlayerListEntry.currencyType = this.m_CurrencyType;
         OfferListEntry.currencyType = this.m_CurrencyType;
         this.PlayerInventory_mc.SetIsDirty();
         this.PlayerInventory_mc.ItemList_mc.SetIsDirty();
         this.OfferInventory_mc.SetIsDirty();
         this.OfferInventory_mc.ItemList_mc.SetIsDirty();
         if(this.m_CurrencyIconConfirmPurchase != null)
         {
            this.ModalConfirmPurchase_mc.Value_mc.Icon_mc.removeChild(this.m_CurrencyIconConfirmPurchase);
            this.m_CurrencyIconConfirmPurchase = null;
         }
         if(this.m_CurrencyIconSetPrice != null)
         {
            this.ModalSetPrice_mc.Value_mc.Icon_mc.removeChild(this.m_CurrencyIconSetPrice);
            this.m_CurrencyIconSetPrice = null;
         }
         this.m_CurrencyIconConfirmPurchase = SecureTradeShared.setCurrencyIcon(this.ModalConfirmPurchase_mc.Value_mc.Icon_mc,this.m_CurrencyType);
         this.m_CurrencyIconSetPrice = SecureTradeShared.setCurrencyIcon(this.ModalSetPrice_mc.Value_mc.Icon_mc,this.m_CurrencyType);
         this.ModalConfirmPurchase_mc.Value_mc.Icon_mc.gotoAndStop(this.m_CurrencyType == SecureTradeShared.CURRENCY_LEGENDARY_TOKENS ? "LTokens" : "Caps");
         this.ModalSetPrice_mc.Value_mc.Icon_mc.gotoAndStop(this.m_CurrencyType == SecureTradeShared.CURRENCY_LEGENDARY_TOKENS ? "unselectedLToken" : "unselected");
      }
      
      public function get isLimitedStorage() : Boolean
      {
         return this.isScrapStash || this.isAmmoStash;
      }
      
      public function get isScrapStash() : Boolean
      {
         return this.m_storageMode == SecureTradeShared.LIMITED_TYPE_STORAGE_SCRAP;
      }
      
      public function get isAmmoStash() : Boolean
      {
         return this.m_storageMode == SecureTradeShared.LIMITED_TYPE_STORAGE_AMMO;
      }
      
      public function get currencyType() : uint
      {
         return this.m_CurrencyType;
      }
      
      private function isCampVendingMenuType() : Boolean
      {
         return SecureTradeShared.IsCampVendingMenuType(this.m_MenuMode);
      }
      
      private function updateOfferWeightDisplay() : void
      {
         this.OfferInventory_mc.showCarryWeight = !this.isLimitedStorage && (this.m_MenuMode == MODE_CONTAINER || this.isCampVendingMenuType());
      }
      
      public function set menuMode(param1:uint) : void
      {
         this.m_MenuMode = param1;
         PlayerListEntry.showCurrency = this.m_MenuMode != MODE_CONTAINER;
         PlayerListEntry.menuMode = param1;
         OfferListEntry.menuMode = param1;
         this.OfferInventory_mc.menuMode = this.m_MenuMode;
         this.updateOfferInventoryTooltipVis();
         this.PlayerInventory_mc.showTooltip = this.m_MenuMode == MODE_PLAYERVENDING;
         this.updateCategoryBar();
         this.CategoryBar_mc.SelectedID = this.m_HasNewTab ? FILTER_NEW_ID : uint(this.NO_FILTER_ID);
         this.m_SelectedTabForceChange = true;
         this.selectedTab = 0;
         switch(this.m_MenuMode)
         {
            case MODE_CONTAINER:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$CONTAINER");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_NPCVENDING:
            case MODE_VENDING_MACHINE:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$VENDOR");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_PLAYERVENDING:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$TRADING");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_DISPLAY_CASE:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$DISPLAY");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_FERMENTER:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$FERMENTER");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_REFRIGERATOR:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$REFRIGERATOR");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_FREEZER:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$FREEZER");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_RECHARGER:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$RECHARGER");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_CAMP_DISPENSER:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$DISPENSER");
               this.ItemCardContainer_mc.gotoAndStop("BackerHeight1");
               break;
            case MODE_ALLY:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$ALLY");
               this.ItemCardContainer_mc.gotoAndStop("ItemStatsOff");
               break;
            case MODE_PET:
               GlobalFunc.SetText(this.Header_mc.HeaderText_tf,"$PET");
               this.ItemCardContainer_mc.gotoAndStop("ItemStatsOff");
         }
         TextFieldEx.setTextAutoSize(this.Header_mc.HeaderText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.updateHeaders();
         this.updateSelfInventory();
         this.updateOtherInventory();
      }
      
      public function set subMenuMode(param1:uint) : void
      {
         this.m_SubMenuMode = param1;
         this.OfferInventory_mc.subMenuMode = this.m_SubMenuMode;
         this.updateCategoryBar();
         this.OfferInventory_mc.showTooltip = this.m_SubMenuMode != SecureTradeShared.SUB_MODE_STANDARD;
      }
      
      public function updateOfferInventoryTooltipVis() : void
      {
         this.OfferInventory_mc.showTooltip = this.m_MenuMode == MODE_PLAYERVENDING || this.m_MenuMode == MODE_CONTAINER || this.isCampVendingMenuType();
      }
      
      public function set selectedTab(param1:int) : void
      {
         var _loc2_:SecureTradeInventory = null;
         if(param1 != this.m_SelectedTab || this.m_SelectedTabForceChange)
         {
            if(param1 != this.m_SelectedTab)
            {
               this.lastScrollPosition_Player = 0;
               this.lastScrollPosition_Offer = 0;
               this.PlayerInventory_mc.ItemList_mc.List_mc.scrollPosition = 0;
               this.OfferInventory_mc.ItemList_mc.List_mc.scrollPosition = 0;
            }
            this.m_SelectedTabForceChange = false;
            if(param1 < this.m_TabMin)
            {
               param1 = this.m_TabMin;
            }
            else if(param1 >= this.m_TabMax)
            {
               param1 = this.m_TabMax - 1;
            }
            this.m_SelectedTab = param1;
            if(this.m_SelectedTab == param1)
            {
               this.m_OnNewTab = this.m_HasNewTab && this.m_SelectedTab == 0;
               this.updateHeaders();
               this.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter = this.m_CorpseLootMode ? FILTER_ALL : int(this.m_ItemFilters[this.m_SelectedTab].flag);
               this.OfferInventory_mc.ItemList_mc.List_mc.filterer.itemFilter = this.m_ItemFilters[this.m_SelectedTab].flag;
               this.updateSelfInventory();
               this.OfferInventory_mc.ItemList_mc.SetIsDirty();
               this.m_ContainerEmpty = this.OfferInventory_mc != null && this.IsInventoryEmpty(this.OfferInventory_mc);
               this.updateInventoryFocus();
               this.updateButtonHints();
            }
            _loc2_ = this.selectedList == this.PlayerInventory_mc ? this.OfferInventory_mc : this.PlayerInventory_mc;
            if(this.selectedList != null)
            {
               this.selectedList.selectedItemIndex = this.IsInventoryEmpty(this.selectedList) ? -1 : this.selectedList.ItemList_mc.List_mc.filterer.ClampIndex(0);
               this.ItemCardContainer_mc.visible = this.selectedList.selectedItemIndex != -1;
            }
            if(_loc2_ != null)
            {
               _loc2_.selectedItemIndex = -1;
            }
            this.updateModSelectedTab();
         }
      }
      
      public function get selectedTab() : int
      {
         return this.m_SelectedTab;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         if(param1 != this.m_IsOpen)
         {
            if(param1)
            {
               gotoAndPlay("rollOn");
            }
            else
            {
               gotoAndPlay("rollOff");
            }
            this.m_IsOpen = param1;
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this.m_IsOpen;
      }
      
      public function get selectedListEntry() : Object
      {
         return this.m_SelectedList.ItemList_mc.List_mc.selectedEntry;
      }
      
      public function get selectedListIndex() : int
      {
         return this.m_SelectedList.ItemList_mc.List_mc.selectedIndex;
      }
      
      private function updateListActive(param1:SecureTradeInventory) : void
      {
         var _loc2_:* = this.m_SelectedList == param1;
         param1.Active = _loc2_;
         param1.ItemList_mc.Active = _loc2_;
         param1.ItemList_mc.List_mc.Active = _loc2_;
         param1.ItemList_mc.List_mc.disableInput_Inspectable = !_loc2_;
         if(param1.ItemList_mc.disableSelection_Inspectable)
         {
            param1.ItemList_mc.disableSelection_Inspectable = false;
         }
         if(param1.ItemList_mc.List_mc.hasBeenUpdated)
         {
            if(_loc2_)
            {
               param1.ItemList_mc.setSelectedIndex(0);
            }
            else
            {
               param1.ItemList_mc.setSelectedIndex(-1);
            }
         }
         param1.ItemList_mc.disableSelection_Inspectable = !_loc2_;
      }
      
      public function set selectedList(param1:SecureTradeInventory) : *
      {
         if(param1 != this.m_SelectedList)
         {
            this.m_SelectedList = param1;
            stage.focus = this.m_SelectedList.ItemList_mc.List_mc;
            this.updateListActive(this.PlayerInventory_mc);
            this.updateListActive(this.OfferInventory_mc);
            this.updateButtonHints();
            this.updateHeaders();
            if(this.maintainScrollPosition)
            {
               if(this.m_SelectedList == PlayerInventory_mc)
               {
                  this.PlayerInventory_mc.ItemList_mc.List_mc.scrollPosition = GlobalFunc.Clamp(this.lastScrollPosition_Player,0,this.PlayerInventory_mc.ItemList_mc.List_mc.maxScrollPosition);
               }
               else if(this.m_SelectedList == OfferInventory_mc)
               {
                  this.OfferInventory_mc.ItemList_mc.List_mc.scrollPosition = GlobalFunc.Clamp(this.lastScrollPosition_Offer,0,this.OfferInventory_mc.ItemList_mc.List_mc.maxScrollPosition);
               }
            }
         }
      }
      
      public function get selectedList() : SecureTradeInventory
      {
         return this.m_SelectedList;
      }
      
      public function get modalActive() : Boolean
      {
         return this.m_ModalActive;
      }
      
      public function set modalActive(param1:Boolean) : void
      {
         if(param1 != this.m_ModalActive)
         {
            this.m_ModalActive = param1;
            if(this.m_ModalActive)
            {
               gotoAndPlay("modalFadeOut");
            }
            else
            {
               gotoAndPlay("modalFadeIn");
            }
         }
      }
      
      private function updateModalActive() : void
      {
         this.modalActive = this.ModalSetQuantity_mc.opened || this.ModalSetPrice_mc.opened || this.ModalDeclineItem_mc.Active || this.ModalConfirmPurchase_mc.open || this.ModalConfirmTakeAll_mc.open || this.ModalConfirmScrap_mc.open || this.m_IsScrapConfirmModalActive;
      }
      
      public function Input_HandleLeftShoulder() : uint
      {
         if(!this.modalActive && !this.m_InspectMode)
         {
            --this.selectedTab;
            this.CategoryBar_mc.SelectPrevious();
         }
         else if(this.ModalSetPrice_mc.opened)
         {
            this.ModalSetPrice_mc.ProcessUserEvent("LShoulder",false);
         }
         else if(this.ModalSetQuantity_mc.opened)
         {
            this.ModalSetQuantity_mc.ProcessUserEvent("LShoulder",false);
         }
         return this.CategoryBar_mc.SelectedID;
      }
      
      public function Input_HandleRightShoulder() : uint
      {
         if(!this.modalActive && !this.m_InspectMode)
         {
            ++this.selectedTab;
            this.CategoryBar_mc.SelectNext();
         }
         else if(this.ModalSetPrice_mc.opened)
         {
            this.ModalSetPrice_mc.ProcessUserEvent("RShoulder",false);
         }
         else if(this.ModalSetQuantity_mc.opened)
         {
            this.ModalSetQuantity_mc.ProcessUserEvent("RShoulder",false);
         }
         return this.CategoryBar_mc.SelectedID;
      }
      
      public function OnLabelMouseSelection(param1:Event) : void
      {
         var _loc2_:uint = 0;
         if((param1 as CustomEvent).params.Source == this.CategoryBar_mc && !this.modalActive)
         {
            _loc2_ = uint((param1 as CustomEvent).params.id);
            this.selectedTab = this.CategoryBar_mc.GetLabelIndex(_loc2_) + this.m_TabMin;
            this.CategoryBar_mc.SelectedID = _loc2_;
         }
      }
      
      private function onInventoryTabWheel(param1:Boolean) : void
      {
         if(param1)
         {
            --this.selectedTab;
            this.CategoryBar_mc.SelectPrevious();
         }
         else
         {
            ++this.selectedTab;
            this.CategoryBar_mc.SelectNext();
         }
      }
      
      private function updateHeaders() : void
      {
         if(this.m_MenuMode == MODE_PLAYERVENDING)
         {
            if(this.m_SelectedTab == 0)
            {
               this.PlayerInventory_mc.header = "$MYINVENTORY";
               if(this.m_PlayerConnected)
               {
                  this.OfferInventory_mc.header = this.m_DefaultHeaderText;
               }
               else
               {
                  GlobalFunc.SetText(this.OfferInventory_mc.Header_mc.Header_tf,"$WaitingForPlayer",true);
                  GlobalFunc.SetText(this.OfferInventory_mc.Header_mc.Header_tf,this.OfferInventory_mc.Header_mc.Header_tf.text.replace("{1}",this.m_DefaultHeaderText),true);
               }
            }
            else
            {
               this.PlayerInventory_mc.header = this.m_ItemFilters[this.m_SelectedTab].text + "Mine";
               if(this.m_PlayerConnected)
               {
                  this.OfferInventory_mc.header = this.m_ItemFilters[this.m_SelectedTab].text;
               }
               else
               {
                  GlobalFunc.SetText(this.OfferInventory_mc.Header_mc.Header_tf,"$WaitingForPlayer",true);
                  GlobalFunc.SetText(this.OfferInventory_mc.Header_mc.Header_tf,this.OfferInventory_mc.Header_mc.Header_tf.text.replace("{1}",this.m_DefaultHeaderText),true);
               }
            }
         }
         else if(this.m_CorpseLootMode)
         {
            this.PlayerInventory_mc.header = "$MYINVENTORY";
            this.OfferInventory_mc.header = this.m_SelectedTab == 0 ? "$ALLCORPSES" : this.m_ItemFilters[this.m_SelectedTab].text.toUpperCase();
         }
         else if(this.m_SelectedTab == 0 && !this.m_IsFilteredCategory || this.m_HasNewTab && this.m_SelectedTab == 1)
         {
            this.PlayerInventory_mc.header = this.m_OnNewTab ? "$InventoryCategoryNew" : "$MYINVENTORY";
            this.OfferInventory_mc.header = this.m_DefaultHeaderText;
         }
         else
         {
            this.PlayerInventory_mc.header = this.m_ItemFilters[this.m_SelectedTab].text + "Mine";
            this.OfferInventory_mc.header = this.m_ItemFilters[this.m_SelectedTab].text;
         }
         this.updateModHeaders();
      }
      
      public function onCharacterInfoDataUpdate(param1:FromClientDataEvent) : void
      {
         this.PlayerInventory_mc.currency = 0;
         this.PlayerInventory_mc.currencyMax = MAX_SELL_PRICE;
         this.PlayerInventory_mc.currencyName = "";
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.currencies.length)
         {
            if(param1.data.currencies[_loc2_].currencyType == this.currencyType)
            {
               this.PlayerInventory_mc.currency = param1.data.currencies[_loc2_].currencyAmount;
               this.PlayerInventory_mc.currencyMax = param1.data.currencies[_loc2_].currencyMax;
               this.PlayerInventory_mc.currencyName = param1.data.currencies[_loc2_].currencyName;
               break;
            }
            _loc2_++;
         }
         this.PlayerInventory_mc.carryWeightCurrent = Math.floor(param1.data.currWeight);
         this.PlayerInventory_mc.carryWeightMax = Math.floor(param1.data.maxWeight);
         this.PlayerInventory_mc.absoluteWeightLimit = Math.floor(param1.data.absoluteWeightLimit);
         PlayerListEntry.playerLevel = param1.data.level;
         OfferListEntry.playerLevel = param1.data.level;
         OfferListEntry.playerCurrency = param1.data.currencyAmount;
         this.PlayerInventory_mc.ItemList_mc.List_mc.InvalidateData();
         this.OfferInventory_mc.ItemList_mc.List_mc.InvalidateData();
      }
      
      public function onContainerOptionsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.m_AcceptBtnText_Player = param1.data.acceptButtonText_Player;
         this.m_AcceptBtnText_Container = param1.data.acceptButtonText_Container;
         this.m_TakeAllBtnText = param1.data.takeAllButtonText;
         this.m_scrapAllowedFlag = param1.data.scrapAllowedFlag;
         this.m_transferUnusedAmmoAllowed = param1.data.isTransferUnusedAmmoAllowed;
         this.m_isWorkbench = param1.data.isWorkbench;
         this.m_isWorkshop = param1.data.isWorkshop;
         this.m_isCamp = param1.data.isCamp;
         this.m_isStash = param1.data.isStash;
         this.m_onlyTakingAllowed = param1.data.onlyTakingAllowed;
         this.m_onlyGivingAllowed = param1.data.onlyGivingAllowed;
         this.m_storageMode = param1.data.storageMode;
         var _loc2_:Boolean = this.m_IsScrapConfirmModalActive && !param1.data.isScrapModalOpen;
         this.m_IsScrapConfirmModalActive = param1.data.isScrapModalOpen;
         if(this.m_isWorkbench)
         {
            this.OfferInventory_mc.visible = false;
            this.OfferInventory_mc.enabled = false;
            this.updateSelfInventory();
         }
         if(_loc2_)
         {
            this.OnSecureTradeScrapConfirmModalClosed(new CustomEvent(SecureTradeScrapConfirmModal.EVENT_CLOSED,{
               "accepted":param1.data.isScrapModalAccepted,
               "favorite":this.selectedListEntry.favorite,
               "isLegendary":this.selectedListEntry.isLegendary,
               "isPremium":this.selectedListEntry.isPremium
            },true,true));
         }
         else
         {
            this.updateOfferWeightDisplay();
            this.updateCategoryBar();
            this.updateButtonHints();
            this.updateHeaders();
         }
      }
      
      public function onCampVendingOfferDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.isCampVendingMenuType())
         {
            this.m_TheirOffersData = param1.data.InventoryList.concat();
            this.PopulateCampVendingInventory();
            this.disableInput = false;
         }
      }
      
      private function onFFEvent(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         if(GlobalFunc.HasFFEvent(_loc2_,EVENT_CAMP_STOP_ITEM_PROCESSING) && this.isCampVendingMenuType())
         {
            this.m_ProcessingItemEvent = false;
         }
         else if(GlobalFunc.HasFFEvent(_loc2_,EVENT_SELL_FAVORITE_DECLINED))
         {
            this.disableInput = false;
         }
         else if(GlobalFunc.HasFFEvent(_loc2_,EVENT_TRADE_FAVORITE_DECLINED))
         {
            this.disableInput = false;
            this.m_ProcessingItemEvent = false;
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.CategoryBar_mc.forceUppercase = false;
         this.CategoryBar_mc.labelWidthScale = this.DEFAULT_CATEGORY_BAR_SCALE;
         this.menuMode = MODE_CONTAINER;
         BSUIDataManager.Subscribe("PlayerInventoryData",this.onPlayerInventoryDataUpdate);
         BSUIDataManager.Subscribe("OtherInventoryTypeData",this.onOtherInvTypeDataUpdate);
         BSUIDataManager.Subscribe("OtherInventoryData",this.onOtherInvDataUpdate);
         BSUIDataManager.Subscribe("MyOffersData",this.onMyOffersDataUpdate);
         BSUIDataManager.Subscribe("TheirOffersData",this.onTheirOffersDataUpdate);
         BSUIDataManager.Subscribe("CharacterInfoData",this.onCharacterInfoDataUpdate);
         BSUIDataManager.Subscribe("ContainerOptionsData",this.onContainerOptionsDataUpdate);
         BSUIDataManager.Subscribe("CampVendingOfferData",this.onCampVendingOfferDataUpdate);
         BSUIDataManager.Subscribe("FireForgetEvent",this.onFFEvent);
         BSUIDataManager.Subscribe("AccountInfoData",this.onAccountInfoUpdate);
         BSUIDataManager.Subscribe("InventoryItemCardData",this.onInventoryItemCardDataUpdate);
         BSUIDataManager.Subscribe("HUDModeData",this.onHudModeDataUpdate);
         this.updateButtonHints();
         this.updateHeaders();
         this.isOpen = true;
         this.selectedList = this.PlayerInventory_mc;
         delta = time = 0;
         this.update();
         this.update();
         this.update();
         stage.addEventListener(Event.ENTER_FRAME,this.update);
         this.CategoryBar_mc.SetSelection(this.selectedTab,true,false);
      }
      
      private function onAccountInfoUpdate(param1:FromClientDataEvent) : void
      {
         this.m_IsFollowerOfZeus = Boolean(param1.data.hasZeus) || Boolean(param1.data.hasFO1Preview);
         this.updateButtonHints();
      }
      
      private function onHudModeDataUpdate(param1:FromClientDataEvent) : void
      {
         if(Boolean(param1.data) && Boolean(param1.data.hudMode))
         {
            this.m_InspectMode = param1.data.hudMode == HUDModes.INSPECT_MODE;
         }
         else
         {
            this.m_InspectMode = false;
         }
      }
      
      public function update(param1:Event = null) : void
      {
         delta = (getTimer() - time) / 1000;
         time = getTimer();
         this.CategoryBar_mc.Update(delta);
      }
      
      private function ClearStartingFocusPreference() : void
      {
         this.m_StartingFocusPref = STARTING_FOCUS_PREF_NONE;
      }
      
      private function onListMouseOver(param1:Event) : *
      {
         if(!this.modalActive)
         {
            if(param1.target == this.PlayerInventory_mc && this.selectedList != this.PlayerInventory_mc && this.m_onlyTakingAllowed != true)
            {
               this.selectedList = this.PlayerInventory_mc;
               this.ClearStartingFocusPreference();
            }
            else if(param1.target == this.OfferInventory_mc && this.selectedList != this.OfferInventory_mc && this.m_onlyGivingAllowed != true)
            {
               this.selectedList = this.OfferInventory_mc;
               this.ClearStartingFocusPreference();
            }
         }
      }
      
      private function onConfirmModalConfirm(param1:Event) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.ModalConfirmPurchase_mc.open)
         {
            this.closeConfirmPurchaseModal(true);
            _loc2_ = Math.min(this.selectedListEntry.count,this.ModalSetQuantity_mc.quantity);
            _loc3_ = !!this.selectedListEntry.isOffered ? Number(this.selectedListEntry.offerValue) : Number(this.selectedListEntry.itemValue);
            if(this.m_MenuMode == MODE_NPCVENDING)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(this.selectedList == this.PlayerInventory_mc ? EVENT_NPC_SELL_ITEM : EVENT_NPC_BUY_ITEM,{
                  "serverHandleId":this.selectedListEntry.serverHandleId,
                  "quantity":_loc2_
               }));
            }
            else if(this.m_MenuMode == MODE_VENDING_MACHINE)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_BUY_ITEM,{
                  "serverHandleId":this.selectedListEntry.serverHandleId,
                  "count":_loc2_,
                  "price":_loc3_
               }));
            }
            else
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_REQUEST_PURCHASE,{
                  "serverHandleId":this.selectedListEntry.serverHandleId,
                  "count":_loc2_,
                  "price":_loc3_
               }));
            }
         }
         else
         {
            this.onAccept();
         }
      }
      
      private function onConfirmModalCancel(param1:Event) : *
      {
         this.onBackButton();
      }
      
      private function onDeclineItemConfirm(param1:Event) : *
      {
         this.closeDeclineItemModal();
         this.ClearSelectedItemValues();
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_DECLINE_ITEM,{
            "serverHandleId":this.ModalDeclineItem_mc.ItemServerHandleId,
            "declineReason":this.ModalDeclineItem_mc.selectedIndex
         }));
      }
      
      private function onQuantityConfirm() : *
      {
         if(this._OnQuantityConfirmedFn != null && this.ModalSetQuantity_mc.opened)
         {
            this.closeQuantityModal();
            this.ModalSetQuantity_mc.quantity = Math.min(this.selectedListEntry.count,this.ModalSetQuantity_mc.quantity);
            this._OnQuantityConfirmedFn();
            this._OnQuantityConfirmedFn = null;
         }
         else if(this._OnSetPriceConfirmedFn != null && this.ModalSetPrice_mc.opened)
         {
            this.closeSetPriceModal();
            this._OnSetPriceConfirmedFn();
            this._OnSetPriceConfirmedFn = null;
         }
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function onQuantityMax() : *
      {
         if(this.ModalSetQuantity_mc.opened)
         {
            this.ModalSetQuantity_mc.quantityInput(this.calcMaxQuantity(true));
         }
      }
      
      private function qConfirm_TransferItem() : *
      {
         var _loc1_:* = this.selectedList == this.OfferInventory_mc;
         if(_loc1_ || this.performContainerWeightCheck(this.selectedListEntry,this.ModalSetQuantity_mc.quantity))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
               "serverHandleId":this.selectedListEntry.serverHandleId,
               "quantity":this.ModalSetQuantity_mc.quantity,
               "fromContainer":_loc1_,
               "containerID":this.selectedListEntry.containerID
            }));
         }
      }
      
      private function qConfirm_TakePartialFromVendingOffer() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
            "serverHandleId":this.selectedListEntry.serverHandleId,
            "quantity":this.ModalSetQuantity_mc.quantity,
            "fromContainer":true,
            "containerID":this.selectedListEntry.containerID
         }));
      }
      
      private function spConfirm_CreatePlayerVendingOffer() : *
      {
         var _loc1_:* = this.ModalSetQuantity_mc.quantity != this.selectedListEntry.count;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CREATE_OFFER,{
            "serverHandleId":this.selectedListEntry.serverHandleId,
            "price":this.ModalSetPrice_mc.quantity,
            "quantity":this.ModalSetQuantity_mc.quantity,
            "partialOffer":_loc1_
         }));
      }
      
      private function spConfirm_CreateCampVendingOffer() : *
      {
         var _loc1_:* = this.ModalSetQuantity_mc.quantity != this.selectedListEntry.count;
         var _loc2_:* = this.m_SelectedList == this.OfferInventory_mc;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_SELL_ITEM,{
            "serverHandleId":this.selectedListEntry.serverHandleId,
            "price":this.ModalSetPrice_mc.quantity,
            "quantity":this.ModalSetQuantity_mc.quantity,
            "partialOffer":_loc1_,
            "fromContainer":_loc2_
         }));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
         this.DelayForItemProcessing();
      }
      
      private function DelayForItemProcessing() : void
      {
         this.updateButtonHints();
      }
      
      private function onQuantityCancel(param1:Event) : *
      {
         this.onBackButton();
      }
      
      private function onDeclineItemAccept() : void
      {
         dispatchEvent(new Event(SecureTradeDeclineItemModal.CONFIRM,true,true));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
      }
      
      private function onConfirmPurchaseAccept() : void
      {
      }
      
      private function onFocusChange(param1:FocusEvent) : *
      {
         if(param1.relatedObject != this.ModalSetQuantity_mc && param1.relatedObject != this.ModalSetQuantity_mc.Value_tf && param1.relatedObject != this.ModalSetPrice_mc && param1.relatedObject != this.ModalSetPrice_mc.Value_tf && param1.relatedObject != this.PlayerInventory_mc.ItemList_mc.List_mc && param1.relatedObject != this.OfferInventory_mc.ItemList_mc.List_mc && param1.relatedObject != this.ModalDeclineItem_mc && param1.relatedObject != this.ModalConfirmPurchase_mc && param1.relatedObject != this.ModalConfirmPurchase_mc.ButtonList_mc && param1.relatedObject != this.ModalConfirmTakeAll_mc && param1.relatedObject != this.ModalConfirmTakeAll_mc.ButtonList_mc && param1.relatedObject != this.ModalConfirmScrap_mc.ComponentList_mc)
         {
            stage.focus = param1.target as InteractiveObject;
         }
      }
      
      public function onKeyUp(param1:KeyboardEvent) : void
      {
         if(this.isOpen && !param1.isDefaultPrevented())
         {
            if(this.modalActive)
            {
               if(param1.keyCode == Keyboard.ENTER)
               {
                  this.onAccept();
                  param1.stopPropagation();
               }
            }
         }
      }
      
      private function UpdateItemCard(param1:Array, param2:Boolean) : *
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc3_:Boolean = false;
         if(this.selectedListEntry != null)
         {
            _loc4_ = [];
            if(this.selectedListEntry.itemLevel != null)
            {
               _loc4_.push({
                  "text":"itemLevel",
                  "value":this.selectedListEntry.itemLevel
               });
            }
            if(this.selectedListEntry.currentHealth != null)
            {
               _loc4_.push({
                  "text":"currentHealth",
                  "value":this.selectedListEntry.currentHealth
               });
            }
            if(this.selectedListEntry.maximumHealth != null)
            {
               _loc4_.push({
                  "text":"maximumHealth",
                  "value":this.selectedListEntry.maximumHealth
               });
            }
            if(this.selectedListEntry.durability != null)
            {
               _loc4_.push({
                  "text":"durability",
                  "value":this.selectedListEntry.durability
               });
            }
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               if(param1[_loc5_].text == "DESC")
               {
                  var desc:* = this.getLegendaryItemDescription(param1[_loc5_].value);
                  GlobalFunc.SetText(this.ItemCardContainer_mc.Background_mc.Description_mc.Description_tf,desc);
                  this.formatLegendaryItemDescription(this.ItemCardContainer_mc.Background_mc.Description_mc.Description_tf);
                  TextFieldEx.setVerticalAlign(this.ItemCardContainer_mc.Background_mc.Description_mc.Description_tf,TextFieldEx.VALIGN_BOTTOM);
                  _loc3_ = true;
               }
               else
               {
                  this.ItemCardContainer_mc.ItemCard_mc.Count = this.selectedListEntry.count;
                  _loc4_.push(param1[_loc5_]);
               }
               _loc5_++;
            }
            this.ItemCardContainer_mc.ItemCard_mc.showValueEntry = this.m_ShowPlayerValueEntry && param2 || this.selectedList != this.PlayerInventory_mc;
            this.ItemCardContainer_mc.ItemCard_mc.currencyType = this.currencyType;
            this.ItemCardContainer_mc.ItemCard_mc.InfoObj = _loc4_;
            this.ItemCardContainer_mc.ItemCard_mc.redrawUIComponent();
            this.ItemCardContainer_mc.Background_mc.visible = true;
            _loc6_ = this.ItemCardContainer_mc.ItemCard_mc.entryCount - 1;
            this.ItemCardContainer_mc.Background_mc.Box_mc.height = this.ITEM_CARD_START_HEIGHT + this.ITEM_CARD_ENTRY_HEIGHT * _loc6_;
            this.ItemCardContainer_mc.Background_mc.Box_mc.y = this.ITEM_CARD_START_Y - this.ITEM_CARD_ENTRY_HEIGHT * _loc6_;
            this.ItemCardContainer_mc.Background_mc.itemStatsLabel_tf.y = this.ITEM_CARD_LABEL_START_Y - (this.ITEM_CARD_ENTRY_HEIGHT - 1) * _loc6_;
            this.ItemCardContainer_mc.Background_mc.StatsLabelBG_mc.y = this.ITEM_CARD_LABEL_START_Y - (this.ITEM_CARD_ENTRY_HEIGHT - 1) * _loc6_;
            this.ItemCardContainer_mc.Background_mc.Description_mc.y = this.ITEM_CARD_DESCRIPTION_START_Y - this.ITEM_CARD_ENTRY_HEIGHT * _loc6_;
         }
         else
         {
            this.ItemCardContainer_mc.Background_mc.visible = false;
            this.ItemCardContainer_mc.ItemCard_mc.InfoObj = new Array();
            this.ItemCardContainer_mc.ItemCard_mc.redrawUIComponent();
         }
         this.ItemCardContainer_mc.Background_mc.Description_mc.visible = _loc3_;
      }
      
      private function onSelectedDataChanged(param1:Event) : *
      {
         if(this.selectedList != null)
         {
            if(this.selectedListEntry != null)
            {
               if(!this.selectedList.ItemList_mc.List_mc.filterer.EntryMatchesFilter(this.selectedListEntry) && this.modalActive)
               {
                  this.closeQuantityModal();
               }
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_ITEM_SELECTED,{
                  "serverHandleId":this.selectedListEntry.serverHandleId,
                  "isSelectionValid":true,
                  "fromContainer":this.selectedList == this.OfferInventory_mc,
                  "containerID":this.selectedListEntry.containerID
               }));
            }
            else
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_ITEM_SELECTED,{
                  "serverHandleId":0,
                  "isSelectionValid":false,
                  "fromContainer":false,
                  "containerID":uint.MAX_VALUE
               }));
            }
            this.updateButtonHints();
         }
      }
      
      private function onUserMovesListSelection(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_FOCUS_CHANGE);
         if(param1.target == this.PlayerInventory_mc.ItemList_mc.List_mc)
         {
            this.m_RefreshSelectionOption = REFRESH_SELECTION_NONE;
            this.lastScrollPosition_Player = this.PlayerInventory_mc.ItemList_mc.List_mc.scrollPosition;
         }
         else if(param1.target == this.OfferInventory_mc.ItemList_mc.List_mc)
         {
            this.m_RefreshSelectionOption = REFRESH_SELECTION_NONE;
            this.lastScrollPosition_Offer = this.OfferInventory_mc.ItemList_mc.List_mc.scrollPosition;
         }
         this.ClearStartingFocusPreference();
      }
      
      private function onPlayerInventoryDataUpdate(param1:FromClientDataEvent) : void
      {
         if(!this.modalActive)
         {
            this.disableInput = false;
         }
         this.updateSelfInventory();
         this.updateInventoryFocus();
         if(this.selectedList == this.PlayerInventory_mc && this.PlayerInventory_mc.ItemList_mc.List_mc.hasBeenUpdated)
         {
            this.PlayerInventory_mc.selectedItemIndex = this.m_PlayerInventoryEmpty ? -1 : this.PlayerInventory_mc.ItemList_mc.List_mc.filterer.ClampIndex(this.PlayerInventory_mc.selectedItemIndex);
         }
      }
      
      private function onOtherInvTypeDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(this.m_MenuMode != _loc2_.menuType)
         {
            this.menuMode = _loc2_.menuType;
         }
         if(this.m_SubMenuMode != _loc2_.menuSubType)
         {
            this.subMenuMode = _loc2_.menuSubType;
         }
         this.OfferInventory_mc.showCurrency = _loc2_.menuType == MODE_NPCVENDING && _loc2_.menuSubType != SecureTradeShared.SUB_MODE_LEGENDARY_VENDOR;
         if(_loc2_.currencyType != null && _loc2_.currencyType != this.currencyType)
         {
            this.currencyType = _loc2_.currencyType;
         }
         this.m_ShowPlayerValueEntry = this.m_MenuMode != MODE_NPCVENDING || this.currencyType == SecureTradeShared.CURRENCY_CAPS || this.currencyType == SecureTradeShared.CURRENCY_LEGENDARY_TOKENS;
         this.m_DefaultHeaderText = _loc2_.defaultHeaderText == undefined ? "$CONTAINER" : _loc2_.defaultHeaderText.toUpperCase();
         this.m_VendorSellOnly = _loc2_.sellOnly;
         this.m_PlayerConnected = _loc2_.playerConnected;
         this.m_OwnsVendor = _loc2_.ownsVendor;
         OfferListEntry.ownsVendor = this.m_OwnsVendor;
         this.OfferInventory_mc.ownsVendor = this.m_OwnsVendor;
         if(this.m_MenuMode == MODE_PLAYERVENDING)
         {
            if(this.m_PlayerConnected)
            {
               if(!this.m_ShowOffersOnly)
               {
                  this.UpdatePartialItems(this.m_OtherInvData,this.m_TheirOffersData);
                  this.PopulateOfferInventory(this.m_OtherInvData);
               }
               else
               {
                  this.InsertRequestedItems(this.m_TheirOffersData,this.m_OtherInvData);
                  this.PopulateOfferInventory(this.m_TheirOffersData);
               }
            }
            else
            {
               this.OfferInventory_mc.ItemList_mc.List_mc.MenuListData = null;
               this.OfferInventory_mc.ItemList_mc.SetIsDirty();
            }
         }
         else if(this.isCampVendingMenuType())
         {
            this.PopulateCampVendingInventory();
         }
         this.OfferInventory_mc.currency = _loc2_.currencyAmount;
         this.OfferInventory_mc.carryWeightCurrent = _loc2_.currWeight;
         this.OfferInventory_mc.carryWeightMax = _loc2_.maxWeight;
         this.updateHeaders();
         if(!this.modalActive)
         {
            this.disableInput = false;
         }
      }
      
      private function onInventoryItemCardDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_.serverHandleId != 0)
         {
            this.UpdateItemCard(_loc2_.itemCardEntries,_loc2_.hasPlayerSellValue);
         }
         else
         {
            this.ItemCardContainer_mc.Background_mc.Description_mc.Description_tf.text = "";
         }
      }
      
      private function updateSelfInventory() : void
      {
         var _loc1_:Object = BSUIDataManager.GetDataFromClient("PlayerInventoryData").data;
         if(_loc1_.InventoryList != null)
         {
            this.m_PlayerInvData = this.m_isWorkbench ? this.CreateScrappableInventoryList(_loc1_.InventoryList) : _loc1_.InventoryList.concat();
            this.m_PlayerInventorySortField = _loc1_.SortField;
         }
         if(!this.m_ShowOffersOnly)
         {
            this.UpdatePartialItems(this.m_PlayerInvData,this.m_MyOffersData);
            this.PopulatePlayerInventory(this.m_PlayerInvData);
         }
         else
         {
            this.InsertRequestedItems(this.m_MyOffersData,this.m_PlayerInvData);
            this.PopulatePlayerInventory(this.m_MyOffersData);
         }
      }
      
      private function onOtherInvDataUpdate(param1:FromClientDataEvent) : void
      {
         this.m_OfferInventorySortField = param1.data.SortField;
         if(Boolean(param1.data.CorpseInventories) && param1.data.CorpseInventories.length > 0)
         {
            this.m_CorpseLootMode = true;
            this.CategoryBar_mc.CorpseLootMode = true;
            this.CategoryBar_mc.labelWidthScale = this.CORPSE_LOOT_CATEGORY_BAR_SCALE;
            this.updateCorpseInventoryLists(param1.data.CorpseInventories);
         }
         else
         {
            this.m_CorpseLootMode = false;
            this.CategoryBar_mc.CorpseLootMode = false;
            this.CategoryBar_mc.labelWidthScale = this.DEFAULT_CATEGORY_BAR_SCALE;
            this.m_OtherInvData = param1.data.InventoryList.concat();
            this.updateOtherInventory();
         }
         if(!this.modalActive)
         {
            this.disableInput = false;
         }
      }
      
      private function updateOtherInventory() : void
      {
         if(!(this.m_MenuMode == MODE_PLAYERVENDING && this.m_PlayerConnected == false))
         {
            if(this.isCampVendingMenuType())
            {
               this.PopulateCampVendingInventory();
            }
            else if(!this.m_ShowOffersOnly)
            {
               this.UpdatePartialItems(this.m_OtherInvData,this.m_TheirOffersData);
               this.PopulateOfferInventory(this.m_OtherInvData);
            }
            else
            {
               this.InsertRequestedItems(this.m_TheirOffersData,this.m_OtherInvData);
               this.PopulateOfferInventory(this.m_TheirOffersData);
            }
         }
         if(!this.modalActive)
         {
            this.disableInput = false;
         }
      }
      
      private function updateCorpseInventoryLists(param1:Object) : void
      {
         this.m_HasNewTab = false;
         this.m_ContainerIDs.splice(0);
         this.m_ItemFilters.splice(0);
         this.CategoryBar_mc.Clear();
         this.m_OtherInvData.splice(0);
         this.CategoryBar_mc.AddLabel("$ALLCORPSES",0,true);
         this.m_ItemFilters.push({
            "text":"$ALLCORPSES",
            "flag":FILTER_ALL
         });
         var _loc2_:Array = param1.concat().sort(this.sortCorpsesByDistance);
         var _loc3_:uint = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            this.m_ContainerIDs.push(_loc2_[_loc4_].containerID);
            this.m_OtherInvData = this.m_OtherInvData.concat(_loc2_[_loc4_].inventory);
            this.m_ItemFilters.push({
               "text":_loc2_[_loc4_].name,
               "flag":_loc2_[_loc4_].inventoryCategory
            });
            _loc3_++;
            this.CategoryBar_mc.AddLabel(_loc2_[_loc4_].name.toUpperCase(),_loc3_,true);
            _loc4_++;
         }
         var _loc5_:int = this.OfferInventory_mc.ItemList_mc.List_mc.selectedIndex;
         this.m_TabMax = this.m_ItemFilters.length;
         var _loc6_:uint = uint(_loc2_.length + 1);
         this.CategoryBar_mc.maxVisible = GlobalFunc.Clamp(_loc6_,1,5);
         this.CategoryBar_mc.Finalize();
         this.CategoryBar_mc.SetSelection(GlobalFunc.Clamp(this.selectedTab,0,this.m_ItemFilters.length - 1),true,false);
         this.m_SelectedTabForceChange = true;
         this.selectedTab = GlobalFunc.Clamp(this.m_SelectedTab,0,this.m_ItemFilters.length - 1);
         this.PopulateOfferInventory(this.m_OtherInvData);
         var _loc7_:int = int(this.OfferInventory_mc.ItemList_mc.List_mc.filterer.filterArray.length);
         if(_loc5_ < _loc7_)
         {
            this.OfferInventory_mc.ItemList_mc.List_mc.selectedIndex = _loc5_;
         }
         else
         {
            this.OfferInventory_mc.ItemList_mc.List_mc.selectedIndex = _loc7_ - 1;
         }
      }
      
      private function onMyOffersDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.m_MenuMode == MODE_PLAYERVENDING)
         {
            this.m_MyOffersData = param1.data.InventoryList.concat();
            if(this.m_PlayerConnected)
            {
               if(this.m_ShowOffersOnly)
               {
                  this.InsertRequestedItems(this.m_MyOffersData,this.m_PlayerInvData);
                  this.PopulatePlayerInventory(this.m_MyOffersData);
               }
               else
               {
                  this.UpdatePartialItems(this.m_PlayerInvData,this.m_MyOffersData);
                  this.PopulatePlayerInventory(this.m_PlayerInvData);
               }
            }
         }
      }
      
      private function onTheirOffersDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.m_MenuMode == MODE_PLAYERVENDING)
         {
            this.m_TheirOffersData = param1.data.InventoryList.concat();
            if(this.m_PlayerConnected)
            {
               if(this.m_ShowOffersOnly)
               {
                  this.InsertRequestedItems(this.m_TheirOffersData,this.m_OtherInvData);
                  this.PopulateOfferInventory(this.m_TheirOffersData);
               }
               else
               {
                  this.UpdatePartialItems(this.m_OtherInvData,this.m_TheirOffersData);
                  this.PopulateOfferInventory(this.m_OtherInvData);
               }
            }
         }
      }
      
      private function sortCorpsesByDistance(param1:Object, param2:Object) : int
      {
         var _loc3_:int = 0;
         if(param1.distance < param2.distance)
         {
            _loc3_ = -1;
         }
         else if(param1.distance > param2.distance)
         {
            _loc3_ = 1;
         }
         return _loc3_;
      }
      
      private function doContainerToPlayerTransfer() : *
      {
         var _loc1_:Object = this.selectedListEntry;
         var _loc2_:* = this.selectedList == this.OfferInventory_mc;
         var _loc3_:Boolean = bNuclearWinterMode ? false : Boolean(_loc1_.isWeightless);
         if(this.selectedList.ItemList_mc.List_mc.filterer.EntryMatchesFilter(_loc1_))
         {
            if(_loc1_.isCurrency)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
                  "serverHandleId":_loc1_.serverHandleId,
                  "quantity":_loc1_.count,
                  "fromContainer":_loc2_,
                  "containerID":_loc1_.containerID
               }));
               GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
            }
            else if(!_loc1_.singleItemTransfer && _loc1_.count > this.TRANSFER_ITEM_COUNT_THRESHOLD && !_loc3_)
            {
               if(this.m_CorpseLootMode)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
                     "serverHandleId":_loc1_.serverHandleId,
                     "quantity":_loc1_.count,
                     "fromContainer":_loc2_,
                     "containerID":_loc1_.containerID
                  }));
               }
               else
               {
                  this.openQuantityModal(this.qConfirm_TransferItem);
               }
            }
            else if(_loc2_ || this.performContainerWeightCheck(_loc1_,1))
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
                  "serverHandleId":_loc1_.serverHandleId,
                  "quantity":1,
                  "fromContainer":_loc2_,
                  "containerID":_loc1_.containerID
               }));
               GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
            }
         }
      }
      
      private function performContainerWeightCheck(param1:Object, param2:uint) : Boolean
      {
         var _loc3_:Boolean = Boolean(param1.isWeightless) || this.OfferInventory_mc.carryWeightMax <= 0 || this.OfferInventory_mc.carryWeightCurrent + param1.weight * param2 <= this.OfferInventory_mc.carryWeightMax;
         if(!_loc3_)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_TOO_HEAVY_ERROR,{}));
         }
         return _loc3_;
      }
      
      private function onItemPress(param1:Event) : *
      {
         var event:Event = param1;
         var _selectedEntry:Object = this.selectedListEntry;
         this.ClearStartingFocusPreference();
         if(this.isOpen && this.AcceptButton.ButtonDisabled != true && this.AcceptButton.ButtonVisible)
         {
            switch(this.m_MenuMode)
            {
               case MODE_PLAYERVENDING:
                  if(!this.m_IgnorePlayerVendingItemPress)
                  {
                     if(this.m_SelectedList == this.OfferInventory_mc)
                     {
                        if(_selectedEntry.isOffered == true)
                        {
                           this.SetSelectedItemValues(_selectedEntry);
                           this.ModalSetQuantity_mc.ShowMaxQuantityButton(true);
                           this.openQuantityModal(this.openConfirmPurchaseModal);
                        }
                        else if(_selectedEntry.isRequested)
                        {
                           this.onCancelRequestItem();
                        }
                        else
                        {
                           this.onRequestItem();
                        }
                     }
                     else if(this.m_ProcessingItemEvent == false)
                     {
                        this.SetSelectedItemValues(_selectedEntry);
                        this.openQuantityModal(this.openSetPriceModal,this.spConfirm_CreatePlayerVendingOffer);
                     }
                  }
                  break;
               case MODE_NPCVENDING:
                  if(this.isItemProtected(_selectedEntry))
                  {
                     break;
                  }
                  this.SetSelectedItemValues(_selectedEntry);
                  this.ModalSetQuantity_mc.ShowMaxQuantityButton(true);
                  this.openQuantityModal(this.openConfirmPurchaseModal);
                  break;
               case MODE_CONTAINER:
                  if(this.isScrapStash && Boolean(_selectedEntry.scrapAllowed))
                  {
                     if(this.isItemProtected(_selectedEntry))
                     {
                        break;
                     }
                     if(_selectedEntry.count > this.SCRAP_ITEM_COUNT_THRESHOLD)
                     {
                        this.openQuantityModal(function():*
                        {
                           ShowScrapConfirmModal(false,ModalSetQuantity_mc.quantity,true);
                        });
                     }
                     else
                     {
                        this.ShowScrapConfirmModal(false,1,true);
                     }
                  }
                  else
                  {
                     if(!this.m_isStash && !this.isAmmoStash && this.isItemProtected(_selectedEntry))
                     {
                        break;
                     }
                     this.doContainerToPlayerTransfer();
                  }
                  break;
               case MODE_ALLY:
               case MODE_DISPLAY_CASE:
               case MODE_PET:
                  if(!this.m_ProcessingItemEvent && this.m_OwnsVendor)
                  {
                     if(this.m_SelectedList == this.OfferInventory_mc)
                     {
                        if(_selectedEntry.isOffered == true)
                        {
                           BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
                              "serverHandleId":this.selectedListEntry.serverHandleId,
                              "quantity":1,
                              "fromContainer":true,
                              "containerID":_selectedEntry.containerID
                           }));
                           GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                        }
                        else
                        {
                           this.doContainerToPlayerTransfer();
                        }
                     }
                     else if(this.performContainerWeightCheck(_selectedEntry,1))
                     {
                        if(!this.SlotInfo_mc.visible || this.SlotInfo_mc.AreSlotsFull())
                        {
                           GlobalFunc.ShowHUDMessage("$SecureTrade_AssignFail_MovingToStash");
                           this.doContainerToPlayerTransfer();
                        }
                        else
                        {
                           BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_DISPLAY_DECORATE_ITEM_IN_SLOT,{
                              "serverHandleId":this.selectedListEntry.serverHandleId,
                              "fromContainer":false
                           }));
                           GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                           this.DelayForItemProcessing();
                        }
                     }
                  }
                  break;
               case MODE_CAMP_DISPENSER:
               case MODE_FERMENTER:
               case MODE_REFRIGERATOR:
               case MODE_FREEZER:
               case MODE_RECHARGER:
                  if(!this.m_ProcessingItemEvent && this.m_OwnsVendor)
                  {
                     if(this.m_SelectedList == this.OfferInventory_mc)
                     {
                        if(_selectedEntry.isOffered == true)
                        {
                           BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
                              "serverHandleId":this.selectedListEntry.serverHandleId,
                              "quantity":1,
                              "fromContainer":true,
                              "containerID":_selectedEntry.containerID
                           }));
                           GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                        }
                        else
                        {
                           this.doContainerToPlayerTransfer();
                        }
                     }
                     else if(this.performContainerWeightCheck(_selectedEntry,1))
                     {
                        if(!this.SlotInfo_mc.visible || this.SlotInfo_mc.AreSlotsFull() || this.m_MenuMode == MODE_FERMENTER && _selectedEntry.currentHealth == -1)
                        {
                           GlobalFunc.ShowHUDMessage("$SecureTrade_AssignFail_MovingToStash");
                           this.doContainerToPlayerTransfer();
                        }
                        else
                        {
                           BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_DISPLAY_ITEM,{
                              "serverHandleId":this.selectedListEntry.serverHandleId,
                              "fromContainer":false
                           }));
                           this.DelayForItemProcessing();
                        }
                        GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                     }
                  }
                  break;
               case MODE_VENDING_MACHINE:
                  if(this.m_ProcessingItemEvent)
                  {
                     break;
                  }
                  this.ModalSetQuantity_mc.ShowMaxQuantityButton(true);
                  if(this.m_OwnsVendor)
                  {
                     if(this.m_SelectedList == this.OfferInventory_mc)
                     {
                        if(_selectedEntry.vendingData.machineType != SecureTradeShared.MACHINE_TYPE_INVALID)
                        {
                           this.openQuantityModal(this.qConfirm_TakePartialFromVendingOffer);
                        }
                        else
                        {
                           this.doContainerToPlayerTransfer();
                        }
                     }
                     else if(!this.SlotInfo_mc.visible || this.SlotInfo_mc.AreSlotsFull())
                     {
                        GlobalFunc.ShowHUDMessage("$SecureTrade_AssignFail_MovingToStash");
                        this.doContainerToPlayerTransfer();
                     }
                     else
                     {
                        this.SetSelectedItemValues(this.selectedListEntry);
                        this.openQuantityModal(this.openSetPriceModal_CheckWeight,this.spConfirm_CreateCampVendingOffer);
                     }
                  }
                  else if(this.m_SelectedList == this.OfferInventory_mc)
                  {
                     this.SetSelectedItemValues(_selectedEntry);
                     this.openQuantityModal(this.openConfirmPurchaseModal);
                  }
                  break;
            }
         }
         else if(this.isOpen && this.ScrapButton.ButtonDisabled != true && this.ScrapButton.ButtonVisible)
         {
            if(this.isItemProtected(_selectedEntry))
            {
               return;
            }
            switch(this.m_MenuMode)
            {
               case MODE_CONTAINER:
                  if(_selectedEntry.count > this.SCRAP_ITEM_COUNT_THRESHOLD)
                  {
                     this.openQuantityModal(function():*
                     {
                        ShowScrapConfirmModal(false,ModalSetQuantity_mc.quantity);
                     });
                     break;
                  }
                  this.ShowScrapConfirmModal(false,1);
                  break;
            }
         }
      }
      
      private function onDeclineItem() : void
      {
         if(this.selectedList == this.OfferInventory_mc)
         {
            this.SetSelectedItemValues(this.selectedListEntry);
            this.openDeclineItemModal();
         }
      }
      
      private function onToggleAssign() : void
      {
         var _loc2_:* = false;
         var _loc1_:Object = this.selectedListEntry;
         this.ClearSelectedItemValues();
         this.ClearStartingFocusPreference();
         if(_loc1_.vendingData.machineType != SecureTradeShared.MACHINE_TYPE_INVALID)
         {
            switch(_loc1_.vendingData.machineType)
            {
               case SecureTradeShared.MACHINE_TYPE_VENDING:
               case SecureTradeShared.MACHINE_TYPE_DISPENSER:
               case SecureTradeShared.MACHINE_TYPE_FERMENTER:
               case SecureTradeShared.MACHINE_TYPE_REFRIGERATOR:
               case SecureTradeShared.MACHINE_TYPE_FREEZER:
               case SecureTradeShared.MACHINE_TYPE_RECHARGER:
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_REMOVE_ITEM,{
                     "serverHandleId":_loc1_.serverHandleId,
                     "quantity":_loc1_.count
                  }));
                  GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                  this.DelayForItemProcessing();
                  break;
               case SecureTradeShared.MACHINE_TYPE_DISPLAY:
               case SecureTradeShared.MACHINE_TYPE_ALLY:
               case SecureTradeShared.MACHINE_TYPE_PET:
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_REMOVE_DECORATE_ITEM_IN_SLOT,{"serverHandleId":_loc1_.serverHandleId}));
                  GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                  this.DelayForItemProcessing();
            }
         }
         else if(this.isCampVendingMenuType() && !this.SlotInfo_mc.isSlotDataValid())
         {
            GlobalFunc.ShowHUDMessage("$SecureTrade_AssignFail_InvalidData");
         }
         else if(this.isCampVendingMenuType() && this.SlotInfo_mc.AreSlotsFull())
         {
            GlobalFunc.ShowHUDMessage("$SecureTrade_AssignFail_SlotsFull");
         }
         else
         {
            switch(this.m_MenuMode)
            {
               case MODE_VENDING_MACHINE:
                  this.SetSelectedItemValues(_loc1_);
                  this.openQuantityModal(this.openSetPriceModal,this.spConfirm_CreateCampVendingOffer);
                  break;
               case MODE_DISPLAY_CASE:
               case MODE_ALLY:
               case MODE_PET:
                  _loc2_ = this.m_SelectedList == this.OfferInventory_mc;
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_DISPLAY_DECORATE_ITEM_IN_SLOT,{
                     "serverHandleId":_loc1_.serverHandleId,
                     "fromContainer":_loc2_
                  }));
                  GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
                  this.DelayForItemProcessing();
                  if(_loc2_ && _loc1_.count > 1)
                  {
                     this.SetSelectedItemValues(_loc1_);
                     this.m_RefreshSelectionOption = REFRESH_SELECTION_NAME_COUNT;
                  }
                  break;
               case MODE_CAMP_DISPENSER:
               case MODE_FERMENTER:
               case MODE_REFRIGERATOR:
               case MODE_FREEZER:
               case MODE_RECHARGER:
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_DISPLAY_ITEM,{
                     "serverHandleId":_loc1_.serverHandleId,
                     "fromContainer":true
                  }));
                  this.DelayForItemProcessing();
                  if(_loc1_.count > 1)
                  {
                     this.SetSelectedItemValues(_loc1_);
                     this.m_RefreshSelectionOption = REFRESH_SELECTION_NAME_COUNT;
                  }
            }
         }
      }
      
      private function onOffersOnly() : void
      {
         if(this.m_PlayerConnected)
         {
            this.m_ShowOffersOnly = !this.m_ShowOffersOnly;
            if(this.m_ShowOffersOnly)
            {
               this.InsertRequestedItems(this.m_TheirOffersData,this.m_OtherInvData);
               this.InsertRequestedItems(this.m_MyOffersData,this.m_PlayerInvData);
            }
            this.PopulateOfferInventory(this.m_ShowOffersOnly ? this.m_TheirOffersData : this.m_OtherInvData);
            this.PopulatePlayerInventory(this.m_ShowOffersOnly ? this.m_MyOffersData : this.m_PlayerInvData);
         }
      }
      
      private function onRequestItem() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_REQUEST_ITEM,{"serverHandleId":this.selectedListEntry.serverHandleId}));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function onCancelRequestItem() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CANCEL_REQUEST_ITEM,{"serverHandleId":this.selectedListEntry.serverHandleId}));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function onInspectItem() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_INSPECT_ITEM,{
            "serverHandleId":this.selectedListEntry.serverHandleId,
            "fromContainer":this.selectedList == this.OfferInventory_mc,
            "containerID":this.selectedListEntry.containerID
         }));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function onScrapButton() : void
      {
         this.ShowScrapConfirmModal(false,1);
      }
      
      private function onTakeAll() : void
      {
         var _loc1_:uint = 0;
         if(!this.hideTakeAllConfirm && this.OfferInventory_mc.ItemList_mc.List_mc.itemsShown > 11)
         {
            this.openConfirmTakeAllModal();
         }
         else
         {
            _loc1_ = uint.MAX_VALUE;
            if(this.m_CorpseLootMode)
            {
               _loc1_ = this.m_SelectedTab == 0 ? 0 : uint(this.m_ContainerIDs[this.m_SelectedTab - 1]);
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TAKE_ALL,{"containerID":_loc1_}));
         }
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function ShowScrapConfirmModal(param1:Boolean, param2:uint = 0, param3:Boolean = false) : void
      {
         this.m_PreviousFocus = stage.focus;
         if(param1)
         {
            if(param3)
            {
               this.ModalConfirmScrap_mc.ShowScrapboxTransferModal();
            }
            else
            {
               this.ModalConfirmScrap_mc.ShowScrapAllModal();
            }
         }
         else if(param3)
         {
            this.ModalConfirmScrap_mc.ShowScrapboxScrapTransferSelectionModal(this.selectedListEntry,param2);
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("Workbench::PrepScrapPrompt",{
               "serverHandleId":this.selectedListEntry.serverHandleId,
               "quantity":param2
            }));
         }
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = true;
      }
      
      private function OnSecureTradeScrapConfirmModalClosed(param1:CustomEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.params.accepted);
         var _loc3_:Boolean = Boolean(param1.params.favorite);
         var _loc4_:Boolean = Boolean(param1.params.isLegendary);
         var _loc5_:Boolean = Boolean(param1.params.isPremium);
         stage.focus = this.m_PreviousFocus;
         this.m_PreviousFocus = null;
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = !this.isScrapStash && _loc2_ && !_loc3_ && !_loc4_ && !_loc5_;
      }
      
      private function onStoreUnusedItems() : void
      {
         if(this.isScrapStash)
         {
            this.ShowScrapConfirmModal(true,0,true);
         }
         else if(this.m_isWorkbench)
         {
            this.ShowScrapConfirmModal(true);
         }
         else if(this.isAmmoStash)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_UNUSED_AMMO,{}));
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_STORE_ALL_JUNK,{}));
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
         }
      }
      
      public function set disableInput(param1:Boolean) : *
      {
         this.PlayerInventory_mc.ItemList_mc.List_mc.disableInput_Inspectable = param1;
         this.PlayerInventory_mc.ItemList_mc.List_mc.disableSelection_Inspectable = param1;
         this.OfferInventory_mc.ItemList_mc.List_mc.disableInput_Inspectable = param1;
         this.OfferInventory_mc.ItemList_mc.List_mc.disableSelection_Inspectable = param1;
         this.ItemCardContainer_mc.visible = true;
      }
      
      public function onQuantityAccepted() : *
      {
         dispatchEvent(new Event(QuantityMenu.CONFIRM,true,true));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      public function onPriceAccepted() : *
      {
         dispatchEvent(new Event(QuantityMenu.CONFIRM,true,true));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function openDeclineItemModal() : void
      {
         this.ModalDeclineItem_mc.Active = true;
         this.m_PreviousFocus = stage.focus;
         stage.focus = this.ModalDeclineItem_mc;
         this.ModalDeclineItem_mc.ItemServerHandleId = this.selectedListEntry.serverHandleId;
         this.updateModalActive();
         this.updateButtonHints();
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_DECLINE_ITEM_OPEN,{}));
         this.disableInput = true;
      }
      
      private function closeDeclineItemModal() : void
      {
         if(this.m_PreviousFocus != null)
         {
            stage.focus = this.m_PreviousFocus;
         }
         this.ModalDeclineItem_mc.Active = false;
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = false;
      }
      
      private function openConfirmPurchaseModal() : void
      {
         var _loc5_:Number = NaN;
         this.m_PreviousFocus = stage.focus;
         var _loc1_:* = this.selectedList == this.OfferInventory_mc;
         if(_loc1_)
         {
            this.ModalConfirmPurchase_mc.header = "$CONFIRMPURCHASE";
         }
         else
         {
            this.ModalConfirmPurchase_mc.header = "$CONFIRMSALE";
         }
         var _loc2_:Number = Math.min(this.selectedListEntry.count,this.ModalSetQuantity_mc.quantity);
         var _loc3_:Number = !!this.selectedListEntry.isOffered ? Number(this.selectedListEntry.offerValue) : Number(this.selectedListEntry.itemValue);
         this.ModalConfirmPurchase_mc.value = (_loc3_ * _loc2_).toString();
         var _loc4_:String = this.selectedListEntry.text;
         this.ModalConfirmPurchase_mc.tooltip = "";
         if(_loc2_ > 1)
         {
            _loc4_ += " (" + _loc2_ + ")";
         }
         if(!_loc1_ && this.PlayerInventory_mc.currency + _loc3_ * _loc2_ > this.PlayerInventory_mc.currencyMax)
         {
            this.ModalConfirmPurchase_mc.Tooltip_mc.textField.height = this.m_ToolTipDefaultHeight + HEIGHT_BUFFER;
            _loc5_ = this.PlayerInventory_mc.currencyMax - this.PlayerInventory_mc.currency;
            this.ModalConfirmPurchase_mc.tooltip = _loc5_ > 0 ? "$SecureTrade_MaxCurrencyWarningDifference" : "$SecureTrade_MaxCurrencyWarning";
            this.ModalConfirmPurchase_mc.tooltip = this.ModalConfirmPurchase_mc.tooltip.replace("{1}",_loc5_);
            this.ModalConfirmPurchase_mc.tooltip = this.ModalConfirmPurchase_mc.tooltip.replace("{2}",this.PlayerInventory_mc.currencyName);
            this.ModalConfirmPurchase_mc.tooltip += "\n\n";
         }
         this.ModalConfirmPurchase_mc.tooltip += _loc4_;
         stage.focus = this.ModalConfirmPurchase_mc;
         this.ModalConfirmPurchase_mc.open = true;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = true;
      }
      
      private function closeConfirmPurchaseModal(param1:Boolean = false) : void
      {
         if(this.m_PreviousFocus != null)
         {
            stage.focus = this.m_PreviousFocus;
         }
         this.ModalConfirmPurchase_mc.open = false;
         this.ModalConfirmPurchase_mc.Tooltip_mc.textField.height = this.m_ToolTipDefaultHeight;
         this.m_PreviousFocus = null;
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = param1;
      }
      
      private function openConfirmTakeAllModal() : void
      {
         this.m_PreviousFocus = stage.focus;
         this.ModalConfirmTakeAll_mc.header = "$Container_ConfirmTakeAll";
         stage.focus = this.ModalConfirmTakeAll_mc;
         this.ModalConfirmTakeAll_mc.open = true;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = true;
      }
      
      private function closeConfirmTakeAllModal() : void
      {
         if(this.m_PreviousFocus != null)
         {
            stage.focus = this.m_PreviousFocus;
         }
         this.ModalConfirmTakeAll_mc.open = false;
         this.m_PreviousFocus = null;
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = false;
      }
      
      private function openSetPriceModal() : void
      {
         this.ModalSetPrice_mc.tooltip = "$ItemWillBeAvailableForImmediatePurchase";
         var _loc1_:Number = Math.min(this.selectedListEntry.count,this.ModalSetQuantity_mc.quantity);
         var _loc2_:String = _loc1_ > 1 ? "$SETPRICEPERITEM" : "$SETITEMPRICE";
         this.ModalSetPrice_mc.OpenMenuRange(stage.focus,_loc2_,0,MAX_SELL_PRICE,this.defaultVendorItemPrice > -1 ? this.defaultVendorItemPrice : this.selectedListEntry.itemValue,0,true);
         stage.focus = this.ModalSetPrice_mc;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = true;
      }
      
      private function openSetPriceModal_CheckWeight() : void
      {
         var _loc1_:* = this.selectedList == this.OfferInventory_mc;
         var _loc2_:Number = Math.min(this.selectedListEntry.count,this.ModalSetQuantity_mc.quantity);
         if(_loc1_ || this.performContainerWeightCheck(this.selectedListEntry,_loc2_))
         {
            this.openSetPriceModal();
         }
      }
      
      private function closeSetPriceModal() : void
      {
         stage.focus = this.ModalSetPrice_mc.prevFocus;
         this.ModalSetPrice_mc.CloseMenu(true);
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = false;
      }
      
      private function calcMaxQuantity(param1:Boolean = false) : uint
      {
         var i:int = 0;
         var itemValue:Number = Number(this.ItemCardContainer_mc.ItemCard_mc.getChildAt(0).Value_tf.text);
         var offerCurrency:Number = this.OfferInventory_mc.currency;
         var playerCurrency:Number = this.PlayerInventory_mc.currency;
         var currency:Number = this.selectedList == this.PlayerInventory_mc ? offerCurrency : playerCurrency;
         var maxQuantity:Number = !!this.selectedListEntry ? Number(this.selectedListEntry.count) : 1;
         if(param1)
         {
            if(!this.m_OwnsVendor && this.m_MenuMode == MODE_PLAYERVENDING && Boolean(this.selectedListEntry.isOffered))
            {
               maxQuantity = Math.min(this.selectedListEntry.count,Math.floor(currency / this.selectedListEntry.offerValue));
            }
            else if(!this.m_OwnsVendor && (this.m_MenuMode == MODE_NPCVENDING || this.m_MenuMode == MODE_VENDING_MACHINE))
            {
               if(isNaN(itemValue))
               {
                  itemValue = 1;
                  i = 0;
                  while(i < this.ItemCardContainer_mc.ItemCard_mc.InfoObj.length)
                  {
                     if(this.ItemCardContainer_mc.ItemCard_mc.InfoObj[i].text == "$val")
                     {
                        itemValue = Number(this.ItemCardContainer_mc.ItemCard_mc.InfoObj[i].value);
                        break;
                     }
                     i++;
                  }
               }
               maxQuantity = Math.min(this.selectedListEntry.count,Math.floor(currency / itemValue));
               if(this.selectedList == this.PlayerInventory_mc && this.isMaxCurrencyProtection())
               {
                  return Math.min(Math.floor((this.PlayerInventory_mc.currencyMax - playerCurrency) / itemValue),maxQuantity);
               }
            }
         }
         if(maxQuantity < 1)
         {
            maxQuantity = 1;
         }
         return maxQuantity;
      }
      
      private function openQuantityModal(param1:Function, param2:Function = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc3_:int = int(this.selectedListEntry.count);
         this._OnQuantityConfirmedFn = param1;
         this._OnSetPriceConfirmedFn = param2;
         if(_loc3_ == 1)
         {
            this.ModalSetQuantity_mc.quantity = 1;
            param1();
         }
         else
         {
            this.ModalSetQuantity_mc.tooltip = "";
            _loc4_ = this.calcMaxQuantity();
            _loc5_ = this.calcMaxQuantity(this._OnSetPriceConfirmedFn == null);
            this.ModalSetQuantity_mc.OpenMenuRange(stage.focus,"$SETQUANTITY",1,_loc4_,_loc5_,0);
            stage.focus = this.ModalSetQuantity_mc;
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
            this.updateModalActive();
            this.updateButtonHints();
            this.disableInput = true;
         }
      }
      
      private function closeQuantityModal() : void
      {
         stage.focus = this.ModalSetQuantity_mc.prevFocus;
         this.ModalSetQuantity_mc.CloseMenu();
         this.ModalSetQuantity_mc.ShowMaxQuantityButton(false);
         this.updateModalActive();
         this.updateButtonHints();
         this.disableInput = false;
      }
      
      private function updateCategoryBar() : void
      {
         var _loc1_:Boolean = false;
         this.m_HasNewTab = false;
         if(!this.m_CorpseLootMode)
         {
            this.m_ItemFilters.splice(0);
            this.m_IsFilteredCategory = true;
            _loc1_ = this.m_MenuMode == MODE_FERMENTER || this.m_MenuMode == MODE_CAMP_DISPENSER || this.m_MenuMode == MODE_REFRIGERATOR || this.m_MenuMode == MODE_FREEZER;
            if(_loc1_)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryFoodWater",
                  "flag":FILTER_FOODWATER
               });
            }
            else if(this.isScrapStash)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryJunk",
                  "flag":FILTER_JUNK
               });
            }
            else if(this.isAmmoStash)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryAmmo",
                  "flag":FILTER_AMMO
               });
            }
            else if(this.m_MenuMode == MODE_ALLY || this.m_SubMenuMode == SecureTradeShared.SUB_MODE_ARMOR_RACK)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryArmor",
                  "flag":FILTER_ARMOR
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryApparel",
                  "flag":FILTER_APPAREL
               });
            }
            else if(this.m_MenuMode == MODE_PET)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryApparel",
                  "flag":FILTER_APPAREL
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_WEAPON_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryWeapons",
                  "flag":FILTER_WEAPONS
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_POWER_ARMOR_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryArmor",
                  "flag":FILTER_ARMOR
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_APPAREL_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryApparel",
                  "flag":FILTER_APPAREL
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_AID_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryAid",
                  "flag":FILTER_AID
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_BOOK_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryNotes",
                  "flag":FILTER_BOOKS
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_MISC_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryMisc",
                  "flag":FILTER_MISC
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_JUNK_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryJunk",
                  "flag":FILTER_JUNK
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_FOODWATER_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryFoodWater",
                  "flag":FILTER_FOODWATER
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_HOLO_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryHolo",
                  "flag":FILTER_HOLOTAPES
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_MODS_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryMods",
                  "flag":FILTER_MODS
               });
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_AMMO_DISPLAY)
            {
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryAmmo",
                  "flag":FILTER_AMMO
               });
            }
            else
            {
               this.m_IsFilteredCategory = false;
               if(this.m_MenuMode == MODE_NPCVENDING || this.m_MenuMode == MODE_CONTAINER)
               {
                  this.m_HasNewTab = true;
                  this.m_ItemFilters.push({
                     "text":"$InventoryCategoryNew",
                     "flag":FILTER_ALL
                  });
               }
               this.m_ItemFilters.push({
                  "text":"$INVENTORY",
                  "flag":FILTER_ALL
               });
               if(this.m_MenuMode != MODE_PLAYERVENDING)
               {
                  this.m_ItemFilters.push({
                     "text":"$InventoryCategoryFavorites",
                     "flag":FILTER_FAVORITES
                  });
               }
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryWeapons",
                  "flag":FILTER_WEAPONS
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryArmor",
                  "flag":FILTER_ARMOR
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryApparel",
                  "flag":FILTER_APPAREL
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryFoodWater",
                  "flag":FILTER_FOODWATER
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryAid",
                  "flag":FILTER_AID
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryMisc",
                  "flag":FILTER_MISC
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryHolo",
                  "flag":FILTER_HOLOTAPES
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryNotes",
                  "flag":FILTER_BOOKS
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryJunk",
                  "flag":FILTER_JUNK
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryMods",
                  "flag":FILTER_MODS
               });
               this.m_ItemFilters.push({
                  "text":"$InventoryCategoryAmmo",
                  "flag":FILTER_AMMO
               });
            }
            this.m_TabMax = this.m_ItemFilters.length;
            this.CategoryBar_mc.Clear();
            this.CategoryBar_mc.forceUppercase = false;
            if(_loc1_)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryFoodWater",FILTER_FOODWATER,true);
            }
            else if(this.isScrapStash)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryJunk",FILTER_JUNK,true);
            }
            else if(this.isAmmoStash)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryAmmo",FILTER_AMMO,true);
            }
            else if(this.m_MenuMode == MODE_ALLY || this.m_SubMenuMode == SecureTradeShared.SUB_MODE_ARMOR_RACK)
            {
               this.CategoryBar_mc.maxVisible = 2;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryArmor",FILTER_ARMOR,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryApparel",FILTER_APPAREL,true);
            }
            else if(this.m_MenuMode == MODE_PET)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryApparel",FILTER_APPAREL,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_WEAPON_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryWeapons",FILTER_WEAPONS,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_POWER_ARMOR_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryArmor",FILTER_ARMOR,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_APPAREL_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryApparel",FILTER_APPAREL,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_AID_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryAid",FILTER_AID,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_BOOK_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryNotes",FILTER_BOOKS,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_MISC_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryMisc",FILTER_MISC,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_JUNK_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryJunk",FILTER_JUNK,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_FOODWATER_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryFoodWater",FILTER_FOODWATER,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_HOLO_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryHolo",FILTER_HOLOTAPES,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_MODS_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryMods",FILTER_MODS,true);
            }
            else if(this.m_MenuMode == MODE_DISPLAY_CASE && this.m_SubMenuMode == SecureTradeShared.SUB_MODE_AMMO_DISPLAY)
            {
               this.CategoryBar_mc.maxVisible = 1;
               this.CategoryBar_mc.AddLabel("$InventoryCategoryAmmo",FILTER_AMMO,true);
            }
            else
            {
               this.CategoryBar_mc.maxVisible = maxtabs;
               if(this.m_MenuMode == MODE_NPCVENDING || this.m_MenuMode == MODE_CONTAINER)
               {
                  this.CategoryBar_mc.AddLabel("$InventoryCategoryNew",FILTER_NEW_ID,true);
               }
               this.CategoryBar_mc.AddLabel("$INVENTORY",FILTER_ALL,true);
               if(this.m_MenuMode != MODE_PLAYERVENDING)
               {
                  this.CategoryBar_mc.AddLabel("$InventoryCategoryFavorites",FILTER_FAVORITES,true);
               }
               this.CategoryBar_mc.AddLabel("$InventoryCategoryWeapons",FILTER_WEAPONS,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryArmor",FILTER_ARMOR,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryApparel",FILTER_APPAREL,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryFoodWater",FILTER_FOODWATER,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryAid",FILTER_AID,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryMisc",FILTER_MISC,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryHolo",FILTER_HOLOTAPES,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryNotes",FILTER_BOOKS,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryJunk",FILTER_JUNK,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryMods",FILTER_MODS,true);
               this.CategoryBar_mc.AddLabel("$InventoryCategoryAmmo",FILTER_AMMO,true);
            }
            this.CategoryBar_mc.Finalize();
            this.CategoryBar_mc.SetSelection(this.selectedTab,true,false);
            this.m_SelectedTabForceChange = true;
            this.selectedTab = this.m_SelectedTab;
         }
      }
      
      private function ModeToButtonSwitchText(param1:uint) : String
      {
         if(this.isScrapStash)
         {
            return "$LimitedTypeStorageOverrideName_Scrap";
         }
         if(this.isAmmoStash)
         {
            return "$LimitedTypeStorageOverrideName_Ammo";
         }
         switch(param1)
         {
            case MODE_CONTAINER:
               return "$CONTAINER";
            case MODE_NPCVENDING:
               return "$VENDOR";
            case MODE_PLAYERVENDING:
               return this.m_DefaultHeaderText;
            case MODE_VENDING_MACHINE:
               return "$VENDOR";
            case MODE_DISPLAY_CASE:
               return "$DISPLAY";
            case MODE_FERMENTER:
               return "$FERMENTER";
            case MODE_REFRIGERATOR:
               return "$REFRIGERATOR";
            case MODE_FREEZER:
               return "$FREEZER";
            case MODE_RECHARGER:
               return "$RECHARGER";
            case MODE_CAMP_DISPENSER:
               return "$DISPENSER";
            case MODE_ALLY:
               return "$ALLY";
            case MODE_PET:
               return "$PET";
            default:
               return "";
         }
      }
      
      private function UpdateButtonToggleAssignText(param1:Object) : void
      {
         this.ButtonToggleAssign.ButtonEnabled = true;
         switch(param1.vendingData.machineType)
         {
            case SecureTradeShared.MACHINE_TYPE_INVALID:
               this.ButtonToggleAssign.ButtonText = this.m_MenuMode == SecureTradeShared.MACHINE_TYPE_VENDING ? "$SELL" : "$SecureTrade_InsertItem";
               this.ButtonToggleAssign.ButtonEnabled = param1.vendingData.assignEnabled;
               break;
            case SecureTradeShared.MACHINE_TYPE_VENDING:
               this.ButtonToggleAssign.ButtonText = "$CANCEL SALE";
               break;
            case SecureTradeShared.MACHINE_TYPE_DISPLAY:
            case SecureTradeShared.MACHINE_TYPE_DISPENSER:
            case SecureTradeShared.MACHINE_TYPE_FERMENTER:
            case SecureTradeShared.MACHINE_TYPE_REFRIGERATOR:
            case SecureTradeShared.MACHINE_TYPE_RECHARGER:
            case SecureTradeShared.MACHINE_TYPE_FREEZER:
            case SecureTradeShared.MACHINE_TYPE_ALLY:
            case SecureTradeShared.MACHINE_TYPE_PET:
               this.ButtonToggleAssign.ButtonText = "$SecureTrade_RemoveDisplayedItem";
               this.ButtonToggleAssign.ButtonEnabled = param1.vendingData.unassignEnabled;
         }
         this.ButtonToggleAssign.ButtonVisible = !param1.vendingData.readOnly;
      }
      
      private function updateButtonHints() : void
      {
         var _loc1_:BSButtonHintData = null;
         var _loc2_:Object = null;
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         if(this.selectedList == null)
         {
            return;
         }
         this.DeclineItemAcceptButton.ButtonVisible = this.ModalDeclineItem_mc.Active;
         this.DeclineItemCancelButton.ButtonVisible = this.ModalDeclineItem_mc.Active;
         if(this.modalActive)
         {
            for each(_loc1_ in this.ButtonHintDataV)
            {
               if(_loc1_ != this.DeclineItemAcceptButton && _loc1_ != this.DeclineItemCancelButton)
               {
                  _loc1_.ButtonVisible = false;
               }
            }
         }
         else
         {
            _loc2_ = this.selectedListEntry;
            _loc3_ = this.selectedList == this.PlayerInventory_mc;
            _loc4_ = this.selectedList == this.OfferInventory_mc;
            _loc5_ = this.selectedList == null || _loc2_ == null;
            this.ButtonPlayerInventory.ButtonVisible = uiController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.OfferInventory_mc.Active && !this.m_onlyGivingAllowed && !this.m_onlyTakingAllowed && !this.m_isWorkbench && !this.m_PlayerInventoryEmpty;
            this.ButtonContainerInventory.ButtonVisible = uiController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.PlayerInventory_mc.Active && !this.m_onlyGivingAllowed && !this.m_onlyTakingAllowed && !this.m_isWorkbench && !this.m_ContainerEmpty;
            this.SortButton.ButtonVisible = true;
            this.SortButton.ButtonText = this.m_SortFieldText[!!_loc3_ ? this.m_PlayerInventorySortField : this.m_OfferInventorySortField];
            this.ExitButton.ButtonVisible = true;
            this.ShowHistoryButton.ButtonVisible = this.m_OwnsVendor && this.m_MenuMode !== MODE_PET;
            this.InspectButton.ButtonDisabled = this.selectedList == null || _loc2_ == null;
            this.ScrapButton.ButtonVisible = !_loc5_ && (this.m_isWorkbench || this.m_isWorkshop) && this.m_scrapAllowedFlag != 0;
            if(this.ScrapButton.ButtonVisible)
            {
               this.ScrapButton.ButtonDisabled = _loc2_.scrapAllowed != true || (_loc2_.filterFlag & this.m_scrapAllowedFlag) == 0 || this.isItemProtected(this.selectedListEntry,true);
            }
            this.StoreUnusedItemsButton.ButtonVisible = this.m_isWorkbench || this.m_isWorkshop || this.m_isStash || this.isLimitedStorage;
            if(this.StoreUnusedItemsButton.ButtonVisible)
            {
               if(this.isScrapStash)
               {
                  _loc6_ = false;
                  for each(_loc7_ in this.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData)
                  {
                     if(Boolean(_loc7_.isAutoScrappable) || Boolean(_loc7_.canGoIntoScrapStash))
                     {
                        _loc6_ = true;
                        break;
                     }
                  }
                  this.StoreUnusedItemsButton.ButtonDisabled = !this.m_IsFollowerOfZeus || !_loc6_;
                  this.StoreUnusedItemsButton.ButtonText = "$SCRAPBOXSCRAPANDSTORE";
               }
               else if(this.isAmmoStash)
               {
                  this.StoreUnusedItemsButton.ButtonDisabled = !this.m_IsFollowerOfZeus || !this.m_transferUnusedAmmoAllowed;
                  this.StoreUnusedItemsButton.ButtonText = "$TRANSFERUNUSED";
               }
               else
               {
                  this.StoreUnusedItemsButton.ButtonDisabled = this.m_isWorkbench ? !this.m_playerHasAutoScrappableJunkItems : !this.m_playerHasMiscItems;
                  this.StoreUnusedItemsButton.ButtonText = this.m_isWorkbench ? "$ScrapAllJunk" : "$StoreAllJunk";
               }
            }
            this.ToggleShowMarkedItemsOnlyButton.ButtonVisible = this.isCampVendingMenuType() && this.m_OwnsVendor;
            switch(this.m_FilterItemsOption)
            {
               case FILTER_OPTION_NONE:
                  this.ToggleShowMarkedItemsOnlyButton.ButtonText = "$SecureTrade_ToggleShowMarked_ShowMarkedOnly";
                  break;
               case FILTER_OPTION_THIS_MACHINE:
                  this.ToggleShowMarkedItemsOnlyButton.ButtonText = "$SecureTrade_ToggleShowMarked_ShowMarkedAndStash";
                  break;
               case FILTER_OPTION_THIS_MACHINE_AND_STASH:
                  this.ToggleShowMarkedItemsOnlyButton.ButtonText = "$SecureTrade_ToggleShowMarked_ShowAll";
            }
            this.AcceptButton.ButtonVisible = !this.m_isWorkbench && !_loc5_;
            switch(this.m_MenuMode)
            {
               case MODE_CONTAINER:
                  this.ButtonDecline.ButtonVisible = false;
                  this.ButtonToggleAssign.ButtonVisible = Boolean(_loc2_) && _loc4_ && _loc2_.vendingData.machineType != SecureTradeShared.MACHINE_TYPE_INVALID;
                  if(this.ButtonToggleAssign.ButtonVisible)
                  {
                     this.UpdateButtonToggleAssignText(_loc2_);
                  }
                  this.InspectButton.ButtonVisible = true;
                  if(this.AcceptButton.ButtonVisible)
                  {
                     this.AcceptButton.ButtonDisabled = !this.m_isStash && !this.isAmmoStash && this.isItemProtected(this.selectedListEntry,true);
                     if(_loc4_)
                     {
                        this.AcceptButton.ButtonText = this.m_AcceptBtnText_Container;
                     }
                     else if(this.isScrapStash && Boolean(_loc2_.scrapAllowed))
                     {
                        this.AcceptButton.ButtonText = "$SCRAP";
                     }
                     else
                     {
                        this.AcceptButton.ButtonText = this.m_AcceptBtnText_Player;
                     }
                  }
                  this.TakeAllButton.ButtonVisible = !this.m_isWorkbench && !this.m_isCamp && !this.m_isStash && !this.m_onlyGivingAllowed && !this.isLimitedStorage;
                  if(this.TakeAllButton.ButtonVisible)
                  {
                     this.TakeAllButton.ButtonText = this.m_TakeAllBtnText;
                  }
                  this.ButtonOffersOnly.ButtonVisible = false;
                  break;
               case MODE_NPCVENDING:
                  this.ButtonDecline.ButtonVisible = _loc4_ && _loc2_ != null && Boolean(_loc2_.isOffered);
                  this.ButtonToggleAssign.ButtonVisible = false;
                  this.InspectButton.ButtonVisible = true;
                  if(this.AcceptButton.ButtonVisible)
                  {
                     this.AcceptButton.ButtonDisabled = !_loc4_ && (this.m_VendorSellOnly || this.isItemProtected(this.selectedListEntry,true));
                     this.AcceptButton.ButtonText = !!_loc4_ ? "$BUY" : "$SELL";
                  }
                  this.TakeAllButton.ButtonVisible = false;
                  this.ButtonOffersOnly.ButtonVisible = false;
                  break;
               case MODE_PLAYERVENDING:
                  this.ButtonDecline.ButtonVisible = _loc4_ && _loc2_ != null && Boolean(_loc2_.isOffered);
                  this.ButtonToggleAssign.ButtonVisible = false;
                  this.InspectButton.ButtonVisible = true;
                  if(this.AcceptButton.ButtonVisible)
                  {
                     this.AcceptButton.ButtonDisabled = _loc4_ && _loc2_.isTradable == false;
                     if(_loc4_)
                     {
                        this.AcceptButton.ButtonText = !!_loc2_.isOffered ? "$BUY" : (!!_loc2_.isRequested ? "$CANCEL" : "$REQUEST");
                     }
                     else
                     {
                        this.AcceptButton.ButtonText = "$OFFER";
                     }
                  }
                  this.TakeAllButton.ButtonVisible = false;
                  this.ButtonOffersOnly.ButtonVisible = true;
                  this.ButtonOffersOnly.ButtonText = this.m_ShowOffersOnly ? "$SHOWALL" : "$OFFERSONLY";
                  this.ButtonOffersOnly.ButtonDisabled = !this.m_PlayerConnected;
                  break;
               case MODE_VENDING_MACHINE:
                  this.ButtonDecline.ButtonVisible = false;
                  this.ButtonToggleAssign.ButtonVisible = this.m_OwnsVendor && _loc2_ != null && _loc4_;
                  if(this.ButtonToggleAssign.ButtonVisible)
                  {
                     this.UpdateButtonToggleAssignText(_loc2_);
                  }
                  this.InspectButton.ButtonVisible = true;
                  if(_loc3_ && !this.m_OwnsVendor)
                  {
                     this.AcceptButton.ButtonVisible = false;
                  }
                  if(this.AcceptButton.ButtonVisible)
                  {
                     this.AcceptButton.ButtonDisabled = false;
                     if(this.m_OwnsVendor)
                     {
                        this.AcceptButton.ButtonText = !!_loc4_ ? this.m_AcceptBtnText_Container : "$SELL";
                     }
                     else
                     {
                        this.AcceptButton.ButtonText = "$BUY";
                     }
                  }
                  this.TakeAllButton.ButtonVisible = false;
                  this.ButtonOffersOnly.ButtonVisible = false;
                  break;
               case MODE_DISPLAY_CASE:
               case MODE_ALLY:
               case MODE_FERMENTER:
               case MODE_REFRIGERATOR:
               case MODE_FREEZER:
               case MODE_RECHARGER:
               case MODE_CAMP_DISPENSER:
               case MODE_PET:
                  this.ButtonDecline.ButtonVisible = false;
                  this.ButtonToggleAssign.ButtonVisible = this.m_OwnsVendor && _loc2_ != null && _loc4_;
                  if(this.ButtonToggleAssign.ButtonVisible)
                  {
                     this.ButtonToggleAssign.ButtonDisabled = this.m_ProcessingItemEvent;
                     this.UpdateButtonToggleAssignText(_loc2_);
                  }
                  this.InspectButton.ButtonVisible = true;
                  if(_loc3_ && !this.m_OwnsVendor)
                  {
                     this.AcceptButton.ButtonVisible = false;
                  }
                  if(this.AcceptButton.ButtonVisible)
                  {
                     this.AcceptButton.ButtonDisabled = this.m_ProcessingItemEvent;
                     this.AcceptButton.ButtonText = !!_loc4_ ? this.m_AcceptBtnText_Container : this.m_AcceptBtnText_Player_Assign;
                  }
                  this.TakeAllButton.ButtonVisible = false;
                  this.ButtonOffersOnly.ButtonVisible = false;
            }
            if(this.ButtonContainerInventory.ButtonVisible)
            {
               this.ButtonContainerInventory.ButtonText = this.ModeToButtonSwitchText(this.m_MenuMode);
            }
            this.updateModButtons();
         }
      }
      
      private function updateInventoryFocus() : void
      {
         if(this.m_onlyTakingAllowed)
         {
            if(this.selectedList != this.OfferInventory_mc)
            {
               this.onSwapInventoryContainer();
            }
         }
         else if(this.m_onlyGivingAllowed || this.m_isWorkbench)
         {
            if(this.selectedList != this.PlayerInventory_mc)
            {
               this.onSwapInventoryPlayer();
            }
         }
         else if(!this.m_PlayerInventoryEmpty && !this.m_ContainerEmpty && this.m_StartingFocusPref != STARTING_FOCUS_PREF_NONE)
         {
            if(this.m_StartingFocusPref == STARTING_FOCUS_PREF_PLAYER)
            {
               this.onSwapInventoryPlayer();
            }
            else if(this.m_StartingFocusPref == STARTING_FOCUS_PREF_CONTAINER)
            {
               this.onSwapInventoryContainer();
            }
            this.m_StartingFocusPref = STARTING_FOCUS_PREF_NONE;
         }
         else if(this.m_PlayerInventoryEmpty && !this.m_ContainerEmpty && this.selectedList == this.PlayerInventory_mc)
         {
            this.onSwapInventoryContainer();
         }
         else if(!this.m_CorpseLootMode && this.m_ContainerEmpty && !this.m_PlayerInventoryEmpty && this.selectedList == this.OfferInventory_mc)
         {
            this.onSwapInventoryPlayer();
         }
      }
      
      private function onBackButton() : void
      {
         this.ClearSelectedItemValues();
         var _loc1_:Boolean = true;
         if(this.ModalSetPrice_mc.opened)
         {
            if(this.ModalSetPrice_mc.inTextInputMode)
            {
               this.ModalSetPrice_mc.CancelTextInput();
            }
            else
            {
               this.closeSetPriceModal();
            }
         }
         else if(this.ModalSetQuantity_mc.opened)
         {
            if(this.ModalSetQuantity_mc.inTextInputMode)
            {
               this.ModalSetQuantity_mc.CancelTextInput();
            }
            else
            {
               this.closeQuantityModal();
            }
         }
         else if(this.ModalDeclineItem_mc.Active)
         {
            this.closeDeclineItemModal();
         }
         else if(this.ModalConfirmPurchase_mc.open)
         {
            this.closeConfirmPurchaseModal();
         }
         else if(this.ModalConfirmTakeAll_mc.open)
         {
            this.closeConfirmTakeAllModal();
         }
         else if(this.ModalConfirmScrap_mc.open)
         {
            this.ModalConfirmScrap_mc.HandleSecondaryAction();
            _loc1_ = false;
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_MENU_EXIT,{}));
         }
         if(_loc1_)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
         }
      }
      
      private function onSwapInventoryPlayer() : void
      {
         this.selectedList = this.PlayerInventory_mc as SecureTradeInventory;
         if(uiController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.selectedList.ItemList_mc.List_mc.selectedIndex == -1)
         {
            this.selectedList.ItemList_mc.List_mc.selectedIndex = 0;
         }
         this.updateButtonHints();
      }
      
      private function onSwapInventoryContainer() : void
      {
         this.selectedList = this.OfferInventory_mc as SecureTradeInventory;
         if(uiController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.selectedList.ItemList_mc.List_mc.selectedIndex == -1)
         {
            this.selectedList.ItemList_mc.List_mc.selectedIndex = 0;
         }
         this.updateButtonHints();
      }
      
      private function onRequestSort(param1:Boolean = true) : void
      {
         var _loc2_:* = 0;
         if(this.isScrapStash)
         {
            _loc2_ = this.JUNK_TAB_INDEX;
         }
         else if(this.isAmmoStash)
         {
            _loc2_ = this.AMMO_TAB_INDEX;
         }
         else if(this.m_MenuMode == MODE_PLAYERVENDING)
         {
            if(this.m_SelectedTab > this.PLAYERVENDING_WEAPONS_TAB_INDEX)
            {
               _loc2_ = this.m_SelectedTab - this.PLAYERVENDING_WEAPONS_TAB_INDEX;
            }
         }
         else if(this.m_SelectedTab >= this.WEAPONS_TAB_INDEX)
         {
            _loc2_ = this.m_SelectedTab - 1;
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_REQUEST_SORT,{
            "isPlayerInventory":this.selectedList == this.PlayerInventory_mc,
            "filter":_loc2_,
            "incrementSort":param1,
            "tabIndex":this.m_SelectedTab
         }));
      }
      
      private function onAccept() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:Boolean = true;
         if(this.ModalConfirmPurchase_mc.open)
         {
            this.onConfirmPurchaseAccept();
         }
         else if(this.ModalConfirmTakeAll_mc.open)
         {
            _loc2_ = uint.MAX_VALUE;
            if(this.m_CorpseLootMode)
            {
               _loc2_ = this.m_SelectedTab == 0 ? 0 : uint(this.m_ContainerIDs[this.m_SelectedTab - 1]);
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TAKE_ALL,{"containerID":_loc2_}));
         }
         else if(this.ModalConfirmScrap_mc.open)
         {
            this.ModalConfirmScrap_mc.HandlePrimaryAction();
            _loc1_ = false;
         }
         if(_loc1_)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
         }
      }
      
      private function selectItemViaHandleID(param1:MenuListComponent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         if(!this.selectedListEntry || this.selectedListEntry.serverHandleId != this.m_SelectedItemServerHandleId)
         {
            _loc2_ = param1.List_mc.MenuListData;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].serverHandleId == this.m_SelectedItemServerHandleId)
               {
                  _loc4_ = param1.disableSelection_Inspectable;
                  param1.disableSelection_Inspectable = false;
                  param1.setSelectedIndex(_loc3_);
                  param1.disableSelection_Inspectable = _loc4_;
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      private function selectStackViaNameCount(param1:MenuListComponent, param2:String, param3:Number) : void
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         if(!this.selectedListEntry || this.selectedListEntry.text != param2 || this.selectedListEntry.count != param3 || this.selectedListEntry.vendingData.machineType != SecureTradeShared.MACHINE_TYPE_INVALID)
         {
            _loc4_ = param1.List_mc.MenuListData;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].text == param2 && _loc4_[_loc5_].count == param3 && _loc4_[_loc5_].vendingData.machineType == SecureTradeShared.MACHINE_TYPE_INVALID)
               {
                  _loc6_ = param1.disableSelection_Inspectable;
                  param1.disableSelection_Inspectable = false;
                  param1.setSelectedIndex(_loc5_);
                  param1.disableSelection_Inspectable = _loc6_;
                  break;
               }
               _loc5_++;
            }
         }
      }
      
      private function PopulateOfferInventory(param1:Array) : void
      {
         this.SortListData(param1,this.m_OfferInventorySortField);
         this.OfferInventory_mc.ItemList_mc.List_mc.MenuListData = param1;
         if(this.selectedList == this.OfferInventory_mc)
         {
            if(this.m_RefreshSelectionOption == REFRESH_SELECTION_SERVER_ID && this.m_SelectedItemServerHandleId > 0)
            {
               this.selectItemViaHandleID(this.OfferInventory_mc.ItemList_mc);
            }
            else if(this.m_RefreshSelectionOption == REFRESH_SELECTION_NAME_COUNT)
            {
               this.selectStackViaNameCount(this.OfferInventory_mc.ItemList_mc,this.m_SelectedStackName,this.m_SelectedItemCount - 1);
            }
         }
         this.OfferInventory_mc.ItemList_mc.SetIsDirty();
         this.OfferInventory_mc.UpdateTooltips();
         this.m_ContainerEmpty = this.IsInventoryEmpty(this.OfferInventory_mc);
         if(this.m_MenuMode == MODE_PLAYERVENDING && this.selectedList == this.OfferInventory_mc && this.modalActive && this.SelectedOfferChanged(this.OfferInventory_mc.ItemList_mc.List_mc.MenuListData))
         {
            this.onBackButton();
            GlobalFunc.ShowHUDMessage("$TradeOfferChanged");
         }
         this.updateInventoryFocus();
         this.onSelectedDataChanged(null);
      }
      
      private function PopulatePlayerInventory(param1:Array) : void
      {
         var _loc2_:uint = 0;
         this.SortListData(param1,this.m_PlayerInventorySortField);
         this.m_playerHasMiscItems = false;
         this.m_playerHasAutoScrappableJunkItems = false;
         this.m_NewItems.splice(0);
         if(param1 is Array)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if((param1[_loc2_].filterFlag & FILTER_JUNK) > 0)
               {
                  this.m_playerHasMiscItems = true;
               }
               if((param1[_loc2_].filterFlag & FILTER_CANAUTOSCRAP) > 0)
               {
                  this.m_playerHasAutoScrappableJunkItems = true;
               }
               if(param1[_loc2_].isNew)
               {
                  this.m_NewItems.push(this.m_PlayerInvData[_loc2_]);
               }
               _loc2_++;
            }
         }
         this.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData = this.m_OnNewTab ? this.m_NewItems : param1;
         if(this.selectedList == this.PlayerInventory_mc)
         {
            if(this.m_RefreshSelectionOption == REFRESH_SELECTION_SERVER_ID && this.m_SelectedItemServerHandleId > 0)
            {
               this.selectItemViaHandleID(this.PlayerInventory_mc.ItemList_mc);
            }
            else if(this.m_RefreshSelectionOption == REFRESH_SELECTION_NAME_COUNT)
            {
               this.selectStackViaNameCount(this.PlayerInventory_mc.ItemList_mc,this.m_SelectedStackName,this.m_SelectedItemCount - 1);
            }
         }
         this.PlayerInventory_mc.ItemList_mc.SetIsDirty();
         this.PlayerInventory_mc.UpdateToolTipText();
         if(this.m_MenuMode == MODE_PLAYERVENDING && this.selectedList == this.PlayerInventory_mc && this.modalActive && this.SelectedOfferChanged(this.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData,true))
         {
            this.onBackButton();
            GlobalFunc.ShowHUDMessage("$TradeOfferChanged");
         }
         this.m_PlayerInventoryEmpty = this.PlayerInventory_mc != null && this.IsInventoryEmpty(this.PlayerInventory_mc);
         this.updateButtonHints();
         this.onSelectedDataChanged(null);
      }
      
      private function onShowHistory() : void
      {
         GlobalFunc.PlayMenuSound(CampBuildsShared.CAMP_SLOTS_FLYOUT_OPEN_SOUND);
         BSUIDataManager.dispatchEvent(new CustomEvent(CampBuildsShared.CAMP_SLOTS_MAP_VENDING_HISTORY_SHOW_FUNC,{"bFromMap":false}));
      }
      
      private function onToggleShowMarkedItemsOnlyButton() : void
      {
         if(!this.isCampVendingMenuType() || !this.m_OwnsVendor)
         {
            return;
         }
         ++this.m_FilterItemsOption;
         if(this.m_FilterItemsOption == FILTER_OPTION_COUNT)
         {
            this.m_FilterItemsOption = FILTER_OPTION_NONE;
         }
         this.SetSelectedItemValues(this.selectedListEntry);
         this.PopulateCampVendingInventory();
         this.updateButtonHints();
         this.ClearSelectedItemValues();
      }
      
      private function PopulateCampVendingInventory() : void
      {
         var listData:Array;
         if(!this.isCampVendingMenuType())
         {
            return;
         }
         if(this.m_OwnsVendor)
         {
            this.UpdatePartialItems(this.m_OtherInvData,this.m_TheirOffersData);
         }
         listData = this.m_OwnsVendor ? this.m_OtherInvData : this.m_TheirOffersData;
         switch(this.m_FilterItemsOption)
         {
            case FILTER_OPTION_THIS_MACHINE:
               listData = listData.filter(function(param1:Object):Boolean
               {
                  var _loc2_:* = param1.vendingData;
                  return _loc2_.machineType != SecureTradeShared.MACHINE_TYPE_INVALID && !_loc2_.isVendedOnOtherMachine;
               });
               break;
            case FILTER_OPTION_THIS_MACHINE_AND_STASH:
               listData = listData.filter(function(param1:Object):Boolean
               {
                  var _loc2_:* = param1.vendingData;
                  return _loc2_.machineType == SecureTradeShared.MACHINE_TYPE_INVALID || !_loc2_.isVendedOnOtherMachine;
               });
         }
         this.SortListData(listData,this.m_OfferInventorySortField);
         this.OfferInventory_mc.ItemList_mc.List_mc.MenuListData = listData;
         if(this.selectedList == this.OfferInventory_mc)
         {
            if(this.m_RefreshSelectionOption == REFRESH_SELECTION_SERVER_ID && this.m_SelectedItemServerHandleId > 0)
            {
               this.selectItemViaHandleID(this.OfferInventory_mc.ItemList_mc);
            }
            else if(this.m_RefreshSelectionOption == REFRESH_SELECTION_NAME_COUNT)
            {
               this.selectStackViaNameCount(this.OfferInventory_mc.ItemList_mc,this.m_SelectedStackName,this.m_SelectedItemCount - 1);
            }
         }
         this.OfferInventory_mc.ItemList_mc.SetIsDirty();
         this.OfferInventory_mc.UpdateTooltips();
         this.m_ContainerEmpty = this.IsInventoryEmpty(this.OfferInventory_mc);
         if(this.selectedList == this.OfferInventory_mc && this.modalActive && this.SelectedOfferChanged(this.OfferInventory_mc.ItemList_mc.List_mc.MenuListData))
         {
            this.onBackButton();
            GlobalFunc.ShowHUDMessage("$TradeOfferChanged");
         }
         this.updateInventoryFocus();
         this.onSelectedDataChanged(null);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         if(param1 == "DISABLED")
         {
            return false;
         }
         if(param2 && param1 == "StoreAllJunk")
         {
            this.m_DownEventRecieved = true;
         }
         var _loc3_:Boolean = false;
         if(this.m_IgnorePlayerVendingItemPress && param2 && param1 == "Accept")
         {
            this.m_IgnorePlayerVendingItemPress = false;
         }
         if(this.ModalSetPrice_mc.opened && param1 != "RShoulder")
         {
            _loc3_ = this.ModalSetPrice_mc.ProcessUserEvent(this.ConvertEventString(param1),param2);
         }
         if(!_loc3_ && this.ModalSetQuantity_mc.opened && param1 != "RShoulder")
         {
            _loc3_ = this.ModalSetQuantity_mc.ProcessUserEvent(this.ConvertEventString(param1),param2);
         }
         if(!_loc3_ && this.isOpen && !param2)
         {
            switch(param1)
            {
               case "SwitchToPlayer":
                  if(this.ButtonPlayerInventory.ButtonVisible == true && this.ButtonPlayerInventory.ButtonDisabled != true && this.m_PlayerInventoryEmpty != true)
                  {
                     this.onSwapInventoryPlayer();
                     _loc3_ = true;
                  }
                  break;
               case "SwitchToContainer":
                  if(this.ButtonContainerInventory.ButtonVisible == true && this.ButtonContainerInventory.ButtonDisabled != true && this.m_ContainerEmpty != true)
                  {
                     this.onSwapInventoryContainer();
                     _loc3_ = true;
                  }
                  break;
               case "DeclineItem":
                  if(this.InspectButton.ButtonVisible == true && this.InspectButton.ButtonDisabled != true)
                  {
                     this.onInspectItem();
                     _loc3_ = true;
                  }
                  break;
               case "SortList":
                  if(!this.modalActive)
                  {
                     this.onRequestSort();
                     _loc3_ = true;
                  }
                  break;
               case "TakeAll":
                  if(this.ButtonDecline.ButtonVisible == true && this.ButtonDecline.ButtonDisabled != true)
                  {
                     this.onDeclineItem();
                     _loc3_ = true;
                  }
                  else if(this.ButtonToggleAssign.ButtonVisible == true && this.ButtonToggleAssign.ButtonDisabled != true)
                  {
                     this.onToggleAssign();
                     _loc3_ = true;
                  }
                  else if(this.TakeAllButton.ButtonVisible == true && this.TakeAllButton.ButtonDisabled != true)
                  {
                     this.onTakeAll();
                     _loc3_ = true;
                  }
                  break;
               case "StoreAllJunk":
                  if(this.StoreUnusedItemsButton.ButtonVisible == true)
                  {
                     if(this.StoreUnusedItemsButton.ButtonDisabled)
                     {
                        if(this.isScrapStash)
                        {
                           _loc4_ = false;
                           for each(_loc5_ in this.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData)
                           {
                              if(Boolean(_loc5_.isAutoScrappable) || Boolean(_loc5_.canGoIntoScrapStash))
                              {
                                 _loc4_ = true;
                                 break;
                              }
                           }
                           if(!this.m_IsFollowerOfZeus)
                           {
                              GlobalFunc.ShowHUDMessage("$StoreJunkFailNoFO1st");
                           }
                           else if(!_loc4_)
                           {
                              GlobalFunc.ShowHUDMessage("$StoreJunkFailNoScrappableItems");
                           }
                        }
                        else if(this.isAmmoStash)
                        {
                           if(!this.m_IsFollowerOfZeus)
                           {
                              GlobalFunc.ShowHUDMessage("$TransferUnusedFailNoFO1st");
                           }
                           else if(!this.m_transferUnusedAmmoAllowed)
                           {
                              GlobalFunc.ShowHUDMessage("$TransferUnusedFailNoUnusedAmmo");
                           }
                        }
                     }
                     else
                     {
                        this.onStoreUnusedItems();
                     }
                     _loc3_ = true;
                  }
                  else if(this.ButtonOffersOnly.ButtonVisible == true && this.ButtonOffersOnly.ButtonDisabled != true && this.m_DownEventRecieved)
                  {
                     this.onOffersOnly();
                     _loc3_ = true;
                     this.m_DownEventRecieved = false;
                  }
                  else if(this.ToggleShowMarkedItemsOnlyButton.ButtonVisible == true && this.ToggleShowMarkedItemsOnlyButton.ButtonDisabled != true)
                  {
                     this.onToggleShowMarkedItemsOnlyButton();
                     _loc3_ = true;
                  }
                  break;
               case "Select":
                  if(!this.modalActive && this.m_OwnsVendor)
                  {
                     this.onShowHistory();
                  }
                  break;
               case "Cancel":
                  this.onBackButton();
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function SortListData(param1:Array, param2:int) : void
      {
         var aListData:Array = param1;
         var aSortField:int = param2;
         if(aListData != null)
         {
            aListData.sort(function(param1:Object, param2:Object):int
            {
               var _loc4_:String = null;
               var _loc5_:Number = NaN;
               var _loc6_:Number = NaN;
               var _loc7_:Number = NaN;
               var _loc8_:Number = NaN;
               var _loc3_:int = 0;
               if(Boolean(param1.vendingData.isVendedOnOtherMachine) && Boolean(param2.isOffered) && !param2.vendingData.isVendedOnOtherMachine)
               {
                  _loc3_ = 1;
               }
               else if(param1.isOffered && !param1.vendingData.isVendedOnOtherMachine && Boolean(param2.vendingData.isVendedOnOtherMachine))
               {
                  _loc3_ = -1;
               }
               else if(param1.vendingData.machineType == SecureTradeShared.MACHINE_TYPE_INVALID && param2.vendingData.machineType != SecureTradeShared.MACHINE_TYPE_INVALID)
               {
                  _loc3_ = 1;
               }
               else if(param1.vendingData.machineType != SecureTradeShared.MACHINE_TYPE_INVALID && param2.vendingData.machineType == SecureTradeShared.MACHINE_TYPE_INVALID)
               {
                  _loc3_ = -1;
               }
               else if(param1.vendingData.machineType < param2.vendingData.machineType)
               {
                  _loc3_ = -1;
               }
               else if(param1.vendingData.machineType > param2.vendingData.machineType)
               {
                  _loc3_ = 1;
               }
               else
               {
                  _loc4_ = "";
                  switch(aSortField)
                  {
                     case SOF_DAMAGE:
                        _loc4_ = "damage";
                        break;
                     case SOF_ROF:
                        _loc4_ = "weaponDisplayRateOfFire";
                        break;
                     case SOF_RANGE:
                        _loc4_ = "weaponDisplayRange";
                        break;
                     case SOF_ACCURACY:
                        _loc4_ = "weaponDisplayAccuracy";
                        break;
                     case SOF_VALUE:
                        _loc4_ = "itemValue";
                        break;
                     case SOF_WEIGHT:
                        _loc4_ = "weight";
                        break;
                     case SOF_STACKWEIGHT:
                        _loc5_ = param1.count * param1.weight;
                        _loc6_ = param2.count * param2.weight;
                        if(_loc5_ != _loc6_)
                        {
                           _loc3_ = _loc5_ < _loc6_ ? 1 : -1;
                        }
                        break;
                     case SOF_SPOILAGE:
                        _loc7_ = param1.currentHealth >= 0 ? param1.currentHealth / param1.maximumHealth : 1;
                        _loc8_ = param2.currentHealth >= 0 ? param2.currentHealth / param2.maximumHealth : 1;
                        if(_loc7_ != _loc8_)
                        {
                           _loc3_ = _loc7_ < _loc8_ ? -1 : 1;
                        }
                        break;
                     default:
                        _loc4_ = "isLearnedRecipe";
                  }
                  if(_loc4_ == "isLearnedRecipe")
                  {
                     if(param1[_loc4_] < param2[_loc4_])
                     {
                        _loc3_ = -1;
                     }
                     else if(param1[_loc4_] > param2[_loc4_])
                     {
                        _loc3_ = 1;
                     }
                  }
                  else if(_loc4_ != "")
                  {
                     if(param1[_loc4_] < param2[_loc4_])
                     {
                        _loc3_ = 1;
                     }
                     else if(param1[_loc4_] > param2[_loc4_])
                     {
                        _loc3_ = -1;
                     }
                  }
               }
               if(m_CorpseLootMode && _loc3_ == 0)
               {
                  if(param1.numLegendaryStars < param2.numLegendaryStars)
                  {
                     _loc3_ = 1;
                  }
                  else if(param1.numLegendaryStars > param2.numLegendaryStars)
                  {
                     _loc3_ = -1;
                  }
                  if(_loc3_ == 0)
                  {
                     if(param1.isCurrency < param2.isCurrency)
                     {
                        _loc3_ = 1;
                     }
                     else if(param1.isCurrency > param2.isCurrency)
                     {
                        _loc3_ = -1;
                     }
                  }
                  if(_loc3_ == 0)
                  {
                     if((param1.itemCategory & FILTER_AMMO) != 0 && (param2.itemCategory & FILTER_AMMO) == 0)
                     {
                        _loc3_ = -1;
                     }
                     else if((param1.itemCategory & FILTER_AMMO) == 0 && (param2.itemCategory & FILTER_AMMO) != 0)
                     {
                        _loc3_ = 1;
                     }
                  }
               }
               if(_loc3_ == 0)
               {
                  if(param1.text < param2.text)
                  {
                     _loc3_ = -1;
                  }
                  else if(param1.text > param2.text)
                  {
                     _loc3_ = 1;
                  }
                  else if(param1.count < param2.count)
                  {
                     _loc3_ = -1;
                  }
                  else if(param1.count > param2.count)
                  {
                     _loc3_ = 1;
                  }
               }
               if(_loc3_ == 0)
               {
                  if(param1.serverHandleId < param2.serverHandleId)
                  {
                     _loc3_ = 1;
                  }
                  else if(param1.serverHandleId > param2.serverHandleId)
                  {
                     _loc3_ = -1;
                  }
               }
               return _loc3_;
            });
         }
      }
      
      private function CreateScrappableInventoryList(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(_loc3_.scrapAllowed)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function ConvertEventString(param1:String) : String
      {
         if(param1 == "SwitchToContainer")
         {
            return "RTrigger";
         }
         if(param1 == "SwitchToPlayer")
         {
            return "LTrigger";
         }
         if(param1 == "SortList")
         {
            return "Q";
         }
         return param1;
      }
      
      private function IsInventoryEmpty(param1:MovieClip) : Boolean
      {
         var _loc2_:* = true;
         var _loc3_:Boolean = true;
         if(param1 != null)
         {
            if(param1.ItemList_mc.List_mc.MenuListData != undefined && param1.ItemList_mc.List_mc.MenuListData != null)
            {
               _loc2_ = param1.ItemList_mc.List_mc.MenuListData.length == 0;
            }
            if(param1.ItemList_mc.List_mc.filterer != undefined && param1.ItemList_mc.List_mc.filterer != null)
            {
               if(this.m_CorpseLootMode && param1 == this.PlayerInventory_mc)
               {
                  _loc3_ = Boolean(param1.ItemList_mc.List_mc.filterer.IsFilterEmpty(this.m_ItemFilters[0].flag));
               }
               else
               {
                  _loc3_ = Boolean(param1.ItemList_mc.List_mc.filterer.IsFilterEmpty(this.m_ItemFilters[this.m_SelectedTab].flag));
               }
            }
         }
         return _loc2_ || _loc3_;
      }
      
      private function SetSelectedItemValues(param1:Object) : void
      {
         if(param1 != null)
         {
            this.m_SelectedStackName = param1.text;
            this.m_SelectedItemOffered = param1.isOffered;
            this.m_SelectedItemValue = param1.itemValue;
            this.m_SelectedItemCount = param1.count;
            this.m_SelectedItemServerHandleId = param1.serverHandleId;
            this.m_SelectedItemIsPartialOffer = param1.partialOffer;
            this.m_RefreshSelectionOption = REFRESH_SELECTION_SERVER_ID;
         }
      }
      
      private function ClearSelectedItemValues() : void
      {
         this.m_SelectedStackName = "";
         this.m_SelectedItemOffered = false;
         this.m_SelectedItemValue = 0;
         this.m_SelectedItemCount = 0;
         this.m_SelectedItemServerHandleId = 0;
         this.m_SelectedItemIsPartialOffer = false;
         this.m_RefreshSelectionOption = REFRESH_SELECTION_NONE;
      }
      
      private function SelectedOfferChanged(param1:Array, param2:Boolean = false) : Boolean
      {
         var _loc3_:Boolean = true;
         var _loc4_:Object = null;
         var _loc5_:Number = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_].serverHandleId == this.m_SelectedItemServerHandleId && (param2 && !this.m_SelectedItemOffered || param1[_loc5_].partialOffer == this.m_SelectedItemIsPartialOffer))
            {
               _loc4_ = param1[_loc5_];
               break;
            }
            _loc5_++;
         }
         if(_loc4_ != null)
         {
            if(param2)
            {
               _loc3_ = false;
            }
            else if(this.m_SelectedItemOffered == _loc4_.isOffered && this.m_SelectedItemValue == _loc4_.itemValue && this.m_SelectedItemCount == _loc4_.count)
            {
               _loc3_ = false;
            }
         }
         return _loc3_;
      }
      
      private function UpdatePartialItems(param1:Array, param2:Array) : void
      {
         var _loc3_:int = int(param1.length);
         while(--_loc3_ > -1)
         {
            if(param1[_loc3_].partialOffer == true)
            {
               param1.splice(_loc3_,1);
            }
         }
         var _loc4_:Number = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_].partialOffer == true)
            {
               param1.push(param2[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      private function InsertRequestedItems(param1:Array, param2:Array) : void
      {
         var _loc3_:int = int(param1.length);
         while(--_loc3_ > -1)
         {
            if(param1[_loc3_].isOffered == false)
            {
               param1.splice(_loc3_,1);
            }
         }
         var _loc4_:Number = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_].isRequested == true)
            {
               param1.push(param2[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame32() : *
      {
         stop();
      }
      
      internal function frame49() : *
      {
         stop();
      }
      
      internal function frame59() : *
      {
         stop();
      }
      
      internal function frame69() : *
      {
         stop();
      }
   }
}
