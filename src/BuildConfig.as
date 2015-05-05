package {

import by.vnz.VO.vkontakte.APIVkontakteVO;
import by.vnz.framework.model.HTTPRequester;
import by.vnz.framework.resources.EnhancedResource;

import logger.Logger;

/**
 * false/true can be changed
 */
public class BuildConfig {
    static public const API_VK:String = "api_vk";
    static public const API_MAIL_RU:String = "api_mail_ru";

    private static const CACHE_BY_VERSION_ENABLED:Boolean = true;
    private static const LOG_ENABLED:Boolean = true;

    static public var BASE_URL:String = "http://www.1.vard777.z8.ru/en/";
    static public var SOCIAL_API_URL:String = "http://api.vkontakte.ru/api.php";
    /** set "debug(development)" OR "release" mode build */
    public static var DEV_MODE:Boolean = false;
    /** use web data or offline xml/text files */
    public static var OFFLINE_MODE:Boolean = false;
    public static var API_TYPE:String = API_VK;
    /** variables which dependence of DEV_MODE */
    private static var ANTICACHE_ANYWAY:Boolean = true;
    private static var USE_AIR_BASED_DEBUGGERS:Boolean = false;

    static public function init():void {
        inf("Release mode", !DEV_MODE);

        EnhancedResource.baseURL = BASE_URL;// + "stars/";
        if (DEV_MODE) {
            ANTICACHE_ANYWAY = true;
            USE_AIR_BASED_DEBUGGERS = true;
			APIVkontakteVO.secret_key = "VTzZPVcATO";
//            EnhancedResource.baseURL = "";
        }
        if (OFFLINE_MODE) {
            EnhancedResource.baseURL = "";
        }

//        HTTPRequester.offLineMode = OFFLINE_MODE;
        debug("EnhancedResource.baseURL", EnhancedResource.baseURL);
        EnhancedResource.cacheByVersionEnabled = CACHE_BY_VERSION_ENABLED;
        EnhancedResource.anticacheAnyway = ANTICACHE_ANYWAY;
        Logger.enabled = LOG_ENABLED;
        inf("Cache enabled", ( CACHE_BY_VERSION_ENABLED && ( !ANTICACHE_ANYWAY )));
    }

    static public function get onMailRu():Boolean{
        return (API_TYPE == API_MAIL_RU);
    }

}
}