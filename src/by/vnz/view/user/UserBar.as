package by.vnz.view.user {
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;

	public class UserBar extends GUIElement {
		public var BG : ImageProxy;
		public var line : ImageProxy;
		public var border : ImageProxy;
		protected var _data : uint = 1;

		public function UserBar() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			createUIChild( ImageProxy, <ui name="BG"  /> );
			createUIChild( ImageProxy, <ui name="line"  /> );
			createUIChild( ImageProxy, <ui name="border"  /> );

			data = _data;
		}

		public function get data() : uint {
			var result : uint = _data;

			return result;
		}

		public function set data( value : uint ) : void {
			_data = value;

			if ( _data > 0 ) {
				line.scaleX = _data / 100;
			}
		}
	}
}