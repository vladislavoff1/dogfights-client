package by.vnz.view.items {
	import by.vnz.framework.resources.ResourcesManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class ArmorItem extends Sprite {
		private var _ID : uint;

		public function ArmorItem() {
			super();

		}

		public function get ID() : uint {
			var result : uint = _ID;

			return result;
		}

		public function set ID( value : uint ) : void {
			_ID = value;

			update();
		}

		protected function update() : void {
			ResourcesManager.demandResource( "item_type3_" + _ID );
		}

		protected function onGraphics( source : MovieClip ) : void {
			if ( source ) {
				addChild( source );
			}
		}
	}
}