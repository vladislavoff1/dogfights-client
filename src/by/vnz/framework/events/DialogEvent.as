package by.vnz.framework.events {
	import by.vnz.framework.VO.DialogWindowVO;

	public class DialogEvent extends BubbleEvent {
		static public const ADD_DIALOG : String = "add.dialog";
		static public const REMOVE_DIALOG : String = "remove.dialog";

		public var dialogData : DialogWindowVO;

		public function DialogEvent( data : DialogWindowVO, type : String = ADD_DIALOG ) {
			super( type );

			if (( type != ADD_DIALOG ) && ( type != REMOVE_DIALOG )) {
				inf( "Invalid Dialog Message!" );
				throw( new Error( "Invalid Dialog Message!" ));
			}
			dialogData = data;

		}
	}
}
