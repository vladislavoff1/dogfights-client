package by.vnz.view.arena {
import by.vnz.VO.vkontakte.AdsVkontakteVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.core.GUIElement;
import by.vnz.framework.view.elements.DialogWindow;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.model.Model;

import by.vnz.view.staff.AdsBox;

import flash.events.MouseEvent;
import flash.text.TextField;

public class BuyFightDialog extends BaseElement {
    public var txtMessage:TextField;
    public var btnBuy:SimpleButtonProxy;
    public var btnCancel:SimpleButtonProxy;
    private var _waiting:String;
    public var ads:AdsBox;

    public function BuyFightDialog() {
        super();
    }

    override protected function preinitUI():void {
        super.preinitUI();

        createUIChild(TextField, <ui name="txtMessage" width="280" height="120" x="0" y="0" multiline="true" font="Calibri" size="18" color="0xffffff" bold="true" align="center" />);
        createUIChild(ImageProxy, <ui name="coinIcon" resource="coin_icon" x="253" y="92"/>);
        createUIChild(SimpleButtonProxy, <ui name="btnBuy" resource="btn_buy"  x="25" y="130" />);
        createUIChild(SimpleButtonProxy, <ui name="btnCancel" resource="btn_cancel" x="145" y="130" />);

        btnBuy.addEventListener(MouseEvent.CLICK, btnBuy_clickHandler);
        btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_clickHandler);
    }

    public function get waiting():String {
        return _waiting;
    }

    public function set waiting(value:String):void {
        _waiting = value;
        txtMessage.text = "Ваша собака устала в боях!\nДо следующего боя осталось " + _waiting + "!";
        txtMessage.appendText("\n\nДополнительный бой - 100");
    }

    private function btnBuy_clickHandler(event:MouseEvent):void {
        Model.instance.buyFight();
        ( parent as DialogWindow ).dispatchMessage(( parent as DialogWindow ).messageCancel);
    }

    private function btnCancel_clickHandler(event:MouseEvent):void {
        dispatchMessage(IDMMainMessages.MSG_BUY_FIGHT_EXIT);
        ( parent as DialogWindow ).dispatchMessage(( parent as DialogWindow ).messageCancel);
    }

    public function setAds(data:AdsVkontakteVO):void {
        if (!data){
            return;
        }
        createUIChild(AdsBox, <ui name="ads"  y="170" />);
        ads.x = (this.width - ads.width) / 2;
        ads.data = data;
        ads.updateTitle(false);
    }

}
}