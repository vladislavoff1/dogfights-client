package by.vnz.view.user {
	import by.vnz.VO.DogVO;
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.components.SimpleButtonProxy;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.idmaps.IDMMainMessages;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class UserPanel extends GUIElement {
		private var _data : DogVO;

		public var avatar : UserAvatar;
		public var levelIcon : LevelIcon;
		public var levelBar : LevelBar;
		public var txtMoney : TextField;
		public var txtLevel : TextField;
		public var dogInfo : DogInfoPanel;
		public var wallet : SimpleButtonProxy;

		public function UserPanel() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

//			createUIChild( ImageProxy, <ui name="BG" resource="shop_item_BG" /> );
			createUIChild( UserAvatar, <ui name="avatar" y="8" /> );

			createUIChild( LevelIcon, <ui name="levelIcon" x="37" y="0" /> );
			createUIChild( LevelBar, <ui name="levelBar" x="67" y="7" /> );
			createUIChild( TextField, <ui name="txtLevel" x="65" y="17" width="150" height="22" text="0/200" font="Calibri" size="15" color="0xFFFED4" bold="true" /> );

			createUIChild( SimpleButtonProxy, <ui name="wallet" resource="wallet"  x="61" y="39" /> );
			createUIChild( ImageProxy, <ui name="coinIcon" resource="coin_icon" x="90" y="40"/> );
			createUIChild( TextField, <ui name="txtMoney" x="115" y="39" width="100" height="25" text="500" font="Calibri" size="17" color="0xFFE000" bold="true" /> );

			createUIChild( DogInfoPanel, <ui name="dogInfo" x="-320" y="160" visible="false"/> );

			avatar.addEventListener( MouseEvent.ROLL_OVER, avatarRollOverHandler );
			avatar.addEventListener( MouseEvent.ROLL_OUT, avatarRollOutHandler );
			avatar.addEventListener( MouseEvent.MOUSE_DOWN, avatarRollOutHandler );
			wallet.addEventListener( MouseEvent.CLICK, walletClickHandler );

			dataChangeHandler( null );
		}

		public function get data() : DogVO {
			var result : DogVO = _data;

			return result;
		}

		public function set data( value : DogVO ) : void {
			if ( !value || _data == value ) {
				return;
			}
			_data = value;
			_data.addEventListener( Event.CHANGE, dataChangeHandler );
			dataChangeHandler( null );
			dogInfo.data = _data;
		}

		private function dataChangeHandler( event : Event ) : void {
			if ( !isGUIReady || !_data ) {
				return;
			}
			update();
		}

		public function update() : void {
			levelIcon.data = _data.level;
			var levelProgress : uint = 100 * _data.exp / _data.nextlevel;
			levelBar.data = levelProgress;
			txtMoney.text = _data.money.toString();
			txtLevel.text = _data.exp.toString() + "/" + _data.nextlevel.toString();

			avatar.loadImage( _data.photo );
		}

		private function avatarRollOverHandler( event : MouseEvent ) : void {
			dogInfo.show();
		}

		private function avatarRollOutHandler( event : MouseEvent ) : void {
			dogInfo.hide();
		}

		private function walletClickHandler( event : MouseEvent ) : void {
			dispatchMessage( IDMMainMessages.MSG_BANK_ENTER );
		}

	}
}