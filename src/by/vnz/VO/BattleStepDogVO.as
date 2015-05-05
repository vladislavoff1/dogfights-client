package by.vnz.VO {
	import by.vnz.framework.VO.BaseVO;

	public class BattleStepDogVO extends BaseVO {
		public var id : String;
        public var contr :Boolean = false;
		public var stroke : uint;
		public var damage : uint;
		public var health : uint;

		/**
		   <stroke id="1">Бросок</stroke>
		   <damage>4.368</damage>
		   <health>95.632</health>
		 */
		public function BattleStepDogVO() {
			super();
		}


        override protected function parseXML(xml:XML):void {
            super.parseXML(xml);
            if (xml.hasOwnProperty("contr")){
                contr = true;
            }
        }
    }
}