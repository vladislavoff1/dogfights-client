package by.vnz.framework.audio {

	import flash.events.Event;

	public class SoundEvent extends Event {
		static public const APPEAR : String = "sound.event:appear";

		public var data : SoundData;

		public function SoundEvent( type : String = APPEAR, bubbles : Boolean = true, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
		}
	}
}
