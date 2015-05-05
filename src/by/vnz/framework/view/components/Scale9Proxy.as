package by.vnz.framework.view.components {

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class Scale9Proxy extends BaseProxy {
		private var resourceObject : DisplayObject;
		private var gridObject : Rectangle;

		private var grid9Thing : Scale9Thing;
		public var initialized : Boolean;

		public function Scale9Proxy( resource : String = null, grid : Array = null ) {
			super();

			initialized = false;

			cacheAsBitmap = true;

			if ( grid ) {
				this.grid = grid;
			}
			if ( resource ) {
				this.resource = resource;
			}
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			if ( grid9Thing is Scale9Thing ) {
				grid9Thing.destroy();
			}

			super.destroy();
			resourceObject = null;
			grid9Thing = null;
			gridObject = null;

		}

		/**
		 * @param
		 */
		override protected function onGraphics( source : DisplayObject ) : void {
//			return;
			var w : uint = this.width;
			var h : uint = this.height;
			super.onGraphics( source );

			resourceObject = source;

			if ( gridObject != null ) {
//				debug( this + " " + _resourceId + " " + this.x + "x" + this.y, "onGraphics " + gridObject.toString());
				finalizeGraphics();
				this.width = w;
				this.height = h;
			}
		}

		/**
		 * @param
		 */
		private function finalizeGraphics() : void {
			grid9Thing = new Scale9Thing();

			grid9Thing.addChild( resourceObject );
			grid9Thing.scale9Grid = gridObject;
//			debug( this, resourceObject, grid9Thing, gridObject );

			grid9Thing.height = resourceObject.width;
			grid9Thing.width = resourceObject.height;

//			grid9Thing.width = this.width;
//			grid9Thing.height = this.height;

			resourceObject = null;
			addChild( grid9Thing );
			initialized = true;
		}

		public function get grid() : Array {
			var result : Array = [];
			if ( gridObject ) {
				result = [gridObject.x, gridObject.y, gridObject.width, gridObject.height]
			}
			return result;
		}

		/**
		 *
		 * Сеттер.
		 */
		[Inspectable( name="Grid 3x3", type=Array )]
		public function set grid( source : Array ) : void {
			// Код сеттера.
			if ( source.length != 4 ) {
				warn( "Scale9Proxy: Wrong Grid <" + source + ">" );
				return;
			}

			gridObject = new Rectangle( source[0], source[1], source[2], source[3]);

			if ( resourceObject != null ) {
				finalizeGraphics();
			}
		}

		/**
		 *
		 * Геттер/сеттер.
		 */
		override public function get width() : Number {
			var result : Number;

			// Код геттера.
			if ( initialized ) {
				result = grid9Thing.width;
			} else {
				result = super.width;
			}

			return ( result );
		}

		override public function set width( value : Number ) : void {
			if ( width == value ) {
				return;
			}
			if ( initialized ) {
				grid9Thing.width = value;
			} else {
				super.width = value;
			}
//			debug( this + " " + resourceId + " " + this.width + "x" + this.height, "width: " + value.toString(), Logger.DC_5 );
		}

		/**
		 *
		 * Геттер/сеттер.
		 */
		override public function get height() : Number {
			var result : Number;

			// Код геттера.
			if ( initialized ) {
				result = grid9Thing.height;
			} else {
				result = super.height;
			}

			return ( result );
		}

		override public function set height( value : Number ) : void {
			// Код сеттера.
			if ( initialized ) {
				grid9Thing.height = value;
			} else {
				super.height = value;
			}
//			debug( this + " " + resourceId + " " + this.width + "x" + this.height, "height: " + value.toString(), Logger.DC_5 );
		}
	}
}
