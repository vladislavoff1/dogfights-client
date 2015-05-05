package by.vnz.view.user {
	import by.vnz.framework.view.components.ImageProxy;

	import flash.text.TextField;

	public class LevelIcon extends UserPropIcon {
		public function LevelIcon() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			BG.resource = "level_icon_bg";

			setGUIParams( txt, <ui x="0" y="3" width="22" height="15" text="1" font="Avanti" size="12" color="0xFFFFFF" bold="true" align="center" /> );

		}
	}
}