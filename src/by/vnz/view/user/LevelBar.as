package by.vnz.view.user {
	import by.vnz.framework.view.components.ImageProxy;

	public class LevelBar extends UserBar {

		public function LevelBar() {
			super();

		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

			setGUIParams( BG, <ui resource="level_bar_bg" x="0" y="0" /> );
			setGUIParams( line, <ui  resource="level_bar_line" x="0" y="0" /> );
			setGUIParams( border, <ui  resource="level_bar_border" x="0" y="0" /> );

		}

	}
}