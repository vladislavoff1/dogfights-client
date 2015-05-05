package by.vnz.framework.events {
	import flash.events.Event;

	public class BubbleEvent extends Event {
		public function BubbleEvent( type : String ) {
			super( type, true, cancelable );
		}
	}
}