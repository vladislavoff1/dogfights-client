package by.vnz.view.items {
import by.vnz.VO.BaseItemVO;
import by.vnz.VO.ItemVO;
import by.vnz.VO.ShopItemVO;
import by.vnz.VO.TrainingItemVO;
import by.vnz.framework.VO.BaseVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.core.GUIElement;
import by.vnz.idmaps.IDMItemTypes;

import by.vnz.view.items.ItemObject;

import flash.events.Event;
import flash.geom.Point;
import flash.text.TextField;

public class ItemHint extends GUIElement {
    public var coinIcon:ImageProxy;
    public var itemImage:ImageProxy;
    public var txtDescription:TextField;
    public var txtPrice:TextField;
    public var txtPriceValue:TextField;
    public var txtTitle:TextField;
    public var txtProperties:TextField;
    public var txtPropertiesDesc:TextField;
    public var txtRequirements:TextField;

    public function ItemHint() {
        super();

        mouseEnabled = mouseChildren = false;
    }

    override protected function preinitUI():void {
        super.preinitUI();

        buttonMode = true;

        createUIChild(ImageProxy, <ui name="BG" resource="shop_item_hint_bg" x="-10" y="-10" />);

        createUIChild(ImageProxy, <ui name="itemImage" x="0" y="0" />);
        itemImage.addEventListener(Event.COMPLETE, imageCompleteHandler, false, 0, true);
        createUIChild(TextField, <ui name="txtTitle" x="80" y="3" width="100" height="42" text="name" font="Calibri" size="14" color="0x000000" bold="true" align="center" multiline="true" />);
        createUIChild(TextField, <ui name="txtDescription" x="0" y="60" width="180" height="75" text="description" font="Calibri" size="11" color="0xFFFFFF" align="left" multiline="true" />);

        createUIChild(TextField, <ui name="txtProperties" x="0" y="125" width="180" height="75" text="properties" font="Calibri" size="11" color="0xFFDB47" align="left" bold="true" multiline="true" />);
        //			createUIChild( TextField, <ui name="txtPropertiesDesc" x="0" y="138" width="160" height="20" text="описание свойств" font="Calibri" size="11" color="0xFFDB47" align="left" bold="false" /> );

        createUIChild(TextField, <ui name="txtRequirements" x="0" y="185" width="175" height="34" text="requirements: properties" font="Calibri" size="11" color="0xFEBCCA" align="left" multiline="true" />);

        createUIChild(TextField, <ui name="txtPrice" x="2" y="205" width="40" height="22" text="Price:" font="Calibri" size="11" color="0xFFDB47" bold="false" align="left" />);
        createUIChild(ImageProxy, <ui name="coinIcon" resource="coin_icon" x="36" y="203" />);
        createUIChild(TextField, <ui name="txtPriceValue" x="56" y="204" width="80" height="22" text="55" font="Calibri" size="13" color="0xFFDB47" bold="true" align="left" />);

    }

    public function show(data:BaseItemVO, pos:Point):void {
        txtTitle.text = data.name;
        txtDescription.text = data.desc;
        txtPriceValue.text = data.price.toString();

        if (data is ItemVO) {
            var itemData:ItemVO = data as ItemVO;
            itemImage.resource = "item_shop_type" + itemData.type + "_" + itemData.itemID;
            switch (itemData.type) {
                case IDMItemTypes.TYPE_CLOW:
                    txtProperties.text = "Increases agility by ";
                    break;
                case IDMItemTypes.TYPE_FANG:
                    txtProperties.text = "Increases strength by ";
                    break;
                case IDMItemTypes.TYPE_ARMOR:
                    txtProperties.text = "Increases endurance by ";
                    break;
                case IDMItemTypes.TYPE_DRUG:
                    txtProperties.text = "Increases the chance of counterattack: ";
                    break;
            }
            txtProperties.appendText(itemData.rate.toString());
            txtRequirements.text = "Requirements: Level " + itemData.level;

        }

        if (( data is ShopItemVO ) && ( data as ShopItemVO ).duration > 0) {
            txtProperties.appendText("\nOperates fights: " + ( data as ShopItemVO ).duration);
        }

        if (data is TrainingItemVO) {
            var trainingVO:TrainingItemVO = data as TrainingItemVO;
            itemImage.resource = "training_item_" + data.itemID;
            txtProperties.text = "Increases: ";
            if (trainingVO.dex > 0) {
                txtProperties.text += "\nagility by " + trainingVO.dex;
            }
            if (trainingVO.str > 0) {
                txtProperties.text += "\nforce by " + trainingVO.str;
            }
            if (trainingVO.endr > 0) {
                txtProperties.text += "\nendurance by " + trainingVO.endr;
            }
            //            txtProperties.appendText("");
            txtRequirements.text = "Training time: " + trainingVO.time;
        }

        x = pos.x;
        y = pos.y;

        if (x + this.width > stage.stageWidth) {
            x -= this.width;
        }
        if (y + this.height > stage.stageHeight) {
            y -= (( y + this.height ) - stage.stageHeight - 10 );
        }

        visible = true;
    }

    public function hide():void {
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