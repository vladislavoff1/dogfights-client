package by.vnz.view.staff {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

import flash.events.EventDispatcher;

import logger.Logger;

import vk.APIConnection;
import vk.events.BalanceEvent;
import vk.events.CustomEvent;
import vk.events.SettingsEvent;

public class VKAPIConnection extends EventDispatcher {
    private var conn:APIConnection;
    private var _resultHandler:Function;

    public function VKAPIConnection() {
    }

    public function init(lcName:String):void {
        if (!lcName) {
            return;
        }
        conn = new APIConnection(lcName);

        conn.addEventListener(CustomEvent.CONN_INIT, eventHandler);
        conn.addEventListener(CustomEvent.WINDOW_BLUR, eventHandler);
        conn.addEventListener(CustomEvent.WINDOW_BLUR, eventHandler);
        conn.addEventListener(CustomEvent.APP_ADDED, eventHandler);
        conn.addEventListener(BalanceEvent.CHANGED, eventHandler);
        conn.addEventListener(SettingsEvent.CHANGED, eventHandler);
    }


    private function eventHandler(event:Event):void {
        if (event is CustomEvent) {
            switch (event.type) {
                case CustomEvent.CONN_INIT:
                    debug("VKAPIConnection", "Connection initialized", Logger.DC_1);
                    break;
                case CustomEvent.WINDOW_BLUR:
                    debug("VKAPIConnection", "Window blur", Logger.DC_1);
                    break;
                case CustomEvent.WINDOW_BLUR:
                    debug("VKAPIConnection", "Window focus", Logger.DC_1);
                    break;
                case CustomEvent.APP_ADDED:
                    debug("VKAPIConnection", "Application added", Logger.DC_1);
                    if (_resultHandler != null) {
                        _resultHandler();
                    }
                    break;
            }
        } else if (event is SettingsEvent) {
            debug("VKAPIConnection", "Settings changed: " + (event as SettingsEvent).settings, Logger.DC_1);
            if (_resultHandler != null) {
                _resultHandler((event as SettingsEvent).settings);
            }
        } else if (event is BalanceEvent) {
            debug("VKAPIConnection", "Balance changed: " + (event as BalanceEvent).balance, Logger.DC_1);
        }

        //redispatch event
        dispatchEvent(event);
    }

    public function showInviteFriends():void {
        conn.showInviteBox();
    }

    public function showSettings(resultHandler:Function = null):void {
        _resultHandler = resultHandler;
        conn.showSettingsBox();
    }

    public function showInstallApp(resultHandler:Function = null):void {
         _resultHandler = resultHandler;
        conn.showInstallBox();
    }

}
}