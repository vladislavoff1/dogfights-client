package by.vnz.framework.audio {

	import by.vnz.framework.resources.ResourcesManager;
	import by.vnz.framework.view.core.MessageDispatcher;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class InterfaceAudio extends MessageDispatcher {
		private var audio : Sound;
		private var audioChannel : SoundChannel;

		private var audioVolume : Number;
		private var audioPan : Number;

		public var id : String;
		public var loop : Boolean;

		private var mPrevPosition : int;
		private var mIsPlay : Boolean;

		public function InterfaceAudio() {
			super();

			audioPan = 0;
			audioVolume = 1;
			loop = false;
			mPrevPosition = 0;
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			if ( audioChannel is SoundChannel ) {
				audioChannel.stop();
				audioChannel = null;
			}

			super.destroy();
		}

		/**
		 * @param
		 */
		public function set volume( value : Number ) : void {
			//inf("NEW VOLUME = ", id, value);

			if ( destroyed ) {
				return;
			}

			audioVolume = value;
		}

		/**
		 * @param
		 */
		public function set pan( value : Number ) : void {
			if ( destroyed ) {
				return;
			}

			audioPan = value;
		}

		/**
		 * @param
		 */
		public function set looping( value : Boolean ) : void {
			if ( destroyed ) {
				return;
			}

			loop = value;
		}

		/**
		 * @param
		 */
		public function set resource( value : String ) : void {
			mIsPlay = true;
			ResourcesManager.demandResource( value, onResource );
		}

		/**
		 * @param
		 */
		public function stopPlaying() : void {
			mIsPlay = false;
			if ( audioChannel ) {
				audioChannel.stop();
			}

			removeEventListener( Event.ENTER_FRAME, onPlayed );

			dispatchMessage( "remove.me" );
		}

		/**
		 * @param
		 */
		private function onResource( source : Sound ) : void {
			if ( !mIsPlay ) {
				dispatchMessage( "remove.me" );
				return;
			}

			if ( destroyed ) {
				return;
			}

			if ( source == null ) {
				return;
			}

			audio = source;

			var aTransform : SoundTransform;

			aTransform = new SoundTransform( audioVolume, audioPan );
			audioChannel = source.play( 0, loop ? int.MAX_VALUE : 1, aTransform );

			addEventListener( Event.ENTER_FRAME, onPlayed );
		}

		private function onPlayed( event : Event ) : void {
			if ( !audio || !audioChannel ) {
				removeEventListener( Event.ENTER_FRAME, onPlayed );
				dispatchMessage( "remove.me" );
				return;
			}

			if ( !loop && ( audioChannel.position >= audio.length || audioChannel.position == mPrevPosition )) {
				removeEventListener( Event.ENTER_FRAME, onPlayed );

				dispatchMessage( "remove.me" );
			}
			mPrevPosition = audioChannel.position;
		}
	}
}
