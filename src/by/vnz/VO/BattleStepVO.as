package by.vnz.VO {
	import by.vnz.framework.VO.BaseVO;

	public class BattleStepVO extends BaseVO {
		public var index : uint;
		public var steps : Array = new Array();

		/**
		   <block num="0">
		   <dog id="53620871">
		   <stroke id="1">Бросок</stroke>
		   <damage>4.368</damage>
		   <health>95.632</health>
		   </dog>
		   <dog id="43824638">
		   <stroke id="5">Укус спины</stroke>
		   <damage>8.3328</damage>
		   <health>91.6672</health>
		   </dog>
		   </block>
		 */
		public function BattleStepVO() {
			super();
		}

		override protected function parseXML( xml : XML ) : void {
			index = uint( xml.@num );
			for each ( var item : XML in xml.dog ) {
				var dog : BattleStepDogVO = new BattleStepDogVO();
				dog.update( item );
				steps.push( dog );

			}

		}
	}
}