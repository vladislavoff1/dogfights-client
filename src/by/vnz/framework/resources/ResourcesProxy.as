package by.vnz.framework.resources {
	import flash.display.Sprite;
	import flash.events.Event;

	import by.vnz.framework.events.ResourceCheck;
	import by.vnz.framework.events.ResourceDemand;
	import by.vnz.framework.events.ResourceCheck;
	import by.vnz.framework.events.ResourceDemand;

	public class ResourcesProxy extends Sprite {
		private var bubblesQueue : Array = new Array();
		static private var _instance : ResourcesProxy = null;

		public function ResourcesProxy() {
			super();
			if ( instance ) {
				throw( "Error on create instance of ResourcesPoxy" );
				return;
			}
			_instance = this;
			addEventListener( Event.ADDED_TO_STAGE, onAdded, false, 0, true );
		}

		public function get instance() : ResourcesProxy {
			var result : ResourcesProxy = _instance;
			return result;
		}

		/**
		 * @param
		 */
		private function onAdded( event : Event ) : void {
			while ( bubblesQueue.length > 0 ) {
				dispatchEvent( bubblesQueue.shift() as Event );
			}
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
		}

		static public function demand( id : String, resultHandler : Function ) : void {
			var event : ResourceDemand;

			event = new ResourceDemand();
			event.handler = resultHandler;
			event.id = id;

			_instance.sendBubble( event );
		}

		private function sendBubble( event : Event ) : void {
			if ( stage != null ) {
				dispatchEvent( event );
			} else {
				bubblesQueue.push( event );
			}
		}

		/**
		 * @param
		 */
		static public function checkExist( id : String, handler : Function, defaultID : String = "" ) : void {
			var anEvent : ResourceCheck;

			anEvent = new ResourceCheck();
			anEvent.handler = handler;
			anEvent.id = id;
			anEvent.defaultID = defaultID;

			_instance.sendBubble( anEvent );
		}

	}
}