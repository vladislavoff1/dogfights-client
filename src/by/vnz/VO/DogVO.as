package by.vnz.VO {
import by.vnz.framework.VO.BaseVO;

public class DogVO extends BaseVO {
    public var name:String = "";
    public var breedID:uint = 0;
    public var breed:String = "";
    public var level:uint;
    public var nextlevel:uint;
    public var exp:uint;
    /** strength */
    public var str:uint;
    /** dexterity */
    public var dex:uint;
    /** endurance */
    public var endu:uint;

    public var win:uint;
    public var money:uint;

    public var claw:uint;
    public var fang:uint;
    public var armor:uint;

    public var viewer_id:String = 'undefined';

    public function get photo():String {
		return 'https://graph.facebook.com/' + viewer_id + '/picture';
//		return 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/c35.35.441.441/s50x50/401470_10100510043650231_1987952959_n.jpg?oh=50aefded2f5b008fb55b4b319bbcc1dd&oe=55C71ED9&__gda__=1439057034_791031807fe905a37c4b4b1eb0c75c13';
    }

    /*public function set photo(s:String):void {
		photo_s = s;
    }*/
    /**
     <dog>
     <name>Gector</name>
     <breeID>2</breeID>
     <breed>Ротвейлер</breed>
     <level>1</level>
     <nextlevel>100</nextlevel>
     <exp>1</exp>
     <str>10</str>
     <dex>15</dex>
     <endu>29</endu>
     <money>446490</money>
     <win>1</win>
     <clow>7</clow>
     <fang>24</fang>
     <armor>48</armor>
     </dog>
     */

    public function DogVO() {
        super();
    }


    override protected function parseXML(xml:XML):void {
        if (xml.hasOwnProperty("breedID")) {
            if (!xml.hasOwnProperty("armor")) {
                armor = 0;
            }
            if (!xml.hasOwnProperty("fang")) {
                fang = 0;
            }
            if (!xml.hasOwnProperty("clow")) {
                claw = 0;
            }
        }
        /*if (xml.hasOwnProperty("pic")) {
            this.photo = String(xml.pic.*);
        }*/
        //name = breed;
        super.parseXML(xml);
    }
}
}