package by.vnz.framework.audio {

	import flash.events.Event;

	public class AudioEvent extends Event {
		static public const APPEAR : String = "audio.event:appear";

		public var data : AudioData;

		public function AudioEvent( type : String = APPEAR, bubbles : Boolean = true, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
		}
	}
}
