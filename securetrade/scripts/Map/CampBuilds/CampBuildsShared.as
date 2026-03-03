package Map.CampBuilds
{
   import flash.utils.getDefinitionByName;
   
   public class CampBuildsShared
   {
      
      public static const EVENT_CAMP_BUILDS_DATA:String = "CampSlotsData";
      
      public static const EVENT_CAMP_SLOTS_CHANGE_ICON:String = "CampSlots::SetCustomIconEvent";
      
      public static const EVENT_ON_COLLAPSE:String = "CampBuilds::OnCollapse";
      
      public static const EVENT_ON_EXPAND:String = "CampBuilds::onExpand";
      
      public static const EVENT_FLYOUT_SHOW:String = "CampBuilds::FlyoutShow";
      
      public static const EVENT_FLYOUT_HIDE:String = "CampBuilds::FlyoutHide";
      
      public static const EVENT_ICON_FLYOUT_SHOW:String = "CampBuilds::IconFlyoutShow";
      
      public static const EVENT_ICON_FLYOUT_HIDE:String = "CampBuilds::IconFlyoutHide";
      
      public static const EVENT_SELECTED_CAMP_MARKER_REMOVED:String = "CampBuilds::SelectedCampMarkerRemoved";
      
      public static const EVENT_SELECTED_CAMP_MARKER_UPDATED:String = "CampBuilds::SelectedCampMarkerUpdated";
      
      public static const LINKAGE_CAMP_BUILDS_ENTRY:String = "Map.CampBuilds.CampBuildsEntry";
      
      public static const LINKAGE_CAMP_BUILDS_ACTIVATION_LIST_ENTRY:String = "Map.CampBuilds.CampBuildsActivationListEntry";
      
      public static const LINKAGE_SET_ICON_FLYOUT_LIST_ENTRY:String = "Map.CampBuilds.SetIconListEntry";
      
      public static const CAMP_SLOTS_ACTIVATE_FUNC:String = "CampSlots::ActivateEvent";
      
      public static const CAMP_SLOTS_RENAME_FUNC:String = "CampSlots::RenameEvent";
      
      public static const CAMP_SLOTS_SET_PUBLIC_FUNC:String = "CampSlots::SetPublicEvent";
      
      public static const CAMP_SLOTS_SET_CUSTOM_ICON_FUNC:String = "CampSlots::SetCustomIconEvent";
      
      public static const CAMP_SLOTS_FAST_TRAVEL_FUNC:String = "CampSlots::FastTravelEvent";
      
      public static const CAMP_SLOTS_OPEN_STORE:String = "CampSlots::OpenStoreEvent";
      
      public static const CAMP_SLOTS_SUBMIT_BESTBUILD_FUNC:String = "CampSlots::SubmitBestBuildEvent";
      
      public static const CAMP_SLOTS_MANAGE_BESTBUILD_FUNC:String = "CampSlots::ManageBestBuildEvent";
      
      public static const CAMP_SLOTS_MAP_VENDING_HISTORY_SHOW_FUNC:String = "VendingHistoryMenu::Show";
      
      public static const CAMP_SLOTS_MAP_ACTIVATE_FUNC:String = "CampSlotsActivate";
      
      public static const CAMP_SLOTS_MAP_RENAME_FUNC:String = "CampSlotsRename";
      
      public static const CAMP_SLOTS_MAP_TOGGLE_PUBLIC_FUNC:String = "CampSlotsTogglePublic";
      
      public static const CAMP_SLOTS_MAP_SET_CUSTOM_ICON_FUNC:String = "CampSlotsSetCustomIcon";
      
      public static const CAMP_SLOTS_ACTIVATE_SOUND:String = "UICampSlotActivate";
      
      public static const CAMP_SLOTS_HIGHLIGHT_SOUND:String = "UICampSlotHighlight";
      
      public static const CAMP_SLOTS_FLYOUT_OPEN_SOUND:String = "UICampSlotInfoPaneOpen";
      
      public static const CAMP_SLOTS_ICON_SELECT_SOUND:String = "UICampSlotIconSelect";
      
      public static const CAMP_SLOTS_FLYOUT_CLOSE_SOUND:String = "UICampSlotInfoPaneClose";
      
      public static const CAMP_SLOTS_PUBLIC_ON_SOUND:String = "UICampSlotPublicIconOn";
      
      public static const CAMP_SLOTS_PUBLIC_OFF_SOUND:String = "UICampSlotPublicIconOff";
      
      public static const CAMP_TITLES_SHOW:String = "CampCustomizersMenu::Show";
      
      private static const CAMP_SLOTS_ICON_ARRAY:Array = ["DefaultCampMarker","AgriculturalCenterMarker","AirfieldMarker","AmusementParkMarker","AppalachianAntiquesMarker","ArktosPharmaMarker","BloodEagleMarker","BoSBaseMarker","BoSMarker","BunkerMarker","CabinMarker","CamperMarker","CapitalBuildingMarker","CarMarker","CastleMarker","CaveMarker","ChurchMarker","CityMarker","LastCorpseMarker","CountryClubMarker","CowSpotsCreameryMarker","CultistMarker","CustomHouseMarker","DamMarker","SkyscraperMarker","DriveInMarker","ElectricalSubstationMarker","ElevatedHighwayMarker","EncampmentMarker","ExcavatorMarker","FactoryMarker","FarmMarker","FillingStationMarker","FissureMarker","ForestedMarker","GoodneighborMarker","GraveyardMarker","HammerWingMarker","HighTechBuildingMarker","HospitalMarker","HouseTrailerMarker","IndustrialDomeMarker","IrishPrideMarker","JunkyardMarker","LandmarkMarker","LegendaryPurveyorMarker","LibertaliaMarker","LighthouseMarker","LookoutTowerMarker","LowRiseMarker","MansionMarker"
      ,"MechanistMarker","MetroMarker","MilitaryBaseMarker","MissileSiloMarker","MonorailMarker","MonumentMarker","NukaColaQuantumPlant","ObservatoryMarker","OfficeMarker","OverlookMarker","PalaceWindingPathMarker","PierMarker","PoliceStationMarker","PondLakeMarker","PowerPlantMarker","PumpkinMarker","QuarryMarker","RadioactiveAreaMarker","RadioTowerMarker","RaiderSettlementMarker","RailroadFactionMarker","RailroadMarker","SancHillsMarker","SatelliteMarker","SchoolMarker","SentinelMarker","SettlementMarker","SewerMarker","ShipwreckMarker","SkiResortMarker","SkullRingMarker","SpaceStationMarker","SubmarineMarker","SwanPondMarker","TeapotMarker","TopOfTheWorldMarker","TownMarker","TownRuinsMarker","TrainStationMarker","TrainTrackMark","UrbanRuinsMarker","VaultMarker","WhitespringResort","WoodShackMarker"];
      
      public function CampBuildsShared()
      {
         super();
      }
      
      public static function getCampActivationOptions(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean = false, param7:Boolean = false) : Array
      {
         var _loc8_:Array = new Array();
         if(param1)
         {
            if(param3 && !param4)
            {
               _loc8_.push({
                  "text":"$$FastTravel",
                  "funcName":CAMP_SLOTS_FAST_TRAVEL_FUNC
               });
            }
            if(param6)
            {
               _loc8_.push({
                  "text":"$BESTBUILDSSUBMIT",
                  "funcName":CAMP_SLOTS_SUBMIT_BESTBUILD_FUNC
               });
            }
            else if(param7)
            {
               _loc8_.push({
                  "text":"$BESTBUILDSMANAGE",
                  "funcName":CAMP_SLOTS_MANAGE_BESTBUILD_FUNC
               });
            }
            if(param5)
            {
               _loc8_.push({
                  "text":"$CAMP_TITLE",
                  "funcName":CAMP_TITLES_SHOW
               });
            }
            _loc8_.push({
               "text":"$CAMP_SLOTS_RENAME",
               "funcName":(param4 ? CAMP_SLOTS_MAP_RENAME_FUNC : CAMP_SLOTS_RENAME_FUNC)
            });
            _loc8_.push({
               "text":(param2 ? "$CAMP_SLOTS_TOGGLE_PUBLIC_ON" : "$CAMP_SLOTS_TOGGLE_PUBLIC_OFF"),
               "funcName":(param4 ? CAMP_SLOTS_MAP_TOGGLE_PUBLIC_FUNC : CAMP_SLOTS_SET_PUBLIC_FUNC)
            });
            _loc8_.push({
               "text":"$CAMP_SLOTS_CHANGE_ICON",
               "funcName":(param4 ? CAMP_SLOTS_MAP_SET_CUSTOM_ICON_FUNC : CAMP_SLOTS_SET_CUSTOM_ICON_FUNC)
            });
            _loc8_.push({
               "text":"$CAMP_SLOTS_VENDING_HISTORY",
               "funcName":CAMP_SLOTS_MAP_VENDING_HISTORY_SHOW_FUNC
            });
         }
         else
         {
            _loc8_.push({
               "text":"$CAMP_SLOTS_ACTIVATE",
               "funcName":(param4 ? CAMP_SLOTS_MAP_ACTIVATE_FUNC : CAMP_SLOTS_ACTIVATE_FUNC)
            });
         }
         return _loc8_;
      }
      
      public static function getCampIconStringFromIndex(param1:uint) : String
      {
         if(param1 >= CAMP_SLOTS_ICON_ARRAY.length)
         {
            param1 = 0;
         }
         return CAMP_SLOTS_ICON_ARRAY[param1];
      }
      
      public static function buildSetIconListData() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < CAMP_SLOTS_ICON_ARRAY.length)
         {
            _loc1_.push({"customIcon":CAMP_SLOTS_ICON_ARRAY[_loc2_]});
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getCustomIconClipClass(param1:String) : Class
      {
         var clipClass:Class = null;
         var aCustomIconString:String = param1;
         try
         {
            clipClass = getDefinitionByName(aCustomIconString) as Class;
         }
         catch(error:ReferenceError)
         {
            trace("Error Can\'t find map marker type " + aCustomIconString);
            clipClass = getDefinitionByName("DefaultCampMarker") as Class;
         }
         return clipClass;
      }
   }
}

