package
{
   import Shared.AS3.*;
   import Shared.AS3.Data.*;
   import Shared.AS3.Events.*;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.JSONDecoder;
   import com.adobe.serialization.json.JSONEncoder;
   import extractors.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.*;
   import utils.*;
   
   public class InventOmaticStash extends MovieClip
   {
      
      public static const FULL_MOD_NAME:String = "IOMS " + Version.VERSION;
       
      
      private const DEFAULT_SHOW_BUTTON_STATE:Boolean = InventOmaticConfig.DEFAULT_SHOW_BUTTON_STATE;
      
      private const CRAFTING_ITEM_UNLOCKED_REGEX:* = /(Crafting item unlocked|Objet de fabrication débloqué |Objeto de creación desbloqueado|Objeto de creación desbloqueado|Herstellungsgegenstand freigeschaltet|Oggetto creabile sbloccato|Odblokowujesz nową rzecz do tworzenia|Item de criação desbloqueado|Открыт предмет для изготовления|クラフトアイテムを解除|제작 아이템 잠금 해제|已解锁的物品制作|道具製作已解鎖)/;
      
      public var debugLogger:TextField;
      
      private var _itemExtractor:ItemExtractor;
      
      private var _customFormatExtractor:CustomFormatExtractor;
      
      private var _itemWorker:ItemWorker;
      
      private var _parent:MovieClip;
      
      public var extractButton:BSButtonHintData;
      
      public var transferButton:BSButtonHintData;
      
      public var transferButtons:Vector.<BSButtonHintData>;
      
      public var scrapItemsButton:BSButtonHintData;
      
      public var lootItemsButton:BSButtonHintData;
      
      public var npcSellItemsButton:BSButtonHintData;
      
      public var buyItemsButton:BSButtonHintData;
      
      public var campAssignItemsButton:BSButtonHintData;
      
      public var buttonHintBar:BSButtonHintBar;
      
      private var _shift:Boolean = false;
      
      private var timer:Timer;
      
      private var _characterName:String;
      
      private var _offset:Number = 0;
      
      private var modHeaders:*;
      
      private var offerHeader:String = "";
      
      public function InventOmaticStash()
      {
         this.modHeaders = {};
         super();
         modHeaders.player = {};
         modHeaders.stash = {};
         try
         {
            Logger.DEBUG_MODE = false;
            Logger.init(this.debugLogger);
            addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
            BSUIDataManager.Subscribe("CharacterInfoData",this.onCharacterInfoDataUpdate);
            BSUIDataManager.Subscribe("HUDMessageProvider",this.onHUDMessageProviderUpdate);
         }
         catch(e:Error)
         {
            Logger.get().error("Error loading mod " + e);
            ShowHUDMessage("Error loading mod " + e,true);
         }
      }
      
      private static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      public static function ShowHUDMessage(param1:String, param2:Boolean = false) : void
      {
         if(Logger.DEBUG_MODE || param2)
         {
            GlobalFunc.ShowHUDMessage("[" + FULL_MOD_NAME + "] " + param1);
         }
      }
      
      public function get config() : Object
      {
         return InventOmaticConfig.get();
      }
      
      public function get parentClip() : MovieClip
      {
         return this._parent;
      }
      
      public function log(param1:String) : void
      {
         Logger.get().info(param1);
      }
      
      public function logEvent(param1:Object) : void
      {
         Logger.get().info("logEvent");
         Logger.get().info(toString(param1));
         Logger.get().info(param1.type);
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         var movieRoot:*;
         try
         {
            movieRoot = stage.getChildAt(0).getChildAt(0);
            if(Boolean(movieRoot) && getQualifiedClassName(movieRoot) == "SecureTrade")
            {
               this._parent = movieRoot;
               this._itemExtractor = new ItemExtractor(this._parent);
               this._customFormatExtractor = new CustomFormatExtractor(this._parent);
               this._itemWorker = new ItemWorker(this._parent);
               this.buttonHintBar = this._parent.ButtonHintBar_mc;
               this.loadConfig();
            }
            else
            {
               Logger.get().error("Not injected into SecureTrade");
               ShowHUDMessage("Error: Not injected into SecureTrade",true);
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error setting parent " + e);
            ShowHUDMessage("Error setting parent " + e,true);
         }
         setTimeout(rescale,10);
      }
      
      public function rescale() : void
      {
         stage.scaleMode = "showAll";
      }
      
      private function onCharacterInfoDataUpdate(param1:Event) : void
      {
         setTimeout(updateVendorCurrencyTextField,10);
         setTimeout(CategoryWeight.updateWeightLabels,20);
      }
      
      private function onHUDMessageProviderUpdate(param1:Event) : void
      {
         if(config != null && Boolean(config.notifyLegendaryModLearnedOnScrap))
         {
            var i:int = 0;
            while(i < param1.data.messages.length)
            {
               if(param1.data.messages[i].messageText.indexOf("¬") != -1 && CRAFTING_ITEM_UNLOCKED_REGEX.test(param1.data.messages[i].messageText))
               {
                  Logger.get().debugMode = true;
                  Logger.get().info(param1.data.messages[i].messageText);
               }
               i++;
            }
         }
      }
      
      public function get isMaxCurrencyProtection() : Boolean
      {
         return this.config && this.config.protectionConfig && this.config.protectionConfig.saleProtection && this.config.protectionConfig.saleProtection.enabled && this.config.protectionConfig.saleProtection.maxCurrency;
      }
      
      public function isItemProtected(item:Object) : Boolean
      {
         var t1:*;
         try
         {
            if(!this.config || !this.config.protectionConfig)
            {
               Logger.get().error("Unable to check item protection, config not loaded");
               return false;
            }
            t1 = getTimer();
            if(this.config.protectionConfig.transferProtection && offerHeader != "")
            {
               this.config.protectionConfig.transferProtection.containerName = offerHeader;
            }
            if(this.parentClip.MenuMode == SecureTradeShared.MODE_NPCVENDING)
            {
               if(ItemProtection.isProtected(item,this.config.protectionConfig.saleProtection))
               {
                  if(this.config.protectionConfig.debug)
                  {
                     Logger.get().info(item.text + " is Sale protected: " + ItemProtection.ProtectionReason + " (" + (getTimer() - t1) + "ms)");
                  }
                  return true;
               }
            }
            else if(this.parentClip.IsWorkbench || this.parentClip.isScrapStash)
            {
               if(ItemProtection.isProtected(item,this.config.protectionConfig.scrapProtection))
               {
                  if(this.config.protectionConfig.debug)
                  {
                     Logger.get().info(item.text + " is Scrap protected: " + ItemProtection.ProtectionReason + " (" + (getTimer() - t1) + "ms)");
                  }
                  return true;
               }
            }
            else if(ItemProtection.isProtected(item,this.config.protectionConfig.transferProtection))
            {
               if(this.config.protectionConfig.debug)
               {
                  Logger.get().info(item.text + " is Transfer protected: " + ItemProtection.ProtectionReason + " (" + (getTimer() - t1) + "ms)");
               }
               return true;
            }
            if(this.config.protectionConfig.debug)
            {
               Logger.get().info(item.text + " is not protected (" + (getTimer() - t1) + "ms)");
            }
            return false;
         }
         catch(e:Error)
         {
            Logger.get().error("Error checking Item Protection " + e);
            ShowHUDMessage("Error checking Item Protection " + e,true);
         }
         return false;
      }
      
      public function getLegendaryItemDescription(desc:String) : String
      {
         return LegendaryMods.getLegendaryItemDescription(desc);
      }
      
      public function formatLegendaryItemDescription(description_tf:TextField) : void
      {
         LegendaryMods.formatLegendaryItemDescription(description_tf);
      }
      
      private function loadConfig() : void
      {
         var loaderComplete:Function;
         var t1:*;
         var t2:*;
         var t3:*;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         try
         {
            t1 = getTimer();
            loaderComplete = function(param1:Event):void
            {
               var _loc2_:Object;
               try
               {
                  _loc2_ = new JSONDecoder(loader.data,true).getValue();
                  t2 = getTimer();
                  Logger.get().debugMode = _loc2_.debug;
                  InventOmaticConfig.init(_loc2_);
                  init();
                  t3 = getTimer();
                  if(!config.hideLoadMessage)
                  {
                     ShowHUDMessage("Config file is loaded!");
                  }
                  Logger.get().info("Config file is loaded! v" + Version.VERSION + " (" + (t2 - t1) + "ms/init:" + (t3 - t2) + "ms)");
               }
               catch(e:Error)
               {
                  Logger.get().error("Error initializing config " + e);
                  ShowHUDMessage("Error initializing config " + e,true);
               }
            };
            url = new URLRequest("../inventOmaticStashConfig.json");
            loader = new URLLoader();
            loader.load(url);
            loader.addEventListener(Event.COMPLETE,loaderComplete);
            timer = new Timer(50);
            timer.addEventListener(TimerEvent.TIMER,timerElapsed);
            timer.start();
         }
         catch(e:Error)
         {
            Logger.get().error("Error loading config: " + e.getStackTrace());
            ShowHUDMessage("Error loading config: " + e.getStackTrace(),true);
         }
      }
      
      public function updateButtonHints() : Boolean
      {
         var button:int;
         var i:int;
         var end:Boolean = false;
         try
         {
            if(this.extractButton)
            {
               this.extractButton.ButtonVisible = Parser.parseBoolean(config.extractConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.lootItemsButton)
            {
               this.lootItemsButton.ButtonVisible = this.parentClip.CorpseLootMode && Parser.parseBoolean(config.lootConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.scrapItemsButton)
            {
               this.scrapItemsButton.ButtonVisible = this.parentClip.IsWorkbench && Parser.parseBoolean(config.scrapConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.npcSellItemsButton)
            {
               this.npcSellItemsButton.ButtonVisible = this.parentClip.MenuMode == SecureTradeShared.MODE_NPCVENDING && Parser.parseBoolean(config.npcSellConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.buyItemsButton)
            {
               this.buyItemsButton.ButtonVisible = Parser.parseBoolean(config.buyConfig.showButton,DEFAULT_SHOW_BUTTON_STATE) && (this.parentClip.MenuMode == SecureTradeShared.MODE_NPCVENDING || this.parentClip.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && !this.parentClip.OwnsVendor);
               end = true;
            }
            if(this.campAssignItemsButton)
            {
               this.campAssignItemsButton.ButtonVisible = Parser.parseBoolean(config.campAssignConfig.showButton,DEFAULT_SHOW_BUTTON_STATE) && (this.parentClip.MenuMode == SecureTradeShared.MODE_FREEZER || this.parentClip.MenuMode == SecureTradeShared.MODE_FERMENTER || this.parentClip.MenuMode == SecureTradeShared.MODE_REFRIGERATOR || this.parentClip.MenuMode == SecureTradeShared.MODE_DISPLAY_CASE || this.parentClip.MenuMode == SecureTradeShared.MODE_CAMP_DISPENSER || this.parentClip.MenuMode == SecureTradeShared.MODE_RECHARGER);
               end = true;
            }
            if(this.transferButtons && this.transferButtons.length > 0)
            {
               button = 0;
               i = 0;
               while(i < config.transferConfig.length)
               {
                  if(config.transferConfig[i].enabled)
                  {
                     if(this.transferButtons[button])
                     {
                        if(this.parentClip.IsWorkbench || this.parentClip.MenuMode == SecureTradeShared.MODE_NPCVENDING || this.parentClip.MenuMode == SecureTradeShared.MODE_PLAYERVENDING || this.parentClip.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && !this.parentClip.OwnsVendor)
                        {
                           this.transferButtons[button].ButtonVisible = false;
                        }
                        else
                        {
                           this.transferButtons[button].ButtonVisible = Parser.parseBoolean(config.transferConfig[i].showButton,DEFAULT_SHOW_BUTTON_STATE) && ItemWorker.isTheSameCharacterName(config.transferConfig[i]);
                        }
                     }
                     button++;
                  }
                  i++;
               }
               end = true;
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error updating buttons " + e);
            ShowHUDMessage("Error updating buttons " + e,true);
         }
         return end;
      }
      
      public function updateVendorCurrencyTextField() : *
      {
         var playerCurrency_tf:TextField;
         var playerCurrency:uint;
         var playerCurrencyMax:uint;
         try
         {
            if(!this.parentClip || !this.parentClip.PlayerInventory_mc || !this.parentClip.PlayerInventory_mc.PlayerCurrency_tf || !this.config || !this.config.currencyLimitConfig || !this.config.currencyLimitConfig.enabled)
            {
               return;
            }
            playerCurrency_tf = this.parentClip.PlayerInventory_mc.PlayerCurrency_tf;
            playerCurrency = uint(this.parentClip.PlayerInventory_mc.currency);
            playerCurrencyMax = uint(this.parentClip.PlayerInventory_mc.currencyMax);
            CurrencyLimit.setTextfieldLimitColor(playerCurrency_tf,playerCurrency,playerCurrencyMax);
         }
         catch(e:Error)
         {
            Logger.get().error("Error updating vendor currency " + e);
            ShowHUDMessage("Error updating vendor currency " + e,true);
         }
      }
      
      private function timerElapsed(event:TimerEvent) : void
      {
         stage.scaleMode = "showAll";
         var end:Boolean = updateButtonHints();
         if(end)
         {
            timer.removeEventListener(TimerEvent.TIMER,timerElapsed);
            timer = null;
         }
      }
      
      private function init() : void
      {
         ItemCardData.init();
         ArmorGrade.initLocalization(config.localizationConfig);
         this._itemExtractor.init(config.extractConfig);
         this._customFormatExtractor.init(config.extractConfig);
         this.initTabs();
         this.initCurrencyLimit();
         this.initButtonHints();
         this.initDurabilityValue();
         this.initScrollPosition();
         this.initHideTakeAll();
         this.initDefaultVendorItemPrice();
         this.initDefaultSelectedTab();
         this.initItemProtection();
         this.initUIChanges();
         CategoryWeight.init(this._parent);
         LegendaryMods.init();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
      }
      
      private function initTabs() : *
      {
         var maxTabs:int;
         var labelWidthScale:Number;
         try
         {
            if(config && config.tabsConfig && config.tabsConfig.enabled)
            {
               maxTabs = Parser.parsePositiveNumber(config.tabsConfig.maxTabs,this.parentClip.maxTabs);
               this.parentClip.maxTabs = maxTabs;
               this.parentClip.CategoryBar_mc.maxVisible = maxTabs;
               labelWidthScale = Parser.parsePositiveNumber(config.tabsConfig.labelWidthScale,1.1);
               this.parentClip.CategoryBar_mc.labelWidthScale = labelWidthScale;
               Logger.get().info("Loaded tabsConfig, values set: maxTabs (" + maxTabs + "), labelWidthScale (" + labelWidthScale + ")");
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error initTabs",e);
            ShowHUDMessage("Error initTabs " + e,true);
         }
      }
      
      private function initCurrencyLimit() : *
      {
         try
         {
            if(config && config.currencyLimitConfig && config.currencyLimitConfig.enabled)
            {
               CurrencyLimit.init(config.currencyLimitConfig);
               this.parentClip.CurrencyLimitIndicator = true;
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error initCurrencyLimit",e);
            ShowHUDMessage("Error initCurrencyLimit " + e,true);
         }
      }
      
      private function initButtonHints() : void
      {
         var buttons:Vector.<BSButtonHintData>;
         var indexConfig:int;
         var transferConfigName:String;
         var hotkey:Number;
         var button:*;
         if(this.buttonHintBar == null)
         {
            Logger.get().error("Error getting button hint bar from parent.");
            return;
         }
         buttons = new Vector.<BSButtonHintData>();
         try
         {
            buttons = this._parent.ButtonHintData;
         }
         catch(e:Error)
         {
            Logger.get().error("Error getting button hints from parent: " + e);
            return;
         }
         try
         {
            if(config.hideUnknownGamepadButtonIcons)
            {
               Buttons.HideUnknownGamepadButtonIcons = true;
            }
            if(config.extractConfig && config.extractConfig.enabled)
            {
               this.extractButton = new BSButtonHintData(config.extractConfig.name,Buttons.getButtonKey(InventOmaticConfig.ExtractKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.ExtractKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.ExtractKeyCode),1,this.extractDataCallback);
               this.extractButton.ButtonVisible = Parser.parseBoolean(config.extractConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.extractButton.ButtonDisabled = false;
               buttons.push(this.extractButton);
            }
            if(config.scrapConfig && config.scrapConfig.enabled)
            {
               this.scrapItemsButton = new BSButtonHintData(config.scrapConfig.name,Buttons.getButtonKey(InventOmaticConfig.ScrapKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.ScrapKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.ScrapKeyCode),1,this.scrapItemsCallback);
               this.scrapItemsButton.ButtonVisible = Parser.parseBoolean(config.scrapConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.scrapItemsButton.ButtonDisabled = false;
               buttons.push(this.scrapItemsButton);
            }
            if(config.lootConfig && config.lootConfig.enabled)
            {
               this.lootItemsButton = new BSButtonHintData(config.lootConfig.name,Buttons.getButtonKey(InventOmaticConfig.LootKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.LootKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.LootKeyCode),1,this.lootItemsCallback);
               this.lootItemsButton.ButtonVisible = Parser.parseBoolean(config.lootConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.lootItemsButton.ButtonDisabled = false;
               buttons.push(this.lootItemsButton);
            }
            if(config.npcSellConfig && config.npcSellConfig.enabled)
            {
               this.npcSellItemsButton = new BSButtonHintData(config.npcSellConfig.name,Buttons.getButtonKey(InventOmaticConfig.NpcSellKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.NpcSellKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.NpcSellKeyCode),1,this.npcSellItemsCallback);
               this.npcSellItemsButton.ButtonVisible = Parser.parseBoolean(config.npcSellConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.npcSellItemsButton.ButtonDisabled = false;
               buttons.push(this.npcSellItemsButton);
            }
            if(config.campAssignConfig && config.campAssignConfig.enabled)
            {
               this.campAssignItemsButton = new BSButtonHintData(config.campAssignConfig.name,Buttons.getButtonKey(InventOmaticConfig.CampAssignKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.CampAssignKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.CampAssignKeyCode),1,this.campAssignItemsCallback);
               this.campAssignItemsButton.ButtonVisible = Parser.parseBoolean(config.campAssignConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.campAssignItemsButton.ButtonDisabled = false;
               buttons.push(this.campAssignItemsButton);
            }
            if(config.buyConfig && config.buyConfig.enabled)
            {
               this.buyItemsButton = new BSButtonHintData(config.buyConfig.name,Buttons.getButtonKey(InventOmaticConfig.BuyKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.BuyKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.BuyKeyCode),1,this.buyItemsCallback);
               this.buyItemsButton.ButtonVisible = Parser.parseBoolean(config.buyConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.buyItemsButton.ButtonDisabled = false;
               buttons.push(this.buyItemsButton);
            }
            if(config.transferConfig && config.transferConfig.length > 0)
            {
               this.transferButtons = new Vector.<BSButtonHintData>();
               indexConfig = 0;
               while(indexConfig < config.transferConfig.length)
               {
                  if(config.transferConfig[indexConfig].enabled)
                  {
                     button = new BSButtonHintData(config.transferConfig[indexConfig].name,Buttons.getButtonKey(config.transferConfig[indexConfig].hotkey),Buttons.getButtonGamepad(config.transferConfig[indexConfig].hotkey),Buttons.getButtonGamepad(config.transferConfig[indexConfig].hotkey),1,null);
                     button.ButtonVisible = ItemWorker.isTheSameCharacterName(config.transferConfig[indexConfig]) && Parser.parseBoolean(config.transferConfig[indexConfig].showButton,DEFAULT_SHOW_BUTTON_STATE);
                     button.ButtonDisabled = false;
                     this.transferButtons.push(button);
                     buttons.push(button);
                  }
                  indexConfig++;
               }
            }
            this.buttonHintBar.SetButtonHintData(buttons);
            this.buttonHintBar.onRemovedFromStage();
            this.buttonHintBar.onAddedToStage();
            this.buttonHintBar.redrawDisplayObject();
         }
         catch(e:Error)
         {
            Logger.get().error("Error setting new button hints data: " + e);
            ShowHUDMessage("Error setting new button hints data: " + e,true);
         }
      }
      
      private function initDurabilityValue() : void
      {
         try
         {
            this._parent.showDurabilityValue(Parser.parseBoolean(config.showDurabilityValue,true));
         }
         catch(e:Error)
         {
            Logger.get().error("Error initDurabilityValue: " + e);
            ShowHUDMessage("Error initDurabilityValue: " + e,true);
         }
      }
      
      private function initItemProtection() : void
      {
         try
         {
            if(config != null && config.protectionConfig != null)
            {
               ItemProtection.init(this._parent);
               this._parent.CheckItemProtectionOnSelectionChange = Parser.parseBoolean(config.protectionConfig.checkOnSelectionChange,true);
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error initItemProtection: " + e);
            ShowHUDMessage("Error initItemProtection: " + e,true);
         }
      }
      
      private function initScrollPosition() : void
      {
         try
         {
            this._parent.MaintainScrollPosition = Parser.parseBoolean(config.maintainScrollPosition,false);
         }
         catch(e:Error)
         {
            Logger.get().error("Error initScrollPosition: " + e);
            ShowHUDMessage("Error initScrollPosition: " + e,true);
         }
      }
      
      private function initHideTakeAll() : void
      {
         try
         {
            this._parent.HideTakeAllConfirm = Parser.parseBoolean(config.hideTakeAllConfirm,false);
         }
         catch(e:Error)
         {
            Logger.get().error("Error initHideTakeAll: " + e);
            ShowHUDMessage("Error initHideTakeAll: " + e,true);
         }
      }
      
      private function initDefaultVendorItemPrice() : void
      {
         try
         {
            this._parent.DefaultVendorItemPrice = Parser.parseNumber(config.defaultVendorItemPrice,-1);
         }
         catch(e:Error)
         {
            Logger.get().error("Error initDefaultVendorItemPrice: " + e);
            ShowHUDMessage("Error initDefaultVendorItemPrice: " + e,true);
         }
      }
      
      private function initDefaultSelectedTab() : void
      {
         var tabName:*;
         try
         {
            tabName = config.defaultSelectedTab;
            if(tabName != null && tabName is String && tabName.length > 0)
            {
               setTimeout(function():void
               {
                  if(ItemTypes.ITEM_TYPES[tabName] != null)
                  {
                     var selectedID:uint = uint(ItemTypes.ITEM_TYPES[tabName][0]);
                  }
                  else if(tabName == "INVENTORY")
                  {
                     selectedID = uint.MAX_VALUE;
                  }
                  else
                  {
                     if(tabName != "FAVORITES")
                     {
                        return;
                     }
                     selectedID = 1;
                  }
                  var selectedTab:uint = uint(_parent.CategoryBar_mc.GetLabelIndex(selectedID));
                  _parent.selectedTab = selectedTab;
                  _parent.CategoryBar_mc.SelectedID = selectedID;
                  Logger.get().info("defaultSelectedTab set to " + tabName);
               },500);
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error initDefaultSelectedTab: " + e);
            ShowHUDMessage("Error initDefaultSelectedTab: " + e,true);
         }
      }
      
      private function initUIChanges() : void
      {
         try
         {
            if(getQualifiedClassName(this._parent.getChildAt(0)) == "flash.display::MovieClip" && Boolean(config.hideVignette))
            {
               this._parent.getChildAt(0).visible = false;
            }
            if(Boolean(config.hideHeader))
            {
               this._parent.Header_mc.visible = false;
            }
            if(config.showAdditionalColumns != null)
            {
               this._parent.ShowAdditionalColumns = config.showAdditionalColumns;
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error initUIChanges: " + e);
            ShowHUDMessage("Error initUIChanges: " + e,true);
         }
      }
      
      public function extractDataCallback() : void
      {
         var extractorToUse:BaseItemExtractor = null;
         try
         {
            if(!config.extractConfig.enabled)
            {
               return;
            }
            Logger.get().info("Extract Items Callback!");
            if(config.extractConfig.useCustomFormat)
            {
               extractorToUse = this._customFormatExtractor;
            }
            else
            {
               extractorToUse = this._itemExtractor;
            }
            extractorToUse.setInventory(this.parentClip);
         }
         catch(e:Error)
         {
            Logger.get().error("Error extracting items(init): " + e);
            ShowHUDMessage("Error extracting items(init): " + e,true);
         }
      }
      
      public function transferItemsCallback(keyCode:uint = 0) : void
      {
         try
         {
            if(this.parentClip.IsWorkbench || this.parentClip.MenuMode == SecureTradeShared.MODE_NPCVENDING || this.parentClip.MenuMode == SecureTradeShared.MODE_PLAYERVENDING || this.parentClip.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && !this.parentClip.OwnsVendor)
            {
               return;
            }
            Logger.get().info("Transfer Items Callback! (key " + keyCode + (_shift ? " + shift)" : ")"));
            setTimeout(function():void
            {
               _itemWorker.transferItems(keyCode,_shift);
            },10);
         }
         catch(e:Error)
         {
            Logger.get().error("Error transferring items: " + e);
            ShowHUDMessage("Error transferring items: " + e,true);
         }
      }
      
      public function lootItemsCallback() : void
      {
         try
         {
            if(!this.parentClip.CorpseLootMode)
            {
               return;
            }
            Logger.get().info("Filtered Loot Items Callback!");
            setTimeout(this._itemWorker.lootItems,10);
         }
         catch(e:Error)
         {
            Logger.get().error("Error looting items: " + e);
            ShowHUDMessage("Error looting items: " + e,true);
         }
      }
      
      public function scrapItemsCallback() : void
      {
         try
         {
            if(!this.parentClip.IsWorkbench)
            {
               return;
            }
            Logger.get().info("Scrap Items Callback!");
            setTimeout(this._itemWorker.scrapItems,10);
         }
         catch(e:Error)
         {
            Logger.get().error("Error scrapping items: " + e);
            ShowHUDMessage("Error scrapping items: " + e,true);
         }
      }
      
      public function npcSellItemsCallback() : void
      {
         try
         {
            setTimeout(function():void
            {
               if(parentClip.MenuMode != SecureTradeShared.MODE_NPCVENDING)
               {
                  return;
               }
               Logger.get().info("NPC Sell Items Callback!");
               _itemWorker.npcSellItems();
            },10);
         }
         catch(e:Error)
         {
            Logger.get().error("Error selling items: " + e);
            ShowHUDMessage("Error selling items: " + e,true);
         }
      }
      
      public function campAssignItemsCallback() : void
      {
         try
         {
            if(this.parentClip.MenuMode != SecureTradeShared.MODE_FREEZER && this.parentClip.MenuMode != SecureTradeShared.MODE_FERMENTER && this.parentClip.MenuMode != SecureTradeShared.MODE_REFRIGERATOR && this.parentClip.MenuMode != SecureTradeShared.MODE_DISPLAY_CASE && this.parentClip.MenuMode != SecureTradeShared.MODE_CAMP_DISPENSER && this.parentClip.MenuMode != SecureTradeShared.MODE_RECHARGER)
            {
               return;
            }
            if(this.parentClip.selectedList == this.parentClip.OfferInventory_mc)
            {
               Logger.get().error("Unable to assign items from stash");
               return;
            }
            if(this.parentClip.selectedListEntry)
            {
               Logger.get().info("Camp Assign Items Callback!");
               setTimeout(this._itemWorker.campAssignItems,10);
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error assigning items: " + e);
            ShowHUDMessage("Error assigning items: " + e,true);
         }
      }
      
      public function buyItemsCallback() : void
      {
         var playerCurrency:Number;
         try
         {
            if(this.parentClip.MenuMode != SecureTradeShared.MODE_NPCVENDING && (this.parentClip.MenuMode != SecureTradeShared.MODE_VENDING_MACHINE || this.parentClip.OwnsVendor))
            {
               return;
            }
            Logger.get().info("Buy Items Callback! Mode: " + (this.parentClip.MenuMode == SecureTradeShared.MODE_NPCVENDING ? "NPC Vendor" : "CAMP Vendor"));
            setTimeout(this._itemWorker.vendorBuyItems,10);
         }
         catch(e:Error)
         {
            Logger.get().error("Error buying items: " + e);
            ShowHUDMessage("Error buying items: " + e,true);
         }
      }
      
      public function calculateCatWeightCallback() : void
      {
         var delay:Number = 0;
         try
         {
            if(!config.categoryWeightConfig || !config.categoryWeightConfig.enabled)
            {
               return;
            }
            Logger.get().info("Calculate Category Weight callback");
            if(this.parentClip.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter == 4)
            {
               delay = Number(CategoryWeight.calculateCurrentCategoryWeight(false));
            }
            if(config.categoryWeightConfig.debug)
            {
               Logger.get().info("Calculating category weight for selected tab: " + this.parentClip.selectedTab + ", filter player: " + this.parentClip.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter + ", filter offer: " + this.parentClip.OfferInventory_mc.ItemList_mc.List_mc.filterer.itemFilter + ", delay: " + delay);
            }
            setTimeout(CategoryWeight.calculateCurrentCategoryWeight,delay);
         }
         catch(e:Error)
         {
            Logger.get().error("Error calculating cat weight: " + e);
            ShowHUDMessage("Error calculating cat weight: " + e,true);
         }
      }
      
      public function onSelectedTabChanged() : void
      {
         CategoryWeight.updateWeightLabels();
      }
      
      public function updateModHeaders() : void
      {
         var playerInv:*;
         var stashInv:*;
         var countPlayer:int;
         var countStash:int;
         var index:int;
         var playerInvFilter:int;
         var stashInvFilter:int;
         try
         {
            if(offerHeader == "")
            {
               offerHeader = this.parentClip.OfferInventory_mc.Header_mc.Header_tf.text;
               ItemWorker.ContainerName = offerHeader;
               Logger.get().info("Offer header: " + offerHeader);
            }
            if(!config || !config.showCategoryItemCount)
            {
               return;
            }
            playerInvFilter = int(this.parentClip.PlayerInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
            stashInvFilter = int(this.parentClip.OfferInventory_mc.ItemList_mc.List_mc.filterer.itemFilter);
            if(playerInvFilter == -1 || modHeaders.player[playerInvFilter] == null || modHeaders.player[playerInvFilter] == 0)
            {
               playerInv = this.parentClip.PlayerInventory_mc.ItemList_mc.List_mc.MenuListData;
               stashInv = this.parentClip.OfferInventory_mc.ItemList_mc.List_mc.MenuListData;
               countPlayer = 0;
               if(playerInvFilter == -1)
               {
                  countPlayer = int(playerInv.length);
               }
               else
               {
                  index = 0;
                  while(index < playerInv.length)
                  {
                     if((playerInv[index].filterFlag & playerInvFilter) != 0)
                     {
                        countPlayer++;
                     }
                     index++;
                  }
               }
               modHeaders.player[playerInvFilter] = countPlayer;
               countStash = 0;
               if(stashInvFilter == -1)
               {
                  countStash = int(stashInv.length);
               }
               else
               {
                  index = 0;
                  while(index < stashInv.length)
                  {
                     if((stashInv[index].filterFlag & stashInvFilter) != 0)
                     {
                        countStash++;
                     }
                     index++;
                  }
               }
               modHeaders.stash[stashInvFilter] = countStash;
            }
            if(false)
            {
               Logger.get().info("player[" + playerInvFilter + "]: " + modHeaders.player[playerInvFilter] + ", stash[" + stashInvFilter + "]: " + modHeaders.stash[stashInvFilter]);
            }
            if(this.parentClip.PlayerInventory_mc.Header_mc.Header_tf.text.indexOf(" [") == -1)
            {
               this.parentClip.PlayerInventory_mc.header = this.parentClip.PlayerInventory_mc.Header_mc.Header_tf.text + " [" + modHeaders.player[playerInvFilter] + "]";
            }
            if(this.parentClip.OfferInventory_mc.Header_mc.Header_tf.text.indexOf(" [") == -1)
            {
               this.parentClip.OfferInventory_mc.header = this.parentClip.OfferInventory_mc.Header_mc.Header_tf.text + " [" + modHeaders.stash[stashInvFilter] + "]";
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error setting category label: " + e);
         }
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SHIFT)
         {
            _shift = true;
         }
         if(this.config)
         {
            if(this.config.debugKeys)
            {
               Logger.get().info("KeyDown: " + param1.keyCode + "(" + Buttons.getButtonKey(param1.keyCode) + "), shift: " + _shift);
            }
            if(InventOmaticConfig.SwapToPlayerInventoryHotkey != InventOmaticConfig.SwapToContainerInventoryHotkey)
            {
               if(InventOmaticConfig.SwapToPlayerInventoryHotkey != 0 && param1.keyCode == InventOmaticConfig.SwapToPlayerInventoryHotkey)
               {
                  this.parentClip.onSwapInventoryPlayer();
               }
               else if(InventOmaticConfig.SwapToContainerInventoryHotkey != 0 && param1.keyCode == InventOmaticConfig.SwapToContainerInventoryHotkey)
               {
                  this.parentClip.onSwapInventoryContainer();
               }
            }
            else if(InventOmaticConfig.SwapToPlayerInventoryHotkey != 0 && param1.keyCode == InventOmaticConfig.SwapToPlayerInventoryHotkey)
            {
               if(this.parentClip.selectedList == this.parentClip.OfferInventory_mc)
               {
                  this.parentClip.onSwapInventoryPlayer();
               }
               else
               {
                  this.parentClip.onSwapInventoryContainer();
               }
            }
         }
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SHIFT)
         {
            _shift = false;
         }
         if(this.config && this.config.debugKeys)
         {
            Logger.get().info("KeyUp: " + param1.keyCode + "(" + Buttons.getButtonKey(param1.keyCode) + "), shift: " + _shift);
         }
         if(param1.keyCode == Keyboard.F6)
         {
            if(this.config.down != null)
            {
               _offset--;
               BSUIDataManager.dispatchEvent(new CustomEvent("SecureTrade::OnItemSelected",{
                  "serverHandleID":this.parentClip.selectedListEntry.serverHandleID + _offset,
                  "isSelectionValid":true,
                  "fromContainer":this.parentClip.selectedList == this.parentClip.OfferInventory_mc,
                  "containerID":this.parentClip.selectedListEntry.containerID
               }));
               Logger.get().info("serverHandleID: " + this.parentClip.selectedListEntry.serverHandleID + " + offset: " + _offset + " = " + (this.parentClip.selectedListEntry.serverHandleID + _offset));
            }
         }
         else if(param1.keyCode == Keyboard.F7)
         {
            if(this.config.up != null)
            {
               _offset++;
               BSUIDataManager.dispatchEvent(new CustomEvent("SecureTrade::OnItemSelected",{
                  "serverHandleID":this.parentClip.selectedListEntry.serverHandleID + _offset,
                  "isSelectionValid":true,
                  "fromContainer":this.parentClip.selectedList == this.parentClip.OfferInventory_mc,
                  "containerID":this.parentClip.selectedListEntry.containerID
               }));
               Logger.get().info("serverHandleID: " + this.parentClip.selectedListEntry.serverHandleID + " + offset: " + _offset + " = " + (this.parentClip.selectedListEntry.serverHandleID + _offset));
            }
         }
         else if(param1.keyCode == Keyboard.F8)
         {
            Logger.get().info("F8");
         }
         else if(param1.keyCode == Keyboard.F9)
         {
            var selectedItem:String = new JSONEncoder(this.parentClip.selectedListEntry).getString();
            Logger.get().info(selectedItem);
         }
         else if(param1.keyCode == Keyboard.F10)
         {
            Logger.get().info("Category weights");
            var weights:String = "";
            var totalWt:Number = 0;
            for(var key in CategoryWeight.icategoryWeights)
            {
               weights += ItemTypes.getName(key) + ":" + CategoryWeight.icategoryWeights[key].toFixed(2) + ", ";
               totalWt += CategoryWeight.icategoryWeights[key];
            }
            Logger.get().info("Inventory weights: " + weights + " - TOTAL:" + totalWt.toFixed(2));
            totalWt = 0;
            weights = "";
            for(key in CategoryWeight.categoryWeights)
            {
               weights += ItemTypes.getName(key) + ":" + CategoryWeight.categoryWeights[key].toFixed(2) + ", ";
               totalWt += CategoryWeight.categoryWeights[key];
            }
            Logger.get().info("Stash weights: " + weights + " - TOTAL:" + totalWt.toFixed(2));
         }
         else if(param1.keyCode == Keyboard.F11)
         {
            if(this.config.testEvent != null && this.config.testEventData != null)
            {
               Logger.get().info("Sending event: " + this.config.testEvent);
               for(i in this.config.testEventData)
               {
                  if(this.config.testEventData[i] == "{selectedId}")
                  {
                     this.config.testEventData[i] = this.parentClip.selectedListEntry.serverHandleID;
                  }
                  else if(i == "serverHandleID")
                  {
                     this.config.testEventData[i] = uint(this.config.testEventData[i]);
                  }
               }
               Logger.get().info("Event data: " + toString(this.config.testEventData));
               BSUIDataManager.dispatchEvent(new CustomEvent(this.config.testEvent,this.config.testEventData));
            }
         }
         else if(param1.keyCode == Keyboard.F12)
         {
            if(config.testMethod != null)
            {
               var apiData:* = GameApiDataExtractor.getApiData(config.testMethod);
               var data:String = new JSONEncoder(apiData).getString();
               Logger.get().info("Retrieve data for: " + config.testMethod);
               Logger.get().info(data);
               matches.forEach(Logger.get().info);
            }
         }
         if(this.parentClip.modalActive)
         {
            return;
         }
         if(param1.keyCode == InventOmaticConfig.CalculateCatWeightKeyCode)
         {
            this.calculateCatWeightCallback();
         }
         if(param1.keyCode == InventOmaticConfig.ScrapKeyCode)
         {
            this.scrapItemsCallback();
         }
         if(param1.keyCode == InventOmaticConfig.NpcSellKeyCode)
         {
            if(this.config.npcSellConfig && this.config.npcSellConfig.enabled)
            {
               this.npcSellItemsCallback();
            }
         }
         if(param1.keyCode == InventOmaticConfig.BuyKeyCode)
         {
            if(this.config.buyConfig && this.config.buyConfig.enabled)
            {
               this.buyItemsCallback();
            }
         }
         if(param1.keyCode == InventOmaticConfig.CampAssignKeyCode)
         {
            if(this.config.campAssignConfig && this.config.campAssignConfig.enabled)
            {
               this.campAssignItemsCallback();
            }
         }
         var indexConfig:int = 0;
         while(indexConfig < this.config.transferConfig.length)
         {
            if(this.config.transferConfig[indexConfig] && this.config.transferConfig[indexConfig].enabled && param1.keyCode == this.config.transferConfig[indexConfig].hotkey)
            {
               this.transferItemsCallback(param1.keyCode);
               break;
            }
            indexConfig++;
         }
         if(param1.keyCode == InventOmaticConfig.LootKeyCode)
         {
            if(this.config.lootConfig && this.config.lootConfig.enabled)
            {
               this.lootItemsCallback();
            }
         }
         if(param1.keyCode == InventOmaticConfig.ExtractKeyCode)
         {
            this.extractDataCallback();
         }
         if(param1.keyCode == InventOmaticConfig.ToggleDebugKeyCode)
         {
            Logger.get().debugMode = !Logger.DEBUG_MODE;
         }
      }
   }
}
