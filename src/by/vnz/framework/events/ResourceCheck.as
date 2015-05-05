package by.vnz.framework.events {

	import flash.events.Event;

	public class ResourceCheck extends Event {
		static public const CHECK : String = "check";

		public var id : String;
		public var defaultID : String;
		public var handler : Function;

		public function ResourceCheck( type : String = ResourceCheck.CHECK, bubbles : Boolean = true, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
		}
	}
}
