package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ItemCard_Entry extends MovieClip
   {
      
      public static var DynamicModDescEnable:Boolean = false;
      
      public static var AdvanceModDescMode:Boolean = false;
      
      public static var ShowDurability:Boolean = true;
      
      public var Label_tf:TextField;
      
      public var Value_tf:TextField;
      
      public var Difference_mc:MovieClip;
      
      public var Comparison_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var Sizer_mc:MovieClip;
      
      private var m_Count:uint = 0;
      
      public function ItemCard_Entry()
      {
         super();
         Extensions.enabled = true;
      }
      
      public static function ShouldShowDifference(param1:Object) : Boolean
      {
         var _loc2_:uint = param1.precision != undefined ? uint(param1.precision) : 0;
         var _loc3_:Number = 1;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ /= 10;
            _loc4_++;
         }
         return Math.abs(param1.difference) >= _loc3_;
      }
      
      public function PopulateText(param1:String) : *
      {
         if(this.Label_tf != null)
         {
            GlobalFunc.SetText(this.Label_tf,param1,false);
            TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      public function PopulateEntry(param1:Object) : *
      {
         var _loc2_:* = null;
         if(this.Label_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(this.Value_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.PopulateDifferenceValue(param1);
         this.PopulateText(param1.text);
         if(this.Value_tf != null)
         {
            if(param1.value is String)
            {
               _loc2_ = param1.value;
            }
            else
            {
               _loc2_ = this.getValueTextWithPrecision(param1.value,param1.precision,param1.scaleWithDuration,param1.duration);
               if(param1.showAsPercent)
               {
                  _loc2_ += "%";
               }
            }
            GlobalFunc.SetText(this.Value_tf,_loc2_,false);
            this.setIconPosition();
         }
      }
      
      public function getValueTextWithPrecision(param1:Number, param2:uint, param3:Boolean, param4:uint) : String
      {
         var _loc5_:String = null;
         var _loc6_:Number = param1;
         if(param3)
         {
            _loc6_ *= param4;
         }
         if(param2)
         {
            _loc5_ = _loc6_.toFixed(param2);
         }
         else
         {
            _loc5_ = Math.round(_loc6_).toString();
         }
         if(_loc6_ > 0 && parseFloat(_loc5_) < 0.001)
         {
            _loc5_ = "< 0.001";
         }
         return GlobalFunc.TrimZeros(_loc5_);
      }
      
      public function PopulateDifferenceValue(param1:Object) : *
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         if(ShouldShowDifference(param1))
         {
            _loc2_ = "";
            _loc3_ = "";
            _loc4_ = Number(param1.value);
            _loc5_ = Number(param1.originalValue);
            _loc6_ = param1.precision ? uint(param1.precision) : 0;
            if(!param1.precision)
            {
               _loc4_ = Math.round(_loc4_);
               _loc5_ = Math.round(_loc5_);
            }
            _loc7_ = _loc4_ - _loc5_;
            if(Boolean(this.Difference_mc) && DynamicModDescEnable)
            {
               gotoAndStop(AdvanceModDescMode ? "numbers" : "symbols");
               switch(param1.text)
               {
                  case "$APCost":
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(_loc7_ < 0 ? "Good" : "Bad");
                        _loc3_ = _loc7_ > 0 ? "+" : "";
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(_loc7_ < 0 ? "GoodDecrease" : "BadIncrease");
                     }
                     break;
                  case "$wt":
                     _loc7_ *= -1;
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(_loc7_ < 0 ? "Good" : "Bad");
                        _loc3_ = _loc7_ > 0 ? "+" : "";
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(_loc7_ < 0 ? "GoodDecrease" : "BadIncrease");
                     }
                     break;
                  default:
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(_loc7_ < 0 ? "Bad" : "Good");
                        _loc3_ = _loc7_ > 0 ? "+" : "";
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(_loc7_ < 0 ? "BadDecrease" : "GoodIncrease");
                     }
               }
               if(this.Difference_mc.Difference_tf)
               {
                  TextFieldEx.setTextAutoSize(this.Difference_mc.Difference_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  _loc2_ = _loc7_.toFixed(_loc6_);
                  this.Difference_mc.Difference_tf.text = _loc3_ + _loc2_;
               }
            }
            else if(this.Comparison_mc != null)
            {
               switch(param1.diffRating)
               {
                  case -3:
                     this.Comparison_mc.gotoAndStop("Worst");
                     break;
                  case -2:
                     this.Comparison_mc.gotoAndStop("Worse");
                     break;
                  case -1:
                     this.Comparison_mc.gotoAndStop("Bad");
                     break;
                  case 1:
                     this.Comparison_mc.gotoAndStop("Good");
                     break;
                  case 2:
                     this.Comparison_mc.gotoAndStop("Better");
                     break;
                  case 3:
                     this.Comparison_mc.gotoAndStop("Best");
                     break;
                  default:
                     this.Comparison_mc.gotoAndStop("None");
               }
            }
         }
      }
      
      public function setIconPosition() : void
      {
         if(this.Icon_mc != null)
         {
            this.Icon_mc.x = this.Value_tf.x + this.Value_tf.width - this.Value_tf.getLineMetrics(0).width - this.Icon_mc.width / 2 - 8;
         }
      }
      
      public function populateStackWeight(param1:Object, param2:uint) : void
      {
         var _loc4_:String = null;
         this.PopulateText("$StackWeight");
         TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         var _loc3_:Number = param1.value * param2;
         if(_loc3_ < 1)
         {
            _loc4_ = "< 1";
         }
         else
         {
            _loc4_ = _loc3_.toFixed(0);
         }
         GlobalFunc.SetText(this.Value_tf,_loc4_,false);
      }
      
      public function populateStashStackWeight(param1:Object, param2:uint, suffix:String) : void
      {
         param4 = null;
         this.PopulateText("$WeightInStash");
         this.Label_tf.text += suffix;
         TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         param3 = param1.value * param2;
         if(param3 < 1)
         {
            param4 = "< 1";
         }
         else
         {
            param4 = String(param3.toFixed(2));
         }
         GlobalFunc.SetText(this.Value_tf,param4,false);
      }
   }
}

