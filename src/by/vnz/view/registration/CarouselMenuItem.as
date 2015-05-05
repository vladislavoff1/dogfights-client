package  by.vnz.view.registration {
	import flash.display.Sprite;

	public class CarouselMenuItem extends Sprite {
		public var xpos3D : Number;
		public var zpos3D : Number;
		public var ypos3D : Number;
		public var currentAngle : Number;

		private var _data : XML;

		public function get data() : XML {
			var result : XML = _data;

			return result;
		}

		public function set data( value : XML ) : void {
			_data = value;
		}

		public function CarouselMenuItem() {
			super();
		}
	}
}