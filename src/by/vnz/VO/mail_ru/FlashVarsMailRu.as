package by.vnz.VO.mail_ru {
import by.vnz.framework.social_net.BaseFlashVarsVO;

public class FlashVarsMailRu extends BaseFlashVarsVO {

    // это адрес сервиса API, по которому необходимо осуществлять запросы.
    public var api_url:String = "http://www.appsmail.ru/platform/api";
    //– это id запущенного приложения.
    public var app_id:uint;
    // – это id пользователя, со страницы которого было запущено приложение. Если приложение запущено не со страницы пользователя, то значение равно 0.
    public var oid:String;
    // – это id группы, со страницы которой было запущено приложение. Если приложение запущено не со страницы группы, то значение равно 0.
    public var group_id:String;
    // – это id пользователя, который просматривает приложение.
    public var vid:String;
    //– это тип пользователя, который просматривает приложение (возможные значения описаны ниже).
    public var viewer_type:String;
    // – Сессия текущего пользователя
    public var session_key:String;
    // – окно в котором запущено приложение
    public var window_id:String;
    // тип реферала
    public var referer_type:String;
    // id того, кто пригласил в приложение
    public var referer_id:String;

    public function FlashVarsMailRu() {
        super();
    }

    override public function get viewerID():String{
        return vid;
    }
    override public function get apiID():uint{
        return app_id;
    }

    
}
}