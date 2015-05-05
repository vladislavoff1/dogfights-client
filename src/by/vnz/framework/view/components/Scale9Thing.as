package by.vnz.framework.view.components {
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class Scale9Thing extends MovieClip {
		private var PieceLU : Bitmap;
		private var PieceCU : Bitmap;
		private var PieceRU : Bitmap;
		private var PieceLM : Bitmap;
		private var PieceCM : Bitmap;
		private var PieceRM : Bitmap;
		private var PieceLB : Bitmap;
		private var PieceCB : Bitmap;
		private var PieceRB : Bitmap;

		private var scaleRect : Rectangle;

		private var pieceNames : Array = ["PieceLU",
			"PieceCU",
			"PieceRU",
			"PieceLM",
			"PieceCM",
			"PieceRM",
			"PieceLB",
			"PieceCB",
			"PieceRB",];

		public var initialized : Boolean;

		public function Scale9Thing() {
			super();

			initialized = false;
			cacheAsBitmap = true;
		}

		/**
		 * @param
		 */
		public function monumentalize() : void {
			var aBounds : Rectangle;
			var aData : BitmapData;
			var aMatrix : Matrix;
			var aBitmap : Bitmap;

			aBounds = getBounds( this );

			aMatrix = new Matrix();
			aMatrix.translate( -aBounds.left, -aBounds.top );
			aData = new BitmapData( aBounds.width, aBounds.height, true, 0x00000000 );

			aData.draw( this, aMatrix );

			aBitmap = new Bitmap();
			aBitmap.y = aBounds.top;
			aBitmap.x = aBounds.left;
			aBitmap.bitmapData = aData;

			destroy();
			addChild( aBitmap );
		}

		/**
		 * @param
		 */
		public function destroy() : void {
			var aBitmap : Bitmap;

			if ( PieceLU != null ) {
				for ( var i : int = 0; i < pieceNames.length; i++ ) {
					aBitmap = this[pieceNames[i]];
					aBitmap.bitmapData.dispose();
					this[pieceNames[i]] = null;
				}
			}

			while ( numChildren > 0 ) {
				removeChildAt( 0 );
			}
		}

		/**
		 * @param
		 */
		private function initParts() : void {
			var aBitmap : Bitmap;

			for ( var i : int = 0; i < pieceNames.length; i++ ) {
				aBitmap = new Bitmap();
				this[pieceNames[i]] = aBitmap;
			}
		}

		/**
		 *
		 * Сеттер.
		 */
		override public function set scale9Grid( rect : Rectangle ) : void {
			// Код сеттера.
			scaleRect = rect;
			revitalize();

			var anEvent : Event;

			anEvent = new Event( Event.INIT );
			dispatchEvent( anEvent );
		}

		/**
		 * @param
		 */
		private function revitalize() : void {
			var aPoint : Point;
			var aPiece : Bitmap;
			var aRect : Rectangle;
			var aBitmap : BitmapData;
			var originalBitmap : BitmapData;

			var originalWidth : int;
			var originalHeight : int;

			originalWidth = width;
			originalHeight = height;

			scaleX = 1;
			scaleY = 1;

			originalBitmap = new BitmapData( width, height, true, 0x00000000 );
			originalBitmap.draw( this );

			var sequEnce : Array;
			var xCuts : Array;
			var yCuts : Array;

			if ( PieceLU == null ) {
				initParts();
			}

			sequEnce = [PieceLU,
				PieceCU,
				PieceRU,
				PieceLM,
				PieceCM,
				PieceRM,
				PieceLB,
				PieceCB,
				PieceRB,];

			xCuts = [0, scaleRect.left, scaleRect.right, width];
			yCuts = [0, scaleRect.top, scaleRect.bottom, height];

			aPoint = new Point( 0, 0 );

			for ( var i : int = 0; i < 3; i++ ) {
				for ( var j : int = 0; j < 3; j++ ) {
					aRect = new Rectangle( xCuts[j], yCuts[i], xCuts[j + 1] - xCuts[j], yCuts[i + 1] - yCuts[i]);
					aBitmap = new BitmapData( aRect.width, aRect.height );
					aBitmap.copyPixels( originalBitmap, aRect, aPoint );
					aPiece = sequEnce.shift() as Bitmap;
					aPiece.bitmapData = aBitmap;
					aPiece.x = aRect.left;
					aPiece.y = aRect.top;

					// Хитрый план.
					//addChild(aPiece);
					sequEnce.push( aPiece );
				}
			}

			initialized = true;

			width = originalWidth;
			height = originalHeight;

			while ( numChildren > 0 ) {
				removeChildAt( 0 );
			}

			while ( sequEnce.length ) {
				aPiece = sequEnce.shift() as Bitmap;
				addChild( aPiece );
			}
		}

		/**
		 *
		 * Геттер/сеттер.
		 */
		override public function get width() : Number {
			var result : Number;

			// Код геттера.
			result = super.width;

			return ( result );
		}

		override public function set width( value : Number ) : void {
			// Код сеттера.

			if ( initialized ) {
				PieceRU.x = value - PieceRU.width;
				PieceCU.width = value - PieceRU.width - PieceLU.width;

				PieceRM.x = value - PieceRM.width;
				PieceCM.width = value - PieceRM.width - PieceLM.width;

				PieceRB.x = value - PieceRB.width;
				PieceCB.width = value - PieceRB.width - PieceLB.width;
			} else {
				super.width = value;
			}
		}

		/**
		 *
		 * Геттер/сеттер.
		 */
		override public function get height() : Number {
			var result : Number;

			// Код геттера.
			result = super.height;

			return ( result );
		}

		override public function set height( value : Number ) : void {
			// Код сеттера.

			if ( initialized ) {
				PieceLB.y = value - PieceLB.height;
				PieceLM.height = value - PieceLU.height - PieceLB.height;

				PieceCB.y = value - PieceCB.height;
				PieceCM.height = value - PieceCU.height - PieceCB.height;

				PieceRB.y = value - PieceRB.height;
				PieceRM.height = value - PieceRU.height - PieceRB.height;
			} else {
				super.height = value;
			}
		}
	}
}
