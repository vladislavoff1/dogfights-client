package by.vnz.view.user {
	import by.vnz.idmaps.IDMDogParams;

	public class DogParamBar extends UserBar {
		public var paramName : String = IDMDogParams.STRENGTH;

		public function DogParamBar() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			BG.resource = "dog_info_bar_bg";
			line.resource = "dog_" + paramName + "_bar_line";
			border.resource = "dog_info_bar_border";
		}
	}
}