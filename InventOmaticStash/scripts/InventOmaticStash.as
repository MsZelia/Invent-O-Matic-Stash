package
{
   import Shared.AS3.*;
   import Shared.AS3.Data.*;
   import Shared.AS3.Events.*;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.JSONDecoder;
   import com.adobe.serialization.json.JSONEncoder;
   import extractors.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.*;
   import flash.ui.Keyboard;
   import flash.utils.*;
   import mx.utils.*;
   import utils.*;
   
   public class InventOmaticStash extends MovieClip
   {
      
      public static const FULL_MOD_NAME:String = "IOMS " + Version.VERSION;
      
      private const DEFAULT_SHOW_BUTTON_STATE:Boolean = InventOmaticConfig.DEFAULT_SHOW_BUTTON_STATE;
      
      private const CRAFTING_ITEM_UNLOCKED_REGEX:* = /(Crafting item unlocked|Objet de fabrication débloqué |Objeto de creación desbloqueado|Objeto de creación desbloqueado|Herstellungsgegenstand freigeschaltet|Oggetto creabile sbloccato|Odblokowujesz nową rzecz do tworzenia|Item de criação desbloqueado|Открыт предмет для изготовления|クラフトアイテムを解除|제작 아이템 잠금 해제|已解锁的物品制作|道具製作已解鎖)/;
      
      public var debugLogger:TextField;
      
      private var _itemExtractor:ItemExtractor;
      
      private var _customFormatExtractor:CustomFormatExtractor;
      
      private var _customFormatConvertExtractor:CustomFormatConvertExtractor;
      
      private var _itemWorker:ItemWorker;
      
      private var _parent:MovieClip;
      
      public var extractButton:BSButtonHintData;
      
      public var transferButton:BSButtonHintData;
      
      public var transferButtons:Vector.<BSButtonHintData>;
      
      public var assignButtons:Vector.<BSButtonHintData>;
      
      public var scrapItemsButton:BSButtonHintData;
      
      public var lootItemsButton:BSButtonHintData;
      
      public var npcSellItemsButton:BSButtonHintData;
      
      public var buyItemsButton:BSButtonHintData;
      
      public var lockItemsButton:BSButtonHintData;
      
      public var buttonHintBar:BSButtonHintBar;
      
      private var _shift:Boolean = false;
      
      private var timer:Timer;
      
      private var _characterName:String;
      
      private var _offset:Number = 0;
      
      private var modHeaders:*;
      
      private var offerHeader:String = "";
      
      private var OtherInventoryTypeData:*;
      
      private var ContainerOptionsData:*;
      
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
            this.OtherInventoryTypeData = BSUIDataManager.GetDataFromClient("OtherInventoryTypeData").data;
            this.ContainerOptionsData = BSUIDataManager.GetDataFromClient("ContainerOptionsData").data;
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
      
      public function get MenuMode() : uint
      {
         return OtherInventoryTypeData.menuType;
      }
      
      public function get SubMenuMode() : uint
      {
         return OtherInventoryTypeData.menuSubType;
      }
      
      public function get OwnsVendor() : Boolean
      {
         return OtherInventoryTypeData.ownsVendor;
      }
      
      public function get IsWorkbench() : Boolean
      {
         return ContainerOptionsData.isWorkbench;
      }
      
      public function get IsScrapStash() : Boolean
      {
         return ContainerOptionsData.storageMode == SecureTradeShared.LIMITED_TYPE_STORAGE_SCRAP;
      }
      
      public function IsAssignSlotDataValid() : Boolean
      {
         return this.OtherInventoryTypeData.slotDataA != null && this.OtherInventoryTypeData.slotDataA.length > 0;
      }
      
      public function AreAssignSlotsFull() : Boolean
      {
         var slot:Object = null;
         for each(slot in this.OtherInventoryTypeData.slotDataA)
         {
            if(slot.slotCountFilled < slot.slotCountMax)
            {
               return false;
            }
         }
         return true;
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
               this._customFormatConvertExtractor = new CustomFormatConvertExtractor(this._parent);
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
         return Boolean(this.config) && Boolean(this.config.protectionConfig) && Boolean(this.config.protectionConfig.saleProtection) && Boolean(this.config.protectionConfig.saleProtection.enabled) && Boolean(this.config.protectionConfig.saleProtection.maxCurrency);
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
            if(this.MenuMode == SecureTradeShared.MODE_NPCVENDING)
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
            else if(this.IsWorkbench || this.IsScrapStash)
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
                  Logger.get().setPosition(Parser.parseNumber(_loc2_.debugX,0),Parser.parseNumber(_loc2_.debugY,0));
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
         var isValidMode:Boolean;
         var cnf:Object;
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
               this.lootItemsButton.ButtonVisible = Boolean(this.parentClip.CorpseLootMode) && Parser.parseBoolean(config.lootConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.scrapItemsButton)
            {
               this.scrapItemsButton.ButtonVisible = Boolean(this.IsWorkbench) && Parser.parseBoolean(config.scrapConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.npcSellItemsButton)
            {
               this.npcSellItemsButton.ButtonVisible = this.MenuMode == SecureTradeShared.MODE_NPCVENDING && Parser.parseBoolean(config.npcSellConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.buyItemsButton)
            {
               this.buyItemsButton.ButtonVisible = Parser.parseBoolean(config.buyConfig.showButton,DEFAULT_SHOW_BUTTON_STATE) && (this.MenuMode == SecureTradeShared.MODE_NPCVENDING || this.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && !this.OwnsVendor);
               end = true;
            }
            if(this.lockItemsButton)
            {
               this.lockItemsButton.ButtonVisible = Parser.parseBoolean(config.protectionConfig.itemLocking.showButton,DEFAULT_SHOW_BUTTON_STATE);
               end = true;
            }
            if(this.assignButtons && this.assignButtons.length > 0)
            {
               if(this.IsAssignSlotDataValid() && !this.AreAssignSlotsFull())
               {
                  button = 0;
                  i = 0;
                  while(i < config.campAssignConfig.configs.length)
                  {
                     cnf = config.campAssignConfig.configs[i];
                     if(cnf.enabled)
                     {
                        if(this.assignButtons[button])
                        {
                           if(cnf.assignMode == CampAssignContainer.VENDOR)
                           {
                              isValidMode = this.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && this.OwnsVendor && ItemWorker.isTheSameCharacterName(cnf) && ItemWorker.isValidContainerName(cnf);
                              this.assignButtons[button].ButtonEnabled = isValidMode;
                              this.assignButtons[button].ButtonVisible = this.assignButtons[button].ButtonEnabled && Parser.parseBoolean(cnf.showButton,DEFAULT_SHOW_BUTTON_STATE);
                           }
                           else if(cnf.assignMode == CampAssignContainer.DISPLAY)
                           {
                              isValidMode = (this.MenuMode == SecureTradeShared.MODE_DISPLAY_CASE || this.MenuMode == SecureTradeShared.MODE_ALLY || this.MenuMode == SecureTradeShared.MODE_PET) && ItemWorker.isTheSameCharacterName(cnf) && ItemWorker.isValidContainerName(cnf);
                              this.assignButtons[button].ButtonEnabled = isValidMode;
                              this.assignButtons[button].ButtonVisible = this.assignButtons[button].ButtonEnabled && Parser.parseBoolean(cnf.showButton,DEFAULT_SHOW_BUTTON_STATE);
                           }
                           else if(cnf.assignMode == CampAssignContainer.OTHER)
                           {
                              isValidMode = (this.MenuMode == SecureTradeShared.MODE_FERMENTER || this.MenuMode == SecureTradeShared.MODE_FREEZER || this.MenuMode == SecureTradeShared.MODE_REFRIGERATOR || this.MenuMode == SecureTradeShared.MODE_RECHARGER || this.MenuMode == SecureTradeShared.MODE_CAMP_DISPENSER) && ItemWorker.isTheSameCharacterName(cnf) && ItemWorker.isValidContainerName(cnf);
                              this.assignButtons[button].ButtonEnabled = isValidMode;
                              this.assignButtons[button].ButtonVisible = this.assignButtons[button].ButtonEnabled && Parser.parseBoolean(cnf.showButton,DEFAULT_SHOW_BUTTON_STATE);
                           }
                           else
                           {
                              Logger.get().info("Invalid assignMode: " + cnf.assignMode);
                              this.assignButtons[button].ButtonEnabled = false;
                              this.assignButtons[button].ButtonVisible = false;
                           }
                        }
                        button++;
                     }
                     i++;
                  }
                  end = true;
               }
               else
               {
                  i = 0;
                  while(i < this.assignButtons.length)
                  {
                     this.assignButtons[i].ButtonEnabled = false;
                     this.assignButtons[i].ButtonVisible = false;
                     i++;
                  }
               }
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
                        if(this.IsWorkbench || this.MenuMode == SecureTradeShared.MODE_NPCVENDING || this.MenuMode == SecureTradeShared.MODE_PLAYERVENDING || this.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && !this.OwnsVendor)
                        {
                           this.transferButtons[button].ButtonVisible = false;
                        }
                        else
                        {
                           this.transferButtons[button].ButtonVisible = Parser.parseBoolean(config.transferConfig[i].showButton,DEFAULT_SHOW_BUTTON_STATE) && ItemWorker.isTheSameCharacterName(config.transferConfig[i]) && ItemWorker.isValidContainerName(config.transferConfig[i]);
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
         CampAssignContainer.init();
         ArmorGrade.initLocalization(config.localizationConfig);
         this._itemExtractor.init(config.extractConfig);
         this._customFormatExtractor.init(config.extractConfig);
         this._customFormatConvertExtractor.init(config.extractConfig);
         this.initItemCountThreshold();
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
      
      private function initItemCountThreshold() : *
      {
         var isSet:Boolean;
         try
         {
            if(config)
            {
               isSet = false;
               if(config.scrapItemCountThresholdPopup != null && !isNaN(config.scrapItemCountThresholdPopup) && config.scrapItemCountThresholdPopup != 5)
               {
                  this.parentClip.SCRAP_ITEM_COUNT_THRESHOLD = config.scrapItemCountThresholdPopup;
                  isSet = true;
               }
               if(config.transferItemCountThresholdPopup != null && !isNaN(config.transferItemCountThresholdPopup) && config.transferItemCountThresholdPopup != 4)
               {
                  this.parentClip.TRANSFER_ITEM_COUNT_THRESHOLD = config.transferItemCountThresholdPopup;
                  isSet = true;
               }
               if(isSet)
               {
                  Logger.get().info("ItemCountThreshold set: " + config.scrapItemCountThresholdPopup + ", " + config.transferItemCountThresholdPopup);
               }
            }
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error initItemCountThreshold",e);
            ShowHUDMessage("Error initItemCountThreshold " + e,true);
         }
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
            if(ItemProtection.isValidLockConfig(config.protectionConfig))
            {
               this.lockItemsButton = new BSButtonHintData(config.protectionConfig.itemLocking.name,Buttons.getButtonKey(InventOmaticConfig.LockAllKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.LockAllKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.LockAllKeyCode),1,this.lockItemsCallback);
               this.lockItemsButton.ButtonVisible = Parser.parseBoolean(config.protectionConfig.itemLocking.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.lockItemsButton.ButtonDisabled = false;
               buttons.push(this.lockItemsButton);
            }
            if(config.buyConfig && config.buyConfig.enabled)
            {
               this.buyItemsButton = new BSButtonHintData(config.buyConfig.name,Buttons.getButtonKey(InventOmaticConfig.BuyKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.BuyKeyCode),Buttons.getButtonGamepad(InventOmaticConfig.BuyKeyCode),1,this.buyItemsCallback);
               this.buyItemsButton.ButtonVisible = Parser.parseBoolean(config.buyConfig.showButton,DEFAULT_SHOW_BUTTON_STATE);
               this.buyItemsButton.ButtonDisabled = false;
               buttons.push(this.buyItemsButton);
            }
            if(config.campAssignConfig && config.campAssignConfig.enabled && config.campAssignConfig.configs.length > 0)
            {
               this.assignButtons = new Vector.<BSButtonHintData>();
               indexConfig = 0;
               while(indexConfig < config.campAssignConfig.configs.length)
               {
                  if(config.campAssignConfig.configs[indexConfig].enabled)
                  {
                     button = new BSButtonHintData(config.campAssignConfig.configs[indexConfig].name,Buttons.getButtonKey(config.campAssignConfig.configs[indexConfig].hotkey),Buttons.getButtonGamepad(config.campAssignConfig.configs[indexConfig].hotkey),Buttons.getButtonGamepad(config.campAssignConfig.configs[indexConfig].hotkey),1,null);
                     button.ButtonVisible = ItemWorker.isTheSameCharacterName(config.campAssignConfig.configs[indexConfig]) && Parser.parseBoolean(config.campAssignConfig.configs[indexConfig].showButton,DEFAULT_SHOW_BUTTON_STATE);
                     button.ButtonDisabled = false;
                     this.assignButtons.push(button);
                     buttons.push(button);
                  }
                  indexConfig++;
               }
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
            if(config.additionalColumnsConfig.enabled)
            {
               this._parent.ShowAdditionalColumns = config.additionalColumnsConfig;
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
               if(config.extractConfig.customFormat.format.toLowerCase() == "json_to_csv")
               {
                  extractorToUse = this._customFormatConvertExtractor;
               }
               else
               {
                  extractorToUse = this._customFormatExtractor;
               }
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
            if(this.IsWorkbench || this.MenuMode == SecureTradeShared.MODE_NPCVENDING || this.MenuMode == SecureTradeShared.MODE_PLAYERVENDING || this.MenuMode == SecureTradeShared.MODE_VENDING_MACHINE && !this.OwnsVendor)
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
            if(!this.IsWorkbench)
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
      
      public function campAssignItemsCallback(keyCode:uint = 0) : void
      {
         var validConfigs:Array;
         var i:int;
         var buttonId:int;
         try
         {
            validConfigs = [];
            i = 0;
            buttonId = 0;
            while(i < this.config.campAssignConfig.configs.length)
            {
               if(this.config.campAssignConfig.configs[i] && this.config.campAssignConfig.configs[i].enabled)
               {
                  if(this.assignButtons[buttonId] && this.assignButtons[buttonId].ButtonEnabled && keyCode == this.config.campAssignConfig.configs[i].hotkey)
                  {
                     validConfigs.push(this.config.campAssignConfig.configs[i]);
                  }
                  buttonId++;
               }
               i++;
            }
            if(validConfigs.length == 0)
            {
               return;
            }
            Logger.get().info("Camp Assign Items Callback!");
            setTimeout(this._itemWorker.campAssignItems,10,validConfigs);
         }
         catch(e:Error)
         {
            Logger.get().error("Error assigning items: " + e);
            ShowHUDMessage("Error assigning items: " + e,true);
         }
      }
      
      public function lockItemsCallback() : void
      {
         try
         {
            if(false && this.MenuMode != SecureTradeShared.MODE_CONTAINER)
            {
               Logger.get().error("Unable to lock items: not in stash box");
               return;
            }
            Logger.get().info("Lock Protected Items Callback!");
            setTimeout(this._itemWorker.lockProtectedItems,10);
         }
         catch(e:Error)
         {
            Logger.get().error("Error locking items: " + e);
            ShowHUDMessage("Error locking items: " + e,true);
         }
      }
      
      public function buyItemsCallback() : void
      {
         var playerCurrency:Number;
         try
         {
            if(this.MenuMode != SecureTradeShared.MODE_NPCVENDING && (this.MenuMode != SecureTradeShared.MODE_VENDING_MACHINE || this.OwnsVendor))
            {
               return;
            }
            Logger.get().info("Buy Items Callback! Mode: " + (this.MenuMode == SecureTradeShared.MODE_NPCVENDING ? "NPC Vendor" : "CAMP Vendor"));
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
      
      private function getZlibArrayString(data:String) : String
      {
         var baZlib:ByteArray;
         var errorCode:String = "";
         try
         {
            errorCode = "zlib";
            baZlib = new ByteArray();
            errorCode = "writeObj";
            baZlib.writeObject(data);
            errorCode = "compress";
            baZlib.compress("zlib");
            errorCode = "toStr";
            return baZlib.toString();
         }
         catch(e:*)
         {
            Logger.get().error("Error getZlibArrayString " + errorCode + ", " + e);
         }
         return "";
      }
      
      private function getB64String(data:String) : String
      {
         var ba:ByteArray;
         var b64:Base64Encoder;
         var b64str:String;
         var _data:*;
         var errorCode:String = "";
         try
         {
            errorCode = "ba";
            ba = new ByteArray();
            errorCode = "ba write";
            ba.writeUTFBytes(data);
            errorCode = "Base64Encoder";
            b64 = new Base64Encoder();
            errorCode = "encodeBytes";
            b64.encodeBytes(ba);
            errorCode = "b64 string";
            return b64.toString();
         }
         catch(e:*)
         {
            Logger.get().error("Error getB64String " + errorCode + ", " + e);
         }
         return undefined;
      }
      
      private function printStringMinMax(data:String) : void
      {
         var min:Number = Number.MAX_VALUE;
         var max:Number = Number.MIN_VALUE;
         var i:int = 0;
         while(i < data.length)
         {
            var char:Number = Number(data.charCodeAt(i));
            if(char > max)
            {
               max = char;
            }
            if(char < min && char != 10)
            {
               min = char;
            }
            i++;
         }
         Logger.get().info("range " + min + ", " + max);
      }
      
      private function fillB64String(b64:String) : void
      {
         var tf:TextField;
         var font:TextFormat;
         try
         {
            tf = new TextField();
            tf.x = 0;
            tf.y = 0;
            tf.width = 1920;
            tf.height = 1080;
            tf.multiline = false;
            tf.wordWrap = true;
            font = new TextFormat(config.F8.font,config.F8.size,config.F8.color);
            tf.defaultTextFormat = font;
            tf.setTextFormat(font);
            tf.selectable = true;
            tf.mouseWheelEnabled = true;
            tf.mouseEnabled = true;
            tf.visible = true;
            tf.background = true;
            tf.backgroundColor = config.F8.bgColor;
            tf.text = b64;
            setTimeout(addChild,1000,tf);
         }
         catch(e:*)
         {
            Logger.get().error("Error fillB64String " + e);
         }
      }
      
      private function fillHexString(b64:String) : void
      {
         var tf:TextField;
         var font:TextFormat;
         var hexString:String;
         var i:int;
         try
         {
            tf = new TextField();
            tf.x = 0;
            tf.y = 0;
            tf.width = 1920;
            tf.height = 1080;
            tf.multiline = false;
            tf.wordWrap = true;
            font = new TextFormat(config.F8.font,config.F8.size,config.F8.color);
            tf.defaultTextFormat = font;
            tf.setTextFormat(font);
            tf.selectable = true;
            tf.mouseWheelEnabled = true;
            tf.mouseEnabled = true;
            tf.visible = true;
            tf.background = true;
            tf.backgroundColor = config.F8.bgColor;
            hexString = "";
            i = 0;
            while(i < b64.length)
            {
               hexString += b64.charCodeAt(i).toString(16);
               i++;
            }
            tf.text = hexString;
            addChild(tf);
            return hexString;
         }
         catch(e:*)
         {
            Logger.get().error("Error fillHexString " + e);
         }
      }
      
      private function fillGraphics(b64:String) : void
      {
         var mc:MovieClip;
         var w:int;
         var h:int;
         var x:int;
         var y:int;
         var i:int;
         var b64len:int;
         var numPixelsPerSquare:int;
         var r:uint;
         var g:uint;
         var b:uint;
         try
         {
            Logger.get().info("drawing b64 data");
            numPixelsPerSquare = 6;
            w = 1920 / numPixelsPerSquare;
            h = 1080 / numPixelsPerSquare;
            x = 0;
            y = 0;
            i = 0;
            b64len = b64.length;
            this.graphics.clear();
            this.graphics.beginFill(0);
            this.graphics.drawRect(0,0,w * numPixelsPerSquare,h * numPixelsPerSquare);
            this.graphics.endFill();
            while(i < b64len)
            {
               x = i / 3 % w;
               y = Math.floor(i / 3 / w);
               r = 2 * b64.charCodeAt(i);
               g = 2 * (b64.charCodeAt(i + 1) || 0);
               b = 2 * (b64.charCodeAt(i + 2) || 0);
               this.graphics.beginFill(r * 256 * 256 + g * 256 + b);
               this.graphics.drawRect(x * numPixelsPerSquare,y * numPixelsPerSquare,numPixelsPerSquare,numPixelsPerSquare);
               this.graphics.endFill();
               i += 3;
               if(i % 1000 < 3)
               {
                  Logger.get().info(i + "/" + b64len);
               }
            }
            Logger.get().info("drawing complete");
         }
         catch(e:*)
         {
            Logger.get().error("Error fillB64String " + e);
         }
      }
      
      private function fillBitmap(b64:String) : void
      {
         var b64len:int;
         var bmapW:int;
         var bmapH:int;
         var bmapData:BitmapData;
         var w:int;
         var h:int;
         var charId:int;
         var bmap:Bitmap;
         var errorCode:String = "fillBitmap";
         try
         {
            errorCode = "len";
            b64len = b64.length;
            bmapW = 960;
            bmapH = 540;
            errorCode = "BitmapData";
            bmapData = new BitmapData(bmapW,bmapH,false,16777215);
            Logger.get().info("bmap created: " + bmapData.width + ", " + bmapData.height);
            w = 0;
            h = 0;
            charId = 0;
            errorCode = "while";
            while(h < bmapH)
            {
               w = 0;
               while(w < bmapW)
               {
                  charId = h * bmapH + w;
                  if(charId >= b64len)
                  {
                     h = bmapH;
                     break;
                  }
                  errorCode = "setPixel:" + w + "," + h;
                  bmapData.setPixel(w,h,uint(2 * b64.charCodeAt(charId)));
                  w++;
               }
               h++;
            }
            errorCode = "while end";
            Logger.get().info("bmap filled pixels: " + charId);
            errorCode = "Bitmap";
            bmap = new Bitmap(bmapData);
            errorCode = "addChild";
            this.parentClip.addChild(bmap);
         }
         catch(e:*)
         {
            Logger.get().error("Error fillBitmap " + errorCode + ", " + e);
            Logger.get().info("w h : " + w + " " + h);
            Logger.get().info("charId: " + charId);
            Logger.get().info("b64char: " + b64.charCodeAt(charId));
            Logger.get().info("color: " + uint(2 * b64.charCodeAt(charId)));
         }
      }
      
      private function trimStoreData(data:Object) : Object
      {
         var trimmedObj:Object = {"pages":[]};
         var trimTemplatePage:Object = {
            "name":"",
            "isZeus":false,
            "image":{
               "imageName":"",
               "directory":"",
               "assocMediaPayload":{"url":""}
            },
            "items":[]
         };
         var trimTemplateItem:Object = {
            "isNew":false,
            "isZeus":false,
            "itemID":0,
            "itemName":"",
            "itemNameShort":"",
            "itemDesc":"",
            "primaryImage":{
               "imageName":"",
               "directory":""
            },
            "carouselImages":[],
            "lowPrice":{
               "amount":0,
               "originalAmount":0,
               "ltoTimer":0,
               "isLto":false
            },
            "lowestPurchasablePrice":{
               "amount":0,
               "originalAmount":0
            },
            "highPrice":{
               "amount":0,
               "originalAmount":0
            },
            "dynamicBundleItems":[]
         };
         for each(page in data.pages)
         {
            var tempPage:Object = GlobalFunc.CloneObject(trimTemplatePage);
            tempPage.name = page.name;
            tempPage.isZeus = page.isZeus;
            tempPage.image.imageName = page.image.imageName;
            tempPage.image.directory = page.image.directory;
            tempPage.image.assocMediaPayload.url = page.image.assocMediaPayload.url;
            for each(item in page.items)
            {
               var tempItem:Object = GlobalFunc.CloneObject(trimTemplateItem);
               tempItem.itemID = item.itemID;
               tempItem.isNew = item.isNew;
               tempItem.isZeus = item.isZeus;
               tempItem.itemName = item.itemName;
               tempItem.itemNameShort = item.itemNameShort;
               tempItem.itemDesc = item.itemDesc;
               tempItem.primaryImage.directory = item.primaryImage.directory;
               tempItem.primaryImage.imageName = item.primaryImage.imageName;
               tempItem.lowPrice.originalAmount = item.lowPrice.originalAmount;
               tempItem.lowPrice.amount = item.lowPrice.amount;
               tempItem.lowPrice.isLto = item.lowPrice.isLto;
               tempItem.lowPrice.ltoTimer = item.lowPrice.ltoTimer;
               tempItem.lowestPurchasablePrice.amount = item.lowestPurchasablePrice.amount;
               tempItem.lowestPurchasablePrice.originalamount = item.lowestPurchasablePrice.originalamount;
               tempItem.highPrice.originalAmount = item.highPrice.originalAmount;
               for each(carouselImage in item.carouselImages)
               {
                  tempItem.carouselImages.push({
                     "directory":carouselImage.directory,
                     "imageName":carouselImage.imageName
                  });
               }
               for each(dynamicBundleItem in item.dynamicBundleItems)
               {
                  tempItem.dynamicBundleItems.push({"szItemName":dynamicBundleItem.szItemName});
               }
               tempPage.items.push(tempItem);
            }
            trimmedObj.pages.push(tempPage);
         }
         return trimmedObj;
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         var apiData:*;
         var data:String;
         var b64:String;
         var selectedItem:String;
         var weights:String;
         var totalWt:Number;
         var key:*;
         var indexConfig:int;
         var dataTrimmed:String;
         var hexB64:String;
         var keys:Array;
         var output:String;
         if(param1.keyCode == Keyboard.SHIFT)
         {
            _shift = false;
         }
         if(this.config && this.config.debugKeys)
         {
            Logger.get().info("KeyUp: " + param1.keyCode + "(" + Buttons.getButtonKey(param1.keyCode) + "), shift: " + _shift);
         }
         if(param1.keyCode == Keyboard.F5)
         {
            keys = ["bksp","tab","enter","shift","ctrl","alt","pause","caps","esc","pgup","pgdn","end","home","left","up","right","down","ins","del","0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","sel","n0","n1","n2","n3","n4","n5","n6","n7","n8","n9","n*","n+","n-","n.","n/","f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","numlk","scrlk",";","=",",","-",".","/","`","\\","\'"];
            output = "";
            for each(key in keys)
            {
               output += key + ":" + Buttons.getButtonValue(key) + " (" + Buttons.getButtonKey(Buttons.getButtonValue(key)) + "), ";
            }
            Logger.get().info("keys: " + output);
         }
         else if(param1.keyCode == Keyboard.F6)
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
            if(config.testMethod != null)
            {
               try
               {
                  apiData = GameApiDataExtractor.getApiData(config.testMethod);
                  data = new JSONEncoder(apiData).getString();
                  if(config.testMethod == "StorePageData")
                  {
                     apiData = trimStoreData(apiData);
                     dataTrimmed = new JSONEncoder(apiData).getString();
                     Logger.get().info("Store data trimmed: " + data.length + " > " + dataTrimmed.length);
                     data = dataTrimmed;
                  }
                  b64 = getB64String(data);
                  Logger.get().info("org: " + data.length);
                  printStringMinMax(data);
                  Logger.get().info("b64: " + b64.length);
                  printStringMinMax(b64);
                  hexB64 = "";
                  if(config.F8)
                  {
                     if(config.F8.showText)
                     {
                        if(config.F8.base64Text)
                        {
                           if(config.F8.hexText)
                           {
                              hexB64 = fillHexString(b64);
                              Logger.get().info("hexB64: " + hexB64.length);
                              printStringMinMax(hexB64);
                           }
                           else
                           {
                              fillB64String(b64);
                           }
                        }
                        else
                        {
                           fillB64String(data);
                        }
                     }
                     else
                     {
                        fillGraphics(b64);
                     }
                     if(config.F8.saveFile && this.parentClip.__SFCodeObj != null && this.parentClip.__SFCodeObj.call != null)
                     {
                        if(config.F8.base64Text)
                        {
                           if(config.F8.hexText)
                           {
                              this.parentClip.__SFCodeObj.call("writeItemsModFile",hexB64);
                           }
                           else
                           {
                              this.parentClip.__SFCodeObj.call("writeItemsModFile",b64);
                           }
                        }
                        else
                        {
                           this.parentClip.__SFCodeObj.call("writeItemsModFile",data);
                        }
                     }
                  }
               }
               catch(e:*)
               {
                  Logger.get().info("F8 error: " + e);
               }
            }
         }
         else if(param1.keyCode == Keyboard.F9)
         {
            selectedItem = new JSONEncoder(this.parentClip.selectedListEntry).getString();
            Logger.get().info(selectedItem);
         }
         else if(param1.keyCode == Keyboard.F10)
         {
            Logger.get().info("Category weights");
            weights = "";
            totalWt = 0;
            for(key in CategoryWeight.icategoryWeights)
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
               apiData = GameApiDataExtractor.getApiData(config.testMethod);
               data = new JSONEncoder(apiData).getString();
               Logger.get().info("Retrieve data for: " + config.testMethod);
               Logger.get().info(data);
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
         indexConfig = 0;
         while(indexConfig < this.config.campAssignConfig.configs.length)
         {
            if(this.config.campAssignConfig.configs[indexConfig] && this.config.campAssignConfig.configs[indexConfig].enabled && param1.keyCode == this.config.campAssignConfig.configs[indexConfig].hotkey)
            {
               this.campAssignItemsCallback(param1.keyCode);
               break;
            }
            indexConfig++;
         }
         indexConfig = 0;
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
         if(param1.keyCode == InventOmaticConfig.LockAllKeyCode)
         {
            this.lockItemsCallback();
         }
         if(param1.keyCode == InventOmaticConfig.ToggleDebugKeyCode)
         {
            Logger.get().debugMode = !Logger.DEBUG_MODE;
         }
      }
   }
}

