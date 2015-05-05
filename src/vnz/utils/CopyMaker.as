package vnz.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class CopyMaker {
		public function CopyMaker() {
		}

		static public function getBitmapCopy( source : DisplayObject, withOffset : Boolean = false ) : Bitmap {
			if ( !source ) {
				return null;
			}
			var bounds : Rectangle;
			var bitmapData : BitmapData;
			var matrix : Matrix;
			var bitmap : Bitmap;

			bounds = source.getBounds( source );

			matrix = new Matrix();
			matrix.translate( -bounds.left, -bounds.top );
			bitmapData = new BitmapData( bounds.width, bounds.height, true, 0x00000000 );

			bitmapData.draw( source, matrix );

			bitmap = new Bitmap();
			bitmap.bitmapData = bitmapData;

			if ( withOffset ) {
				bitmap.y = bounds.top;
				bitmap.x = bounds.left;
			}

			return bitmap;
		}

	}
}