package by.vnz.framework.view.components {
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ImageProxy extends BaseProxy {

		private var _innerOffsetX : int = 0;
		private var _innerOffsetY : int = 0;

		public function setInnerOffset( valueX : int, valueY : int ) : void {
			_innerOffsetX = valueX;
			_innerOffsetY = valueY;
			invalidate();
		}

		public function get innerOffsetX() : int {
			var result : int = _innerOffsetX;

			return result;
		}

		public function set innerOffsetX( value : int ) : void {
			_innerOffsetX = value;
			invalidate();
		}

		public function get innerOffsetY() : int {
			var result : int = _innerOffsetY;

			return result;
		}

		public function set innerOffsetY( value : int ) : void {
			_innerOffsetY = value;
			invalidate();
		}

		public function ImageProxy( resource : String = null ) {
			super();

			cacheAsBitmap = true;

			mouseEnabled = false;
			mouseChildren = false;

			if ( resource ) {
				this.resource = resource;
			}
		}

		/**
		 * @param source
		 */
		override protected function onGraphics( source : DisplayObject ) : void {
			super.onGraphics( source );
			if ( source is DisplayObject ) {
				addChild( source );
//				dispatchEvent( new Event( Event.RESIZE, false ));
////				if ( width == 0 || height == 0 ) {
//				setSize( _source.width, _source.height );
//				}				
//				_innerOffsetX += source.x;
//				_innerOffsetY += source.y;
			}
			dispatchEvent( new Event( Event.COMPLETE, false ));
			invalidate();
		}

		override protected function redraw() : void {
			if ( !_source ) {
				return;
			}

			_source.x = _innerOffsetX;
			_source.y = _innerOffsetY;
			if ( flipH ) {
				_source.scaleX = -1;
				_source.x += _source.width;
			}
			if ( flipV ) {
				_source.scaleY = -1;
				_source.y += _source.height;
			}
		}

	}
}
