package by.vnz.framework.resources.types {

	import by.vnz.framework.idmaps.IDMCResourceImportance;
	import by.vnz.framework.resources.EnhancedResource;
	import by.vnz.framework.resources.ResourceData;
	import by.vnz.framework.resources.ResourcesManager;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	public class MovieResource extends EnhancedResource {
		private var resourceLoader : URLLoader;
		private var clipResource : ByteArray;

		public function MovieResource( source : ResourceData ) {
			super( source );

		}

		override protected function loadResource() : void {
			super.loadResource();

			if ( !data.libID ) {
				resourceLoader = new URLLoader();

				resourceLoader.addEventListener( IOErrorEvent.IO_ERROR, onError, false, 0, true );
				resourceLoader.addEventListener( Event.COMPLETE, onResource, false, 0, true );
				resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
				resourceLoader.load( createRequest());
			} else {
				//				initResource();
				onResource();
			}
		}

		override protected function onError( event : IOErrorEvent ) : void {
			resourceLoader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			resourceLoader.removeEventListener( Event.COMPLETE, onResource );

			super.onError( event );
		}

		override protected function onResource( event : Event = null ) : void {
			if ( resourceLoader && resourceLoader.data ) {
				ResourcesManager.setNewBytesLoaded( resourceLoader.bytesLoaded, data.type );

				resourceLoader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
				resourceLoader.removeEventListener( Event.COMPLETE, onResource );

				clipResource = resourceLoader.data as ByteArray;
			}
			super.onResource( event );
			resourceLoader = null;

		}

		override protected function normalSatisfy() : void {
			if ( !data.libID ) {
				var loader : Loader;

				loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onMovie );
				loader.loadBytes( clipResource );
					//			loader.addEventListener( Event.ENTER_FRAME, onMovie );

			} else {
				var result : DisplayObject;
				result = ResourcesManager.getResourceFromLib( data.libID, data.id );
				finallySatisfy( result );
			}
		}

		private function onMovie( event : Event ) : void {
			var loader : LoaderInfo;
			var framesTotal : int;
			var loadedFrames : int;

			loader = event.target as LoaderInfo;

			if ( !( loader.content is MovieClip )) {
				return;
			}

			loadedFrames = ( loader.content as MovieClip ).framesLoaded;
			framesTotal = ( loader.content as MovieClip ).totalFrames;

			//inf(framesTotal);

			if ( loadedFrames < framesTotal ) {
				return;
			}

//			aLoader.removeEventListener( Event.ENTER_FRAME, onMovie );
//			aLoader.content.cacheAsBitmap = true;
			finallySatisfy( loader.content );

		}

		override protected function clearContent() : void {
//			return;
			if ( data.importance != IDMCResourceImportance.IMPORTANT ) {
				super.clearContent();
				clipResource = null;
			}
		}
	}
}
