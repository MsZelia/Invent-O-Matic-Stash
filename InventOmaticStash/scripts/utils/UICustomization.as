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
      
      private static function applyUIChanges(obj:*, cfg:Object, rescale:Boolean = false) : void
      {
         if(obj != null)
         {
            obj.x += Parser.parseNumber(cfg.x);
            obj.y += Parser.parseNumber(cfg.y);
            if(rescale)
            {
               obj.scaleX = Parser.parseNumber(cfg.scaleX,1);
               obj.scaleY = Parser.parseNumber(cfg.scaleY,1);
            }
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
         var uiConfig:*;
         try
         {
            oInv = _parent.OfferInventory_mc;
            pInv = _parent.PlayerInventory_mc;
            uiConfig = config.uiConfig;
            errorCode = "hideVignette";
            if(Boolean(uiConfig.hideVignette) && getQualifiedClassName(_parent.getChildAt(0)) == "flash.display::MovieClip")
            {
               _parent.getChildAt(0).visible = false;
            }
            errorCode = "hideHeader";
            if(uiConfig.hideHeader)
            {
               _parent.Header_mc.visible = false;
            }
            errorCode = "playerInventory";
            if(uiConfig.playerInventory)
            {
               applyUIChanges(pInv,uiConfig.playerInventory,true);
               if(uiConfig.playerInventory.hideBackground)
               {
                  pInv.getChildAt(0).alpha = 0;
               }
            }
            errorCode = "otherInventory";
            if(uiConfig.otherInventory)
            {
               applyUIChanges(oInv,uiConfig.otherInventory,true);
               if(uiConfig.otherInventory.hideBackground)
               {
                  oInv.getChildAt(0).alpha = 0;
               }
            }
            errorCode = "slotInfo";
            if(uiConfig.slotInfo)
            {
               applyUIChanges(_parent.SlotInfo_mc,uiConfig.slotInfo,true);
               if(uiConfig.slotInfo.hideBackground)
               {
                  _parent.SlotInfo_mc.getChildAt(0).alpha = 0;
                  _parent.SlotInfo_mc.getChildAt(_parent.SlotInfo_mc.numChildren - 2).alpha = 0;
               }
            }
            errorCode = "expandItemLists";
            if(uiConfig.expandItemLists && uiConfig.expandItemLists.items > 0)
            {
               cfg = uiConfig.expandItemLists;
               nItems = Math.min(Parser.parsePositiveNumber(cfg.items,13),20);
               expandHeight = (nItems - 13) * 41.5;
               cfg.x = 0;
               cfg.y = expandHeight;
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
            if(uiConfig.categoryBar)
            {
               applyUIChanges(_parent.CategoryBar_mc,uiConfig.categoryBar,true);
               if(uiConfig.categoryBar.hideBackground)
               {
                  _parent.CategoryBar_mc.BackerBar_mc.getChildAt(0).alpha = 0;
               }
            }
            errorCode = "itemCardContainer";
            if(uiConfig.itemCardContainer)
            {
               applyUIChanges(_parent.ItemCardContainer_mc,uiConfig.itemCardContainer,true);
            }
            errorCode = "itemCard";
            if(uiConfig.itemCard)
            {
               cfg = uiConfig.itemCard;
               cfg.y = 0;
               cfg.textAlign = "";
               itemCard = _parent.ItemCardContainer_mc;
               applyUIChanges(itemCard.ItemCard_mc,cfg);
               applyUIChanges(itemCard.Background_mc.StatsLabelBG_mc,cfg);
               applyUIChanges(itemCard.Background_mc.Box_mc,cfg);
               applyUIChanges(itemCard.Background_mc.itemStatsLabel_tf,cfg);
            }
            errorCode = "itemCardContainer.hideBackground";
            if(uiConfig.itemCardContainer && uiConfig.itemCardContainer.hideBackground)
            {
               _parent.ItemCardContainer_mc.Background_mc.StatsLabelBG_mc.alpha = 0;
               _parent.ItemCardContainer_mc.Background_mc.Box_mc.alpha = 0;
            }
            errorCode = "itemDescription";
            if(uiConfig.itemDescription)
            {
               applyUIChanges(_parent.ItemCardContainer_mc.Background_mc.Description_mc.Description_tf,uiConfig.itemDescription,true);
            }
            errorCode = "buttonBar";
            if(uiConfig.buttonBar)
            {
               applyUIChanges(_parent.ButtonHintBar_mc,uiConfig.buttonBar,true);
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

