package by.vnz.framework.VO {
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	public class DialogWindowVO extends EventDispatcher {
		/** base ID, every new ID = baseID++ */
		static private var _lastID : uint = 58294;

		public var ID : uint;
		public var title : String;
		public var text : String;
		public var content : DisplayObject;
		public var allowButtons : int;
		public var messageConfirm : String;
		public var messageCancel : String;
		public var important : Boolean;
		public var modal : Boolean;
		/** in ms */
		public var autoCloseTime : uint = 0;

		public function DialogWindowVO( title : String = "", content : * = null, allowButtons : uint = 0 ) {
			super();

			ID = newID;

			this.title = title;
			if ( content is String ) {
				this.text = content as String;
			} else if ( content is DisplayObject ) {
				this.content = content;
			}
			this.allowButtons = allowButtons;
		}

		public function get newID() : uint {
			var result : uint;
			_lastID++;
			result = _lastID;
			return result;
		}

	}
}