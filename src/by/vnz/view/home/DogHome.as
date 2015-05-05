package by.vnz.view.home {
import by.vnz.VO.DogVO;
import by.vnz.VO.HomeItemVO;
import by.vnz.framework.dragdrop.DragManager;
import by.vnz.framework.events.DragEvent;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.core.ExtendedSprite;
import by.vnz.idmaps.IDMItemMsg;
import by.vnz.idmaps.IDMItemTypes;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.model.Model;
import by.vnz.view.items.ItemHint;
import by.vnz.view.items.ItemObject;
import by.vnz.view.items.ItemSlot;
import by.vnz.view.shop.SellBuyItemDialog;

import flash.events.MouseEvent;
import flash.geom.Point;

import logger.Logger;

public class DogHome extends BaseElement {
    private var dragObject:ItemObject;
    private var dragSlot:ItemSlot;
    private var dropSlot:ItemSlot;
    private var _selectedSlot:ItemSlot;

    public var btnClose:SimpleButtonProxy;
    public var activeSlotsBox:ExtendedSprite;
    public var inactiveSlotsBox:ExtendedSprite;
    public var btnChangeBreed:ExtendedSprite;
    public var dogInfo:DogInfoHomePanel;

    public var sellDialog:SellBuyItemDialog;
    public var itemHint:ItemHint;

    public function DogHome() {
        super();
    }

    override protected function initUI():void {
        super.initUI();
        createUIChild(ImageProxy, <ui name="BG" resource="dog_home" x="0" y="0" />);
        createUIChild(SimpleButtonProxy, <ui name="btnClose" resource="btn_close" x="567" y="4" />);
        btnClose.addEventListener(MouseEvent.CLICK, btnClose_clickHandler);
        createUIChild(SimpleButtonProxy, <ui name="btnChangeBreed" resource="btn_change_dog"  x="355" y="266" />);
        btnChangeBreed.addEventListener(MouseEvent.CLICK, btnChangeBreed_clickHandler);

        createUIChild(ExtendedSprite, <ui name="activeSlotsBox" x="10" y="50" />);
        createUIChild(ImageProxy, <ui name="activeSlotsTitles" resource="home_active_slots_titles" x="30" y="90" />);

        createUIChild(ExtendedSprite, <ui name="inactiveSlotsBox" x="305" y="50" />);
        createUIChild(DogInfoHomePanel, <ui name="dogInfo" x="292" y="265" />);

        createUIChild(SellBuyItemDialog, <ui name="sellDialog" x="200" y="200" visible="false" />);
        listenElement(sellDialog);

        createUIChild(ItemHint, <ui name="itemHint" x="200" y="200" visible="false" />);
        listenElement(itemHint);

        //add slots
        var i:uint = 0;
        var posX:uint = 0;
        var posY:uint = 0;
        var slot:ItemSlot;
        var index:uint;
        for (i = 0; i < 6; i++) {
            index = ( i + 1 );
            slot = createUIChild(ItemSlot, <ui name={"slot" + index } x={posX} y={posY} index={index} active="true" />, activeSlotsBox);
            listenElement(slot);
            slot.addEventListener(MouseEvent.MOUSE_DOWN, slot_mouseDownHandler, false, 0, true);
            //				slot.data = itemVO;
            posX += ItemSlot.SLOT_SIZE;
            if (posX == ( 3 * ItemSlot.SLOT_SIZE )) {
                posX = 0;
                posY = 290;
            }

        }
        posX = 0;
        posY = 0;
        for (i = 0; i < 6; i++) {
            index = ( i + 1 );
            slot = createUIChild(ItemSlot, <ui name={"slot" + index } x={posX} y={posY} index={index} active="false" />, inactiveSlotsBox);
            listenElement(slot);
            slot.addEventListener(MouseEvent.MOUSE_DOWN, slot_mouseDownHandler, false, 0, true);

            posX += ItemSlot.SLOT_SIZE;
            if (posX == ( 3 * ItemSlot.SLOT_SIZE )) {
                posX = 0;
                posY += ItemSlot.SLOT_SIZE;
            }

        }

    }

    private function btnClose_clickHandler(event:MouseEvent):void {
        dispatchMessage(IDMMainMessages.MSG_HOME_EXIT);
    }

    public function init(activeItems:Array, inactiveItems:Array, dogData:DogVO):void {
        clear();

        var itemVO:HomeItemVO;
        var slot:ItemSlot;
        var item:HomeItem;
        for each (itemVO in activeItems) {
            var slotIndex:uint = itemVO.slot; // + 3;
            slot = activeSlotsBox.getChildByName("slot" + slotIndex) as ItemSlot;
            item = new HomeItem();
            item.data = itemVO;
            slot.item = item;
        }

        for (var i:uint = 0; i < inactiveItems.length; i++) { //inactiveItems.length
            if (i >= 6) {
                break;
            }
            itemVO = inactiveItems[i] as HomeItemVO;
            slot = inactiveSlotsBox.getChildByName("slot" + ( i + 1 )) as ItemSlot;
            item = new HomeItem();
            item.data = itemVO;
            slot.item = item;
        }

        dogInfo.data = dogData;
    }

    private function slot_mouseDownHandler(event:MouseEvent):void {
        var slot:ItemSlot = event.currentTarget as ItemSlot;
        debug(slot, "slot");
        slot.addEventListener(MouseEvent.MOUSE_MOVE, slot_waitDragHandler, false, 0, true);
        slot.addEventListener(MouseEvent.CLICK, slot_waitDragHandler, false, 0, true);

    }

    private function slot_waitDragHandler(event:MouseEvent):void {
        dragSlot = event.currentTarget as ItemSlot;
        dragSlot.removeEventListener(MouseEvent.MOUSE_MOVE, slot_waitDragHandler);
        dragSlot.removeEventListener(MouseEvent.CLICK, slot_waitDragHandler);
        if (event.type == MouseEvent.MOUSE_MOVE) {
            DragManager.doDrag(dragSlot, dragSlot.item, dragSlot.item.dragCopy);
            stage.addEventListener(DragEvent.DROP_REQUEST, itemDropHandler);
            var slots:Array = [];
            var i:uint
            var slot:ItemSlot;
            for (i = 0; i < activeSlotsBox.numChildren; i++) {
                slots.push(activeSlotsBox.getChildAt(i));
            }
            //add only free slots
            for (i = 0; i < inactiveSlotsBox.numChildren; i++) {
                slot = inactiveSlotsBox.getChildAt(i) as ItemSlot;
                if (!slot.item) {
                    slots.push(slot);
                }
            }

            DragManager.acceptDragDrop(slots);
        } else {
            DragManager.cancelDrag();
            dragSlot = null;
        }

    }

    private function itemDropHandler(event:DragEvent):void {
        if (!dragSlot || !( event.target is ItemSlot ) || !( event.dragData is ItemObject )) {
            return;
        }

        dragObject = event.dragData as ItemObject;
        dropSlot = event.target as ItemSlot;

        var index:uint = 0;
        if (dropSlot.active) {

            index = dropSlot.index;
        }
        var from:uint = 0;
        if (dragObject.data.type == IDMItemTypes.TYPE_DRUG && dragSlot.active) {
            from = dragSlot.index;
        }
        finishMoveItem(index, from);
    }

    private function finishMoveItem(slot:uint, from:uint):void {
        stage.removeEventListener(DragEvent.DROP_REQUEST, itemDropHandler);
        //clear drag
        DragManager.cancelDrag();
        dragSlot = null;
        //init request
        debug("DOGHOME moveItem", dragSlot, Logger.DC_5);
        Model.instance.dogHomeMoveItem(dragObject.data.itemID, 1, slot, from);

    }

    private function clear():void {
        var slot:ItemSlot;
        var i:uint;
        for (i = 0; i < activeSlotsBox.numChildren; i++) {
            slot = activeSlotsBox.getChildAt(i) as ItemSlot;
            slot.clear();
        }
        for (i = 0; i < inactiveSlotsBox.numChildren; i++) {
            slot = inactiveSlotsBox.getChildAt(i) as ItemSlot;
            slot.clear();
        }

    }

    override protected function messageHandler(msg:SimpleMessage):void {
        super.messageHandler(msg);

        switch (msg.text) {
            case SellBuyItemDialog.BUY_SELL_COMFIRM:
                DragManager.cancelDrag();

                var index:uint = 0;
                if (_selectedSlot.active) {
                    index = _selectedSlot.index;
                }
                Model.instance.dogHomeSellItem(_selectedSlot.item.data.itemID, 1, index);
                slotsEnabled = true;
                break;
            case SellBuyItemDialog.BUY_SELL_CANCEL:
                slotsEnabled = true;
                break;
            case IDMItemMsg.SELECT:
                DragManager.cancelDrag();
                //					debug( "item select", msg.target );
                _selectedSlot = msg.target as ItemSlot;
                if (_selectedSlot && _selectedSlot.item) {
                    sellDialog.setData(_selectedSlot.item.data, false);
                    sellDialog.visible = true;
                    slotsEnabled = false;
                }
                break;
            case IDMItemMsg.SHOW_HINT:
                var item:ItemObject = msg.target as ItemObject;
                var pos:Point = new Point(mouseX, mouseY);
                itemHint.show(item.data, pos);

                break;
            case IDMItemMsg.HIDE_HINT:
                itemHint.hide();
                break;
        }
    }

    private function set slotsEnabled(value:Boolean):void {
        activeSlotsBox.mouseEnabled = activeSlotsBox.mouseChildren = value;
        inactiveSlotsBox.mouseEnabled = inactiveSlotsBox.mouseChildren = value;

    }

    override public function destroy():void {
        super.destroy();
        dogInfo.destroy();
    }

    private function btnChangeBreed_clickHandler(event:MouseEvent):void {
       Model.instance.chooseDog();
    }
}
}