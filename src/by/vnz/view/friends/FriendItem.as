package by.vnz.view.friends {
import by.vnz.VO.FriendVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.core.GUIElement;
import by.vnz.view.user.LevelIcon;
import by.vnz.view.user.UserAvatar;

import flash.events.MouseEvent;

public class FriendItem extends BaseElement {
    static public const SHOW_INFO:String = "show_info";
    static public const HIDE_INFO:String = "hide_info";
    public var BG:ImageProxy;
    public var levelIcon:LevelIcon;
    public var avatar:UserAvatar;

    public function FriendItem() {
    }

    override protected function initUI():void {
        super.initUI();

        createUIChild(ImageProxy, <ui name="BG" resource="reiting_avatar" x="0" y="0" />);
        createUIChild(UserAvatar, <ui name="avatar" x="11" y="11" />);

        createUIChild(LevelIcon, <ui name="levelIcon" x="55" y="55" scaleX="1" scaleY="1" />);


        avatar.addEventListener(MouseEvent.ROLL_OVER, avatarRollOverHandler);
        avatar.addEventListener(MouseEvent.ROLL_OUT, avatarRollOutHandler);
        avatar.addEventListener(MouseEvent.MOUSE_DOWN, avatarRollOutHandler);
    }


    override protected function update():void {
        super.update();

        var vo:FriendVO = _data as FriendVO;
        levelIcon.data = vo.level;
        avatar.loadImage(vo.photo);
    }

    private function avatarRollOverHandler(event:MouseEvent):void {
        dispatchMessage(SHOW_INFO);
    }

    private function avatarRollOutHandler(event:MouseEvent):void {
        dispatchMessage(HIDE_INFO);
    }
}
}