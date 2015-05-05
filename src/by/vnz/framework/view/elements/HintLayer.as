package by.vnz.framework.view.elements {

	import by.vnz.framework.events.HintBubble;
	import by.vnz.framework.view.core.MessageDispatcher;

	import flash.display.Sprite;
	import flash.geom.Point;

	public class HintLayer extends MessageDispatcher {
		private var currentHint : HintBaloon;

		public function HintLayer( w : uint = 0, h : uint = 0 ) {
			super();

//			createBounds( w, h );
//
			mouseEnabled = false;
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			if ( currentHint is HintBaloon ) {
				currentHint.destroy();
				currentHint = null;
			}

			super.destroy();
		}

		/**
		 * @param
		 */
		public function attachTo( target : Sprite ) : void {
			target.addEventListener( HintBubble.SHOW_HINT, onRequest, false, 0, true );
			target.addEventListener( HintBubble.HIDE_HINT, onRequest, false, 0, true );
		}

		/**
		 * @param
		 */
		private function onRequest( event : HintBubble ) : void {
			event.stopPropagation();

			if ( currentHint != null ) {
				if ( currentHint.parent == this ) {
					removeChild( currentHint );
				}

				currentHint.destroy();
				currentHint == null;
			}

			if ( event.data == null ) {
				return;
			}

			var aPoint : Point;

			aPoint = new Point( event.globalX, event.globalY );
			//aPoint = (event.target as MovieClip).localToGlobal(aPoint);
			aPoint = globalToLocal( aPoint );

			currentHint = new HintBaloon();

//			if ( event.data is String ) {
//				currentHint.localize( "content", event.data, "" );
//			} else {
			currentHint.content = event.data;
//			}

			currentHint.x = aPoint.x;
			currentHint.y = aPoint.y;

			currentHint.align = (( aPoint.x < ( width / 2 )) ? HintBaloon.ALIGN_LEFT : HintBaloon.ALIGN_RIGHT ) + (( aPoint.y < ( height / 2 )) ? HintBaloon.ALIGN_TOP : HintBaloon.ALIGN_BOTTOM );

			addChild( currentHint );
		}

		private function hideHintHandler( event : HintBubble ) : void {
			if (( currentHint ) && ( currentHint.parent == this )) {
				removeChild( currentHint );
				currentHint.destroy();
				currentHint == null;
			}
		}
	}
}
