package extractors
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   
   public class GameApiDataExtractor
   {
      
      public static const EVENT_TRANSFER_ITEM:String = "Container::TransferItem";
      
      public static const EVENT_INSPECT_ITEM:String = "Container::InspectItem";
      
      public static const EVENT_ITEM_SELECTED:String = "SecureTrade::OnItemSelected";
      
      public static const EVENT_SCRAP_ITEM:String = "Workbench::ScrapItem";
      
      public static const EVENT_NPC_SELL_ITEM:String = "NPCVend::SellItem";
      
      public static const EVENT_NPC_BUY_ITEM:String = "NPCVend::BuyItem";
      
      public static const EVENT_CAMP_BUY_ITEM:String = "CampVend::BuyItem";
      
      public static const EVENT_CAMP_DISPLAY_ITEM:String = "CampVend::DisplayItem";
      
      public static const EVENT_CAMP_DISPLAY_DECORATE_ITEM_IN_SLOT:String = "CampDecorate::DisplayDecorateItemInSlot";
      
      public static var PlayerInventoryData:String = "PlayerInventoryData";
      
      public static var CharacterInfoData:String = "CharacterInfoData";
      
      public static var AccountInfoData:String = "AccountInfoData";
      
      public static var InventoryItemCardData:String = "InventoryItemCardData";
      
      private static var GAME_API_METHODS:Array = ["AccountInfoData","ActiveEmoteData","BabylonAvailableMapsData","BabylonData","BabylonUIData","CameraScopeData","CampSlotsData","CampVendingOfferData","CardPacksUIData","ChallengeCompleteData","ChallengeData","ChallengeTrackerData","ChallengeTrackerUpdateData","CharacterCardData","CharacterInfoData","CharacterNameData","CompassData","ContainerOptionsData","ControlMapData","ConversationHistoryData","CreditsMenuShuttle","CurrencyData","DailyOpsModalData","DamageNumberUIData","DeathData","DeathReviveData","DefaultMenuListData","DialogueData","EncounterHealthMeterArray","EndOfMatchUIData","ExpeditionLocationsData","FanfareData","FanfareQuestAcceptData","FireForgetEvent","FriendsContextMenuData","FriendsListDataCold","FriendsListDataHot","FrobberData","GameStatePromptData","HelpMenuShuttle","HitIndicators","HotMapMarkerData","HubMenuShuttle","HUDColors","HUDMessageProvider","HUDModeData","HUDRightMetersData","HUDVOFlyoutData","InventoryItemCardData","ItemLevelEligibilityData","KeypadInfoData","LegendaryPerksMenuData","LobbyMenuList","LoginInfoData","LoginResponseData","MainMenuListData","MapMenuData","MapMenuDataChanges","MapMenuFlyoutData","MenuStackData","MessageEvents","MotdData","MyOffersData","OtherInventoryData","OtherInventoryTypeData","PartyMenuList","PerkCardGameModeFilterUIData","PerksUIData","PhotoGalleryData","pingArray","PlayerStatsUIData","PlayMenuListData","PowerArmorInfoData","ProximityTrackersProvider","PublicTeamsData","PurchaseCompleteData","PVPData","PVPScoreEventData","QuestEventData","QuestTrackerData","QuestTrackerProvider","QuickPlayMenuData","RadialMenuActiveEffectListData","RadialMenuListData","RadialMenuExpandedListData","RadialMenuExpandMeterData","RadialMenuStateData","RadialMenuStatus","RecentActivitiesData","RecentActivityNavigateData","RecentPlayersListDataCold","RecentPlayersListDataHot","ReconMarkerData","ReputationData","ScoreboardData","ScoreboardFilterData","ScreenResolutionData","SeasonData","SeasonRewardClaimedFlyoutData","SeasonWidgetData","ServerPromptData","SocialMenuData","SocialMenuNavigateData","SocialNotificationData","SpeakerNamePosData","SplashData","StoreAtomPackData","StoreCategoryData","StoreMenuData","TargetData","TeamMarkers","TextInputData","TheirOffersData","TutorialModalData","UpdateRankData","VoiceChatAreaData","WorkshopBudgetData","WorkshopButtonBarData","WorkshopCategoryData","WorkshopConfigData","WorkshopEditModeData","WorkshopItemCardData","WorkshopMarkers","WorkshopMessageData","WorkshopStateData","WorldData"];
       
      
      public function GameApiDataExtractor()
      {
         super();
      }
      
      public static function getFullApiData(param1:Array) : Object
      {
         var gameApiData:Object = null;
         var array:Array = param1;
         gameApiData = {};
         if(array == null || array.length < 1)
         {
            array = GAME_API_METHODS;
         }
         array.forEach(function(param1:String):void
         {
            gameApiData[param1] = getApiData(param1);
         });
         return gameApiData;
      }
      
      public static function getApiData(param1:String) : Object
      {
         try
         {
            return BSUIDataManager.GetDataFromClient(param1).data;
         }
         catch(e:Error)
         {
         }
         return {"message":"Error extracting data for " + param1};
      }
      
      public static function getAccountInfoData() : Object
      {
         return getApiData(AccountInfoData);
      }
      
      public static function getCharacterInfoData() : Object
      {
         return getApiData(CharacterInfoData);
      }
      
      public static function getInventoryItemCardData() : Object
      {
         return getApiData(InventoryItemCardData);
      }
      
      public static function inspectItem(param1:Number, param2:Boolean) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_INSPECT_ITEM,{
            "serverHandleID":param1,
            "fromContainer":param2
         }));
      }
      
      public static function selectItem(param1:Number, param2:Boolean) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_ITEM_SELECTED,{
            "serverHandleID":param1,
            "isSelectionValid":true,
            "fromContainer":param2
         }));
      }
      
      public static function subscribeInventoryItemCardData(param1:Function) : void
      {
         BSUIDataManager.Subscribe(InventoryItemCardData,param1);
      }
      
      public static function transferItem(param1:Object, param2:Boolean = false, param3:int = -1) : void
      {
         var _loc4_:uint = param3 === -1 ? uint(param1.count) : uint(param3);
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRANSFER_ITEM,{
            "serverHandleID":param1.serverHandleID,
            "quantity":_loc4_,
            "fromContainer":param2,
            "containerID":param1.containerID
         }));
      }
      
      public static function scrapItem(param1:Object, param2:int = -1) : void
      {
         var _loc3_:int = param2 === -1 ? int(param1.count) : param2;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCRAP_ITEM,{
            "serverHandleID":param1.serverHandleID,
            "quantity":_loc3_
         }));
      }
      
      public static function sellItem(param1:Object, param2:int = -1) : void
      {
         var _loc3_:uint = param2 === -1 ? uint(param1.count) : uint(param2);
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_NPC_SELL_ITEM,{
            "serverHandleID":param1.serverHandleID,
            "quantity":_loc3_
         }));
      }
      
      public static function campAssignItem(param1:Object, param2:Boolean) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_DISPLAY_ITEM,{
            "serverHandleID":param1.serverHandleID,
            "fromContainer":param2
         }));
      }
      
      public static function displayAssignItem(param1:Object, param2:Boolean) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_DISPLAY_DECORATE_ITEM_IN_SLOT,{
            "serverHandleID":param1.serverHandleID,
            "fromContainer":param2
         }));
      }
      
      public static function npcBuyItem(param1:uint, param2:int) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_NPC_BUY_ITEM,{
            "serverHandleID":param1,
            "quantity":param2
         }));
      }
      
      public static function campBuyItem(param1:uint, param2:int, param3:int) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CAMP_BUY_ITEM,{
            "serverHandleID":param1,
            "count":param2,
            "price":param3
         }));
      }
   }
}
