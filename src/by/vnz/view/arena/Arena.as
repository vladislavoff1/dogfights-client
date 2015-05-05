package by.vnz.view.arena {
import by.vnz.VO.EnemyVO;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.core.ExtendedSprite;
import by.vnz.idmaps.IDMItemMsg;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.model.Model;

import flash.events.MouseEvent;

public class Arena extends BaseElement {
    private var _selectedItem:ArenaItem;
    public var btnClose:SimpleButtonProxy;
    public var btnAttack:SimpleButtonProxy;
    public var btnRefresh:SimpleButtonProxy;
    public var itemsBox:ExtendedSprite;

    public function Arena() {
        super();
    }

    override protected function initUI():void {
        createUIChild(ImageProxy, <ui name="BG" resource="arena_bg" x="0" y="0" />);
        createUIChild(SimpleButtonProxy, <ui name="btnClose" resource="btn_close" x="567" y="6" />);
        btnClose.addEventListener(MouseEvent.CLICK, btnClose_clickHandler);
        createUIChild(SimpleButtonProxy, <ui name="btnAttack" resource="btn_attack" x="180" y="401" />);
        btnAttack.addEventListener(MouseEvent.CLICK, btnAttack_clickHandler);
        createUIChild(SimpleButtonProxy, <ui name="btnRefresh" resource="btn_refresh" x="305" y="401"/>);
        btnRefresh.addEventListener(MouseEvent.CLICK, btnRefresh_clickHandler);

        createUIChild(ExtendedSprite, <ui name="itemsBox" x="32" y="51" />);

        btnAttack.enabled = false;
    }

    public function init(enemiesList:Array):void {
        itemsBox.removeChildren11();
        var posX:uint = 0;
        var posY:uint = 0;
        for each (var itemVO:EnemyVO in enemiesList) {
            var item:ArenaItem = createUIChild(ArenaItem, <ui name={"a" + posX + "_" + posY} x={posX} y={posY} />, itemsBox);
            listenElement(item);
            item.data = itemVO;
            posX += ArenaItem.ITEM_WIDTH;
            if (posX == ( 2 * ArenaItem.ITEM_WIDTH )) {
                posX = 0;
                posY += ArenaItem.ITEM_HEIGHT;
            }
        }
        btnAttack.enabled = true;
        btnRefresh.enabled = true;
    }

    private function btnAttack_clickHandler(event:MouseEvent):void {
        if (!_selectedItem) {
            return;
        }
        Model.instance.battleFight(_selectedItem.data);
        btnAttack.enabled = false;
        btnRefresh.enabled = false;
    }

    private function btnRefresh_clickHandler(event:MouseEvent):void {
        Model.instance.battleGetEnemies();
        btnAttack.enabled = false;
        btnRefresh.enabled = false;
    }

    private function btnClose_clickHandler(event:MouseEvent):void {
        dispatchMessage(IDMMainMessages.MSG_ARENA_EXIT);
    }

    override protected function messageHandler(msg:SimpleMessage):void {
        super.messageHandler(msg);

        switch (msg.text) {
            case IDMItemMsg.SELECT:
                if (_selectedItem) {
                    _selectedItem.selected = false;
                }
                _selectedItem = msg.target as ArenaItem;
                _selectedItem.selected = true;
                itemsBox.setChildIndex(_selectedItem, itemsBox.numChildren - 1);
                btnAttack.enabled = ( _selectedItem != null );
                break;
        }
    }
}
}