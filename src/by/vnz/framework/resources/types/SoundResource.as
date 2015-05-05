package by.vnz.framework.resources.types {

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;

	import by.vnz.framework.resources.EnhancedResource;
	import by.vnz.framework.resources.ResourceData;
	import by.vnz.framework.resources.ResourcesManager;

	public class SoundResource extends EnhancedResource {
		private var resourceLoader : Sound;

		public function SoundResource( source : ResourceData ) {
			super( source );
		}

		override protected function loadResource() : void {
			super.loadResource();

			resourceLoader = new Sound();

			resourceLoader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			resourceLoader.addEventListener( Event.COMPLETE, onResource );
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

			super.onResource( event );
		}

		/**
		 * @param
		 */
		override protected function normalSatisfy() : void {
			finallySatisfy( resourceLoader );
		}

	}
}
