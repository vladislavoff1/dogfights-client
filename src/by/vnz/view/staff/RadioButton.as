package by.vnz.view.staff {
import by.vnz.framework.resources.ResourcesManager;
import by.vnz.framework.view.components.*;
import by.vnz.framework.view.core.GUIElement;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

public class RadioButton extends GUIElement {
    static public const CHANGE_SELECT : String = "change_select";
    private var _selected:Boolean = false;
    private var clip:MovieClip;

    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        _selected = value;
        invalidate();
    }

    public function RadioButton() {

    }


    override protected function initUI():void {
        super.initUI();


        ResourcesManager.demandResource("radio_button", onClipResource);

    }

    private function onClipResource(source:MovieClip):void {
        clip = source;
        addChild(clip);
        invalidate();

        addEventListener(MouseEvent.CLICK, clickHandler)
    }


    override protected function redraw():void {
        super.redraw();
        if (!clip){
            return;
        }
        if (_selected) {
            clip.gotoAndStop(2);
        } else {
            clip.gotoAndStop(1);
        }

    }

    private function clickHandler(event:MouseEvent):void {
        dispatchMessage(CHANGE_SELECT);
    }
}
}