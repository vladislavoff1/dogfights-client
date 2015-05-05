package by.vnz.view.shop {
import by.vnz.VO.BaseItemVO;
import by.vnz.VO.ItemVO;
import by.vnz.VO.TrainingItemVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.GUIElement;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class SellBuyItemDialog extends GUIElement {
    static public const BUY_SELL_COMFIRM:String = "buy_sell_comfirm";
    static public const BUY_SELL_CANCEL:String = "buy_sell_cancel";

    public var coinIcon:ImageProxy;
    public var itemImage:ImageProxy;
    public var txtDescription:TextField;
    public var txtPrice:TextField;
    public var txtPriceValue:TextField;
    public var txtTitle:TextField;
    public var btnConfirm:SimpleButtonProxy;
    public var btnCancel:SimpleButtonProxy;

    public function SellBuyItemDialog() {
        super();
        //			this.width = 250;
        //			this.height = 160;
    }

    override protected function preinitUI():void {
        super.preinitUI();

        //			buttonMode = true;

        createUIChild(ImageProxy, <ui name="BG" resource="dialogs_bg" x="-10" y="-10" />);

        createUIChild(ImageProxy, <ui name="itemImage" x="0" y="0" />);
        itemImage.addEventListener(Event.COMPLETE, imageCompleteHandler, false, 0, true);
        createUIChild(TextField, <ui name="txtTitle" x="94" y="0" width="150" height="22" text="name" font="Calibri" size="14" color="0x000000" bold="true" align="center" />);
        createUIChild(TextField, <ui name="txtPrice" x="105" y="46" width="50" height="22" text="Price:" font="Calibri" size="14" color="0xFFDB47" bold="true" align="left" />);
        createUIChild(ImageProxy, <ui name="coinIcon" resource="coin_icon" x="146" y="46"/>);
        createUIChild(TextField, <ui name="txtPriceValue" x="165" y="46" width="250" height="22" text="55" font="Calibri" size="14" color="0xFFDB47" bold="true" align="left" />);
        createUIChild(TextField, <ui name="txtDescription" x="0" y="77" width="250" height="85" text="description" font="Calibri" size="13" color="0xFFFFFF" align="center" multiline="true" />);

        createUIChild(SimpleButtonProxy, <ui name="btnConfirm"  x="20" y="150" />);
        createUIChild(SimpleButtonProxy, <ui name="btnCancel" resource="btn_cancel" x="142" y="150" />);

        btnConfirm.addEventListener(MouseEvent.CLICK, btnConfirm_clickHandler);
        btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_clickHandler);

    }

    public function setData(data:BaseItemVO, buy:Boolean = true):void {
        txtTitle.text = data.name;
        txtDescription.text = data.desc;
        txtPriceValue.text = data.price.toString();
        if (data is ItemVO) {
            itemImage.resource = "item_shop_type" + (data as ItemVO).type + "_" + data.itemID;
        } else if (data is TrainingItemVO) {
            itemImage.resource = "training_item_" + data.itemID;
        }

        if (buy) {
            btnConfirm.resource = "btn_buy";
        } else {
            btnConfirm.resource = "btn_sell_item";
        }

        //			if ( txtDescription.textHeight > txtDescription.height ) {
        //				txtDescription.height = txtDescription.textHeight + 7;
        //				dispatchEvent( new Event( Event.RESIZE ));
        //			}

    }

    private function btnConfirm_clickHandler(event:MouseEvent):void {
        dispatchMessage(BUY_SELL_COMFIRM);
        visible = false;
    }

    private function btnCancel_clickHandler(event:MouseEvent):void {
        dispatchMessage(BUY_SELL_CANCEL);
        visible = false;
    }

    private function imageCompleteHandler(event:Event):void {
        itemImage.removeEventListener(Event.COMPLETE, imageCompleteHandler);
        var maxItemSize:uint = 56;
        if (itemImage.width > maxItemSize || itemImage.height > maxItemSize) {
            var scale:Number = maxItemSize / Math.max(itemImage.width, itemImage.height);
            itemImage.scaleX = itemImage.scaleY = scale;
        }
        itemImage.x = (maxItemSize - itemImage.width ) / 2;
        itemImage.y = ( maxItemSize - itemImage.height ) / 2;
    }

}
}