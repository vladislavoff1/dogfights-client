package by.vnz.view.bank {
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.components.SimpleButtonProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.model.Model;

import by.vnz.view.staff.RadioButton;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;

import vnz.core.ZSprite;

public class VoiceExchange extends BaseElement {
	public var blocker:ZSprite;
	public var box:Sprite;
	public var btnConfirm:SimpleButtonProxy;
	public var btnCancel:SimpleButtonProxy;
	public var btnPrev:SimpleButtonProxy;
	public var btnNext:SimpleButtonProxy;
	public var txtValue:TextField;
	private var _voices:uint = 1000;

	public var rbSMS:RadioButton;
	public var rbOther:RadioButton;
	public var rbSMS1:RadioButton;
	public var rbSMS2:RadioButton;
	public var rbSMS3:RadioButton;
	public var smsPaymentInfo:ImageProxy;
	public var otherPaymentInfo:ImageProxy;
	private var smsPrice:uint = 1;

	public function VoiceExchange() {
		super();
	}

	override protected function initUI():void {
		super.initUI();

		createUIChild(ZSprite, <ui name="blocker"  />);
		blocker.graphicsDrawRect(stage.stageWidth, stage.stageHeight, 0x000000, 0.3);

		var resourceID:String = "voice_exchange_bg";
		
		var offsetY:int = 50;
		createUIChild(Sprite, <ui name="box" x={( blocker.width - 415 ) / 2 + 75} y={( blocker.height - 450 ) / 2 + offsetY} />, box);
		createUIChild(ImageProxy, <ui name="BG" resource={resourceID} x="0" y="0" />, box);

		createUIChild(SimpleButtonProxy, <ui name="btnPrev" resource="btn_prev" x="115" y="113" />, box);
		createUIChild(SimpleButtonProxy, <ui name="btnNext" resource="btn_next" x="190" y="113" />, box);
		createUIChild(TextField, <ui name="txtValue" x="146" y="113" width="41" height="24" text="1" font="Calibri" size="16" color="0" bold="true" type={TextFieldType.INPUT} border="true" background="true" restrict="0-9" maxChars="4" />, box);
		resourceID = BuildConfig.onMailRu ? "btn_buy" : "btn_change";
		createUIChild(SimpleButtonProxy, <ui name="btnConfirm" resource={resourceID} x="26" y="180" />, box);
		createUIChild(SimpleButtonProxy, <ui name="btnCancel" resource="btn_cancel" x="143" y="180" />, box);

		btnConfirm.addEventListener(MouseEvent.CLICK, btnConfirm_clickHandler);
		btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_clickHandler);
		btnPrev.addEventListener(MouseEvent.CLICK, btnPrev_clickHandler);
		btnNext.addEventListener(MouseEvent.CLICK, btnNext_clickHandler);

		
		voices = 1;
	}

	public function get voices():uint {
		var result:uint = _voices;

		return result;
	}

	public function set voices(value:uint):void {
		_voices = value;
		txtValue.text = _voices.toString();

	}

	private function btnPrev_clickHandler(event:MouseEvent):void {
		var value:uint = uint(txtValue.text);
		if (value > 1) {
			value--;
		}
		txtValue.text = value.toString();
	}

	private function btnNext_clickHandler(event:MouseEvent):void {
		var value:uint = uint(txtValue.text);
		value++;
		txtValue.text = value.toString();
	}

	private function btnConfirm_clickHandler(event:MouseEvent):void {
		dispatchMessage(IDMMainMessages.MSG_BANK_EXIT);
		var count:uint = uint(txtValue.text);
		Model.instance.addUserBalance(count, false);
		visible = false;
	}

	private function btnCancel_clickHandler(event:MouseEvent):void {
		dispatchMessage(IDMMainMessages.MSG_BANK_EXIT);
		visible = false;
	}

	override protected function messageHandler(msg:SimpleMessage):void {
		super.messageHandler(msg);
		if (msg.text == RadioButton.CHANGE_SELECT) {
			var rb:RadioButton = msg.target as RadioButton;
			if (rb.selected) {
				return;
			}
			switch (rb) {
				case rbSMS :
					rb.selected = true;
					rbOther.selected = false;
					break;
				case rbOther :
					rb.selected = true;
					rbSMS.selected = false;
					break;
				case rbSMS1 :
					rb.selected = true;
					rbSMS2.selected = false;
					rbSMS3.selected = false;
					smsPrice = 1;
					break;
				case rbSMS2 :
					rb.selected = true;
					rbSMS1.selected = false;
					rbSMS3.selected = false;
					smsPrice = 3;
					break;
				case rbSMS3 :
					rb.selected = true;
					rbSMS2.selected = false;
					rbSMS1.selected = false;
					smsPrice = 5;
					break;
			}


			rbSMS1.visible = rbSMS.selected;
			rbSMS2.visible = rbSMS.selected;
			rbSMS3.visible = rbSMS.selected;
			smsPaymentInfo.visible = rbSMS.selected;

			otherPaymentInfo.visible = !rbSMS.selected;
			btnNext.visible = !rbSMS.selected;
			btnPrev.visible = !rbSMS.selected;
			txtValue.visible = !rbSMS.selected;
		}
	}
}
}