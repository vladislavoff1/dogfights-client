package by.vnz.VO.vkontakte {
	import by.vnz.framework.model.RequestVars;
import by.vnz.framework.social_net.ISocialAPI;
import by.vnz.model.Model;

	import vnz.utils.MD5;

	public class APIVkontakteVO implements ISocialAPI{
        static public const USER_PROFILES : String = "getProfiles";
        static public const GET_FRIENDS : String = "getAppFriends";
		static public var secret_key : String = "PIBhkiPrKe";

		//идентификатор приложения, присваивается при создании.
		static public var appID : uint = 1743000;
		//если этот параметр равен 1, разрешает тестовые запросы к данным приложения.
		//При этом аутентификация не проводится и считается, что текущий пользователь – это автор приложения.
		//Это позволяет тестировать приложение без загрузки его на сайт. По умолчанию 0. 
		public var test_mode : uint = 0;
		//формат возвращаемых данных – XML или JSON. По умолчанию XML.
		public var format : String = "XML";
		//версия API, текущая версия равна 2.0.
		public var v : String = "2.0";
		
		//подпись, которая создается в целях безопасности.
		public var sig : String;
        
        public function get api_id():uint{
            return APIVkontakteVO.appID;
        }
        
        public function set api_id(value:uint):void{
            APIVkontakteVO.appID = value;
        }
        

//		public var uid : String;

		public function initSig( params : RequestVars, userID:String ) : String {
			var ar : Array = params.toString().split( "&" );
			ar.sort();
			var p : String = ar.join( "" );
			return MD5.encrypt( userID + p + secret_key );
		}

		public function APIVkontakteVO() {
			super();
		}

		static public function get requiredProps() : Array {
			var result : Array = ["api_id", "v"];
			return result;
		}
	}
}