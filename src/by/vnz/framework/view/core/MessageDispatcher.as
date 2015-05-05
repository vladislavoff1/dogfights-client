package by.vnz.framework.view.core {
	import by.vnz.framework.events.SimpleMessage;

	import flash.events.EventDispatcher;

	public class MessageDispatcher extends ExtendedSprite {
		public function MessageDispatcher() {
			super();
//			listenElement( this );
		}

		/**
		 * @param
		 */
		public function dispatchMessage( text : String ) : void {
			var message : SimpleMessage;

			message = new SimpleMessage();
			message.text = text;

			dispatchEvent( message );
		}

		/**
		 * use in descendants
		 * override method
		 * @param event
		 */
		protected function messageHandler( msg : SimpleMessage ) : void {
		}

		/**
		 * @param
		 */
		protected function listenElement( target : MessageDispatcher ) : void {
			if ( target is EventDispatcher ) {
				target.addEventListener( SimpleMessage.MESSAGE, messageHandler, false, 0, true );
			}
		}

		/**
		 * @param
		 */
		protected function ignoreElement( target : MessageDispatcher ) : void {
			if ( target is EventDispatcher ) {
				target.removeEventListener( SimpleMessage.MESSAGE, messageHandler );
			}
		}
	}
}