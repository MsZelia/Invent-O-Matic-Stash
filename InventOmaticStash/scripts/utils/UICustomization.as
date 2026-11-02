package utils
{
   import flash.text.*;
   import flash.utils.getQualifiedClassName;
   
   public class UICustomization
   {
      
      private static var _parent:Object;
      
      public function UICustomization()
      {
         super();
      }
      
      public static function init(parent:Object) : void
      {
         if(config.uiConfig && config.uiConfig.enabled)
         {
            _parent = parent;
            initUIConfig();
         }
      }
      
      private static function get config() : Object
      {
         return InventOmaticConfig.get();
      }
      
      private static function setAlignment(obj:*, align:String) : void
      {
         if(obj != null && (align == "left" || align == "right" || align == "center"))
         {
            var textFormat:* = obj.getTextFormat();
            if(textFormat != null)
            {
               textFormat.align = align;
               obj.defaultTextFormat = textFormat;
               obj.setTextFormat(textFormat);
            }
         }
      }
      
      private static function applyUIChanges(obj:*, cfg:Object) : void
      {
         if(obj != null)
         {
            obj.x += Parser.parseNumber(cfg.x);
            obj.y += Parser.parseNumber(cfg.y);
            if(obj is TextField)
            {
               obj.width += Parser.parseNumber(cfg.width);
               setAlignment(obj,cfg.textAlign);
            }
            obj.alpha = 1;
         }
      }
      
      private static function initUIConfig() : void
      {
         var expandHeight:Number;
         var errorCode:String;
         var cfg:Object;
         var nItems:int;
         var oInv:*;
         var pInv:*;
         var itemCard:*;
         try
         {
            errorCode = "hideVignette";
            if(Boolean(config.uiConfig.hideVignette) && getQualifiedClassName(_parent.getChildAt(0)) == "flash.display::MovieClip")
            {
               _parent.getChildAt(0).visible = false;
            }
            errorCode = "hideHeader";
            if(config.uiConfig.hideHeader)
            {
               _parent.Header_mc.visible = false;
            }
            errorCode = "hideHeader";
            if(config.uiConfig.playerInventory)
            {
               applyUIChanges(_parent.PlayerInventory_mc,config.uiConfig.playerInventory);
            }
            errorCode = "hideHeader";
            if(config.uiConfig.otherInventory)
            {
               applyUIChanges(_parent.OfferInventory_mc,config.uiConfig.otherInventory);
            }
            errorCode = "slotInfo";
            if(config.uiConfig.slotInfo)
            {
               applyUIChanges(_parent.SlotInfo_mc,config.uiConfig.slotInfo);
            }
            errorCode = "expandItemLists";
            if(config.uiConfig.expandItemLists && config.uiConfig.expandItemLists.items > 0)
            {
               cfg = config.uiConfig.expandItemLists;
               nItems = Math.min(Parser.parsePositiveNumber(cfg.items,13),40);
               expandHeight = (nItems - 13) * 41.5;
               cfg.x = 0;
               cfg.y = expandHeight;
               oInv = _parent.OfferInventory_mc;
               pInv = _parent.PlayerInventory_mc;
               oInv.ItemList_mc.numItems_Inspectable = nItems;
               pInv.ItemList_mc.numItems_Inspectable = nItems;
               oInv.getChildAt(0).height = oInv.getChildAt(0).height + expandHeight;
               pInv.getChildAt(0).height = pInv.getChildAt(0).height + expandHeight;
               applyUIChanges(pInv.PlayerCurrency_tf,cfg);
               applyUIChanges(pInv.CurrencyIcon_mc,cfg);
               applyUIChanges(pInv.PlayerWeight_tf,cfg);
               applyUIChanges(pInv.Tooltip_mc,cfg);
               applyUIChanges(pInv.getChildAt(6),cfg);
               applyUIChanges(oInv.OfferCurrency_tf,cfg);
               applyUIChanges(oInv.CurrencyIcon_mc,cfg);
               applyUIChanges(oInv.miniTooltip_mc,cfg);
               applyUIChanges(oInv.OfferWeight_tf,cfg);
               applyUIChanges(oInv.Tooltip_mc,cfg);
               applyUIChanges(oInv.OfferWeightIcon,cfg);
            }
            errorCode = "categoryBar";
            if(config.uiConfig.categoryBar)
            {
               applyUIChanges(_parent.CategoryBar_mc,config.uiConfig.categoryBar);
            }
            errorCode = "itemCardContainer";
            if(config.uiConfig.itemCardContainer)
            {
               applyUIChanges(_parent.ItemCardContainer_mc,config.uiConfig.itemCardContainer);
            }
            errorCode = "itemCard";
            if(config.uiConfig.itemCard)
            {
               cfg = config.uiConfig.itemCard;
               cfg.y = 0;
               cfg.textAlign = "";
               itemCard = _parent.ItemCardContainer_mc;
               applyUIChanges(itemCard.ItemCard_mc,cfg);
               applyUIChanges(itemCard.Background_mc.StatsLabelBG_mc,cfg);
               applyUIChanges(itemCard.Background_mc.Box_mc,cfg);
               applyUIChanges(itemCard.Background_mc.itemStatsLabel_tf,cfg);
            }
            errorCode = "itemDescription";
            if(config.uiConfig.itemDescription)
            {
               applyUIChanges(_parent.ItemCardContainer_mc.Background_mc.Description_mc.Description_tf,config.uiConfig.itemDescription);
            }
            errorCode = "buttonBar";
            if(config.uiConfig.buttonBar)
            {
               applyUIChanges(_parent.ButtonHintBar_mc,config.uiConfig.buttonBar);
            }
            _parent.alpha = 1;
         }
         catch(e:*)
         {
            Logger.get().error("Error initUIConfig (" + errorCode + "): " + e);
            InventOMaticStash.ShowHUDMessage("Error initUIConfig (" + errorCode + "): " + e,true);
         }
      }
   }
}

