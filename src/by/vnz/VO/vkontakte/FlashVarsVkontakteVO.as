package by.vnz.VO.vkontakte {
import by.vnz.framework.social_net.BaseFlashVarsVO;

public class FlashVarsVkontakteVO extends BaseFlashVarsVO {
    // это адрес сервиса API, по которому необходимо осуществлять запросы.
    public var api_url:String;
    //– это id запущенного приложения.
    public var api_id:uint;
    // – это id пользователя, со страницы которого было запущено приложение. Если приложение запущено не со страницы пользователя, то значение равно 0.
    public var user_id:uint;
    // – это id группы, со страницы которой было запущено приложение. Если приложение запущено не со страницы группы, то значение равно 0.
    public var group_id:String;
    // – это id пользователя, который просматривает приложение.
    public var viewer_id:String;
    //– это тип пользователя, который просматривает приложение (возможные значения описаны ниже).
    public var viewer_type:String;
    // – это ключ, необходимый для авторизации пользователя на стороннем сервере (см. описание ниже).
    public var auth_key:String;
    // – это id языка пользователя, просматривающего приложение (см. список языков ниже).
    public var language:String;
    // – это результат первого API-запроса, который выполняется при загрузке приложения (см. описание ниже).
    public var api_result:String;
    // – битовая маска настроек текущего пользователя в данном приложении (подробнее см. в описании метода getUserSettings).
    public var api_settings:uint;
    //имя localConnection
    public var lc_name:String;

    public function FlashVarsVkontakteVO() {
    }

    override public function get viewerID():String {
        return viewer_id;
    }

    override public function get apiID():uint {
        return api_id;
    }
}
}