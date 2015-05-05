package by.vnz.framework.resources.types {

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	import by.vnz.framework.resources.EnhancedResource;
	import by.vnz.framework.resources.ResourceData;
	import by.vnz.framework.resources.ResourcesManager;

	public class RawResource extends EnhancedResource {
		private var resourceLoader : URLLoader;

		private var resourceItself : ByteArray;

		public function RawResource( source : ResourceData ) {
			super( source );
		}

		/**
		 * @param
		 */
		override protected function loadResource() : void {
			super.loadResource();

			resourceLoader = new URLLoader();

			resourceLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			resourceLoader.addEventListener( Event.COMPLETE, onResource );
			resourceLoader.dataFormat = URLLoaderDataFormat.BINARY;
			resourceLoader.load( createRequest());
		}

		/**
		 * @param
		 */
		override protected function onError( event : IOErrorEvent ) : void {
			resourceLoader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			resourceLoader.removeEventListener( Event.COMPLETE, onResource );

			super.onError( event );
		}

		/**
		 * @param
		 */
		override protected function onResource( event : Event = null ) : void {
			ResourcesManager.setNewBytesLoaded( resourceLoader.bytesLoaded, data.type );

			resourceLoader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			resourceLoader.removeEventListener( Event.COMPLETE, onResource );

			resourceItself = resourceLoader.data as ByteArray;

			try {
				resourceItself.uncompress();
			} catch ( error : Error ) {
			}

			super.onResource( event );

			resourceLoader = null;
		}

		/**
		 * @param
		 */
		override protected function normalSatisfy() : void {
			finallySatisfy( resourceItself );
		}
	}
}
