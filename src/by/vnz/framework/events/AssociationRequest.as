package by.vnz.framework.events {

	import flash.events.Event;
	import by.vnz.framework.resources.ResourceData;

	public class AssociationRequest extends Event {
		static public const ASSOCIATE_RESOURCE : String = "associate.resource";

		public var data : ResourceData;

		public function AssociationRequest( type : String = ASSOCIATE_RESOURCE, bubbles : Boolean = true, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
		}
	}
}
