package by.vnz.view.staff {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

public class VKWrapper {
    static private var _wrapper:Object;

    public function VKWrapper() {
    }

    static public function init(app:Sprite):void {
        if (!app.stage) {
            app.addEventListener(Event.ADDED_TO_STAGE, app_addedToStageHandler, false, 0, true);
            return;
        }
        _wrapper = Object(app.parent.parent);
    }

    static private function app_addedToStageHandler(event:Event):void {
        var app:Sprite = event.target as Sprite;
        app.removeEventListener(Event.ADDED_TO_STAGE, app_addedToStageHandler);
        init(app);
    }

    static public function showInviteBox():void {
        _wrapper.external.showInviteBox();
    }

}
}