package vnz.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class ZSprite extends Sprite {
		public function ZSprite() {
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

		public function removeChildren11() : void {
			while ( numChildren > 0 ) {
				removeChildAt( 0 );
			}
		}

		public function removeChildSafely( child : DisplayObject ) : DisplayObject {
			if ( !child ) {
				return child;
			}
			for ( var i : int = 0; i < this.numChildren; i++ ) {
				var findedChild : DisplayObject = this.getChildAt( i );
				if ( child == findedChild ) {
					this.removeChild( child );
					return child;
				}
			}
			return child;
		}
	}
}