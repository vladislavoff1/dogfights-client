package by.vnz.view.battle {
import by.vnz.VO.BattleWinVO;
import by.vnz.VO.vkontakte.AdsVkontakteVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.GUIElement;
import by.vnz.framework.view.elements.DialogWindow;
import by.vnz.idmaps.IDMMainMessages;

import by.vnz.view.staff.AdsBox;

import flash.events.MouseEvent;
import flash.text.TextField;

public class BattleResultDialog extends GUIElement {
    public var txtMessage:TextField;
    public var btnCity:SimpleButtonProxy;
    public var btnArena:SimpleButtonProxy;
    public var txtMoney:TextField;
    public var txtExp:TextField;
    public var ads:AdsBox;

    public function BattleResultDialog() {
        super();
    }

    override protected function preinitUI():void {
        super.preinitUI();

        //			buttonMode = true;

        createUIChild(ImageProxy, <ui name="BG" resource="win_popup" x="0" y="0" />);
        createUIChild(TextField, <ui name="txtMessage" x="5" y="17" width="270" height="80" font="Calibri" size="18" color="0xFFFFFF" bold="true" align="center" multiline="true" />);
        createUIChild(TextField, <ui name="txtMoney" x="172" y="61" width="50" height="26" text="10" font="Calibri" size="17" color="0xFEC94E" bold="true" />);
        createUIChild(TextField, <ui name="txtExp" x="172" y="86" width="50" height="26" text="0" font="Calibri" size="17" color="0xECAEDA" bold="true" />);

        createUIChild(SimpleButtonProxy, <ui name="btnCity"  resource="btn_city" x="26" y="140" />);
        createUIChild(SimpleButtonProxy, <ui name="btnArena" resource="btn_arena" x="142" y="140" />);

        btnCity.addEventListener(MouseEvent.CLICK, btnCity_clickHandler);
        btnArena.addEventListener(MouseEvent.CLICK, btnArena_clickHandler);

    }

    private function btnCity_clickHandler(event:MouseEvent):void {
        dispatchMessage(IDMMainMessages.MSG_BATTLE_EXIT);
        ( parent as DialogWindow ).dispatchMessage(( parent as DialogWindow ).messageCancel );

        //			visible = false;
    }

    private function btnArena_clickHandler(event:MouseEvent):void {
        dispatchMessage(IDMMainMessages.MSG_ARENA_ENTER);
        ( parent as DialogWindow ).dispatchMessage(( parent as DialogWindow ).messageCancel );
        //			visible = false;
    }

    public function update(data:BattleWinVO):void {
        txtMessage.text = data.resmsg;
        txtMoney.text = data.money.toString();
        txtExp.text = data.exp.toString();
        //			visible = true;
    }

    public function setAds(data:AdsVkontakteVO):void {
        if (!data){
            return;
        }
        createUIChild(AdsBox, <ui name="ads"  y="190" />);
        ads.x = (this.width - ads.width) / 2;
        ads.data = data
    }


}
}