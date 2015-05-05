package by.vnz.view.user {
	import by.vnz.idmaps.IDMDogParams;

	public class DogParamIcon extends UserPropIcon {
		public var paramName : String = IDMDogParams.STRENGTH;

		public function DogParamIcon() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			BG.resource = paramName + "_icon_bg";

			setGUIParams( txt, <ui x="0" y="3" width="22" height="15" text="1" font="Avanti" size="12" color="0xFFFFFF" bold="true" align="center" /> );

		}
	}
}