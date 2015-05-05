package by.vnz.idmaps {

	public class IDMServerMethods {
		static public const REG_DOG : String = "dogreg.php?do=userReg&";
		static public const DOG_LIST : String = "dogreg.php?do=getdog&";
        static public const CHOOSE_DOG : String = "doghome.php?do=chooseDog&";
        static public const GET_DOG : String = "doginfo.php?do=getdog&"; //"dogreg.php?";
        static public const SHOP_ITEMS : String = "dogshop.php?do=getItems&";
        static public const SHOP_BUY_ITEM : String = "dogshop.php?do=buyItem&";
        static public const DOG_HOME_INFO : String = "doghome.php?do=getInfo&";
        static public const DOG_HOME_MOVE_ITEM : String = "doghome.php?do=moveItem&";
        static public const DOG_HOME_SELL_ITEM : String = "doghome.php?do=sellItem&";
        static public const CHANGE_DOG : String = "doghome.php?do=changeDog&";
        static public const BATTLE_GET_ENEMIES : String = "dogfights.php?do=getEnemy&";
		static public const BATTLE_FIGHT : String = "dogfights.php?do=dogfight&";
		static public const FIGHT_ENABLED : String = "dogfights?do=checkLockFights&";
		static public const BUY_FIGHT : String = "dogfights.php?do=buyFight&";
		static public const GET_USER_BALANCE : String = "dogbank.php?do=getUserBalance&";
		static public const VOICES_EXCHANGE : String = "dogbank.php?do=addUserBalance&";
        static public const FRIENDS_REITING : String = "doginfo.php?do=friendsRating&"; 
        static public const TRAINING_CAMP_ITEMS : String = "doggym.php?do=getItems&";
        static public const TRAINING_CAMP_USE : String = "doggym.php?do=buytraining&"; 
        static public const INVITE_FRIENDS : String = "friends_ajax.php"; 

		///API vkontakte
		static public const IS_APP_USER : String = "isAppUser";
        static public const GET_FRIENDS : String = "getAppFriends";
		static public const USER_PROFILES : String = "getProfiles";
		static public const GET_APP_SETTINGS : String = "getUserSettings";
		static public const GET_ADS : String = "getAds";

		public function IDMServerMethods() {
		}
	}
}