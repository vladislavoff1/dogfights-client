package by.vnz.framework.events {

	import by.vnz.framework.dragdrop.*;

	import flash.events.EventDispatcher;

	public class DragEvent extends BubbleEvent {
		static public const DRAG_START : String = "startDrag";
		static public const DRAG_ENTER : String = "dragEnter";
		static public const DROP_REQUEST : String = "drop_request";

		public var dragInitiator : EventDispatcher;
		public var dragData : Object;

		public function DragEvent( type : String = DRAG_START ) {
			super( type );
		}
	}
}
