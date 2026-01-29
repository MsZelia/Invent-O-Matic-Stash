package utils
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.*;
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.JSONEncoder;
   import com.brokenfunction.json.JsonDecoderAsync;
   import extractors.GameApiDataExtractor;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.*;
   
   public class LegendaryMods
   {
      
      private static var _characterName:String;
      
      private static var _legendaryModsFromIni:Array;
      
      public static var allCharsLegendaryMods:Object;
      
      private static var RED:uint = 16711680;
      
      private static var _legendaryModsByDesc:* = null;
      
      private static var _legendaryModsByName:* = null;
      
      private static var _legendaryModNamesByDesc:* = null;
      
      private static var _shouldIndicateLearnableLegendaryMods:Boolean = false;
      
      private static var _hasInitializedLearnableLegendaryMods:* = false;
      
      private static var _hasInitializedLegendaryModNames:* = false;
      
      private static var IMPROVED_WORKBENCH_MOD_NAME:String = "ImprovedWorkbench";
      
      public static var FILE_LOCATION:String = "../LegendaryMods.ini";
      
      private static const LEGENDARY_MOD_CURRENTLY_REGEX:* = /(Currently|Aktuell|Actualmente|Valeur actuelle|Attuale|現在|현재|Obecnie|Atualmente|Сейчас|当前效果为|目前為)[^¬]+/;
      
      private static const LEGENDARY_MOD_CAVALIER_LOCALIZED:* = /(Cavalier|Caballero|Cavalier|Des Kavalleristen|Cavaliere|Rycerski|Cavaleiro|Кавалерская|騎士の|기병대의|骑兵的|騎兵)/i;
      
      private static const LEGENDARY_MOD_DEFENDER_LOCALIZED:* = /(Defender|Defensor|Défenseur|Des Verteidigers|Difensore|Obronny|Защитная|ディフェンダーの|방어자의|防御者的|護衛)/i;
      
      private static const MODBOX_PREFIX_REGEX:* = /^\[(WEAPONS|ARMOR|POWER ARMOR)\]\s*/i;
      
      private static var _legendaryModsByDescNoStars:* = null;
      
      private static var keepLearnablePrefix:* = "[Keep+Learnable]";
      
      private static var keepPrefix:* = "[Keep]";
      
      private static var learnablePrefix:* = "[Learnable]";
      
      private static var learnableArmorPrefix:* = "[Learnable from Armor]";
      
      private static var learnablePowerArmorPrefix:* = "[Learnable from Power Armor]";
      
      private static var learnableWeaponPrefix:* = "[Learnable from Weapon]";
      
      private static var stats:* = [[0,0],[0,0],[0,0],[0,0]];
      
      public function LegendaryMods()
      {
         super();
      }
      
      public static function init() : void
      {
         if(config.legendaryModsConfig == null || !config.legendaryModsConfig.enabled)
         {
            return;
         }
         BSUIDataManager.Subscribe("ContainerOptionsData",onContainerOptionsUpdate);
         BSUIDataManager.Subscribe("CharacterNameData",onCharacterNameUpdate);
         BSUIDataManager.Subscribe("MenuStackData",onMenuStackUpdate);
      }
      
      private static function log(message:String) : void
      {
         if(config && config.legendaryModsConfig && config.legendaryModsConfig.debug)
         {
            Logger.get().info(message);
         }
      }
      
      private static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      private static function get config() : Object
      {
         return InventOmaticConfig.get();
      }
      
      private static function onMenuStackUpdate(event:FromClientDataEvent) : *
      {
         if(false)
         {
            log("menu stack event.data = " + new JSONEncoder(event.data).getString());
         }
         if(isVendingMenu(event.data))
         {
            if(!config.legendaryModsConfig || config.legendaryModsConfig && config.legendaryModsConfig.enabled && config.legendaryModsConfig.showInVendors)
            {
               _shouldIndicateLearnableLegendaryMods = true;
               log("LegendaryMods: Valid mode: Vendor");
            }
         }
         initLearnableLegendaryMods();
      }
      
      private static function onContainerOptionsUpdate(event:FromClientDataEvent) : *
      {
         if(false)
         {
            log("container event.data = " + new JSONEncoder(event.data).getString());
         }
         var isWorkbench:* = event.data.isWorkbench;
         var isItemStash:* = event.data.isStash && event.data.storageMode != SecureTradeShared.LIMITED_TYPE_STORAGE_AMMO && event.data.storageMode != SecureTradeShared.LIMITED_TYPE_STORAGE_SCRAP;
         if(config.legendaryModsConfig && config.legendaryModsConfig.enabled)
         {
            if(isWorkbench)
            {
               if(config.legendaryModsConfig.showInWorkbench)
               {
                  _shouldIndicateLearnableLegendaryMods = true;
                  log("LegendaryMods: Valid mode: Workbench");
               }
            }
            else if(isItemStash)
            {
               if(config.legendaryModsConfig.showInStash)
               {
                  _shouldIndicateLearnableLegendaryMods = true;
                  log("LegendaryMods: Valid mode: Item stash");
               }
            }
            else if(event.data.storageMode == 0)
            {
               if(config.legendaryModsConfig.showInWorldContainers)
               {
                  _shouldIndicateLearnableLegendaryMods = true;
                  log("LegendaryMods: Valid mode: World container");
               }
            }
         }
         else
         {
            _shouldIndicateLearnableLegendaryMods = isWorkbench || isItemStash;
            log("LegendaryMods: Is valid container: " + _shouldIndicateLearnableLegendaryMods);
         }
         initLearnableLegendaryMods();
      }
      
      private static function onCharacterNameUpdate(event:FromClientDataEvent) : *
      {
         if(false)
         {
            log("onCharacterNameUpdate = " + _characterName);
         }
         _characterName = event.data.characterName;
         initLearnableLegendaryMods();
      }
      
      private static function isVendingMenu(menuStackData:*) : Boolean
      {
         return Boolean(menuStackData.menuStackA.some(function(element:Object):Boolean
         {
            return element.menuName == "NPCVendingMenu" || element.menuName == "CampVendingMenu";
         }));
      }
      
      private static function initLearnableLegendaryMods() : *
      {
         if(!_shouldIndicateLearnableLegendaryMods || !_characterName || _hasInitializedLearnableLegendaryMods)
         {
            return;
         }
         _hasInitializedLearnableLegendaryMods = true;
         loadExistingItemsmodIni(function(legendaryModsList:*):*
         {
            var legendaryModsByDesc:* = {};
            var legendaryModsByDescNoStars:* = {};
            var legendaryModsByName:* = {};
            var i:* = 0;
            while(i < legendaryModsList.length)
            {
               var currentMod:* = legendaryModsList[i];
               legendaryModsByName[currentMod.fullName] = currentMod.isLearned;
               stats[currentMod.stars - 1][1]++;
               if(currentMod.isKept || !currentMod.isLearned)
               {
                  if(!currentMod.isLearned)
                  {
                     stats[currentMod.stars - 1][0]++;
                  }
                  var starsText:* = "";
                  var s:* = 0;
                  while(s < currentMod.stars)
                  {
                     starsText += "¬";
                     s++;
                  }
                  keepLearnablePrefix = !config.legendaryModsConfig.keepLearnableText ? keepLearnablePrefix : config.legendaryModsConfig.keepLearnableText;
                  keepPrefix = !config.legendaryModsConfig.keepText ? keepPrefix : config.legendaryModsConfig.keepText;
                  learnablePrefix = !config.legendaryModsConfig.learnableText ? learnablePrefix : config.legendaryModsConfig.learnableText;
                  learnableArmorPrefix = !config.legendaryModsConfig.learnableFromArmorText ? learnableArmorPrefix : config.legendaryModsConfig.learnableFromArmorText;
                  learnablePowerArmorPrefix = !config.legendaryModsConfig.learnableFromPowerArmorText ? learnablePowerArmorPrefix : config.legendaryModsConfig.learnableFromPowerArmorText;
                  learnableWeaponPrefix = !config.legendaryModsConfig.learnableFromWeaponText ? learnableWeaponPrefix : config.legendaryModsConfig.learnableFromWeaponText;
                  var activePrefix:* = currentMod.isKept ? (currentMod.isLearned ? keepPrefix : keepLearnablePrefix) : learnablePrefix;
                  var activeArmorPrefix:* = currentMod.isKept ? (currentMod.isLearned ? keepPrefix : keepLearnablePrefix) : learnableArmorPrefix;
                  var activePowerArmorPrefix:* = currentMod.isKept ? (currentMod.isLearned ? keepPrefix : keepLearnablePrefix) : learnablePowerArmorPrefix;
                  var activeWeaponPrefix:* = currentMod.isKept ? (currentMod.isLearned ? keepPrefix : keepLearnablePrefix) : learnableWeaponPrefix;
                  var descObj:* = currentMod.description;
                  var descBase:* = "";
                  if(descObj.all)
                  {
                     descBase = descObj.all + " " + starsText;
                     legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                     legendaryModsByDescNoStars[descObj.all] = activePrefix + " " + descObj.all;
                  }
                  else if(currentMod.name.search(LEGENDARY_MOD_CAVALIER_LOCALIZED) != -1)
                  {
                     descBase = descObj.armor + " " + starsText;
                     legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                     descBase = descObj.weapons + " " + starsText;
                     if(!legendaryModsByDesc[descBase])
                     {
                        legendaryModsByDesc[descBase] = activeWeaponPrefix + " " + descBase;
                     }
                     else
                     {
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                     }
                     legendaryModsByDescNoStars[descObj.armor] = activePrefix + " " + descObj.armor;
                     if(!legendaryModsByDescNoStars[descObj.weapons])
                     {
                        legendaryModsByDescNoStars[descObj.weapons] = activeWeaponPrefix + " " + descObj.weapons;
                     }
                     else
                     {
                        legendaryModsByDescNoStars[descObj.weapons] = activePrefix + " " + descObj.weapons;
                     }
                  }
                  else if(currentMod.name.search(LEGENDARY_MOD_DEFENDER_LOCALIZED) != -1)
                  {
                     descBase = descObj.weapons + " " + starsText;
                     legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                     descBase = descObj.armor + " " + starsText;
                     if(!legendaryModsByDesc[descBase])
                     {
                        legendaryModsByDesc[descBase] = activeArmorPrefix + " " + descBase;
                     }
                     else
                     {
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                     }
                     legendaryModsByDescNoStars[descObj.weapons] = activePrefix + " " + descObj.weapons;
                     if(!legendaryModsByDescNoStars[descObj.armor])
                     {
                        legendaryModsByDescNoStars[descObj.armor] = activeArmorPrefix + " " + descObj.armor;
                     }
                     else
                     {
                        legendaryModsByDescNoStars[descObj.armor] = activePrefix + " " + descObj.armor;
                     }
                  }
                  else
                  {
                     if(descObj.melee)
                     {
                        descBase = descObj.melee + " " + starsText;
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                        legendaryModsByDescNoStars[descObj.melee] = activePrefix + " " + descObj.melee;
                     }
                     if(descObj.ranged)
                     {
                        descBase = descObj.ranged + " " + starsText;
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                        legendaryModsByDescNoStars[descObj.ranged] = activePrefix + " " + descObj.ranged;
                     }
                     if(descObj.weapons)
                     {
                        descBase = descObj.weapons + " " + starsText;
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                        legendaryModsByDescNoStars[descObj.weapons] = activePrefix + " " + descObj.weapons;
                     }
                     if(descObj.armor)
                     {
                        descBase = descObj.armor + " " + starsText;
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                        legendaryModsByDescNoStars[descObj.armor] = activePrefix + " " + descObj.armor;
                     }
                     if(descObj.powerArmor)
                     {
                        descBase = descObj.powerArmor + " " + starsText;
                        legendaryModsByDesc[descBase] = activePrefix + " " + descBase;
                        legendaryModsByDescNoStars[descObj.powerArmor] = activePrefix + " " + descObj.powerArmor;
                     }
                  }
               }
               i++;
            }
            _legendaryModsByName = legendaryModsByName;
            _legendaryModsByDesc = legendaryModsByDesc;
            _legendaryModsByDescNoStars = legendaryModsByDescNoStars;
            if(config.legendaryModsConfig.debug)
            {
               log(toString(legendaryModsByDesc));
            }
         });
      }
      
      private static function initLegendaryModNames() : void
      {
         if(_legendaryModsFromIni == null)
         {
            return;
         }
         var legendaryModsByDesc:* = {};
         var i:* = 0;
         while(i < _legendaryModsFromIni.length)
         {
            var currentMod:* = _legendaryModsFromIni[i];
            var starsText:* = "";
            var s:* = 0;
            while(s < currentMod.stars)
            {
               starsText += "¬";
               s++;
            }
            var descObj:* = currentMod.description;
            var descBase:* = "";
            if(descObj.all)
            {
               descBase = descObj.all + " " + starsText;
               legendaryModsByDesc[descBase] = legendaryModsByDesc[descBase] != null && legendaryModsByDesc[descBase] != currentMod.name ? legendaryModsByDesc[descBase] + "|" + currentMod.name : currentMod.name;
            }
            else
            {
               if(descObj.melee)
               {
                  descBase = descObj.melee + " " + starsText;
                  legendaryModsByDesc[descBase] = legendaryModsByDesc[descBase] != null && legendaryModsByDesc[descBase] != currentMod.name ? legendaryModsByDesc[descBase] + "|" + currentMod.name : currentMod.name;
               }
               if(descObj.ranged)
               {
                  descBase = descObj.ranged + " " + starsText;
                  legendaryModsByDesc[descBase] = legendaryModsByDesc[descBase] != null && legendaryModsByDesc[descBase] != currentMod.name ? legendaryModsByDesc[descBase] + "|" + currentMod.name : currentMod.name;
               }
               if(descObj.weapons)
               {
                  descBase = descObj.weapons + " " + starsText;
                  legendaryModsByDesc[descBase] = legendaryModsByDesc[descBase] != null && legendaryModsByDesc[descBase] != currentMod.name ? legendaryModsByDesc[descBase] + "|" + currentMod.name : currentMod.name;
               }
               if(descObj.armor)
               {
                  descBase = descObj.armor + " " + starsText;
                  legendaryModsByDesc[descBase] = legendaryModsByDesc[descBase] != null && legendaryModsByDesc[descBase] != currentMod.name ? legendaryModsByDesc[descBase] + "|" + currentMod.name : currentMod.name;
               }
               if(descObj.powerArmor)
               {
                  descBase = descObj.powerArmor + " " + starsText;
                  legendaryModsByDesc[descBase] = legendaryModsByDesc[descBase] != null && legendaryModsByDesc[descBase] != currentMod.name ? legendaryModsByDesc[descBase] + "|" + currentMod.name : currentMod.name;
               }
            }
            i++;
         }
         _legendaryModNamesByDesc = legendaryModsByDesc;
         _hasInitializedLegendaryModNames = true;
      }
      
      public static function getLegendaryModName(desc:String, stars:int) : String
      {
         if(_hasInitializedLearnableLegendaryMods && _legendaryModsByDesc != null && !_hasInitializedLegendaryModNames)
         {
            initLegendaryModNames();
         }
         var descParts:* = desc.split("\n");
         var i:* = 0;
         while(i < descParts.length)
         {
            if(descParts[i].indexOf("¬") != -1 && descParts[i].split("¬").length == stars + 1)
            {
               var currentlyText:* = (descParts[i].match(LEGENDARY_MOD_CURRENTLY_REGEX) || [])[0] || "";
               var lookupDesc:* = descParts[i].replace(LEGENDARY_MOD_CURRENTLY_REGEX,"").replace(/^\s+|\s+$/g,"").replace(/\s*¬/," ¬");
               if(lookupDesc.length > 0 && _legendaryModNamesByDesc != null && _legendaryModNamesByDesc[lookupDesc] != null)
               {
                  return _legendaryModNamesByDesc[lookupDesc];
               }
               return lookupDesc;
            }
            i++;
         }
         return null;
      }
      
      public static function isKnownModName(text:String) : Boolean
      {
         if(_hasInitializedLearnableLegendaryMods && _legendaryModsByName != null)
         {
            return Boolean(_legendaryModsByName[text]);
         }
         return false;
      }
      
      public static function getLegendaryItemDescription(desc:String) : *
      {
         if(!_hasInitializedLearnableLegendaryMods || !_legendaryModsByDesc)
         {
            return desc;
         }
         var descLines:* = [];
         var descParts:* = desc.split("\n");
         var showOnModItems:* = config.legendaryModsConfig && config.legendaryModsConfig.showOnModItems;
         var i:* = 0;
         while(i < descParts.length)
         {
            if(descParts[i].indexOf("¬") == -1)
            {
               if(showOnModItems && _legendaryModsByDescNoStars)
               {
                  var currentlyText:* = (descParts[i].match(LEGENDARY_MOD_CURRENTLY_REGEX) || [])[0] || "";
                  var modBoxLine:* = descParts[i].replace(/^\s+|\s+$/g,"");
                  var modBoxPrefix:* = (modBoxLine.match(MODBOX_PREFIX_REGEX) || [])[0] || "";
                  var modBoxLookupDesc:* = modBoxLine.replace(MODBOX_PREFIX_REGEX,"").replace(LEGENDARY_MOD_CURRENTLY_REGEX,"").replace(/^\s+|\s+$/g,"");
                  if(modBoxLookupDesc.length > 0 && _legendaryModsByDescNoStars[modBoxLookupDesc])
                  {
                     var modBoxLearnableString:* = _legendaryModsByDescNoStars[modBoxLookupDesc];
                     if(currentlyText.length > 0)
                     {
                        modBoxLearnableString = modBoxLearnableString.replace(/$/," " + currentlyText);
                     }

                     // Put learnable/keep prefix before [WEAPONS]/[ARMOR]/[POWER ARMOR] prefix
                     if(modBoxPrefix.length > 0)
                     {
                        descLines.push(modBoxLearnableString.replace(modBoxLookupDesc, modBoxPrefix + modBoxLookupDesc));
                     }
                     else
                     {
                        descLines.push(modBoxLearnableString);
                     }
                  }
                  else
                  {
                     descLines.push(descParts[i]);
                  }
               }
               else
               {
                  descLines.push(descParts[i]);
               }
            }
            else
            {
               var currentlyText:* = (descParts[i].match(LEGENDARY_MOD_CURRENTLY_REGEX) || [])[0] || "";
               var lookupDesc:* = descParts[i].replace(LEGENDARY_MOD_CURRENTLY_REGEX,"").replace(/^\s+|\s+$/g,"").replace(/\s*¬/," ¬");
               if(lookupDesc.length === 0 || !_legendaryModsByDesc[lookupDesc])
               {
                  descLines.push(descParts[i]);
               }
               else
               {
                  var learnableModString:* = _legendaryModsByDesc[lookupDesc];
                  var displayedString:* = learnableModString;
                  if(currentlyText.length > 0)
                  {
                     displayedString = displayedString.replace(/ ¬/," " + currentlyText + " ¬");
                  }
                  descLines.push(displayedString);
               }
            }
            i++;
         }
         return descLines.join("\n");
      }
      
      public static function formatLegendaryItemDescription(description_tf:TextField) : void
      {
         var format:*;
         var prefixes:Array;
         var i:int;
         var index:int;
         var endIndex:int;
         var colorStyle:String;
         var color:uint;
         try
         {
            if(!_hasInitializedLearnableLegendaryMods || !_legendaryModsByDesc || !config.legendaryModsConfig)
            {
               return;
            }
            if(description_tf.text.length > 0 && description_tf.text.charAt(0) != " ")
            {
               description_tf.text = " " + description_tf.text;
            }
            colorStyle = config.legendaryModsConfig.keepTextColorStyle || config.legendaryModsConfig.learnableTextColorStyle;
            if(colorStyle == "PREFIX" || colorStyle == "LINE")
            {
               format = new TextFormat();
               color = Parser.parseNumber(config.legendaryModsConfig.keepTextColor || config.legendaryModsConfig.learnableTextColor,RED);
               format.color = color;
               index = int(description_tf.text.indexOf(keepPrefix));
               while(index != -1)
               {
                  if(description_tf.text.indexOf(keepLearnablePrefix,index) != index)
                  {
                     if(colorStyle == "PREFIX")
                     {
                        endIndex = index + keepPrefix.length;
                     }
                    else if(colorStyle == "LINE")
                    {
                       endIndex = int(description_tf.text.indexOf("\r",index));
                       if(endIndex == -1)
                       {
                          endIndex = description_tf.text.length - 1;
                       }
                    }
                    description_tf.setTextFormat(format,index,endIndex + 1);
                 }
                 index = int(description_tf.text.indexOf(keepPrefix,index + 1));
               }
            }
            colorStyle = config.legendaryModsConfig.keepLearnableTextColorStyle || config.legendaryModsConfig.learnableTextColorStyle;
            if(colorStyle == "PREFIX" || colorStyle == "LINE")
            {
               format = new TextFormat();
               color = Parser.parseNumber(config.legendaryModsConfig.keepLearnableTextColor || config.legendaryModsConfig.learnableTextColor,RED);
               format.color = color;
               index = int(description_tf.text.indexOf(keepLearnablePrefix));
               while(index != -1)
               {
                 if(colorStyle == "PREFIX")
                 {
                    endIndex = index + keepLearnablePrefix.length;
                 }
                 else if(colorStyle == "LINE")
                 {
                    endIndex = int(description_tf.text.indexOf("\r",index));
                    if(endIndex == -1)
                    {
                       endIndex = description_tf.text.length - 1;
                    }
                 }
                 description_tf.setTextFormat(format,index,endIndex + 1);
                 index = int(description_tf.text.indexOf(keepLearnablePrefix,endIndex));
               }
            }
            colorStyle = config.legendaryModsConfig.learnableTextColorStyle;
            if(colorStyle == "PREFIX" || colorStyle == "LINE")
            {
               format = new TextFormat();
               format.color = Parser.parseNumber(config.legendaryModsConfig.learnableTextColor,RED);
               prefixes = [learnablePrefix,learnableArmorPrefix,learnablePowerArmorPrefix,learnableWeaponPrefix];
               i = 0;
               while(i < 4)
               {
                  index = int(description_tf.text.indexOf(prefixes[i]));
                  while(index != -1)
                  {
                    if(colorStyle == "PREFIX")
                    {
                       endIndex = index + prefixes[i].length;
                    }
                    else if(colorStyle == "LINE")
                    {
                       endIndex = int(description_tf.text.indexOf("\r",index));
                       if(endIndex == -1)
                       {
                          endIndex = description_tf.text.length - 1;
                       }
                    }
                    description_tf.setTextFormat(format,index,endIndex + 1);
                    index = int(description_tf.text.indexOf(prefixes[i],endIndex));
                  }
                  i++;
               }
            }
         }
         catch(error:*)
         {
            Logger.get().error("Error setting Legendary Mods color: " + error);
         }
      }
      
      private static function loadExistingItemsmodIni(callback:Function) : void
      {
         var loaderComplete:Function;
         var onIOError:Function;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         try
         {
            loaderComplete = function(param1:Event):void
            {
               var i:int;
               try
               {
                  _legendaryModsFromIni = getLegendaryMods(loader.data);
                  if(false)
                  {
                     Logger.get().info(toString(_legendaryModsFromIni));
                  }
                  if(_legendaryModsFromIni)
                  {
                     callback(_legendaryModsFromIni);
                     i = 0;
                     while(i < 4)
                     {
                        Logger.get().info("¬¬¬¬".substr(0,i + 1) + (stats[i][1] - stats[i][0]) + "/" + stats[i][1] + " " + (100 * (stats[i][1] - stats[i][0]) / stats[i][1]).toFixed(0) + "%");
                        i++;
                     }
                  }
               }
               catch(e:Error)
               {
                  if(_legendaryModsFromIni == null)
                  {
                     Logger.get().error("Error parsing legendary mods file " + e);
                  }
                  else
                  {
                     Logger.get().error("Error initializing Learnable LegendaryMods dictionary " + e);
                  }
               }
            };
            onIOError = function(param1:Event):void
            {
               Logger.get().error("Error loading legendary mods file: " + param1.text);
            };
            url = new URLRequest(FILE_LOCATION);
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE,loaderComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
            loader.load(url);
         }
         catch(e:Error)
         {
            Logger.get().error("Error loading legendary mods file " + FILE_LOCATION + ": " + e.getStackTrace());
         }
      }
      
      private static function getLegendaryMods(json:String) : *
      {
         if(config.legendaryModsConfig == null)
         {
            return;
         }
         if(json.search(/\"modName\":\s*\"ImprovedWorkbench\"/) != -1)
         {
            var decoder:JsonDecoderAsync = new JsonDecoderAsync(json,false);
            if(!decoder.process())
            {
               Logger.get().error("JSONDecoderAsync error: " + decoder.result);
               return;
            }
            allCharsLegendaryMods = decoder.result;
            var characterName:String = GameApiDataExtractor.getApiData("CharacterNameData").characterName;
            var chars:Array = [];
            for(var char in allCharsLegendaryMods.characterInventories)
            {
               if(Boolean(config.legendaryModsConfig.showUnknownModsAmongAllChars))
               {
                  chars.push(char);
               }
               else if(characterName == char)
               {
                  chars.push(char);
               }
            }
            if(chars.length == 0)
            {
               Logger.get().error("Legendary data not found for current char: " + characterName);
               return;
            }
            if(allCharsLegendaryMods.characterInventories != null)
            {
               var legendaryMods:Array = GlobalFunc.CloneObject(allCharsLegendaryMods.characterInventories[characterName].legendaryMods);
               var legendaryModsMap:* = {};
               for(var i in legendaryMods)
               {
                  legendaryModsMap[legendaryMods[i].fullName] = legendaryMods[i];
               }
               if(chars.length > 1)
               {
                  for(var c in chars)
                  {
                     if(chars[c] != characterName)
                     {
                        var legendaryModsOther:Array = allCharsLegendaryMods.characterInventories[chars[c]].legendaryMods;
                        for(i in legendaryModsOther)
                        {
                           if(legendaryModsOther[i].isLearned && legendaryModsMap[legendaryModsOther[i].fullName] != null && !legendaryModsMap[legendaryModsOther[i].fullName].isLearned)
                           {
                              legendaryModsMap[legendaryModsOther[i].fullName].isLearned = true;
                           }
                        }
                     }
                     c++;
                  }
                  Logger.get().info("Legendary mods data loaded for " + chars.length + " characters: " + chars.join(", "));
               }
               else
               {
                  Logger.get().info("Legendary mods data loaded for char: " + characterName);
               }
               return legendaryMods;
            }
            Logger.get().error("Legendary mods data not loaded, no characterInventories! " + allCharsLegendaryMods.characterInventories);
         }
         else
         {
            Logger.get().error("Legendary mods data not loaded, invalid extractor mod name");
         }
      }
   }
}

