package by.vnz.view.battle {
	import by.vnz.framework.VO.BaseVO;
	import by.vnz.framework.events.StateEvent;
	import by.vnz.framework.view.core.BaseElement;
	import by.vnz.idmaps.IDMBattleStates;
	import by.vnz.idmaps.IDMDogActions;
	import by.vnz.idmaps.IDMDogs;
	import by.vnz.view.dog.DogImage;

	import flash.events.Event;

	public class BattleDog extends BaseElement {
		static public const MSG_ANIM_COMPLETE : String = "msg_anim_complete";

		private var _breed : String;
		private var _breedID : uint = 0;
		private var _userID : String;
		public var winner : Boolean;

		public var rightHanded : Boolean = true;

		public var dogAnim : DogImage;

		public function BattleDog() {
			super();

			dogAnim = new DogImage();
			listenElement( dogAnim );
			addChild( dogAnim );
			dogAnim.addEventListener( DogImage.MSG_ANIM_COMPLETE, animCompleteHandler );
		}

		public function get userID() : String {
			var result : String = _userID;

			return result;
		}

		public function set userID( value : String ) : void {
			_userID = value;
		}

		public function get breedID() : uint {
			var result : uint = _breedID;

			return result;
		}

		public function set breedID( value : uint ) : void {
			_breedID = value;

			_breed = IDMDogs.getDogByID( breedID );
		}

		override public function set data( value : BaseVO ) : void {
			super.data = value;
			if ( _data ) {
				dogAnim.data = _data;
			}
		}

        override protected function onEnterState( event : StateEvent ) : void {
//			debug( "BATTLE DOG onEnterState", event.state );
			with ( IDMBattleStates )
				switch ( event.state ) {
				case STATE_INIT:
					changeDogAnim( IDMDogActions.WAIT, false );
					break;
				case STATE_FIGHT_BREAK_WAIT:
					changeDogAnim( IDMDogActions.WAIT, true );
					break;
				case STATE_FIGHT_BREAK_END:
				case STATE_ATTACK:
					changeDogAnim( IDMDogActions.ATTACK, true );
					break;
				case STATE_FIGHT:
					var side : String = rightHanded ? "_right" : "_left";
					changeDogAnim( IDMDogActions.FIGHT + side, false );
					break;
				case STATE_FIGHT_BREAK_START:
				case STATE_FIGHT_END:
					changeDogAnim( IDMDogActions.FIGHT_END, true );
					break;
				case STATE_RESULT:
					var action : String = ( winner ? IDMDogActions.WIN : IDMDogActions.DIE );
					changeDogAnim( action, true );
					break;

			}
		}

		override protected function onExitState( event : StateEvent ) : void {

		}

		protected function changeDogAnim( action : String, autoStopAnim : Boolean = false ) : void {

			dogAnim.changeAnim( action, autoStopAnim );

			if ( !rightHanded ) {
				dogAnim.scaleX = -1;
				dogAnim.x = 120; //dogAnim.width;
			}
		}

		protected function animCompleteHandler( event : Event ) : void {
			event.stopImmediatePropagation();
			if ( event.type != DogImage.MSG_ANIM_COMPLETE ) {
				return;
			}
			if ( currentState != IDMBattleStates.STATE_INIT && currentState != IDMBattleStates.STATE_COUNTDOWN && currentState != IDMBattleStates.STATE_FIGHT ) {
//				debug( "battle dog", "anim copmlete : " + currentState );
				dispatchMessage( MSG_ANIM_COMPLETE );
			}
		}
	}
}