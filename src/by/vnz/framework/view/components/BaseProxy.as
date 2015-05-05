package by.vnz.framework.view.components {
	import by.vnz.framework.events.ResourceDemand;
	import by.vnz.framework.view.core.ExtendedSprite;

	import flash.display.DisplayObject;
	import flash.events.Event;

	import vnz.core.ZShape;

	public class BaseProxy extends ExtendedSprite {
		protected var _placeHolder : ZShape;
		protected var _resourceId : String = "";
		protected var _loadStarted : Boolean = false;

		protected var _flipH : Boolean;
		protected var _flipV : Boolean;

		protected var _source : DisplayObject;

//		protected var _width : uint;
//		protected var _height : uint;
//		protected var _x : int;
//		protected var _y : int;

		public function BaseProxy() {
			super();
			if ( numChildren == 0 ) {
				_placeHolder = new ZShape();
				_placeHolder.name = "_placeHolder";
				addChild( _placeHolder );
			}

			addEventListener( Event.ADDED_TO_STAGE, initOnAdded );
		}

		protected function redrawPlaceHolder( w : uint, h : uint ) : void {
			if ( !_placeHolder ) {
				return;
			}
			_placeHolder.graphics.clear();
			_placeHolder.graphicsDrawRect( w, h, 0x000000, 0.3 );
		}

		public function get flipH() : Boolean {
			var result : Boolean = _flipH;

			return result;
		}

		public function set flipH( value : Boolean ) : void {
			_flipH = value;
		}

		public function get flipV() : Boolean {
			var result : Boolean = _flipV;

			return result;
		}

		public function set flipV( value : Boolean ) : void {
			_flipV = value;
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

		/**
		 * @param
		 */
		public function get resource() : String {
			return _resourceId;
		}

		[Inspectable( name="Resource ID", type=String )]
		public function set resource( value : String ) : void {
			if ( value != null ) {
				if ( value.length < 1 ) {
					value = "";
				}
			}

			_resourceId = value;

			getResource();
		}

		protected function initOnAdded( event : Event ) : void {
			getResource();
		}

		private function getResource() : void {
//			debug( this, " getR | " + ( stage != null ).toString() + " | " + resourceId, Logger.DC_2 );
			if ( stage && _resourceId != "" && !_loadStarted ) {
				_loadStarted = true;
				demandResource( _resourceId, onGraphics );
			}
		}

		protected function onGraphics( source : DisplayObject ) : void {
//			debug( this, " onGraphics " + resourceId, Logger.DC_1 );
			_loadStarted = false;
			if ( source == null ) {
				warn( this, "Critical failure: UI resource <" + _resourceId + "> is absent." );
			}
			if ( source is DisplayObject ) {
				_source = source;
				removeChildren11();
				_placeHolder = null;

//				scaleX = 1;
//				scaleY = 1;
				_source.scaleX = _source.scaleY = 1;

			}

		}

		protected function demandResource( id : String, handler : Function ) : void {
			var event : ResourceDemand;

			event = new ResourceDemand();
			event.handler = handler;
			event.id = id;

			dispatchEvent( event );
		}

	}
}