package by.vnz.framework.view.core {

import by.vnz.framework.VO.BaseVO;
import by.vnz.framework.events.StateEvent;

import flash.events.Event;

public class BaseElement extends GUIElement {
    private var _currentState:String;
    protected var _data:BaseVO;

    public function BaseElement() {
        super();

        addEventListener(StateEvent.EXIT_STATE, onExitState, false, 0, true);
        addEventListener(StateEvent.ENTER_STATE, onEnterState, false, 0, true);
    }

    /**
     *
     */
    public function get currentState():String {
        var result:String;

        result = _currentState;

        return result;
    }

    public function set currentState(value:String):void {
        if (value != _currentState) {
            var stateEvent:StateEvent;

            stateEvent = new StateEvent(StateEvent.EXIT_STATE);
            stateEvent.prevState = _currentState;
            stateEvent.nextState = value;
            dispatchEvent(stateEvent);

            stateEvent = new StateEvent(StateEvent.ENTER_STATE);
            stateEvent.prevState = _currentState;
            stateEvent.nextState = value;

            _currentState = value;

            dispatchEvent(stateEvent);
        }
    }

    protected function onEnterState(event:StateEvent):void {

    }

    protected function onExitState(event:StateEvent):void {

    }

    public function get data():BaseVO {
        var result:BaseVO = _data;

        return result;
    }

    public function set data(value:BaseVO):void {
        if (!value) {
            return;
        }
        if (_data == value) {
            dataChangeHandler(null);
            return;
        }
        _data = value;
        _data.addEventListener(Event.CHANGE, dataChangeHandler);
        dataChangeHandler(null);
    }

    private function dataChangeHandler(event:Event):void {
        if (!_data) {
            return;
        }
        invalidate();
    }

    override protected function redraw():void {
        if (!isGUIReady) {
            invalidate();
            return;
        }
        super.redraw();
        if (_data) {
            update();
        }
    }

    protected function update():void {

    }

}
}
