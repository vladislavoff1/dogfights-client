package by.vnz.framework.model {

import flash.external.*;

import by.vnz.VO.vkontakte.APIVkontakteVO;
import by.vnz.framework.VO.WebRequestVO;

import com.dynamicflash.util.Base64;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.utils.Dictionary;

import flash.external.ExternalInterface;

import vnz.utils.Describer;

public class HTTPRequester {
    private var _baseURL:String; //http://4.piter79.z8.ru/dogreg.php
    private var _socialNetApiUrl:String = "http://api.vkontakte.ru/api.php";
    private var _activeRequests:Dictionary = new Dictionary(true);

    public function HTTPRequester(baseURL:String = null, socialNetApiUrl:String = null) {
        if (baseURL) {
            _baseURL = baseURL;
        }
        if(socialNetApiUrl){
            _socialNetApiUrl = BuildConfig.SOCIAL_API_URL;
        }
    }

    public function get activeRequests():Dictionary {
        return _activeRequests;
    }

    public function get socialNetApiUrl():String {
        return _socialNetApiUrl;
    }

    public function set socialNetApiUrl(value:String):void {
        _socialNetApiUrl = value;
    }

    public function request(data:WebRequestVO, vkontakte:Boolean = false):void {

        var _requestLoader:URLLoader;
        var request:URLRequest = new URLRequest();

        _requestLoader = initLoader();
        data.loader = _requestLoader;

        var URL:String = vkontakte ? _socialNetApiUrl : _baseURL;
        if (!vkontakte) {
            URL += data.method + data.params.toString();
        } else {
            URL += "?" + data.params.toString();
        }

        //debug
        //			var fURL : String = URL + "?" + data.params.toString();
        //			debug( "request fullURL", fURL );
        debug("request URL", URL);
        //end debug

        //add to active list
        _activeRequests[data] = data;
        //trace('VkToFacebook ' + URL);
        if(vkontakte){
            if (ExternalInterface.available) {
                ExternalInterface.call('VkToFacebook', URL);
            //debug('VkToFacebook', URL);
			ExternalInterface.addCallback('VkToFacebook', completeHandler);
			}
        } else {
            request.url = URL;
            request.method = URLRequestMethod.POST;
            _requestLoader.load(request);
        }
    }

    private function initLoader():URLLoader {
        var loader:URLLoader = new URLLoader();
        //			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
        loader.addEventListener(Event.COMPLETE, completeHandler);
        loader.addEventListener(Event.OPEN, openHandler);
        loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

        return loader;
    }

    private function completeHandler(event:Event):void {
        var loader:URLLoader = URLLoader(event.target);
        var requestData:WebRequestVO = getRequestData(loader);
        if (!requestData) {
            return;
        }
        var resultString:String = new String(loader.data);
        resultString = resultString.replace(/\t/gi, "");
		resultString = resultString.substring(2);
        debug( "completeHandler: " + resultString );
        if (requestData.useBase64) {
           resultString = Base64.decode(resultString);
        }
        debug( this, "completeHandler: " + resultString );
        var xml:XML = null;
        try {
            xml = new XML(resultString);
            //            debug("request(" + requestData.method + ") result_1", loader.data);
            debug("request(" + requestData.method + ") result", xml);
        } catch (er:Error) {
            debug(this, "request: " + resultString);
            error(this, "XML parser failure: element is malformed!");
        }

        //			var decodeResult2 : String = "%09%09PHJlc3VsdCB0eXBlPSIxIj48ZG9nPjxuYW1lPnNhZDwvbmFtZT48YnJlZWRJRD4zPC9icmVlZElEPjxicmVlZD7QndC10LzQtdGG0LrQsNGPINC%200LLRh9Cw0YDQutCwPC9icmVlZD48bGV2ZWw%20MTwvbGV2ZWw%20PHN0cj43PC9zdHI%20PGRleD41PC9kZXg%20PGVuZHU%20NjwvZW5kdT48L2RvZz48L3Jlc3VsdD4=";
        //			debug( "0 ", resultString );
        //			debug( "1 ", decodeResult2 );
        //			debug( "2 ", Base64.decode( resultString ));
        //			debug( "3", Base64.decode( decodeResult2 ));
        //
        //			var resultString2 : String = resultString.substr( 0, resultString.length );
        //			debug( "4 ", Base64.decode( resultString2 ));
        //			debug( resultString.valueOf());
        //
        //			if ( resultString.localeCompare( decodeResult2 )) {
        //				debug( "GOOD!!!!!!!!!!!!!!!!!" );
        //			}

        if (requestData.resultHandler != null) {
            requestData.resultHandler(requestData, xml);
        }
        requestData.loader = null;
        delete _activeRequests[requestData];

        //			var vars : URLVariables = new URLVariables( loader.data );
        //			trace( "The answer is " + vars.answer );
    }

    private function getRequestData(loader:URLLoader):WebRequestVO {
        var result:WebRequestVO;
        for each (var item:WebRequestVO in _activeRequests) {
            if (item.loader == loader) {
                result = item;
                break;
            }
        }
        return result;
    }

    private function openHandler(event:Event):void {
        //			trace( "openHandler: " + event );
    }

    private function progressHandler(event:ProgressEvent):void {
        //			trace( "progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal );
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("securityErrorHandler: " + event);
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        //			trace( "httpStatusHandler: " + event );
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        trace("ioErrorHandler: " + event);
    }

}
}