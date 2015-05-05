/**
 * @author vnz
 */
package vnz.controls {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BevelFilter;
	import flash.text.*;

	import vnz.core.ZComponent;
	import vnz.core.ZSprite;
	import vnz.text.ZTextField;

	public class ZButton extends ZComponent {

		private var _label : TextField; //text
		private var _body : DisplayObject; //background
		private var _withLabel : Boolean = true;

		override public function set enabled( value : Boolean ) : void {
			super.enabled = value;
			mouseEnabled = mouseChildren = _enabled;
		}

		public function get label() : String {
			if ( !_label ) {
				return "";
			}
			return _label.text;
		}

		public function set label( value : String ) : void {
			if ( !_label ) {
				createLabel( value );
			} else {
				_label.text = value;
			}
		}

		public function get showLabel() : Boolean {
			var result : Boolean = _withLabel ? _label.visible : false;

			return result;
		}

		public function set showLabel( value : Boolean ) : void {
			if ( _withLabel ) {
				return;
			}
			_label.visible = value;
		}

		public function ZButton( labelText : String = "button", bodyClip : DisplayObject = null, withLabel : Boolean = true ) {
			super();
			buttonMode = true;
			updateBody( bodyClip );
			_withLabel = withLabel;
			if ( _withLabel ) {
				createLabel( labelText );
			}
			///----------------------------------
//			this.buttonMode = true;
//			this.mouseChildren = false;
		}

		public function set bodyClip( value : DisplayObject ) : void {
			updateBody( value );
		}

		private function updateBody( bodyClip : DisplayObject ) : void {
			if ( _body && _body.parent == this ) {
				removeChild( _body );
			}
			if ( bodyClip != null ) {
				_body = bodyClip;
				setSize( _body.width, _body.height );
			} else if ( !_body ) {
				setSize( 50, 20 );
				_body = createDefaultBody();
			}
			addChildAt( _body, 0 );
			this.width = _body.width;
			this.height = _body.height;
		}

		override protected function draw() : void {
			super.draw();

			if ( !_body ) {
				return;
			}

			if ( this.width != _body.width ) {
				_body.width = this.width;
			}
			if ( this.height != _body.height ) {
				_body.height = this.height;
			}
			if ( _label ) {
				createLabel( _label.text );
			}
		}

		private function createDefaultBody() : DisplayObject {
			var body : ZSprite = new ZSprite();
			body.graphicsDrawRect( this.width, this.height, 0xb7b7b7 );
			var bevel : BevelFilter = new BevelFilter( 1 );
			body.filters = [bevel];
			return body;
		}

		private function createLabel( labelText : String ) : void {
			if ( _label ) {
				removeChild( _label );
			}
			var formatParams : Object = {size:10, color:0x000000, align:TextFormatAlign.CENTER, bold:true};
			var fieldParams : Object = {selectable:false, width:_body.width, height:_body.height, y:1};
			_label = ZTextField.create( formatParams, fieldParams );
			_label.text = labelText;
			_label.mouseEnabled = false;
			addChild( _label );
		}
	}
}
