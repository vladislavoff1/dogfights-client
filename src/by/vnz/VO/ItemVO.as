package by.vnz.VO {
	import by.vnz.framework.VO.BaseVO;

	public class ItemVO extends BaseItemVO {
        public var level : uint;
        public var rate : uint;
		public var type : uint;

		public function ItemVO() {
			super();
		}
	}
}