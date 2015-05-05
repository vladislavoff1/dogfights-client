package by.vnz.framework.events {

	public class HintBubble extends BubbleEvent {
		static public const SHOW_HINT : String = "show_hint";
		static public const HIDE_HINT : String = "hide_hint";

		public var data : *;
		public var globalX : int;
		public var globalY : int;

		public function HintBubble( type : String = SHOW_HINT ) {
			super( type );
		}
	}
}
