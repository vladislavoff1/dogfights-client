package by.vnz.view.battle {
	import by.vnz.framework.resources.ResourcesManager;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.view.user.UserAvatar;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BattleUserPanel extends GUIElement {
		static public const SHOW_INFO : String = "show_info";
		static public const HIDE_INFO : String = "hide_info";

		private var _startHealth : uint;
		public var avatar : UserAvatar;
		public var rightHanded : Boolean = false;
		public var txtName : TextField;
		public var lifeBar : MovieClip;

		public function BattleUserPanel() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

			//			createUIChild( ImageProxy, <ui name="BG" resource="shop_item_BG" /> );
			createUIChild( UserAvatar, <ui name="avatar" x="0" y="0" /> );
			var textAlign : String = rightHanded ? "right" : "left";
			createUIChild( TextField, <ui name="txtName" x="61" y="4" width="180" height="40" text="кличка" font="Calibri" size="17" color="0xFFFFFF" bold="true" align={textAlign} /> );
			ResourcesManager.demandResource( "battle_life_bar", lifeBarGraphics );
			avatar.addEventListener( MouseEvent.ROLL_OVER, avatarRollOverHandler );
			avatar.addEventListener( MouseEvent.ROLL_OUT, avatarRollOutHandler );
			avatar.addEventListener( MouseEvent.MOUSE_DOWN, avatarRollOutHandler );

//			dataChangeHandler( null );
		}

		private function lifeBarGraphics( source : MovieClip ) : void {
			lifeBar = source;
			if ( !rightHanded ) {
				addUIChild( lifeBar, <ui  x="61" y="35" /> );
			} else {
				addUIChild( lifeBar, <ui scaleX="-1" x={lifeBar.width} y="35" /> );
				txtName.x = 0;
				avatar.x = 193;
			}
			lifeBar.gotoAndStop( 0 );
		}

		public function init( dogName : String, startHealth : uint, avatarURL : String ) : void {
			txtName.text = dogName;
			_startHealth = startHealth;
			updateHealth( _startHealth );
			avatar.loadImage( avatarURL );
		}

		public function updateHealth( value : uint ) : void {
			var per : uint = 100 - ( 100 * value / _startHealth );
			debug( "update health(" + _startHealth + "): " + value, per );
			lifeBar.gotoAndStop( per );
		}

		private function avatarRollOverHandler( event : MouseEvent ) : void {
			dispatchMessage( SHOW_INFO );
		}

		private function avatarRollOutHandler( event : MouseEvent ) : void {
			dispatchMessage( HIDE_INFO );
		}
	}
}