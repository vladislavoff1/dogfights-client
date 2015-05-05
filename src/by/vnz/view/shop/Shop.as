package by.vnz.view.shop {
	import by.vnz.VO.ShopItemVO;
	import by.vnz.framework.events.SimpleMessage;
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.components.SimpleButtonProxy;
	import by.vnz.framework.view.core.BaseElement;
	import by.vnz.framework.view.core.ExtendedSprite;
	import by.vnz.idmaps.IDMMainMessages;
	import by.vnz.idmaps.IDMItemMsg;
	import by.vnz.idmaps.IDMItemTypes;
	import by.vnz.model.Model;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import by.vnz.view.items.ItemHint;

	public class Shop extends BaseElement {
		static public const ITEMS_ON_PAGE : uint = 12;
		static public const ITEMS_IN_ROW : uint = 6;

		/** from 0 to N*/
		private var _currentPage : uint = 0;
		private var _currentType : uint;
		/** from 0 to N*/
		private var _allPagesOfCurrentType : uint = 0;
		private var _selectedItem : ShopItem;

		//UI block
		public var BG : ImageProxy;
		public var btnClose : SimpleButtonProxy;
		public var btnBuy : SimpleButtonProxy;
		public var itemsBox : ExtendedSprite;

		public var btnTabClaw : SimpleButtonProxy;
		public var btnTabFang : SimpleButtonProxy;
		public var btnTabArmor : SimpleButtonProxy;
		public var btnTabDrug : SimpleButtonProxy;

		public var btnPrev : SimpleButtonProxy;
		public var txtPaging : TextField;
		public var btnNext : SimpleButtonProxy;

		public var shopBuyDialog : SellBuyItemDialog;
		public var itemHint : ItemHint;

		public function Shop() {
			super();
		}

		override protected function initUI() : void {
			createUIChild( ImageProxy, <ui name="BG" resource="shop_bg" x="0" y="0" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnClose" resource="btn_close" x="567" y="4" /> );

			createUIChild( SimpleButtonProxy, <ui name="btnTabClaw" resource="btn_tab_clow" x="18" y="47" width="93" height="32" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnTabFang" resource="btn_tab_fang" x="115" y="47" width="93" height="32" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnTabArmor" resource="btn_tab_armor" x="214" y="47" width="93" height="32"  /> );
			createUIChild( SimpleButtonProxy, <ui name="btnTabDrug" resource="btn_tab_drug" x="312" y="47" width="93" height="32"  /> );

			createUIChild( ExtendedSprite, <ui name="itemsBox" x="15" y="100" /> );

			createUIChild( SimpleButtonProxy, <ui name="btnPrev" resource="btn_prev" x="238" y="314" /> );
			createUIChild( TextField, <ui name="txtPaging" x="267" y="312" width="61" height="23" text="1 из 1" font="Calibri" size="15" color="0xFFFFFF" bold="true" align="center" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnNext" resource="btn_next" x="328" y="314" /> );

			createUIChild( SimpleButtonProxy, <ui name="btnBuy" resource="btn_buy" x="475" y="305" /> );

			createUIChild( SellBuyItemDialog, <ui name="shopBuyDialog" x="200" y="200" visible="false" /> );
			listenElement( shopBuyDialog );

			createUIChild( ItemHint, <ui name="itemHint" x="200" y="200" visible="false" /> );
			listenElement( itemHint );

			btnClose.addEventListener( MouseEvent.CLICK, btnClose_clickHandler );
			btnPrev.addEventListener( MouseEvent.CLICK, btnPrev_clickHandler );
			btnNext.addEventListener( MouseEvent.CLICK, btnNext_clickHandler );

			btnTabClaw.addEventListener( MouseEvent.CLICK, tabButtons_clickHandler );
			btnTabFang.addEventListener( MouseEvent.CLICK, tabButtons_clickHandler );
			btnTabArmor.addEventListener( MouseEvent.CLICK, tabButtons_clickHandler );
			btnTabDrug.addEventListener( MouseEvent.CLICK, tabButtons_clickHandler );

			btnBuy.addEventListener( MouseEvent.CLICK, btnBuy_clickHandler );
			btnBuy.enabled = false;

		}

		public function init() : void {
			showItems( 0, IDMItemTypes.TYPE_CLOW );
		}

		private function btnClose_clickHandler( event : MouseEvent ) : void {
			dispatchMessage( IDMMainMessages.MSG_SHOP_EXIT );
		}

		private function tabButtons_clickHandler( event : MouseEvent ) : void {
			var currentButton : SimpleButtonProxy = ( event.target as DisplayObject ).parent as SimpleButtonProxy;
			with ( IDMItemTypes ) {
				switch ( currentButton ) {
					case btnTabClaw:
						showItems( 0, TYPE_CLOW );
						break;
					case btnTabFang:
						showItems( 0, TYPE_FANG );
						break;
					case btnTabArmor:
						showItems( 0, TYPE_ARMOR );
						break;
					case btnTabDrug:
						showItems( 0, TYPE_DRUG );
						break;
				}
			}
		}

		private function btnPrev_clickHandler( event : MouseEvent ) : void {
			showItems(( _currentPage - 1 ));
		}

		private function btnNext_clickHandler( event : MouseEvent ) : void {
			showItems(( _currentPage + 1 ));
		}

		private function showItems( page : uint, type : uint = 0 ) : void {
			if ( type != 0 && type != _currentType ) {
				_currentType = type;
			}
			var list : Array = Model.instance.shopManager.getItemsByType( _currentType );
			_allPagesOfCurrentType = Math.ceil( list.length / ITEMS_ON_PAGE ) - 1;
			_currentPage = page;
			if ( _currentPage > _allPagesOfCurrentType ) {
				_currentPage = _allPagesOfCurrentType;
			}
			btnNext.enabled = ( _currentPage != _allPagesOfCurrentType );
			btnNext.enabled ? btnNext.alpha = 1 : btnNext.alpha = 0.7;
			if ( _currentPage < 0 ) {
				_currentPage = 0;
			}
			btnPrev.enabled = ( _currentPage != 0 );
			btnPrev.enabled ? btnPrev.alpha = 1 : btnPrev.alpha = 0.7;

			txtPaging.text = ( _currentPage + 1 ) + " of " + ( _allPagesOfCurrentType + 1 );

			var from : uint = _currentPage * ITEMS_ON_PAGE;
			var to : uint = ( _currentPage + 1 ) * ITEMS_ON_PAGE;
			if ( from < to ) {
				list = list.slice( from, to );
			}

			itemsBox.removeChildren11();

			var posX : uint = 0;
			var posY : uint = 0;
			for each ( var itemVO : ShopItemVO in list ) {
				var item : ShopItem = createUIChild( ShopItem, <ui x={posX} y={posY} />, itemsBox );
				listenElement( item );
				item.data = itemVO;
				posX += ShopItem.ITEM_SIZE;
				if ( posX == ( ITEMS_IN_ROW * ShopItem.ITEM_SIZE )) {
					posX = 0;
					posY += ShopItem.ITEM_SIZE;
				}

			}

		}

		private function btnBuy_clickHandler( event : MouseEvent ) : void {
//			var dialogData : DialogWindowVO = new DialogWindowVO();
			shopBuyDialog.setData( _selectedItem.data );
			shopBuyDialog.visible = true;

//			dialogData.content = shopBuy;
//			var dEvent : DialogEvent = new DialogEvent( dialogData );
//			dispatchEvent( dEvent );
//			Model.instance.buyShopItem( _selectedItem.data );
		}

		override protected function messageHandler( msg : SimpleMessage ) : void {
			super.messageHandler( msg );

			switch ( msg.text ) {
				case IDMItemMsg.SELECT:
					if ( _selectedItem ) {
						_selectedItem.selected = false;
					}
					_selectedItem = msg.target as ShopItem;
					_selectedItem.selected = true;
					itemsBox.setChildIndex( _selectedItem, itemsBox.numChildren - 1 );
					btnBuy.enabled = ( _selectedItem != null );
					break;
				case SellBuyItemDialog.BUY_SELL_COMFIRM:
					Model.instance.buyShopItem( _selectedItem.data );
//					dispatchMessage( IDMMainMessages.MSG_SHOP_EXIT );
					break;

				case IDMItemMsg.SHOW_HINT:
					var item : ShopItem = msg.target as ShopItem;
					var pos : Point = new Point( mouseX, mouseY );
					itemHint.show( item.data, pos );

					break;
				case IDMItemMsg.HIDE_HINT:
					itemHint.hide();
					break;
			}
		}

	}
}