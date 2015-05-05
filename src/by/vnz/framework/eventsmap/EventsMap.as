package by.vnz.framework.eventsmap {
	import by.vnz.framework.events.InnerEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class EventsMap extends Sprite {
		private var _map : Dictionary = new Dictionary( true );
		private var curEvent : Event;

		public function EventsMap() {
			super();
			addEventListener( Event.ADDED_TO_STAGE, addedHandler, false, 0, true );
		}

		protected function addedHandler( event : Event ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, addedHandler );
			init();
			//
		}

		//for ovveride
		protected function init() : void {

		}

		public function add( eventType : String, subscribe : SubscribeVO ) : void {
			_map[eventType] = subscribe;
			if ( stage ) {
				stage.addEventListener( eventType, eventsHandler, false, 0, true );
			}
		}

		private function eventsHandler( event : Event ) : void {
			if ( !( event is InnerEvent )) {
				return;
			}
			var innerEvent : InnerEvent = event as InnerEvent;
			var subscribe : SubscribeVO = _map[event.type];
			if ( subscribe ) {
				subscribe.resultHandler = innerEvent.callback;
			}

			if ( subscribe.invokerMethod != null ) {
				if ( subscribe.invokParams ) {
					subscribe.invokerMethod( subscribe.invokParams );
				} else {
					subscribe.invokerMethod();
				}
			}
		}
	}
}