package by.vnz.view.items {
	import by.vnz.VO.ItemVO;
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.idmaps.IDMItemMsg;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	import vnz.utils.CopyMaker;

	public class ItemObject extends GUIElement {
		static public const ITEM_SIZE : uint = 95;

		protected var _data : ItemVO;

		public var coinIcon : ImageProxy;
		public var txtPrice : TextField;
		public var itemImage : ImageProxy;

		private var _timer : Timer;

		public function ItemObject() {
			super();
			mouseChildren = false;
		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

			graphics.clear();
			graphics.beginFill( 0xff0000, 0.0 );
			graphics.drawRect( 0, 0, ITEM_SIZE, ITEM_SIZE );
			graphics.endFill();

			createUIChild( ImageProxy, <ui name="coinIcon" resource="coin_icon" x="7" y="71"/> );
			createUIChild( TextField, <ui name="txtPrice" x="30" y="71" width="50" height="20" text="234" font="Calibri" size="13" color="0xFFD600" bold="true" /> );
			createUIChild( ImageProxy, <ui name="itemImage" x="9" y="5" /> );

			addEventListener( MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true );
			addEventListener( MouseEvent.MOUSE_DOWN, rollOutHandler, false, 0, true );

			_timer = new Timer( 500, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );

		}

		override protected function initUICompleted() : void {
			update();

		}

		public function get data() : ItemVO {
			var result : ItemVO = _data;

			return result;
		}

		public function set data( value : ItemVO ) : void {
			if ( !value ) {
				return;
			}
			_data = value;
			dataChangeHandler( null );
		}

		private function dataChangeHandler( event : Event ) : void {
			if ( !isGUIReady || !_data ) {
				return;
			}
			update();
		}

		protected function update() : void {
			txtPrice.text = _data.price.toString();
			itemImage.addEventListener( Event.COMPLETE, imageCompleteHandler, false, 0, true );
			itemImage.resource = "item_shop_type" + data.type + "_" + _data.itemID;
		}

		private function rollOverHandler( event : MouseEvent ) : void {
			_timer.reset();
			_timer.start();
		}

		private function rollOutHandler( event : MouseEvent ) : void {
//			event.stopImmediatePropagation();
			_timer.reset();
			dispatchMessage( IDMItemMsg.HIDE_HINT );

		}

		private function timerCompleteHandler( event : TimerEvent ) : void {
			dispatchMessage( IDMItemMsg.SHOW_HINT );
		}

		public function get dragCopy() : Bitmap {
			var result : Bitmap = CopyMaker.getBitmapCopy( itemImage );
			return result;
		}

		private function imageCompleteHandler( event : Event ) : void {
			itemImage.removeEventListener( Event.COMPLETE, imageCompleteHandler );
			itemImage.x = ( ITEM_SIZE - itemImage.width ) / 2;
			itemImage.y = ( ITEM_SIZE - 10 - itemImage.height ) / 2;
		}

	}
}