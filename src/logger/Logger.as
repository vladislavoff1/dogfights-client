package logger {
import flash.display.DisplayObject;

import nl.demonsters.debugger.MonsterDebugger;
import vnz.debug.DebugPanel;
import flash.net.*;
import flash.events.Event;

public class Logger {
    /** critical error, breakes the future work */
    public static const FATAL:String = "FATAL";
    /** error that is important */
    public static const ERROR:String = "ERROR";
    /** is a tiny error, or an action that can cause an error or fatal */
    public static const WARN:String = "WARN";
    /** some usfull information */
    public static const INFO:String = "INFO";
    /** temporary log */
    public static const DEBUG:String = "DEBUG";
    /** unlaveled log */
    public static const ALL:String = "ALL";

    //DEBUG colors
    public static const DC_0:uint = 0x0099CC;
    /** dark blue */
    public static const DC_1:uint = 0x003299;
    /** green */
    public static const DC_2:uint = 0x0A9414;
    /** lite green */
    public static const DC_3:uint = 0x68D517;
    /** orange */
    public static const DC_4:uint = 0xEA5E00;
    /** pink */
    public static const DC_5:uint = 0xD700D7;

    public static var enabled:Boolean = true;
    public static var enableMonsterDebugger:Boolean = true;
    public static var enableDebugTraces:Boolean = true;
    public static var enableFlashTrace:Boolean = true;
    public static var depthTrace:uint = 4;
    public static var externalLogMethod:Function = null;

    //		static private var _obj : *;
    static protected var _args:Array;
    static protected var _fullDiscription:String;
    static protected var _level:String;
    static protected var _debugColor:uint = DC_0;

    static public function log(level:String, args:Array, discription:* = null):void {
        _level = level;

        if (( !enabled ) || (( level == DEBUG ) && ( !enableDebugTraces ))) {
            return;
        }

        if (!args.length) {
            args = [discription];
            discription = null;
        }
        _args = args;

        parseDiscription(discription);

        if (_level == DEBUG) {
            parseDebugLog();
        }

        //use Flash trace log
        infLog();
        if (enableMonsterDebugger) {
            monsterDebuggerLog();
        }
    }

    static private function infLog():void {
        if (_fullDiscription) {
            _fullDiscription += ": ";
        }
        var levelStr:String = _level == INFO ? "" : "[" + _level + "] ";
        var argTrace:Array = [];
        for (var i:uint = 0; i < _args.length; i++) {
            var ob:* = _args[i];
            ob = ( ob is XML ) ? ( ob as XML ).toXMLString() : ob;
            argTrace.push(ob);
        }
        var logValue:String = levelStr + _fullDiscription + argTrace;
        if (enableFlashTrace) {

            trace(logValue);
			if(1==0){
				//URL('vladtest.pusku.com/error.php');
				var v:URLVariables = new URLVariables();
				v.error = logValue;
				var req:URLRequest = new URLRequest('http://dogfightsgame.com/error.php?error="' + logValue + '"');
				//req.method = URLRequestMethod.GET;
				//req.data = v; 
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onComplete );
				loader.load(req);
				function onComplete(e:Event):void
				{
					/*try
					{
						trace("Успешно получен ответ: " + e.target.data);
						//answer = Number(e.target.data);;
					}
					catch (e:TypeError)
					{
						trace("Не могу получить ответ от сервера.");
					}*/
					
				}
			}
        }
       //use Debug panel
        if (externalLogMethod != null) {
            externalLogMethod(logValue);
        }
    }

    static protected  function monsterDebuggerLog():void {
        var color:uint;
        var obj:*;
        if (_args.length > 1) {
            obj = _args;
        } else {
            obj = _args[0];
        }
        switch (_level) {
            case FATAL:
                color = 0xff3299;
                break;
            case ERROR:
                color = MonsterDebugger.COLOR_ERROR;
                break;
            case WARN:
                color = MonsterDebugger.COLOR_WARNING;
                break;
            case INFO:
                color = MonsterDebugger.COLOR_NORMAL;
                break;
            case DEBUG:
                color = _debugColor;
                break;

        }

        //			try
        //			{
        MonsterDebugger.trace(_fullDiscription, obj, color, false, depthTrace);
        //			} catch ( error : Error )
        //			{
        //				trace( "MonsterDebugger.trace ERROR!!!!!!!!" );
        //			}
    }

    static protected function parseDebugLog():void {
        _debugColor = DC_0;
        var argList:Array = ( _args as Array );
        if (!argList) {
            return;

        }
        if (argList.length > 1) {
            var lastArg:* = argList[argList.length - 1];
            if (isDebugColor(lastArg)) {
                _debugColor = lastArg;
                argList.pop();
                _args = argList;
                return;
            }
        }
    }

    static protected function parseDiscription(discription:* = null):void {
        if (discription != null && typeof( discription ) == "object") {
            var obName:String = ( discription as Object ).hasOwnProperty("name") ? discription["name"] : "";
            _fullDiscription = obName + "(" + getObjectType(discription) + ")";
            var dOb:DisplayObject = discription as DisplayObject;
            if (dOb && dOb.parent) {
                _fullDiscription = dOb.parent.name + "(" + getObjectType(dOb.parent) + ")." + _fullDiscription;
            }
        } else {
            _fullDiscription = discription != null ? String(discription) : "null";
        }
    }

    static protected function isDebugColor(value:*):Boolean {
        var result:Boolean = false;
        if (value is uint) {
            var dColors:Array = [DC_0, DC_1, DC_2, DC_3, DC_4, DC_5];
            result = ( dColors.indexOf(value) != -1 );
        }
        return result;
    }

    static protected function getObjectType(obj:Object):String {
        var result:String = obj.toString();
        result = result.substring(8, result.length - 1);
        return result;
    }

    private function get curTime():String {
        var d:Date = new Date();
        var result:String = "[" + d.hours + ":" + d.minutes + ":" + d.seconds + "." + d.milliseconds + "]";
        return result;
    }

}
}