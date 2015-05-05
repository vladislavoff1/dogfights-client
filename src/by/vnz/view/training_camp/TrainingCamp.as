package by.vnz.view.training_camp {
import by.vnz.VO.TrainingItemVO;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.core.ExtendedSprite;

import by.vnz.idmaps.IDMItemMsg;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.model.Model;
import by.vnz.view.items.ItemHint;

import by.vnz.view.shop.SellBuyItemDialog;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;

public class TrainingCamp extends BaseElement{
    static public const ITEMS_ON_PAGE : uint = 3;
    static public const ITEMS_IN_ROW : uint = 3;

    /** from 0 to N*/
    private var _currentPage : uint = 0;
    /** from 0 to N*/
    private var _allPages : uint = 0;
    private var _selectedItem : TrainingItem;

    //UI block
    public var BG : ImageProxy;
    public var btnClose : SimpleButtonProxy;
    public var btnBuy : SimpleButtonProxy;
    public var itemsBox : ExtendedSprite;

    public var btnPrev : SimpleButtonProxy;
    public var txtPaging : TextField;
    public var btnNext : SimpleButtonProxy;

    public var shopBuyDialog : SellBuyItemDialog;
    public var itemHint : ItemHint;


    public function TrainingCamp() {
    }
    
    override protected function initUI() : void {
        createUIChild( ImageProxy, <ui name="BG" resource="training_bg" x="0" y="0" /> );
        createUIChild( SimpleButtonProxy, <ui name="btnClose" resource="btn_close" x="567" y="4" /> );

        createUIChild( ExtendedSprite, <ui name="itemsBox" x="12" y="65" /> );

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

        btnBuy.addEventListener( MouseEvent.CLICK, btnBuy_clickHandler );
        btnBuy.enabled = false;

    }

    public function init() : void {
        showItems(0);
    }

    private function btnClose_clickHandler( event : MouseEvent ) : void {
        dispatchMessage( IDMMainMessages.MSG_TRAINING_EXIT );
    }
    private function btnPrev_clickHandler( event : MouseEvent ) : void {
        showItems(( _currentPage - 1 ));
    }

    private function btnNext_clickHandler( event : MouseEvent ) : void {
        showItems(( _currentPage + 1 ));
    }

    private function showItems( page : uint ) : void {
        var list : Array = Model.instance.trainingManager.getItems();
        _allPages = Math.ceil( list.length / ITEMS_ON_PAGE ) - 1;
        _currentPage = page;
        if ( _currentPage > _allPages ) {
            _currentPage = _allPages;
        }
        btnNext.enabled = ( _currentPage != _allPages );
        btnNext.enabled ? btnNext.alpha = 1 : btnNext.alpha = 0.7;
        if ( _currentPage < 0 ) {
            _currentPage = 0;
        }
        btnPrev.enabled = ( _currentPage != 0 );
        btnPrev.enabled ? btnPrev.alpha = 1 : btnPrev.alpha = 0.7;

        txtPaging.text = ( _currentPage + 1 ) + " of " + ( _allPages + 1 );

        var from : uint = _currentPage * ITEMS_ON_PAGE;
        var to : uint = ( _currentPage + 1 ) * ITEMS_ON_PAGE;
        if ( from < to ) {
            list = list.slice( from, to );
        }

        itemsBox.removeChildren11();

        var posX : uint = 0;
        var posY : uint = 0;
        for each ( var itemVO : TrainingItemVO in list ) {
            var item : TrainingItem = createUIChild( TrainingItem, <ui x={posX} y={posY} />, itemsBox );
            listenElement( item );
            item.data = itemVO;
            posX += TrainingItem.ITEM_SIZE;
            if ( posX == ( ITEMS_IN_ROW * TrainingItem.ITEM_SIZE )) {
                posX = 0;
//                posY += TrainingItem.ITEM_SIZE;
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
                _selectedItem = msg.target as TrainingItem;
                _selectedItem.selected = true;
                itemsBox.setChildIndex( _selectedItem, itemsBox.numChildren - 1 );
                btnBuy.enabled = ( _selectedItem != null );
                break;
            case SellBuyItemDialog.BUY_SELL_COMFIRM:
                Model.instance.trainingCampUse( _selectedItem.data );
//					dispatchMessage( IDMMainMessages.MSG_SHOP_EXIT );
                break;

            case IDMItemMsg.SHOW_HINT:
                var item : TrainingItem = msg.target as TrainingItem;
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