package by.vnz.framework.view.components {

	import flash.events.MouseEvent;

	public class AbstractButtonProxy extends ImageProxy {
		static public const STATE_DISABLED : String = "state:disabled";
		static public const STATE_DOWN : String = "state:down";
		static public const STATE_OVER : String = "state:over";
		static public const STATE_UP : String = "state:up";

		protected var currentState : String;
		private var isDown : Boolean;
		private var _enabled : Boolean = true;

		protected var upFilters : Array;
		protected var overFilters : Array;
		protected var downFilters : Array;
		protected var disabledFilters : Array;

		public function AbstractButtonProxy() {
			super();

			isDown = false;
			buttonMode = true;
			cacheAsBitmap = true;
			currentState = STATE_UP;

			if ( _enabled ) {
				enabled = true;
			}
		}

		public function get enabled() : Boolean {
			var result : Boolean = _enabled;
			return result;
		}

		/**
		 * @param
		 */
		[Inspectable( name="Enabled", type=Boolean, defaultValue=true )]
		public function set enabled( value : Boolean ) : void {
			_enabled = value;
			mouseEnabled = value;

			removeEventListener( MouseEvent.MOUSE_DOWN, onMousePress );
			removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			removeEventListener( MouseEvent.MOUSE_UP, onMouseOver );

			if ( value ) {
				addEventListener( MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true );
				addEventListener( MouseEvent.MOUSE_UP, onMouseOver, false, 0, true );

				currentState = STATE_UP;
				filters = upFilters;
			} else {
				currentState = STATE_DISABLED;
				filters = disabledFilters;
			}
		}

		/**
		 * @param
		 */
		private function onMouseOver( event : MouseEvent ) : void {
			if ( stage.focus == this ) {
				if ( event.buttonDown ) {
					onMousePress( event );
				} else {
					stage.focus = null;
				}
			}

			if ( stage.focus != this ) {
				if ( !event.buttonDown ) {
					filters = overFilters;
					currentState = STATE_OVER;
				}
			}
		}

		/**
		 * @param
		 */
		private function onMouseOut( event : MouseEvent ) : void {
			filters = upFilters;
			currentState = STATE_UP;
		}

		/**
		 * @param
		 */
		protected function onMousePress( event : MouseEvent ) : void {
			stage.focus = this;
			filters = downFilters;
			currentState = STATE_DOWN;
		}

	}
}
