package by.vnz.view.dog {
	import by.vnz.VO.DogVO;
	import by.vnz.framework.resources.ResourcesManager;
	import by.vnz.framework.view.core.BaseElement;
	import by.vnz.idmaps.IDMDogActions;
	import by.vnz.idmaps.IDMDogs;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class DogImage extends BaseElement {
		static public const MSG_ANIM_COMPLETE : String = "msg_anim_complete";
		static public var instances : Dictionary = new Dictionary( true );

		private var _action : String = IDMDogActions.WAIT;
		private var _sendEndAnimMSG : Boolean = true;
		private var _mirror : Boolean = false;

		public var anim : MovieClip;

		public var armor : MovieClip;
		public var fangsUp : MovieClip;
		public var fangsDown : MovieClip;
		public var claws : Array = [];

		public function DogImage() {
			super();

			instances[this] = this;
//			var fang : DogFangsUp = new DogFangsUp();
//			var claw : DogClaws = new DogClaws();

			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
//			addEventListener( Event.REMOVED_FROM_STAGE, destroy, false, 0, true );
		}

		override protected function update() : void {
			super.update();
            var dogData : DogVO = _data as DogVO;

            if ( dogData.breedID == 0 ) {
                return;
            }

			changeAnim();

            clearEquipmets();

			if ( dogData.armor > 0 ) {
				ResourcesManager.demandResource( "item_type3_" + dogData.armor, onArmorGraphics );
			}
			if ( dogData.fang > 0 ) {
				ResourcesManager.demandResource( "item_type2_" + dogData.fang + "_u", onFangUpGraphics );
				ResourcesManager.demandResource( "item_type2_" + dogData.fang + "_d", onFangDownGraphics );
			}
//			if ( dogData.claw > 0 ) {
//				getClaw();
//			}
		}

		public function get sendEndAnimMSG() : Boolean {
			var result : Boolean = _sendEndAnimMSG;

			return result;
		}

		public function set sendEndAnimMSG( value : Boolean ) : void {
			_sendEndAnimMSG = value;
		}

		protected function getClaw() : void {
			var dogData : DogVO = _data as DogVO;
			ResourcesManager.demandResource( "item_type1_" + dogData.claw, onClawsGraphics );
		}

		public function changeAnim( action : String = null, autoStopAnim : Boolean = false ) : void {
			if ( action ) {
				_action = action;
			}
			_sendEndAnimMSG = autoStopAnim;
			if ( anim ) {
				removeChildSafely( anim );
				anim = null;
			}
			if ( !_data ) {
				return;
			}
			var dogData : DogVO = _data as DogVO;
			var dogResource : String = IDMDogs.getDogByID( dogData.breedID ) + "_" + _action;
			ResourcesManager.demandResource( dogResource, onGraphics );
		}

		public function onGraphics( source : MovieClip ) : void {
//			removeChildSafely( anim );
			if ( source ) {
				anim = source;
				addChild( anim );
				if ( _sendEndAnimMSG ) {
					anim.addEventListener( Event.ENTER_FRAME, dogAnim_enterFrameHandler, false, 0, true );
				}
			}
		}

		public function onArmorGraphics( source : MovieClip ) : void {
			if ( !source ) {
				return;
			}

			armor = source;
		}

		public function onFangUpGraphics( source : MovieClip ) : void {
			if ( !source ) {
				return;
			}
            fangsUp = null;
			fangsUp = source;
		}

		public function onFangDownGraphics( source : MovieClip ) : void {
			if ( !source ) {
				return;
			}
            fangsDown = null;
			fangsDown = source;
		}

		public function onClawsGraphics( source : MovieClip ) : void {
			if ( !source ) {
				return;
			}
			claws.push( source );
			if ( claws.length < 4 ) {
				getClaw();
			}
		}

        private function clearEquipmets():void{
            if (armor && armor.parent ){
                armor.parent.removeChild(armor);
            }
            armor = null;

            if (fangsUp && fangsUp.parent ){
                fangsUp.parent.removeChild(fangsUp);
            }
            fangsUp = null;

            if (fangsDown && fangsDown.parent ){
                fangsDown.parent.removeChild(fangsDown);
            }
            fangsDown = null;
            
        }

		override public function destroy() : void {
			for each ( var dog : DogImage in DogImage.instances ) {
				if ( dog == this ) {
					delete instances[dog];
					anim.removeEventListener( Event.ENTER_FRAME, dogAnim_enterFrameHandler );
					anim = null;
					armor = null;
					fangsUp = null;
					fangsDown = null;
					claws = null;
				}
			}
		}

		protected function dogAnim_enterFrameHandler( event : Event ) : void {
			if ( anim.currentFrame != anim.totalFrames ) {
				return;
			}
			anim.removeEventListener( Event.ENTER_FRAME, dogAnim_enterFrameHandler );
			if ( _sendEndAnimMSG ) {
				anim.stop();
				dispatchEvent( new Event( MSG_ANIM_COMPLETE ));
			}
//				debug( "battle dog", "anim copmlete : " + currentState );
		}

		private function enterFrameHandler( event : Event ) : void {
			if ( !this.anim ) {
				return;
			}
			var body : MovieClip = anim.getChildByName( "body" ) as MovieClip;
			if ( body ) {
				var armors : MovieClip = body.getChildByName( "armors" ) as MovieClip;
				if ( armors && this.armor && !armors.contains( this.armor )) {
					armors.addChild( armor )
				}
			}
			var head : MovieClip = anim.getChildByName( "head" ) as MovieClip;
			if ( head ) {
				var fangUp : MovieClip = head.getChildByName( "fangup" ) as MovieClip;
				if ( fangUp && this.fangsUp && !fangUp.contains( this.fangsUp )) {
					fangUp.addChild( fangsUp );
				}
			}

			var jaw : MovieClip = anim.getChildByName( "jaw" ) as MovieClip;
			if ( jaw ) {
				var fangDown : MovieClip = jaw.getChildByName( "fangdown" ) as MovieClip;
				if ( fangDown && this.fangsDown && !fangDown.contains( this.fangsDown )) {
					fangDown.addChild( fangsDown );
				}
			}
		}

	}
}