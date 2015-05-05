package by.vnz.events {
	import by.vnz.framework.events.BubbleEvent;
	import by.vnz.framework.events.InnerEvent;

	public class MainStatesEvent extends InnerEvent {
		static public const INIT : String = "main_init";

		static public const PRELOADING : String = "preloading";

		public function MainStatesEvent( type : String ) {
			super( type );
		}
	}
}