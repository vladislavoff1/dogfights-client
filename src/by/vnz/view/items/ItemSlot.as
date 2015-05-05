package by.vnz.view.items {
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.idmaps.IDMItemMsg;

	import flash.events.MouseEvent;

	public class ItemSlot extends GUIElement {
		static public const SLOT_SIZE : uint = 95;

		public var index : uint;
		public var active : Boolean;

		public var BG : ImageProxy;
		public var highlighter : ImageProxy;
		private var _item : ItemObject;

		public function ItemSlot() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

			createUIChild( ImageProxy, <ui name="BG" resource="item_slot_bg" /> );
			createUIChild( ImageProxy, <ui name="highlighter" resource="item_slot_highlight" visible="false" /> );

		}

		public function get item() : ItemObject {
			var result : ItemObject = _item;

			return result;
		}

		public function set item( value : ItemObject ) : void {
			if ( !value ) {
				return;
			}
			clear();
			_item = value;
			update();
		}

		protected function update() : void {
			addChild( _item );

			item.addEventListener( MouseEvent.CLICK, clickHandler, false, 0, true );

		}

		private function clickHandler( event : MouseEvent ) : void {
			event.stopImmediatePropagation();

			dispatchMessage( IDMItemMsg.SELECT );
		}

		public function clear() : void {
			if ( _item ) {
				removeChildSafely( _item );
				_item = null;
			}
		}

		public function get selected() : Boolean {
			var result : Boolean = highlighter.visible;

			return result;
		}

		public function set selected( value : Boolean ) : void {
			highlighter.visible = value;
		}
	}
}