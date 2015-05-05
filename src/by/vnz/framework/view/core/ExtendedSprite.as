package by.vnz.framework.view.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ExtendedSprite extends Sprite {
		protected var destroyed : Boolean = false;
		private var invalid : Boolean;

		public function ExtendedSprite() {
			super();

			invalid = false;
		}

		/**
		 * @param
		 */
		public function destroy() : void {
			removeChildren11();
			destroyed = true;
		}

		public function removeChildren11() : void {
			while ( numChildren > 0 ) {
				removeChildAt( 0 );
			}
		}

		/**
		 * @param
		 */
		protected function invalidate() : void {
			if ( !invalid ) {
				addEventListener( Event.ENTER_FRAME, onInvalidate );
				invalid = true;
			}
		}

		/**
		 * use in descendants
		 * override method
		 * @param
		 */
		protected function redraw() : void {

		}

		protected function removeChildSafely( child : DisplayObject ) : DisplayObject {
			if ( !child ) {
				return child;
			}
			if ( this.contains( child )) {
				this.removeChild( child );

			}
			return child;
		}

		/**
		 * @param
		 */
		private function onInvalidate( event : Event ) : void {
			removeEventListener( Event.ENTER_FRAME, onInvalidate );
			invalid = false;
			redraw();
		}
	}
}
