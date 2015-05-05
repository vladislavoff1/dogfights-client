package by.vnz.framework.resources.loading {

import by.vnz.framework.idmaps.IDMCResourceImportance;
import by.vnz.framework.resources.ResourceData;
import by.vnz.framework.resources.ResourcesManager;
import by.vnz.framework.resources.ResourcesMapParser;
import by.vnz.framework.view.core.BaseElement;

import flash.events.Event;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;

import logger.Logger;

public class ResourceLoader extends BaseElement {
    public var completeMessage:String = "message:resource.loader.complete";

    static public const STATE_IMPORTANT:String = "state:important";
    static public const STATE_SUSPENDED:String = "state:suspend";
    static public const STATE_LOADING:String = "state:loading";
    static public const STATE_NORMAL:String = "state:normal";

    static public const MAX_LOADING_THREADS:int = 10;

    static public var idmapsPackage:String = null;

    protected var wholeMap:XML;
    private var externalPiece:XML;
    private var totalExternals:int;
    private var loadedExternals:int;

    private var currentImportant:int;
    private var loadedImportants:int;
    private var importantList:XMLList;

    public function ResourceLoader() {
        super();

        currentState = STATE_NORMAL;
    }


    public function load(mapPath:String = null, completeHandler:Function = null):void {
        if (!mapPath) {
            return;
        }
        loadFile(mapPath, onXMLMap);
    }

    public function parseMap(map:XML):void{
        if (!map){
            return;
        }
        onXMLMap(map);
    }

    private function onXMLMap(source:XML):void {
        debug(this, source, Logger.DC_5);

        writeMapList(source);

        //			var aMap : XML;
        //
        //			aMap = <resources path="resources/" />;
        //			aMap.appendChild( source );
        ResourcesMapParser.parse(source);
        //			return;

        //			addEventListener( Event.COMPLETE, onComplete, false, 0, true );
        demandImportant(source);
    }

    protected function demandMap(source:XML):void {
        if (currentState != STATE_NORMAL) {
            error("ResourceLoader.demandMap(...) : calling it while loading other things is a critical failure.");
        }

        currentState = STATE_LOADING;

        wholeMap = <root />;
        wholeMap.appendChild(source);

        loadedExternals = 0;
        totalExternals = 0;

        filterExternals();
    }


    private function filterExternals():void {
        var list:XMLList;

        list = wholeMap.descendants().( attribute("external").length() > 0 );

        totalExternals = loadedExternals + list.length();
        dispatchProgress(loadedExternals, totalExternals);

        if (list.length() > 0) {
            externalPiece = list[0];
            loadFile(ResourcesMapParser.getPath(externalPiece) + externalPiece.@external);
        } else {
            currentState = STATE_NORMAL;
            dispatchComplete();
            //filterMaps();
        }
    }


    protected function loadFile(value:String, handler:Function = null):void {
        var resData:ResourceData;
        var aFile:String;
        var anId:String;

        //inf(value);

        aFile = value;
        anId = "file:" + value;
        resData = ResourceData.create(anId, aFile, ResourceData.TYPE_XML);

        if (handler == null) {
            handler = onFile;
        }

        ResourcesManager.associateResource(resData);
        ResourcesManager.demandResource(anId, handler);
    }


    private function onFile(source:XML):void {
        externalPiece.setChildren(source.children());
        delete( externalPiece.@external );

        var anAttribute:XML;
        var list:XMLList;

        list = source.@*;

        for (var i:int = 0; i < list.length(); i++) {
            anAttribute = list[i];
            externalPiece.@[anAttribute.name()] = anAttribute;
        }

        externalPiece = null;
        loadedExternals++;
        filterExternals();
    }


    protected function demandImportant(source:XML):void {
        if (currentState != STATE_NORMAL) {
            error("ResourceLoader.demandImportant(...) : calling it while loading other things is a critical failure.");
        }

        buildImportance(source);
        currentImportant = -1;
        loadedImportants = 0;

        currentState = STATE_IMPORTANT;

        loadImportant();

        for (var i:int = 0; ( i < importantList.length()) && ( i < MAX_LOADING_THREADS ); i++) {
            loadImportant();
        }
    }


    private function buildImportance(source:XML):void {
        var list:XMLList;
        var resultList:XML;
        var anImportance:int;
        //			var gameImportance : int;
        //
        //			if ( loaderInfo.url.substr( 0, 7 ) == "http://" ) {
        //				gameImportance = 1;
        //			} else {
        //				gameImportance = 2;
        //			}

        resultList = <important />;
        list = source.descendants().( hasOwnProperty("@file"));

        for each (var item:XML in list) {
            if (IDMCResourceImportance.getImportance(item.@importance) > 1) {
                resultList.appendChild(item);
            }
        }

        importantList = resultList.children().@id;
    }


    private function loadImportant():void {
        var anId:String;

        currentImportant++;
        anId = importantList[currentImportant];

        //			debug( "loadImportant", anId );
        if (anId is String) {
            ResourcesManager.demandResource(anId, onImportant);
        }
    }


    private function onImportant(source:*):void {
        //			debug( "onImportant", source, Logger.DC_2 );
        if (source == null) {
            error("Critical error: important resource <?> is absent");
        }

        loadedImportants++;

        dispatchProgress(loadedImportants, importantList.length());

        if (loadedImportants < importantList.length()) {
            loadImportant();
        } else {
            currentState = STATE_NORMAL;
            dispatchComplete();
        }
    }


    private function dispatchProgress(loaded:int, total:int):void {
        var anEvent:ProgressEvent;

        anEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, loaded, total);
        dispatchEvent(anEvent);
    }


    private function dispatchComplete():void {
        var anEvent:Event;

        anEvent = new Event(Event.COMPLETE);
        dispatchEvent(anEvent);
    }


    protected function filterMaps():void {
        //inf(wholeMap.toXMLString());

        //currentState = STATE_LOADING;

        var list:XMLList;
        var item:XML;

        list = wholeMap.descendants().( attribute("map").length() > 0 );

        for (var i:int = 0; i < list.length(); i++) {
            item = list[i];
            processMap(item);

            //inf(item.toXMLString());
        }
    }


    protected function processMap(source:XML):void {
        writeMapList(source)

        var resData:ResourceData;
        var list:XMLList;
        var aType:String;
        var item:XML;

        list = source.children().( attribute("key").length() > 0 );
        aType = source.@groupid;

        for (var i:int = 0; i < list.length(); i++) {
            item = list[i];

            resData = ResourcesMapParser.getData(item);
            resData.id = aType + item.@key;
            //				if ( item.child( "lod" ).length() > 0 )
            //				{
            //					resData.lodId = aType + item.child( "lod" )[0].@key;
            //				}

            //inf(resData.id + " : " + resData.pathName);

            ResourcesManager.associateResource(resData);
        }
    }

    protected function writeMapList(source:XML):void {
        var mapClass:Object;

        if (source.hasOwnProperty("@map")) {
            try {
                mapClass = getDefinitionByName(idmapsPackage + source.@map) as Class;
                parseIDMap(source, mapClass);
            } catch (er:Error) {
                error("error on writeMapList", er);
            }
        }
    }

    private function parseIDMap(source:XML, target:Object):void {
        if (target == null) {
            warn("IdMap.readMap(...) : class <" + source.@map + "> does not exist.");
            return;
        }

        var list:XMLList;
        var aMap:Object;
        var item:XML;

        aMap = target[source.@list];
        list = source.children().( attribute("key").length() > 0 );

        //inf("");
        //inf(">>>");
        //inf(aMap);

        for (var i:int = 0; i < list.length(); i++) {
            item = list[i];
            aMap[item.@key] = ( item.@id ).toString();
        }
    }

}
}
