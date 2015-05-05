package by.vnz.view.home {
	import by.vnz.framework.audio.SoundsManager;
	import by.vnz.view.dog.DogImage;
	import by.vnz.view.user.DogInfoPanel;

	public class DogInfoHomePanel extends DogInfoPanel {
		public function DogInfoHomePanel() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			BG.resource = "dog_home_info_bg";
//			BG.x += 40;
			BG.y += 40;

			levelIcon.x += 20;
			levelIcon.y += 55;

			createUIChild( DogImage, <ui name="dogImage" x="287" y="41" sendEndAnimMSG="false" /> );
			dogImage.scaleX = dogImage.scaleY = 1.3;
			dogImage.x = -240;
			dogImage.y = -85;

			titles.resource = "dog_home_info_titles";
			titles.y += 42;

			txtName.visible = txtBreed.visible = false;

			SoundsManager.requestSound( "audio.wait", true );
		}

		override public function update() : void {
			super.update();
			dogImage.data = _data;
		}

		override public function destroy() : void {
			super.destroy();
			SoundsManager.requestStopSound( "audio.wait" );
		}
	}
}