package utils
{
   public class CurrencyLimit
   {
      
      public static var GREEN:uint = 65280;
      
      public static var YELLOW:uint = 16772608;
      
      public static var RED:uint = 16711680;
      
      private static var limit_low:Number = 80;
      
      private static var limit_high:Number = 90;
      
      private static var default_color:uint = GREEN;
      
      private static var limit_low_color:uint = YELLOW;
      
      private static var limit_high_color:uint = RED;
      
      private static var lastCurrency:uint = 0;
      
      private static var lastCurrencyMax:uint = 0;
      
      public static var debug:Boolean = false;
      
      public function CurrencyLimit()
      {
         super();
      }
      
      public static function init(config:Object) : *
      {
         limit_low = Parser.parseNumber(config.limitLow,limit_low);
         limit_low_color = Parser.parseNumber(config.limitLowColor,limit_low_color);
         limit_high = Parser.parseNumber(config.limitHigh,limit_high);
         limit_high_color = Parser.parseNumber(config.limitHighColor,limit_high_color);
         default_color = Parser.parseNumber(config.defaultColor,default_color);
         debug = Parser.parseBoolean(config.debug,false);
      }
      
      public static function setTextfieldLimitColor(textfield:Object, playerCurrency:uint, currencyLimit:uint) : *
      {
         if(!textfield || playerCurrency == lastCurrency && lastCurrencyMax == currencyLimit)
         {
            return;
         }
         if(playerCurrency > limit_high / 100 * currencyLimit)
         {
            textfield.textColor = limit_high_color;
            if(debug)
            {
               Logger.get().info("CurrencyLimit: High (>" + limit_high / 100 * currencyLimit + ") " + playerCurrency + "/" + currencyLimit);
            }
         }
         else if(playerCurrency > limit_low / 100 * currencyLimit)
         {
            textfield.textColor = limit_low_color;
            if(debug)
            {
               Logger.get().info("CurrencyLimit: Low (>" + limit_low / 100 * currencyLimit + ") " + playerCurrency + "/" + currencyLimit);
            }
         }
         else
         {
            textfield.textColor = default_color;
            if(debug)
            {
               Logger.get().info("CurrencyLimit: No limit " + playerCurrency + "/" + currencyLimit);
            }
         }
         lastCurrency = playerCurrency;
         lastCurrencyMax = currencyLimit;
      }
   }
}

