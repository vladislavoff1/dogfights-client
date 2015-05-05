package by.vnz.VO {
import by.vnz.framework.VO.BaseVO;

public class FriendVO extends BaseVO {
    public var user:String;
    public var level:uint;
    public var photo:String;

    public function FriendVO(source:Object) {
        super(source);
    }

    override protected function parseXML(xml:XML):void {
        if (xml.hasOwnProperty("pic")) {
            this.photo = String(xml.pic.*);
        }

        super.parseXML(xml);
    }
}
}