package by.vnz.framework.events {
	import flash.events.Event;

	public class StateEvent extends Event {
		public static const ENTER_STATE : String = "enter_state";
		public static const EXIT_STATE : String = "exit_state";

		public var prevState : String;
		public var nextState : String;

		public function StateEvent( type : String = "Wrong!", bubbles : Boolean = false, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );

			if (( type != StateEvent.ENTER_STATE ) && ( type != StateEvent.EXIT_STATE )) {
				warn( "Wrong state event!" );
				throw( new Error( "Wrong state event!" ));
			}
		}

		/**
		 * Значение по умолчанию,
		 * предыдущее состояние для события ухода,
		 * следующее состояние для события входа.
		 * @param
		 * @return
		 */
		public function get state() : String {
			var result : String;

			if ( type == ENTER_STATE ) {
				result = nextState;
			}

			if ( type == EXIT_STATE ) {
				result = prevState;
			}

			return ( result );
		}
	}
}
