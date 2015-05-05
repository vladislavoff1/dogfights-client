package by.vnz.framework.view.core {
	import flash.display.Shape;

	public class ExtendedShape extends Shape {
		public function ExtendedShape() {
			super();
		}

		public function graphicsDrawRect( w : uint, h : uint, color : uint = 0xffffff, alpha : Number = 1 ) : void {
			graphics.beginFill( color, alpha );
			graphics.drawRect( 0, 0, w, h );
			graphics.endFill();
		}

		public function graphicsDrawCircle( radius : uint, color : uint = 0xffffff, alpha : Number = 1 ) : void {
			graphics.beginFill( color, alpha );
			graphics.drawCircle( 0, 0, radius );
			graphics.endFill();
		}
	}
}