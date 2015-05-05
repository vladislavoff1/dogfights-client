package by.vnz.VO.vkontakte {
import by.vnz.framework.VO.BaseVO;

public class AppSettingsVkontakteVO extends BaseVO {
    /** битовая маска настроек
     * +1 – пользователь разрешил отправлять ему уведомления.
     * +2 – доступ к друзьям.
     * +4 – доступ к фотографиям.
     * +8 – доступ к аудиозаписям.
     * +16 - нет свойства
     * +32 – доступ к предложениям.
     * +64 – доступ к вопросам.
     * +128 – доступ к wiki-страницам.
     * +256 – доступ к меню слева.
     * +512 – публикация на стенах пользователей.
     */

    public var sendMessages:Boolean;
    public var friends:Boolean;
    public var photos:Boolean;
    public var audio:Boolean;
    public var tender:Boolean;
    public var questions:Boolean;
    public var wiki:Boolean;
    public var leftMenu:Boolean;
    public var wall:Boolean;

    private var temp:Boolean;

    static protected var props:Array = ["sendMessages","friends","photos","audio","temp","tender","questions","wiki","leftMenu","wall", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp"];

    public function AppSettingsVkontakteVO() {
        super();
    }


    override protected function parseSource(source:*):void {
        var bits:uint = uint(source);
        debug("settings bits", bits.toString(2));
        var v:uint;
        var i:uint = 0;
        var s:uint = 0;
        //        sendMessages = Boolean(bits & 1);
        while (s <= bits) {
            var prop:String = props[i];
            if (!prop){
                i++;
                continue;
            }
            this[prop] = Boolean(bits >> i & 1);
            debug("settings [" + prop + "]", this[prop]);
            s += Math.pow(2, i);
            i++;
        }

    }
}
}