package by.vnz.VO {
	import by.vnz.framework.VO.BaseVO;

	public class BattleWinVO extends BaseVO {

		public var userID : uint;
		public var exp : uint;
		public var money : uint;
		public var resmsg : String;

		/**
		   <dog>
		   <userID>93620871</userID>
		   <exp>10</exp>
		   <money>20</money>
		   <resmsg>Собака выйграла поединок</resmsg>
		   </dog>
		 */
		public function BattleWinVO() {
			super();
		}
	}
}