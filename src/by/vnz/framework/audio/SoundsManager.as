package by.vnz.framework.audio {

	import by.vnz.framework.events.SimpleMessage;
	import by.vnz.framework.view.core.BaseElement;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class SoundsManager extends BaseElement {
		static private var _instance : SoundsManager;

		private var _globalVolume : Number = 1;

		private var audioHeap : Object;

		private var position : Point;

		public function SoundsManager() {
			super();

			if ( _instance ) {
				throw( "SoundsManager instance!" );
				return;
			} else {
				_instance = this;
			}

			audioHeap = new Object();
			position = new Point( 604, 606 );

		}

		static public function get volume() : Number {
			var result : Number = _instance._globalVolume;

			return result;
		}

		static public function set volume( value : Number ) : void {
			if ( value > 1 || value < 0 ) {
				return;
			}
			_instance._globalVolume = value;
			_instance.volumeChanged();
		}

		private function volumeChanged() : void {
			if ( _globalVolume == 0 ) {
				removeAllAudios();
			}
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			for ( var key : String in audioHeap ) {
				removeAudio( key );
			}

			audioHeap = null;
			position = null;

			super.destroy();
		}

		/**
		 * @param
		 */
//		private function onVolumeEnvironment( event : DataMessage ) : void {
//			audioAmplifier = Number( event.data );
//
//			var anAudio : FloatingAudio;
//
//			for ( var key : String in audioHeap ) {
//				anAudio = audioHeap[key];
//				anAudio.amplifier = audioAmplifier;
//			}
//		}
//
//		/**
//		 * @param
//		 */
//		private function onVolumeFX( event : DataMessage ) : void {
//			soundAmplifier = Number( event.data );
//		}

		/**
		 * @param
		 */
		public function attachTo( target : Sprite ) : void {
			target.addEventListener( AudioEvent.APPEAR, onAppear, false, 0, true );
			target.addEventListener( SoundEvent.APPEAR, onSoundAppear, false, 0, true );
		}

		/**
		 * @param
		 */
		public function detachFrom( target : MovieClip ) : void {
			target.removeEventListener( AudioEvent.APPEAR, onAppear );
		}

		public function sendEvent( event : Event ) : void {
			if ( event is AudioEvent ) {
				onAppear( event as AudioEvent );
			} else if ( event is SoundEvent ) {
				onSoundAppear( event as SoundEvent );
			}
		}

		/**
		 * @param
		 */
		private function onAppear( event : AudioEvent ) : void {
			if ( destroyed ) {
				return;
			}

			addAudio( event.data );
		}

		/**
		 * @param
		 */
		private function onSoundAppear( event : SoundEvent ) : void {
			if ( destroyed ) {
				return;
			}

			processSound( event.data );
		}

		/**
		 * @param
		 * @return
		 */
		private function addAudio( source : AudioData ) : void {
			if ( audioHeap[source.id] != null ) {
				return;
			}

			var anAudio : FloatingAudio;

			anAudio = new FloatingAudio();

			anAudio.id = source.id;
			anAudio.radius = source.radius;
			anAudio.amplifier = _globalVolume;
			anAudio.position = source.position.clone();
			anAudio.resource = "map.exploration.audio." + source.audioid;

			audioHeap[source.id] = anAudio;
			updateAudio( anAudio );
			addChild( anAudio );
		}

		/**
		 * @param
		 * @return
		 */
		private function processSound( source : SoundData ) : void {
			if ( !source.stop ) {
				playSound( source );
			} else {
				stopSound( source.id );
			}
		}

		/**
		 * @param
		 * @return
		 */
		private function playSound( source : SoundData ) : void {
			var anSound : InterfaceAudio;

			anSound = new InterfaceAudio();

			anSound.id = source.id;
			anSound.looping = source.loop;
			anSound.volume = _globalVolume;
			anSound.resource = source.id;

			listenElement( anSound );
			addChild( anSound );
		}

		/**
		 * @param
		 * @return
		 */
		private function stopSound( id : String ) : void {
			for ( var i : int = 0; i < numChildren; i++ ) {
				if ( getChildAt( i ) is InterfaceAudio ) {
					var anSound : InterfaceAudio;
					anSound = getChildAt( i ) as InterfaceAudio;
					if ( anSound.id == id ) {
						anSound.stopPlaying();

						break;
					}
				}
			}
		}

		/**
		 * @param
		 * @return
		 */
		private function stopAllSounds() : void {
			for ( var i : int = 0; i < numChildren; i++ ) {
				if ( getChildAt( i ) is InterfaceAudio ) {
					var anSound : InterfaceAudio;
					anSound = getChildAt( i ) as InterfaceAudio;

					anSound.stopPlaying();
				}
			}
		}

		/**
		 * @param
		 */
		private function removeAudio( id : String ) : void {
			var anAudio : FloatingAudio;

			anAudio = audioHeap[id];

			if ( anAudio == null ) {
				return;
			}

			anAudio.destroy();
			delete( audioHeap[id]);

			try {
				removeChild( anAudio );
			} catch ( error : Error ) {
			}
		}

		/**
		 * @param
		 */
		public function removeAllAudios() : void {
			var anAudio : FloatingAudio;

			for each ( anAudio in audioHeap ) {
				if ( anAudio == null ) {
					return;
				}

				anAudio.destroy();
				try {
					removeChild( anAudio );
				} catch ( error : Error ) {
				}
			}
			audioHeap = new Object();

			stopAllSounds();
		}

		/**
		 * @param
		 */
		public function updatePosition( source : Point ) : void {
			position = source.clone();

			var anAudio : FloatingAudio;

			for ( var key : String in audioHeap ) {
				anAudio = audioHeap[key];
				updateAudio( anAudio );
			}
		}

		/**
		 * @param
		 */
		private function updateAudio( audio : FloatingAudio ) : void {
			var aDistance : Number;

			aDistance = Point.distance( position, audio.position );

			if ( aDistance > audio.radius * 2 + 5 ) {
				removeAudio( audio.id );
				return;
			}

			audio.pan = ( audio.position.x - position.x ) / audio.radius;
			audio.volume = Math.max( 0, ( audio.radius - aDistance ) / audio.radius );
		}

		/**
		 * @param
		 */
		static public function requestAudio( id : AudioData, target : Sprite ) : void {
			var anEvent : AudioEvent;

			anEvent = new AudioEvent();
			anEvent.data = id;

			target.dispatchEvent( anEvent );
		}

		/**
		 * @param
		 */
		static public function requestSound( id : String, looping : Boolean = false ) : void {
			if ( _instance._globalVolume == 0 ) {
				return;
			}
			var data : SoundData = new SoundData();
			data.id = id;
			data.loop = looping;

			_instance.processSound( data );
//			var anEvent : SoundEvent;
//
//			anEvent = new SoundEvent();
//			anEvent.data = data;
//
//			target.dispatchEvent( anEvent );

		}

		/**
		 * @param
		 */
		static public function requestStopSound( id : String ) : void {
			var data : SoundData = new SoundData();
			data.id = id;
			data.stop = true;

			_instance.processSound( data );
//			var anEvent : SoundEvent;
//
//			anEvent = new SoundEvent();
//			anEvent.data = data;
//
//			target.dispatchEvent( anEvent );
		}

		override protected function messageHandler( event : SimpleMessage ) : void {
			switch ( event.text ) {
				case "remove.me": {
					for ( var i : int = 0; i < numChildren; i++ ) {
						if ( getChildAt( i ) is InterfaceAudio ) {
							var anSound : InterfaceAudio;
							anSound = getChildAt( i ) as InterfaceAudio;

							if ( event.target.id == anSound.id ) {
								ignoreElement( anSound );
								removeChild( anSound );
							}
						}
					}

					break;
				}
			}
		}
	}
}
