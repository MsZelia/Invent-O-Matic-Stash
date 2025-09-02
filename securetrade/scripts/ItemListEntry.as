package
{
   import Shared.AS3.ItemListEntryBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ItemListEntry extends ItemListEntryBase
   {
      
      public var LeftIcon_mc:MovieClip;
      
      public var FavoriteIcon_mc:MovieClip;
      
      public var TaggedForSearchIcon_mc:MovieClip;
      
      public var questItemIcon_mc:MovieClip;
      
      public var SetBonusIcon_mc:MovieClip;
      
      public var ItemLockIcon_mc:MovieClip;
      
      protected var BaseTextFieldWidth:uint;
      
      protected var BaseTextFieldX:Number;
      
      public function ItemListEntry()
      {
         super();
         this.BaseTextFieldWidth = textField.width;
         this.BaseTextFieldX = textField.x;
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc9_:Object = null;
         super.SetEntryText(param1,param2);
         var _loc3_:* = GlobalFunc.BuildLegendaryStarsGlyphString(param1);
         var _loc4_:int = 0;
         if(param1.barterCount != undefined)
         {
            _loc4_ = GlobalFunc.Clamp(param1.barterCount,0,param1.count);
         }
         var _loc5_:uint = param1.count - _loc4_;
         if(param1.numLegendaryStars > 0)
         {
            textField.appendText(_loc3_);
            this.TruncateSingleLineLegendary(textField,param1.numLegendaryStars,GlobalFunc.MAX_TRUNCATED_TEXT_LENGTH);
         }
         else
         {
            GlobalFunc.SetText(textField,textField.text,false,false,true);
         }
         if(_loc5_ != 1)
         {
            textField.appendText(" (" + _loc5_ + ")");
         }
         if(param1.isLearnedRecipe)
         {
            textField.text = "$$Known " + textField.text;
         }
         GlobalFunc.SetText(textField,textField.text,false);
         if(this.LeftIcon_mc != null)
         {
            SetColorTransform(this.LeftIcon_mc,this.selected);
            this.LeftIcon_mc.EquipIcon_mc.visible = param1.equipState != 0 && !(SecureTrade.IsTransferLockingFeatureEnabled && param1.isTransferLocked);
            this.LeftIcon_mc.BestIcon_mc.visible = param1.inContainer && param1.bestInClass;
            if(this.LeftIcon_mc.BarterIcon_mc)
            {
               this.LeftIcon_mc.BarterIcon_mc.visible = _loc4_ < 0;
            }
            if(this.LeftIcon_mc.ItemLockIcon_mc)
            {
               this.LeftIcon_mc.ItemLockIcon_mc.visible = SecureTrade.IsTransferLockingFeatureEnabled && param1.isTransferLocked;
               this.LeftIcon_mc.ItemLockIcon_mc.gotoAndStop(param1.equipState != 0 ? "isEquipped" : "isUnequipped");
            }
         }
         var _loc6_:Array = [];
         _loc6_.push({
            "clip":this.FavoriteIcon_mc,
            "visible":param1.favorite > 0
         });
         _loc6_.push({
            "clip":this.questItemIcon_mc,
            "visible":param1.isQuestItem || param1.isSharedQuestItem
         });
         _loc6_.push({
            "clip":this.TaggedForSearchIcon_mc,
            "visible":param1.taggedForSearch
         });
         _loc6_.push({
            "clip":this.SetBonusIcon_mc,
            "visible":param1.isSetItem
         });
         if(this.questItemIcon_mc)
         {
            this.questItemIcon_mc.gotoAndStop(param1.isSharedQuestItem ? "shared" : "local");
         }
         if(this.SetBonusIcon_mc)
         {
            this.SetBonusIcon_mc.gotoAndStop(Boolean(param1.isSetBonusActive) && param1.equipState != 0 ? "active" : "inactive");
         }
         var _loc7_:* = this.textField.getLineMetrics(0).width + this.textField.x;
         var _loc8_:* = 10;
         var _loc10_:* = 0;
         while(_loc10_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc10_];
            if(_loc9_.clip != null)
            {
               _loc9_.clip.visible = _loc9_.visible;
               if(_loc9_.visible == true)
               {
                  SetColorTransform(_loc9_.clip,this.selected);
                  _loc9_.clip.x = _loc7_ + _loc8_;
                  _loc8_ += _loc9_.clip.width + 3;
               }
            }
            _loc10_++;
         }
         textField.width = this.BaseTextFieldWidth - _loc8_;
      }
      
      public function TruncateSingleLineLegendary(param1:TextField, param2:int, param3:*) : *
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1.text.length > param3)
         {
            _loc4_ = param1.text.length - param3;
            _loc5_ = param1.text.substr(0,param1.text.length - param2);
            _loc6_ = param1.text.substr(param1.text.length - param2,param2);
            param1.text = _loc5_;
            param1.replaceText(param1.length - _loc4_ - param2,param1.length,"…");
            param1.appendText(_loc6_);
         }
      }
   }
}

