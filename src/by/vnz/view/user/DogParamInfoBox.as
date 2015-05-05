package by.vnz.view.user {
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.idmaps.IDMDogParams;

	public class DogParamInfoBox extends GUIElement {
		public var paramName : String = IDMDogParams.STRENGTH;
		public var bar : DogParamBar;
		public var icon : UserPropIcon;

		public function DogParamInfoBox() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			createUIChild( DogParamBar, <ui name="bar" paramName={this.paramName} /> );
			createUIChild( DogParamIcon, <ui name="icon" x="120" y="-6" /> );

//			icon.BG.resource = paramName + "_icon_bg";
//			setGUIParams( txt, <ui x="0" y="3" width="22" height="15" text="1" font="Avanti" size="12" color="0xFFFFFF" bold="true" align="center" /> );

		}

		public function update( value : uint, barValue : uint ) : void {
			bar.data = barValue;
			icon.data = value;
		}
	}
}