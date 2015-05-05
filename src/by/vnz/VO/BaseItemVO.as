package by.vnz.VO {
	import by.vnz.framework.VO.BaseVO;

	public class BaseItemVO extends BaseVO {
		public var itemID : uint;
		public var name : String;
		public var desc : String;
		public var price : uint;

		public function BaseItemVO() {
			super();
		}
	}
}