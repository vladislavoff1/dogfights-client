package by.vnz.framework.view.components {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;

	public class SimpleButtonProxy extends ImageProxy {
		private var _simpleButtonMode : Boolean = true;
		private var _preInitLabelText : String = "";
		private var _label : TextField; //text

		public function SimpleButtonProxy( resource : String = null ) {
			super( resource );
			simpleButtonMode = true;
		}

		public function get enabled() : Boolean {
			return mouseEnabled;
		}

		public function set enabled( value : Boolean ) : void {
			if ( value == mouseEnabled ) {
				return;
			}
			mouseEnabled = mouseChildren = value;
		}

		public function get simpleButtonMode() : Boolean {
			var result : Boolean = _simpleButtonMode;

			return result;
		}

		public function set simpleButtonMode( value : Boolean ) : void {
			_simpleButtonMode = value;
			if ( _source is SimpleButton ) {
				mouseEnabled = mouseChildren = buttonMode = value;
			}
		}

		override protected function onGraphics( source : DisplayObject ) : void {
			super.onGraphics( source );
//			debug( this, source );
//			debug( "has _label", source.hasOwnProperty( "_label" ));
//			if ( source.hasOwnProperty( "_label" )) {
//				_label = source["_label"];
//				label = _preInitLabelText;
//			}
			simpleButtonMode = _simpleButtonMode;
		}

		public function get label() : String {
			if ( !_label ) {
				return "";
			}
			return _label.text;
		}

		public function set label( value : String ) : void {
			if ( !_label ) {
				_preInitLabelText = value;
				return;
			}
			_label.text = value;
		}

	}
}