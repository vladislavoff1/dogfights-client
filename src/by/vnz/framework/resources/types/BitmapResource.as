package by.vnz.framework.resources.types {
	import by.vnz.framework.idmaps.IDMCResourceImportance;
	import by.vnz.framework.resources.EnhancedResource;
	import by.vnz.framework.resources.ResourceData;
	import by.vnz.framework.resources.ResourcesManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapResource extends EnhancedResource {
		private var _loader : Loader;

		private var bitmapResource : BitmapData;
		private var _originOffset : Point;

		public function BitmapResource( source : ResourceData ) {
			super( source );
		}

		/**
		 * @param
		 */
		override protected function loadResource() : void {
			super.loadResource();

			if ( !data.libID ) {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onResource, false, 0, true );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onError, false, 0, true );
//			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
//			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );			
			} else {
//				initResource();
				onResource();
			}
		}

		/**
		 * @param
		 */
		override protected function onError( event : IOErrorEvent ) : void {
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onResource );

			super.onError( event );
		}

		/**
		 * @param
		 */
		override protected function onResource( event : Event = null ) : void {
			if ( _loader && _loader.contentLoaderInfo ) {
				ResourcesManager.setNewBytesLoaded( _loader.contentLoaderInfo.bytesLoaded, data.type );

				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onError );
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onResource );
			}

			initResource();
			//inf(bitmapResource.width, bitmapResource.height);
			_loader = null;

			super.onResource( event );
		}

		private function initResource() : void {
			var source : DisplayObject;
			if ( !data.libID ) {
				source = _loader;
			} else {
				source = ResourcesManager.getResourceFromLib( data.libID, data.id );
			}

			if ( !source ) {
				error( "On getting resource", data.id );
				return;
			}

			var bounds : Rectangle = source.getBounds( source );
			var mtr : Matrix = new Matrix();

			mtr.translate( -bounds.left, -bounds.top );
			bitmapResource = new BitmapData( bounds.width, bounds.height, true, 0x00000000 );

			bitmapResource.draw( source, mtr );
			_originOffset = bounds.topLeft;
		}

		/**
		 * @param
		 */
		override protected function normalSatisfy() : void {
			var bitmap : Bitmap = new Bitmap;

//			bitmap.x = _originOffset.x;
//			bitmap.y = _originOffset.y;
			bitmap.bitmapData = bitmapResource;

			finallySatisfy( bitmap );

		}

		override protected function clearContent() : void {
			//			return;
			if ( data.importance != IDMCResourceImportance.IMPORTANT ) {
				super.clearContent();
				bitmapResource = null;
			}
		}

	}
}