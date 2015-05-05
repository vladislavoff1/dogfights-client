package by.vnz.framework.events {

	public class SimpleMessage extends BubbleEvent {
		public static const MESSAGE : String = "simple_message";

		public var text : String;

		public function SimpleMessage( type : String = MESSAGE ) {
			super( type );
		}
	}
}
