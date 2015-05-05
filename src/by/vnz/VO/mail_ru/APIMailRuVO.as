package by.vnz.VO.mail_ru {
import by.vnz.framework.model.RequestVars;
import by.vnz.framework.social_net.ISocialAPI;
import by.vnz.model.Model;
import vnz.utils.MD5;

public class APIMailRuVO implements ISocialAPI{
    static public const USER_PROFILES : String = "users.getInfo";
    static public const GET_FRIENDS : String = "friends.getAppUsers";
    static public const PAYMENT_DIALOG : String = "payments.openDialog" ;


    static public const secret_key : String = "d6a9293024166f90784c3d8d8c9cdec2";

    //идентификатор приложения, присваивается при создании.
    static public var appID : uint;
    //формат возвращаемых данных – XML или JSON. По умолчанию XML.
    public var format : String = "xml";

    public function get app_id():uint{
        return APIMailRuVO.appID;
    }

    public function set app_id(value:uint):void{
        APIMailRuVO.appID = value;
    }

//    //подпись, которая создается в целях безопасности.
    public function initSig( params : RequestVars, userID :String ) : String {
        var ar : Array = params.toString().split( "&" );
        ar.sort();
        var p : String = ar.join( "" );
        return MD5.encrypt( userID + p + secret_key );
    }


    static public function get requiredProps() : Array {
        var result : Array = ["app_id", "format"];
        return result;
    }


}
}