package by.vnz.view.friends {
import by.vnz.VO.DogVO;
import by.vnz.VO.FriendVO;
import by.vnz.VO.FriendVO;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.core.ExtendedSprite;
import by.vnz.model.Model;
import by.vnz.view.user.DogInfoPanel;

import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.navigateToURL;

public class FriendsList extends BaseElement {
    public var BG:ImageProxy;
    public var itemsBox:ExtendedSprite;
    public var dogInfo:DogInfoPanel;
    public var btnPrev:SimpleButtonProxy;
    public var btnNext:SimpleButtonProxy;
    public var btnInvite:SimpleButtonProxy;

    public function FriendsList() {
    }

    override protected function preinitUI():void {
        super.preinitUI();

        createUIChild(ImageProxy, <ui name="BG" resource="friends_list_bg" x="0" y="0"/>);
		createUIChild(ExtendedSprite, <ui name="itemsBox" x="6" y="40" />);
		var resourceID : String = "invite_friends_mailru";
		if (!BuildConfig.onMailRu) {
            createUIChild(SimpleButtonProxy, <ui name="btnInvite" resource="btn_invite" x="274" y="2" />)
			btnInvite.addEventListener(MouseEvent.CLICK, btnInvite_clickHandler, false, 0, true);
			resourceID = "invite_friends_vk";
		}
		createUIChild(ImageProxy, <ui name="invateText" resource={resourceID} x="184" y="7"/>);
		
		createUIChild(SimpleButtonProxy, <ui name="btnPrev" resource="btn_prev" x="505" y="8" />)
        createUIChild(SimpleButtonProxy, <ui name="btnNext" resource="btn_next" x="538" y="8" />)

        itemsBox.scrollRect = new Rectangle(0, 0, 595, 90);
        btnNext.addEventListener(MouseEvent.CLICK, btnNext_clickHandler, false, 0, true);
        btnPrev.addEventListener(MouseEvent.CLICK, btnPrev_clickHandler, false, 0, true);

    }

    private function btnNext_clickHandler(event:MouseEvent):void {
        scrollList(1);
    }

    private function btnPrev_clickHandler(event:MouseEvent):void {
        scrollList(-1);
    }

    public function scrollList(direction:int):void {
        var sRect:Rectangle = itemsBox.scrollRect;
        var newX:int = sRect.x + direction * 85;
        var itemsLength:uint = 85 * itemsBox.numChildren;
        if (((sRect.width + newX) >= itemsLength) || (newX < 0)) {
            return;
        }
        sRect.x = newX;
        itemsBox.scrollRect = sRect;

    }


    public function setFriendsList(friends:Array):void {
        itemsBox.removeChildren11();
        var posX:uint = 0;
        for each(var friendVO:FriendVO  in friends) {
            var item:FriendItem = createUIChild(FriendItem, <ui name={"item" + posX.toString()} x={posX} />, itemsBox);
            item.data = friendVO;
            posX += 85;
        }
    }

    public function addUserProfiles(list:XMLList):void {
        for each (var item:XML in list) {
            var userID:String = String(item.uid.*);
            var userData:FriendVO = getUserByID(userID);
            if (userData) {
                userData.update(item);
            }
        }
    }

    public function getUserByID(id:String):FriendVO {
        for (var i:uint = 0; i < itemsBox.numChildren; i++) {
            var item:FriendItem = itemsBox.getChildAt(i) as FriendItem;
            if (item && (item.data as FriendVO).user == id) {
                return item.data as FriendVO;
            }
        }
        return null;
    }

    override protected function messageHandler(msg:SimpleMessage):void {
        super.messageHandler(msg);

        switch (msg.text) {
            case FriendItem.SHOW_INFO:
                dogInfo = createUIChild(DogInfoPanel, <ui name="dogInfo" x="70" y="-200"  />);
                dogInfo.data = new DogVO();
                dogInfo.show();
                var userData:FriendVO = (msg.target as FriendItem).data as FriendVO;
                Model.instance.getDogInfo(userData.user);
                break;
            case FriendItem.HIDE_INFO:
                dogInfo.hide();
                removeChildSafely(dogInfo);
                dogInfo = null;
                break;
        }
    }

    public function setDogInfo(dog:XML):void {
        if (dogInfo) {
            dogInfo.data.update(dog);
        }
    }


    private function btnInvite_clickHandler(event:MouseEvent):void {
        Model.instance.inviteFriends();
    }
}
}