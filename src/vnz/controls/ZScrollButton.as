/**
 * @author vnz
 */
package vnz.controls
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import vnz.events.ZControlsEvents;

	public class ZScrollButton extends ZButton
	{
		protected var _pressTimer : Timer;
		protected var _selected : Boolean = false;
		protected var _autoRepeat : Boolean = true;
		private var _repeatDelay : int = 200;

		public function ZScrollButton()
		{
			super( "", null, false );

//			buttonMode = true;
//			mouseChildren = false;
//			useHandCursor = false;

			setupMouseEvents();

			_pressTimer = new Timer( 1, 1 );
			_pressTimer.addEventListener( TimerEvent.TIMER, buttonDown, false, 0, true );

		}

		protected function setupMouseEvents() : void
		{
			addEventListener( MouseEvent.MOUSE_DOWN, mouseEventHandler, false, 0, true );
			addEventListener( MouseEvent.MOUSE_UP, mouseEventHandler, false, 0, true );

			addEventListener( MouseEvent.ROLL_OVER, mouseEventHandler, false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT, mouseEventHandler, false, 0, true );
		}

		protected function mouseEventHandler( event : MouseEvent ) : void
		{
			if ( event.type == MouseEvent.MOUSE_DOWN )
			{
				startPress();
			} else if ( event.type == MouseEvent.ROLL_OVER || event.type == MouseEvent.MOUSE_UP )
			{
				endPress();
			} else if ( event.type == MouseEvent.ROLL_OUT )
			{
				endPress();
			}
		}

		protected function startPress() : void
		{
			if ( _autoRepeat )
			{
				_pressTimer.delay = _repeatDelay;
				_pressTimer.start();
			}
			dispatchEvent( new ZControlsEvents( ZControlsEvents.BUTTON_DOWN, true ));
		}

		protected function buttonDown( event : TimerEvent ) : void
		{
			if ( !_autoRepeat )
			{
				endPress();
				return;
			}
			if ( _pressTimer.currentCount == 1 )
			{
				_pressTimer.delay = _repeatDelay;
				_pressTimer.reset();
				_pressTimer.start();
			}
			dispatchEvent( new ZControlsEvents( ZControlsEvents.BUTTON_DOWN, true ));
		}

		protected function endPress() : void
		{
			_pressTimer.reset();
		}

	}
}
