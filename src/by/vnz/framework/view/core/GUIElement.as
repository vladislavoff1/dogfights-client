package by.vnz.framework.view.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	import vnz.text.ZTextField;

	public class GUIElement extends MessageDispatcher {
		protected var isGUIReady : Boolean = false;

		protected var _placeHolder : ExtendedShape;

		public function GUIElement() {
			super();
			addEventListener( Event.ADDED_TO_STAGE, gui_onAdded, false, 0, true );
			preinitUI();
			initPlaceHolder();
		}

		private function gui_onAdded( event : Event ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, gui_onAdded );
			initUI();
			//update status
			isGUIReady = true;
			initUICompleted();
			invalidate();
		}

		protected function initPlaceHolder( allways : Boolean = false ) : void {
			if (( !allways && numChildren > 0 ) || ( _placeHolder )) {
				return;
			}
			_placeHolder = new ExtendedShape();
			_placeHolder.name = "_placeHolder";
			addChild( _placeHolder );
		}

		/**
		 * used for preinit GUI
		 * override method
		 */
		protected function preinitUI() : void {
			//override method
		}

		/**
		 * used for init GUI
		 * override method
		 */
		protected function initUI() : void {
			//override method
		}

		/**
		 * used for config after init GUI
		 * override method
		 */
		protected function initUICompleted() : void {
//			debug( this, "initUICompleted " + numChildren, Logger.DC_3 );
		}

		override public function get width() : Number {
			var result : Number;

			if ( _placeHolder ) {
				result = _placeHolder.width;
			} else {
				result = super.width;
			}

			return ( result );
		}

		override public function set width( value : Number ) : void {
			if ( width == value ) {
				return;
			}

			setSize( value, height );
		}

		override public function get height() : Number {
			var result : Number;

			if ( _placeHolder ) {
				result = _placeHolder.height;
			} else {
				result = super.height;
			}

			return ( result );
		}

		override public function set height( value : Number ) : void {
			if ( height == value ) {
				return;
			}
			setSize( width, value );
		}

		public function setSize( w : uint, h : uint ) : void {
			if ( _placeHolder ) {
				redrawPlaceHolder( int( w ), int( h ));
			} else {
				super.width = w;
				super.height = h;
			}
			dispatchEvent( new Event( Event.RESIZE, false ));
			//			debug( this, "setSize | " + _width + "x" + _height, Logger.DC_5 );
		}

		protected function redrawPlaceHolder( w : uint, h : uint, alpha : Number = 0.0 ) : void {
			if ( !_placeHolder ) {
				return;
			}
			_placeHolder.graphics.clear();
			_placeHolder.graphicsDrawRect( w, h, 0x000000, alpha );
		}

		private function createObject( className : String ) : Object {
			var ClassReference : Class = getDefinitionByName( className ) as Class;
			var instance : Object = new ClassReference();
			return instance;
		}

		private function get thisType() : String {
			var result : String = this.toString();
			result = result.substring( 8, result.length - 1 );
			return result;
		}

		protected function createUIChild( UIClass : Class, params : Object = null, parentObject : DisplayObjectContainer = null, addIndex : uint = 999, listen : Boolean = true ) : * {
			var result : DisplayObject = null;
			if ( UIClass != TextField ) {
				result = new UIClass() as DisplayObject;
			} else {
				result = ZTextField.create( null );
			}

			addUIChild( result, params, parentObject, addIndex, listen );

			//set child as class property
			if ( this.hasOwnProperty( result.name ) && !this[result.name]) {
				this[result.name] = result;
			}

			return result;
		}

		protected function addUIChild( child : DisplayObject, params : Object = null, parentObject : DisplayObjectContainer = null, addIndex : uint = 999, listen : Boolean = true ) : DisplayObject {
			var result : DisplayObject = child;
			if ( child ) {
				//apply params
				setGUIParams( child, params );
				//add child
				if ( parentObject is DisplayObjectContainer ) {
					if ( addIndex != 999 && ( addIndex <= parentObject.numChildren )) {
						parentObject.addChildAt( child, addIndex );
					} else {
						parentObject.addChild( child );
					}
				} else {
					if ( addIndex != 999 && ( addIndex <= this.numChildren )) {
//						debug( this, "addUIChild | " + addIndex + " | " + this.numChildren, Logger.DC_5 );
						addChildAt( child, addIndex );
					} else {
						addChild( child );
					}
				}

				if ( listen && child is MessageDispatcher ) {
					listenElement( child as MessageDispatcher );
				}
//				debug( "addUIChild", child, Logger.DC_3 );
			}
			//remove placeHolder if exist
			if ( _placeHolder && this.numChildren > 1 ) {
				_placeHolder.graphics.clear();
				removeChildSafely( _placeHolder );
				_placeHolder = null;
			}

			return child;
		}

		protected function setGUIParams( child : DisplayObject, params : Object = null ) : void {
			if ( child && params ) {
				if ( params is XML ) {
					updateChildPropByXML( child, params as XML );
				} else {
					updateChildProp( child, params );
				}
			}
		}

		private function updateChildProp( child : DisplayObject, params : Object ) : void {
			for ( var prop : String in params ) {
				if ( child.hasOwnProperty( prop )) {
					child[prop] = params[prop];
				}
			}
		}

		private function updateChildPropByXML( child : DisplayObject, xml : XML ) : void {
			var textFormat : TextFormat;
			if ( child is TextField ) {
//				debug( "child is TextField", xml, Logger.DC_2 );
				textFormat = ( child as TextField ).defaultTextFormat;
			}

			for each ( var item : XML in xml.attributes()) {
				var atName : String = String(item.name());

				//set value
				if ( child.hasOwnProperty( atName )) {
					parseAtrValue( atName, item.toString(), child );

				} else if ( child is TextField && textFormat.hasOwnProperty( atName )) {
					parseAtrValue( atName, item.toString(), textFormat );
				}
			}

			if ( child is TextField ) {
				var tf : TextField = child as TextField;
				var tText : String = tf.text;
				tf.wordWrap = tf.multiline;
				tf.selectable = ( tf.type == TextFieldType.INPUT );
				tf.text = "";
				tf.defaultTextFormat = textFormat;
				tf.text = tText;
			}

		}

		/**
		 * parse prop value from xml
		 * @param prop
		 * @param value
		 * @param obj
		 */
		private function parseAtrValue( prop : String, value : String, obj : Object ) : void {
//			debug("parseAtrValue", value, 
			var itemValue : *;
			if ( obj[prop] is Array ) {
				itemValue = value.split( "," );
			} else if ( obj[prop] is Boolean ) {
				if ( value.toString() == "1" || value.toLowerCase() == "true" ) {
					itemValue = true;
				} else {
					itemValue = false;
				}
			} else if ( value.indexOf( "0x" ) != -1 ) {
				itemValue = uint( value );
			} else {
				itemValue = value;
			}
			obj[prop] = itemValue;
		}

	}
}