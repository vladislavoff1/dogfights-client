package by.vnz.framework.social_net {
public class BaseFlashVarsVO {

    // – если пользователь установил приложение – 1, иначе – 0.
    public var is_app_user:uint;

    public function BaseFlashVarsVO() {
    }

    public function get viewerID():String {
        return "";
    }

    public function get apiID():uint {
        return 0;
    }
}
}