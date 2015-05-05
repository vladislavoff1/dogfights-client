package by.vnz.view.user {
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;

	import flash.text.TextField;

	public class UserPropIcon extends GUIElement {
		public var BG : ImageProxy;
		public var txt : TextField;
		protected var _data : uint = 0;

		public function UserPropIcon() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			createUIChild( ImageProxy, <ui name="BG"  /> );

			createUIChild( TextField, <ui name="txt" x="0" y="3" width="22" height="15" text="1" font="Avanti" size="12" color="0xFFFFFF" bold="true" align="center" /> );

			//update
			data = _data;
		}

		public function get data() : uint {
			var result : uint = _data;

			return result;
		}

		public function set data( value : uint ) : void {
			_data = value;

			if ( _data > 0 ) {
				txt.text = _data.toString();
			}
		}
	}
}