package by.vnz.view.training_camp {
import by.vnz.VO.ShopItemVO;
import by.vnz.VO.TrainingItemVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.core.GUIElement;

import by.vnz.idmaps.IDMItemMsg;
import by.vnz.model.Model;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;

import vnz.utils.DesaturateImage;

public class TrainingItem extends GUIElement {
    static public const ITEM_SIZE:uint = 190;

    private var _data:TrainingItemVO;

    public var BG:ImageProxy;
    public var highlighter:ImageProxy;
    public var coinIcon:ImageProxy;
    public var txtPrice:TextField;
    public var itemImage:ImageProxy;

    private var _timer:Timer;


    public function TrainingItem() {
    }

    override protected function initUI() : void {
        super.initUI();

        buttonMode = true;

        createUIChild( ImageProxy, <ui name="BG" resource="training_item_slot_bg" /> );
        createUIChild( ImageProxy, <ui name="itemImage" x="1" y="1" /> );
        createUIChild( ImageProxy, <ui name="highlighter" resource="training_item_slot_highlight" visible="false" /> );
        createUIChild( ImageProxy, <ui name="coinIcon" resource="coin_icon" x="8" y="168"/> );
        createUIChild( TextField, <ui name="txtPrice" x="28" y="168" width="50" height="20" text="234" font="Calibri" size="13" color="0xFFD600" bold="true" /> );

        addEventListener( MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true );
        addEventListener( MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true );
        addEventListener( MouseEvent.MOUSE_DOWN, rollOutHandler, false, 0, true );

        _timer = new Timer( 500, 1 );
        _timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );

        update();
    }

    public function get data() : TrainingItemVO {
        var result : TrainingItemVO = _data;

        return result;
    }

    public function set data( value : TrainingItemVO ) : void {
        if ( !value ) {
            return;
        }
        _data = value;
        update();
    }

    public function get selected() : Boolean {
        var result : Boolean = highlighter.visible;

        return result;
    }

    public function set selected( value : Boolean ) : void {
        highlighter.visible = value;
    }

    protected function update() : void {
        if ( !isGUIReady || !_data ) {
            return;
        }
        txtPrice.text = _data.price.toString();
        itemImage.addEventListener( Event.COMPLETE, imageCompleteHandler, false, 0, true );
        itemImage.resource = "training_item_" + _data.itemID;

        if ( Model.userData.money < _data.price ) {
            DesaturateImage.apply( this );
            return;
        }

        addEventListener( MouseEvent.CLICK, clickHandler, false, 0, true );

    }

    private function clickHandler( event : MouseEvent ) : void {
        event.stopImmediatePropagation();

        dispatchMessage( IDMItemMsg.SELECT );
    }

    private function rollOverHandler( event : MouseEvent ) : void {
        _timer.reset();
        _timer.start();
    }

    private function rollOutHandler( event : MouseEvent ) : void {
        _timer.reset();
        dispatchMessage( IDMItemMsg.HIDE_HINT );

    }

    private function timerCompleteHandler( event : TimerEvent ) : void {
        dispatchMessage( IDMItemMsg.SHOW_HINT );
    }

    private function imageCompleteHandler( event : Event ) : void {
        itemImage.removeEventListener( Event.COMPLETE, imageCompleteHandler );
        itemImage.x = ( ITEM_SIZE - itemImage.width ) / 2;
        itemImage.y = ( ITEM_SIZE - 10 - itemImage.height ) / 2;
    }

    

}
}