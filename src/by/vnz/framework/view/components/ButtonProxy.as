package by.vnz.framework.view.components {
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class ButtonProxy extends AbstractButtonProxy {
		private var _hintID : String = "";

		public function get hintID() : String {
			var result : String = _hintID;

			return result;
		}

		public function set hintID( value : String ) : void {
			_hintID = value;
			autoHint = ( _hintID && _hintID != "" );
		}

		public function ButtonProxy( resource : String = null ) {
			super();

			var aFilter : ColorMatrixFilter;
			var aMatrix : Array;

			aMatrix = [1.2, 0, 0, 0, 0,
				0, 1.2, 0, 0, 0,
				0, 0, 1.2, 0, 0,
				0, 0, 0, 1, 0,];

			aFilter = new ColorMatrixFilter( aMatrix );
			overFilters = [aFilter];

			aMatrix = [1.1, 0, 0, 0, -40,
				0, 1.1, 0, 0, -40,
				0, 0, 1.1, 0, -40,
				0, 0, 0, 1, 0,];

			aFilter = new ColorMatrixFilter( aMatrix );
			downFilters = [aFilter];

			aMatrix = [0.6, 0.2, 0.2, 0, -25,
				0.2, 0.6, 0.2, 0, -25,
				0.2, 0.2, 0.6, 0, -25,
				0, 0, 0, 0.6, 0,];

			aFilter = new ColorMatrixFilter( aMatrix );
			disabledFilters = [aFilter];

			if ( resource ) {
				this.resource = resource;
			}
		}

		private function set autoHint( value : Boolean ) : void {
			if ( value ) {
				addEventListener( MouseEvent.ROLL_OVER, hintOnOver, false, 0, true );
				addEventListener( MouseEvent.ROLL_OUT, hintOnOut, false, 0, true );
				addEventListener( MouseEvent.MOUSE_DOWN, hintOnOut, false, 0, true );
			} else {
				removeEventListener( MouseEvent.ROLL_OVER, hintOnOver );
				removeEventListener( MouseEvent.ROLL_OUT, hintOnOut );
				removeEventListener( MouseEvent.MOUSE_DOWN, hintOnOut );

			}
		}

		private function hintOnOver( event : MouseEvent ) : void {
//			if ( !event.buttonDown ) {
//				HintBaloon.show( this, "${hint." + _hintID + "}", this.width / 2, this.height / 2 );
//			}
		}

		/**
		 * @param
		 */
		private function hintOnOut( event : MouseEvent ) : void {
//			HintBaloon.hide( this );
		}
	}
}
