package by.vnz.VO {

	public class EnemyVO extends DogVO {
		public var user : String = 'undefined';
		public var dogID : uint;

		override public function get photo():String {
			return 'https://graph.facebook.com/' + user + '/picture';
		}
		/**
		 *
		   <dog>
		   <user>62088254</user>
		   <dogID>3153</dogID>
		   <dogname>ушастик</dogname>
		   <breedID>3</breedID>
		   <breed>Немецкая овчарка</breed>
		   <level>1</level>
		   <health>100</health>
		   <exp>1</exp>
		   <str>7</str>
		   <dex>5</dex>
		   <endu>6</endu>
		   </dog>
		 */
		public function EnemyVO() {
			super();
		}
	}
}