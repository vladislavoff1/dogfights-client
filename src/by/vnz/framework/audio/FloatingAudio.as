package by.vnz.framework.audio {
	import by.vnz.framework.resources.ResourcesManager;
	import by.vnz.framework.view.core.MessageDispatcher;

	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class FloatingAudio extends MessageDispatcher {
		private var audioChannel : SoundChannel;
		private var audioAmplifier : Number;

		private var tweenedVolume : Number;
		private var tweenedPan : Number;

		private var audioVolume : Number;
		private var audioPan : Number;

		public var position : Point;
		public var radius : int;
		public var id : String;

		public function FloatingAudio() {
			super();

			audioPan = 0;
			audioVolume = 0;

			tweenedPan = 0;
			tweenedVolume = 0;

			audioAmplifier = 1;
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

			realVolume = value
//			audioVolume = value;

//			if ( audioChannel == null ) {
//				return;
//			}
//
//			stopVolumeTweening();
//
//			if ( audioVolume != realVolume ) {
//				startVolumeTweening();
//			}
		}

//		/**
//		 * @param
//		 */
//		private function onVolumeComplete( event : Event ) : void {
//			stopVolumeTweening();
//		}

		/**
		 * @param
		 */
//		private function stopVolumeTweening() : void {
//			if ( volumeTween == null ) {
//				return;
//			}
//
//			volumeTween.pause();
//			volumeTween.destroy();
//			volumeTween.removeEventListener( Event.COMPLETE, onVolumeComplete );
//
//			volumeTween = null;
//		}
//
//		/**
//		 * @param
//		 */
//		private function startVolumeTweening() : void {
//			volumeTween = new TweenAlot();
//			volumeTween.duration = 500;
//			volumeTween.target = this;
//
//			volumeTween.properties = {realVolume:audioVolume};
//
//			volumeTween.addEventListener( Event.COMPLETE, onVolumeComplete );
////			volumeTween.easingFunction = Regular.easeInOut;
//			volumeTween.start();
//		}

		/**
		 * @param
		 */
		public function get realVolume() : Number {
			var result : Number;

			result = tweenedVolume;

			return ( result );
		}

		public function set realVolume( value : Number ) : void {
			//inf(id, value);

			//unamplifiedVolume = value;
			tweenedVolume = value * audioAmplifier;

			if ( audioChannel == null ) {
				return;
			}

			var aTransform : SoundTransform;

			aTransform = audioChannel.soundTransform;

			if ( aTransform == null ) {
				aTransform = new SoundTransform( tweenedVolume, tweenedPan );
			} else {
				aTransform.volume = tweenedVolume;
			}

			audioChannel.soundTransform = aTransform;
		}

		/**
		 * @param
		 */
		public function set amplifier( value : Number ) : void {
			audioAmplifier = value;
			realVolume = audioVolume;
		}

		/**
		 * @param
		 */
		public function set pan( value : Number ) : void {
			if ( destroyed ) {
				return;
			}
			realPan = value;
//			audioPan = value;
//
//			if ( audioChannel == null ) {
//				return;
//			}
//
//			stopPanTweening();
//			startPanTweening();
		}

//		/**
//		 * @param
//		 */
//		private function onPanComplete( event : Event ) : void {
//			stopPanTweening();
//		}

		/**
		 * @param
		 */
//		private function stopPanTweening() : void {
//			if ( panTween == null ) {
//				return;
//			}
//
//			panTween.pause();
//			panTween.destroy();
//			panTween.removeEventListener( Event.COMPLETE, onPanComplete );
//
//			panTween = null;
//		}
//
//		/**
//		 * @param
//		 */
//		private function startPanTweening() : void {
//			panTween = new TweenAlot();
//			panTween.duration = 500;
//			panTween.target = this;
//
//			panTween.properties = {realPan:audioPan};
//
//			panTween.addEventListener( Event.COMPLETE, onVolumeComplete );
////			panTween.easingFunction = Regular.easeInOut;
//			panTween.start();
//		}

		/**
		 * @param
		 */
		public function get realPan() : Number {
			var result : Number;

			result = tweenedPan;

			return ( result );
		}

		public function set realPan( value : Number ) : void {
			tweenedPan = value;

			if ( audioChannel == null ) {
				return;
			}

			var aTransform : SoundTransform;

			aTransform = audioChannel.soundTransform;

			if ( aTransform == null ) {
				aTransform = new SoundTransform( tweenedVolume, tweenedPan );
			} else {
				aTransform.pan = tweenedPan;
			}

			audioChannel.soundTransform = aTransform;
		}

		/**
		 * @param
		 */
		public function set resource( value : String ) : void {
			ResourcesManager.demandResource( value, onResource );
		}

		/**
		 * @param
		 */
		private function onResource( source : Sound ) : void {
			if ( destroyed ) {
				return;
			}

			if ( source == null ) {
				return;
			}

			var aTransform : SoundTransform;

			aTransform = new SoundTransform( tweenedVolume, tweenedPan );
			audioChannel = source.play( 0, int.MAX_VALUE, aTransform );
		}
	}
}
