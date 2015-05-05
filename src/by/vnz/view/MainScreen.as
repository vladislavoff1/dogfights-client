package by.vnz.view {
import by.vnz.framework.audio.SoundsManager;
import by.vnz.framework.view.MainView;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.view.friends.FriendsList;
import by.vnz.view.user.UserPanel;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.TextField;

public class MainScreen extends BaseElement {
    public var BG:ImageProxy;
    public var btnHome:SimpleButtonProxy;
    public var btnArena:SimpleButtonProxy;
    public var btnShop:SimpleButtonProxy;
    public var btnTrainingCamp:SimpleButtonProxy;
    public var btnHunting:SimpleButtonProxy;
    public var copyRight:Sprite;
    public var btnSound:SimpleButtonProxy;
    public var txtVersion:TextField;

    public var userPanel:UserPanel;
    public var friends:FriendsList;

    public function MainScreen() {
        super();
    }

    override protected function initUI():void {
        createUIChild(ImageProxy, <ui name="mainScreenBG" resource="mainScreenBG" x="0" y="0" />);

        createUIChild(TextField, <ui name="txtVersion" y="-4" width="150" height="22" font="Calibri" size="10" color="0xFFFFFF" align="right" />);
        txtVersion.x = MainView.BOUNDS_WIDTH - txtVersion.width;
        txtVersion.text = MainView.CURRENT_VERSION;

        createUIChild(SimpleButtonProxy, <ui name="btnTrainingCamp" resource="btn_training_camp" x="4" y="110" />);
        createUIChild(SimpleButtonProxy, <ui name="btnHome" resource="budka_btn" x="66" y="244" />);
        createUIChild(SimpleButtonProxy, <ui name="btnArena" resource="ring_btn" x="193" y="138" />);
        createUIChild(SimpleButtonProxy, <ui name="btnShop" resource="zoo_btn" x="290" y="301" />);
        createUIChild(SimpleButtonProxy, <ui name="btnHunting" resource="btn_hunting" x="447" y="209" />);

        createUIChild(SimpleButtonProxy, <ui name="btnSound" resource="sound_on" x="6" y="12" />);

        createUIChild(UserPanel, <ui name="userPanel" x="410" y="6" />);

        createUIChild(FriendsList, <ui name="friends"  x="6" y="460" />);

        btnHome.addEventListener(MouseEvent.CLICK, btns_clickHandler);
        btnArena.addEventListener(MouseEvent.CLICK, btns_clickHandler);
        btnShop.addEventListener(MouseEvent.CLICK, btns_clickHandler);
        btnHunting.addEventListener(MouseEvent.CLICK, btns_clickHandler);
        btnTrainingCamp.addEventListener(MouseEvent.CLICK, btns_clickHandler);
        btnSound.addEventListener(MouseEvent.CLICK, btnSound_clickHandler);
    }

    private function btns_clickHandler(event:MouseEvent):void {
        var btn:SimpleButtonProxy = (event.target as DisplayObject).parent as SimpleButtonProxy;
        switch (btn) {
            case btnShop:
                dispatchMessage(IDMMainMessages.MSG_SHOP_ENTER);
                break;
            case btnArena:
                dispatchMessage(IDMMainMessages.MSG_ARENA_ENTER);
                break;
            case btnHome:
                dispatchMessage(IDMMainMessages.MSG_HOME_ENTER);
                break;
            case btnTrainingCamp:
                dispatchMessage(IDMMainMessages.MSG_TRAINING_ENTER);
                break;
            case btnHunting:
                dispatchMessage(IDMMainMessages.MSG_HUNTING_ENTER);
                break;

        }
    }

    private function btnSound_clickHandler(event:MouseEvent):void {
        if (SoundsManager.volume == 0) {
            btnSound.resource = "sound_on";
            SoundsManager.volume = 1;
        } else {
            btnSound.resource = "sound_off";
            SoundsManager.volume = 0;
        }
    }

    private function copyRightClickHandler(event:MouseEvent):void {
        navigateToURL(new URLRequest("http://vkontakte.ru/club13302714"), "_self");
    }

}
}