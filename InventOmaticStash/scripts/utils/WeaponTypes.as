package utils
{
   public class WeaponTypes
   {
      
      public static const MELEE:String = "MELEE";
      
      public static const RANGED:String = "RANGED";
      
      public static const THROWN:String = "THROWN";
      
      public function WeaponTypes()
      {
         super();
      }
      
      public static function getWeaponType(item:Object) : String
      {
         if(!item)
         {
            return "";
         }
         if(item.weaponDisplayAccuracy > 0 && item.weaponDisplayRateOfFire)
         {
            return RANGED;
         }
         if(item.weaponDisplayRange > 0)
         {
            return THROWN;
         }
         return MELEE;
      }
   }
}

