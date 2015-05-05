package by.vnz.framework.resources.types {
	import by.vnz.framework.resources.EnhancedResource;
	import by.vnz.framework.resources.ResourceData;
	import by.vnz.framework.resources.ResourcesManager;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

import flash.utils.getDefinitionByName;

import flash.utils.getQualifiedClassName;

import ru.etcs.utils.getDefinitionNames;

	import vnz.utils.Describer;

	public class LibraryResource extends EnhancedResource {
		private var _loader : Loader;

		private var _resourcesXML : XML;

		public function get descriptionXML() : XML {
			if ( !_resourcesXML ) {
				createInfoXML();
			}
			return _resourcesXML;
		}

		public function LibraryResource( source : ResourceData ) {
			super( source );
		}

		override protected function loadResource() : void {
			super.loadResource();

			_loader = new Loader();
//			var context : LoaderContext = new LoaderContext( false, new ApplicationDomain());
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onResource, false, 0, true );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onError );
			_loader.load( createRequest() );
			//			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			//			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );			
		}

		override protected function onError( event : IOErrorEvent ) : void {
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onResource );

			super.onError( event );
		}

		override protected function onResource( event : Event = null ) : void {
			ResourcesManager.setNewBytesLoaded( _loader.contentLoaderInfo.bytesLoaded, data.type );
            debug("lib loaded", data.fileName);
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onResource );

			ResourcesManager.addLib( this );

			super.onResource( event );
		}

		private function createInfoXML() : void {
			var resourcesList : Array = getDefinitionNames( _loader.contentLoaderInfo, true, true );

			_resourcesXML = <library path={data.filePath} ></library>;
			for each ( var itemName : String in resourcesList ) {
				var itemXML : XML = <resource id={itemName} file={data.id} type={ResourceData.TYPE_SWF} lib={data.id} />;

				var ItemClass : Class = getClass( itemName );
				if ( ItemClass != null ) {
					var item : DisplayObject = new ItemClass();
					if ( !Describer.checkClassExtended( ItemClass, MovieClip ) && !Describer.checkClassExtended( ItemClass, SimpleButton )) {
						itemXML.@type = ResourceData.TYPE_BITMAP;
					}
				}
				_resourcesXML.appendChild( itemXML );
			}
//			debug( "library", _resourcesXML );
		}

		override protected function normalSatisfy() : void {
			if ( !_resourcesXML ) {
				createInfoXML();
			}

			finallySatisfy( _resourcesXML );
		}

		public function getResource( id : String ) : DisplayObject {
			var result : DisplayObject;
			var ItemClass : Class = getClass( id );
			if ( ItemClass != null ) {
//                try{
				    result = new ItemClass();
//                } catch(er:Error) {
//                    error("Library getResource", getQualifiedClassName(ItemClass));
//                }
			}
//			debug( "getResource", id );
			return result;
		}

		private function getClass( className : String ) : Class {
			if ( _loader.contentLoaderInfo.bytesLoaded > 0 ) {
				if ( _loader.contentLoaderInfo.applicationDomain.hasDefinition( className )) {
					return _loader.contentLoaderInfo.applicationDomain.getDefinition( className ) as Class;
				}
			}
			return null;
		}

	}
}