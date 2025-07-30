package extractors
{
   import Shared.AS3.Events.*;
   import flash.events.*;
   import flash.utils.*;
   import utils.*;
   
   public class CustomFormatExtractor extends BaseItemExtractor
   {
      
      public static const MOD_NAME:String = "Invent-O-Matic-Custom-Format-Extractor";
      
      public function CustomFormatExtractor(param1:Object)
      {
         super(param1,MOD_NAME,Version.ITEM_EXTRACTOR);
      }
      
      override public function buildOutputObject() : Object
      {
         switch(this._extractConfig.customFormat.format.toLowerCase())
         {
            case "json":
               var outputObject:Object = buildJSONObject();
               break;
            case "csv":
               outputObject = buildCSVObject();
               break;
            default:
               outputObject = this.getExtractorName() + ": Unknown format selected (" + this._extractConfig.customFormat.format + ")!";
         }
         return outputObject;
      }
      
      private function buildJSONObject() : Object
      {
         var characterInfoData:Object = GameApiDataExtractor.getCharacterInfoData();
         var accountInfoData:Object = GameApiDataExtractor.getAccountInfoData();
         var outputObject:Object = super.buildOutputObject();
         var characterInventory:Object = {};
         characterInventory.playerInventory = this.playerInventory;
         characterInventory.stashInventory = this.stashInventory;
         characterInventory.AccountInfoData = {"name":accountInfoData.name};
         characterInventory.CharacterInfoData = {
            "name":characterInfoData.name,
            "level":characterInfoData.level
         };
         if(_verboseOutput)
         {
            characterInventory.fullGameData = GameApiDataExtractor.getFullApiData(this._apiMethods);
         }
         outputObject.characterInventories = {};
         outputObject.characterInventories[characterInfoData.name] = characterInventory;
         return outputObject;
      }
      
      private function buildCSVObject() : Object
      {
         var characterInfoData:Object = GameApiDataExtractor.getCharacterInfoData();
         var accountInfoData:Object = GameApiDataExtractor.getAccountInfoData();
         var outputObjectLine:int = 0;
         if(this._extractConfig.customFormat.displayColumnNames)
         {
            var outputObject:Object = new Array(this.playerInventory.length + this.stashInventory.length + 1);
            outputObject[outputObjectLine++] = this._extractConfig.customFormat.columns.join(this._extractConfig.customFormat.delimiter);
         }
         else
         {
            outputObject = new Array(this.playerInventory.length + this.stashInventory.length);
         }
         var source:String = "playerInventory";
         var inv:int = 0;
         while(inv < 2)
         {
            var inventory:Array = inv == 0 ? this.playerInventory : this.stashInventory;
            var i:int = 0;
            while(i < inventory.length)
            {
               var desc:String = "";
               var j:int = 0;
               var line:Array = new Array(this._extractConfig.customFormat.columns.length);
               for(; j < this._extractConfig.customFormat.columns.length; j++)
               {
                  line[j] = tryGetItemData(inventory[i],this._extractConfig.customFormat.columns[j]);
                  if(line[j] != this._extractConfig.customFormat.valueNotFound)
                  {
                     continue;
                  }
                  switch(this._extractConfig.customFormat.columns[j])
                  {
                     case "itemType":
                        line[j] = ItemTypes.getName(inventory[i].filterFlag);
                        break;
                     case "source":
                        line[j] = source;
                        break;
                     case "char":
                        line[j] = characterInfoData.name;
                        break;
                     case "account":
                        line[j] = accountInfoData.name;
                        break;
                     case "physical":
                        line[j] = findDamageTypeItemCard(inventory[i].ItemCardEntries,1);
                        break;
                     case "poison":
                        line[j] = findDamageTypeItemCard(inventory[i].ItemCardEntries,2);
                        break;
                     case "fire":
                        line[j] = findDamageTypeItemCard(inventory[i].ItemCardEntries,3);
                        break;
                     case "energy":
                        line[j] = findDamageTypeItemCard(inventory[i].ItemCardEntries,4);
                        break;
                     case "cryo":
                        line[j] = findDamageTypeItemCard(inventory[i].ItemCardEntries,5);
                        break;
                     case "radiation":
                        line[j] = findDamageTypeItemCard(inventory[i].ItemCardEntries,6);
                        break;
                     case "capacity":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$CAPACITY");
                        break;
                     case "consumption":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$CONSUMPTION");
                        break;
                     case "attackMode":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$ATTACKMODE");
                        break;
                     case "rateOfFire":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$ROF");
                        break;
                     case "range":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$rng");
                        break;
                     case "accuracy":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$acc");
                        break;
                     case "APCost":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$APCost");
                        break;
                     case "speed":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$speed");
                        break;
                     case "wt":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$wt");
                        break;
                     case "weightInStash":
                        line[j] = findItemCardValue(inventory[i].ItemCardEntries,"$WeightInStash");
                        break;
                     case "description":
                        if(desc == "")
                        {
                           desc = findItemCardValue(inventory[i].ItemCardEntries,"DESC");
                        }
                        line[j] = desc.replace(/\n/g," ");
                        break;
                     case "legendary_1":
                        if(desc == "")
                        {
                           desc = findItemCardValue(inventory[i].ItemCardEntries,"DESC");
                        }
                        line[j] = LegendaryMods.getLegendaryModName(desc,1) || this._extractConfig.customFormat.valueNotFound;
                        break;
                     case "legendary_2":
                        if(desc == "")
                        {
                           desc = findItemCardValue(inventory[i].ItemCardEntries,"DESC");
                        }
                        line[j] = LegendaryMods.getLegendaryModName(desc,2) || this._extractConfig.customFormat.valueNotFound;
                        break;
                     case "legendary_3":
                        if(desc == "")
                        {
                           desc = findItemCardValue(inventory[i].ItemCardEntries,"DESC");
                        }
                        line[j] = LegendaryMods.getLegendaryModName(desc,3) || this._extractConfig.customFormat.valueNotFound;
                        break;
                     case "legendary_4":
                        if(desc == "")
                        {
                           desc = findItemCardValue(inventory[i].ItemCardEntries,"DESC");
                        }
                        line[j] = LegendaryMods.getLegendaryModName(desc,4) || this._extractConfig.customFormat.valueNotFound;
                        break;
                     case "armorGrade":
                        if(inventory[i].filterFlag & 8)
                        {
                           line[j] = ArmorGrade.lookupArmorGrade(inventory[i],true) || this._extractConfig.customFormat.valueNotFound;
                        }
                        else
                        {
                           line[j] = this._extractConfig.customFormat.valueNotFound;
                        }
                        break;
                     case "armorPiece":
                        if(inventory[i].filterFlag & 8)
                        {
                           line[j] = ArmorGrade.getArmorPieceFromName(inventory[i].text,true) || this._extractConfig.customFormat.valueNotFound;
                        }
                        else
                        {
                           line[j] = this._extractConfig.customFormat.valueNotFound;
                        }
                        break;
                     case "armorType":
                        if(inventory[i].filterFlag & 8)
                        {
                           line[j] = ArmorGrade.getArmorTypeFromName(inventory[i].text,true) || this._extractConfig.customFormat.valueNotFound;
                        }
                        else
                        {
                           line[j] = this._extractConfig.customFormat.valueNotFound;
                        }
                        break;
                     case "weaponType":
                        if(inventory[i].filterFlag & 4)
                        {
                           line[j] = WeaponTypes.getWeaponType(inventory[i]) || this._extractConfig.customFormat.valueNotFound;
                        }
                        else
                        {
                           line[j] = this._extractConfig.customFormat.valueNotFound;
                        }
                        break;
                  }
               }
               outputObject[outputObjectLine++] = line.join(this._extractConfig.customFormat.delimiter);
               i++;
            }
            source = "stashInventory";
            inv++;
         }
         return outputObject.join(this._extractConfig.customFormat.delimiterLine);
      }
      
      private function findItemCardValue(itemCards:Array, text:String) : Object
      {
         if(itemCards != null && itemCards.length > 0)
         {
            var i:int = 0;
            while(i < itemCards.length)
            {
               if(itemCards[i].text == text)
               {
                  return itemCards[i].value;
               }
               i++;
            }
         }
         return this._extractConfig.customFormat.valueNotFound;
      }
      
      private function findDamageTypeItemCard(itemCards:Array, damageType:int) : Object
      {
         var filtered:Array;
         if(itemCards != null && itemCards.length > 0)
         {
            filtered = itemCards.filter(function(i:*):*
            {
               return (i.text == "$dr" || i.text == "$dmg") && i.damageType == damageType && Number(i.value) > 0;
            });
            if(filtered.length > 0)
            {
               return filtered.map(function(i:*):*
               {
                  if(i.duration > 0)
                  {
                     return i.value + "/" + i.duration + "s";
                  }
                  if(i.projectileCount > 1)
                  {
                     return (Number(i.value) / i.projectileCount).toFixed(0) + "x" + i.projectileCount;
                  }
                  return i.value;
               }).join("+");
            }
         }
         return this._extractConfig.customFormat.valueNotFound;
      }
      
      private function tryGetItemData(item:Object, propName:String) : *
      {
         if(item == null)
         {
            return this._extractConfig.customFormat.valueNotFound;
         }
         var itemProp:* = item;
         var parts:Array = propName.split(/\./);
         var i:int = 0;
         var len:int = parts.length - 1;
         while(i < parts.length)
         {
            if(itemProp[parts[i]] == null)
            {
               return this._extractConfig.customFormat.valueNotFound;
            }
            if(i == len)
            {
               return itemProp[parts[i]];
            }
            itemProp = itemProp[parts[i]];
            i++;
         }
         return this._extractConfig.customFormat.valueNotFound;
      }
      
      override public function isValidMode(param1:uint) : Boolean
      {
         return true;
      }
      
      override public function getInvalidModeMessage() : String
      {
         return "Please, use this function only in your stash box.";
      }
   }
}

