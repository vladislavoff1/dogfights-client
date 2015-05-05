package by.vnz.view.staff {
import by.vnz.VO.vkontakte.AdsVkontakteVO;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.core.BaseElement;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;

import flash.events.MouseEvent;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import flash.text.TextField;

import vnz.core.ZSprite;
import vnz.data.MediaLoader;

public class AdsBox extends BaseElement {
    private var _loader:MediaLoader = new MediaLoader();
    public var box:ZSprite;
    public var txtMsg:TextField;
    public var txtTitle:TextField;

    public function AdsBox() {
    }


    override protected function preinitUI():void {
        super.preinitUI();

        this.visible = false;

        createUIChild(TextField, <ui name="txtMsg" x="0" y="0" width="270" height="24" font="Calibri" size="16" color="0xFFFFFF" bold="true" align="center" multiline="true" />);
        txtMsg.text = "Спонсор боя!";
        createUIChild(ZSprite, <ui name="box" x="100" y= "30" />);
        box.graphicsDrawRect(75, 75, 0xff0000, 0.2);
        createUIChild(TextField, <ui name="txtTitle" x="0" y="110" width="270" height="24" font="Calibri" size="14" color="0xFFFFFF" bold="true" align="center" multiline="true" />);
        box.visible = false;
        txtTitle.text = "Для Вас рекламы нет :)";
    }

    override protected function update():void {
        super.update();

        loadImage((_data as AdsVkontakteVO).photo);
        box.addEventListener(MouseEvent.CLICK, clickHandler);
        box.buttonMode = true;
        box.visible = true;
        txtTitle.text = (_data as AdsVkontakteVO).title;

        this.visible = true;
    }

    private function clickHandler(event:MouseEvent):void {
        navigateToURL(new URLRequest((_data as AdsVkontakteVO).link), "_blank");
    }

    public function loadImage(url:String):void {
        if (!url) {
            return;
        }
        _loader.addEventListener(MediaLoader.MEDIA_LOADED, loaderLoadedHandler);
        _loader.load(url);
    }

    private function loaderLoadedHandler(event:Event):void {
        var image:Bitmap = _loader.media as Bitmap;
        box.addChild(image);
        box.graphics.clear();
    }

    public function updateTitle(modeBattle:Boolean = true):void {
        if (!modeBattle) {
            txtMsg.text = "Устал в боях?!";
        }
    }

}
}