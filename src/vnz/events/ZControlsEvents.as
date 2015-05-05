/**
 * @author vnz
 */
package vnz.events {
	import flash.events.Event;
	
	public class ZControlsEvents extends Event{
		public static const BUTTON_DOWN : String = "buttonDown";
		
		public function ZControlsEvents(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}		
	}
}
