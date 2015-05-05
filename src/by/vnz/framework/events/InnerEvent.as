package by.vnz.framework.events {

	public class InnerEvent extends BubbleEvent {

		public var callback : Function;

		public function InnerEvent( type : String ) {
			super( type );
		}
	}
}