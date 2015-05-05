package by.vnz.events {
	import by.vnz.framework.events.BubbleEvent;

	public class ItemEvent extends BubbleEvent {

		static public const SELECT : String = "item_select";

		public function ItemEvent( type : String ) {
			super( type );
		}
	}
}