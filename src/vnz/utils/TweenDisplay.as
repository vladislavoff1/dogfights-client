package vnz.utils {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class TweenDisplay extends Shape {
		static public const PHASE_INITIAL : String = "phase_initial";
		static public const PHASE_PLAYING : String = "phase_playing";
		static public const PHASE_PAUSED : String = "phase_paused";
		static public const PHASE_END : String = "phase_end";

		private var totalDuration : int;
		private var startTime : int;
		private var pauseTime : int;
		private var endTime : int;

		private var activityPhase : String;

//		private var tweenParent : DisplayObjectContainer;
		private var targetObject : DisplayObject;
		private var initialProperties : Object;
		private var targetProperties : Object;
		private var easingMethod : Function;

		private var _target : DisplayObject;
		public var easingFunction : Function;
		public var properties : Object;
		public var duration : int;

		public function TweenDisplay() {
			super();

			duration = 1000;
			activityPhase = PHASE_INITIAL;
		}

		public function get target() : DisplayObject {
			var result : DisplayObject = _target;

			return result;
		}

		public function set target( value : DisplayObject ) : void {
			_target = value;
		}

		/**
		 * @param
		 */
		public function destroy() : void {
			removeEventListener( Event.ENTER_FRAME, onTween );

			initialProperties = null;
			targetProperties = null;
			easingMethod = null;
			targetObject = null;

			easingFunction = null;
			properties = null;
			_target = null;

			if ( this.parent ) {
				parent.removeChild( this );
			}
		}

		/**
		 * @param
		 */
		public function update() : void {
			targetObject = _target;
			totalDuration = duration;
			endTime = startTime + totalDuration;

			for ( var item : String in targetProperties ) {
				if ( properties[item] != null ) {
					targetProperties[item] = properties[item];
				}
			}

			if ( easingFunction != null ) {
				easingMethod = easingFunction;
			} else {
				easingMethod = linearEasing;
			}
		}

		/**
		 * @param
		 */
		public function start() : void {
			targetObject = _target;

			initialProperties = new Object();
			targetProperties = new Object();

			for ( var item : String in properties ) {
				initialProperties[item] = targetObject[item];
				targetProperties[item] = properties[item];
			}

			startTime = getTimer();
			totalDuration = duration;
			endTime = startTime + totalDuration;

			if ( easingFunction != null ) {
				easingMethod = easingFunction;
			} else {
				easingMethod = linearEasing;
			}

			activityPhase = PHASE_PLAYING;

			addEventListener( Event.ENTER_FRAME, onTween );
		}

		/**
		 * @param
		 */
		public function pause() : void {
			if ( activityPhase == PHASE_PLAYING ) {
				pauseTime = getTimer();
				activityPhase = PHASE_PAUSED;
				removeEventListener( Event.ENTER_FRAME, onTween );
			}
		}

		/**
		 * @param
		 */
		public function resume() : void {
			if ( activityPhase == PHASE_PAUSED ) {
				var wasPaused : int;

				wasPaused = getTimer() - pauseTime;

				startTime += wasPaused;
				endTime += wasPaused;

				activityPhase = PHASE_PLAYING;

				addEventListener( Event.ENTER_FRAME, onTween );
			}
		}

		/**
		 * @param
		 */
		private function onTween( event : Event ) : void {
			if ( getTimer() > endTime ) {
				completeTweening();
			} else {
				var time : int;
				var progress : Number;
				var targetValue : Number;
				var initialValue : Number;

				time = getTimer() - startTime;
				progress = easingMethod( time, 0, 1, totalDuration );

				for ( var item : String in targetProperties ) {
					initialValue = initialProperties[item];
					targetValue = targetProperties[item];

					targetObject[item] = initialValue + ( targetValue - initialValue ) * progress;
				}

				dispatchChange();
			}
		}

		/**
		 * @param
		 */
		private function completeTweening() : void {
			for ( var item : String in targetProperties ) {
				targetObject[item] = targetProperties[item];
			}

			activityPhase = PHASE_END;

			removeEventListener( Event.ENTER_FRAME, onTween );

			dispatchComplete();
		}

		/**
		 * @param
		 */
		private function dispatchChange() : void {
			var newEvent : Event;

			newEvent = new Event( Event.CHANGE );
			dispatchEvent( newEvent );
		}

		/**
		 * @param
		 */
		private function dispatchComplete() : void {
			var newEvent : Event;

			newEvent = new Event( Event.COMPLETE );
			dispatchEvent( newEvent );
		}

		public function getLeftTime() : int {
			var left : int = endTime - getTimer();
			return left < 0 ? 0 : left;
		}

		/**
		 * @param
		 * @return
		 */
		private function linearEasing( t : Number, b : Number, c : Number, d : Number ) : Number {
			var result : Number;

			result = b + c * t / d;

			return ( result );
		}
	}
}
