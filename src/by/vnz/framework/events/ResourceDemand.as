package by.vnz.framework.events {

	import flash.events.Event;

	public class ResourceDemand extends Event {
		static public const DEMAND : String = "ResourceDemand_demand";

		public var id : String;
		public var resource : *;
		public var handler : Function;

		public function ResourceDemand( type : String = ResourceDemand.DEMAND, bubbles : Boolean = true, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
		}
	}
}
