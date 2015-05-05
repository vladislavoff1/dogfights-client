package by.vnz.view.battle {
	import by.vnz.framework.resources.ResourcesManager;
	import by.vnz.framework.view.core.BaseElement;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	public class FightPopup extends BaseElement {
		static public const MSG_HIDE : String = "msg_hide";

		public var rightHanded : Boolean = true;
		public var BG : MovieClip;
		public var txt : TextField;

		public function FightPopup() {
			super();
		}

		override protected function initUI() : void {
			createUIChild( TextField, <ui name="txt" x="0" y="4" width="184" height="60" font="Calibri" size="15" color="0xFF3D63" bold="true" align="center" multiline="true" /> );
			ResourcesManager.demandResource( "fight_popup_bg", onGraphics );
			txt.visible = false;
		}

		protected function onGraphics( source : MovieClip ) : void {
			BG = source;
			addChildAt( BG, 0 );
			BG.gotoAndStop( 0 );

			txt.text = "Тузик получил в пузик";
			if ( !rightHanded ) {
				BG.scaleX = -1;
				BG.x = BG.width;
				txt.x = 55;
			}

		}

		public function show( value : String ) : void {
			if ( !value ) {
				return;
			}
			visible = true;
			BG.gotoAndPlay( "show" );
			BG.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
			txt.text = value;
		}

		public function hide() : void {
			dispatchMessage( MSG_HIDE );
			visible = false;
		}

		private function enterFrameHandler( event : Event ) : void {
			switch ( BG.currentLabel ) {
				case "title":
					txt.visible = true;
//					return;
					break;
				case "hide":
					txt.visible = false;
					break;
			}
			if ( BG.currentFrame == BG.totalFrames ) {
				BG.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
				BG.stop();
				hide();
			}
		}
	}
}