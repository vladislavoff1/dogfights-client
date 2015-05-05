package by.vnz.view.battle {
	import by.vnz.framework.resources.ResourcesManager;
	import by.vnz.framework.view.core.GUIElement;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	public class BattleCountDown extends GUIElement {
		static public const MSG_COUNTDOWN_COMPLETE : String = "msg_countdown_complete";

		public var BG : MovieClip;

//		public var txt : TextField;

		public function BattleCountDown() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

			ResourcesManager.demandResource( "battle_timer_bg", onGraphics );
//			createUIChild( TextField, <ui name="txt" x="0" y="24" width="82" height="50" text="15" font="Calibri" size="25" color="0xFFFFFF" bold="true" align="center" /> );
//			var textShadow : DropShadowFilter = new DropShadowFilter( 1, 45, 0x3A465F, 0.6, 0, 0, 1, BitmapFilterQuality.HIGH );
//			txt.filters = [textShadow];

		}

		protected function onGraphics( source : MovieClip ) : void {
			BG = source;
			addChildAt( BG, 0 );
			BG.gotoAndStop( 0 );
		}

		public function countdown() : void {
			BG.gotoAndPlay( 1 );
			BG.addEventListener( Event.ENTER_FRAME, bg_enterFrameHandler, false, 0, true );
		}

		protected function bg_enterFrameHandler( event : Event ) : void {
			if ( BG.currentFrame == BG.totalFrames ) {
				BG.removeEventListener( Event.ENTER_FRAME, bg_enterFrameHandler );
//				BG.gotoAndStop( 0 );
				BG.stop();
				dispatchMessage( MSG_COUNTDOWN_COMPLETE );
			}
		}
	}
}