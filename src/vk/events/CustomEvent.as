package vk.events {
import flash.events.Event;

/**
 * @author Andrew Rogozov
 */
public class CustomEvent extends Event {
    public static const WINDOW_BLUR:String = "onWindowBlur";
    public static const WINDOW_FOCUS:String = "onWindowFocus";
    public static const APP_ADDED:String = "onApplicationAdded";
    public static const CONN_INIT:String = "onConnectionInit";

    private var _data:Object = new Object();

    public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }

    public function get data():Object {
        return _data;
    }

    public function set data(value:Object):void {
        _data = value;
    }

    override public function clone():Event {
        var result : CustomEvent = new CustomEvent(this.type, this.bubbles, this.cancelable);
        result.data = this._data;
        return result;
    }
}
}