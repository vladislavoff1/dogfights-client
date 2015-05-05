package by.vnz.view.home {
	import by.vnz.VO.HomeItemVO;
	import by.vnz.view.items.ItemObject;

	import flash.text.TextField;

	public class HomeItem extends ItemObject {
		public var txtQuantity : TextField;

		public function HomeItem() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			createUIChild( TextField, <ui name="txtQuantity" x="45" y="71" width="50" height="20" text="234" font="Calibri" size="13" color="0xFFFFFF" bold="true" align="right" /> );

		}

		override protected function update() : void {
			super.update();
			txtQuantity.text = ( _data as HomeItemVO ).amount.toString();
			txtQuantity.visible = (( _data as HomeItemVO ).amount > 1 );
		}

	}
}