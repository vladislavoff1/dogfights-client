package by.vnz.framework.resources {

	import by.vnz.framework.events.AssociationRequest;
	import by.vnz.framework.events.ResourceCheck;
	import by.vnz.framework.events.ResourceDemand;
	import by.vnz.framework.resources.types.LibraryResource;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	public class ResourcesManager extends EventDispatcher {
		/** use for show debug info */
		static public var totalLoadedMB : Number = 0;
		static public var loadedByTypes : Object = new Object();

		static private var _instance : ResourcesManager;

		private var _resources : Object;

		private var resourcesProxy : ResourcesProxy;

		private var _libsList : Array = new Array();

		public function ResourcesManager() {
			super();

			if ( !_instance ) {
				_instance = this;
			} else {
				throw( "ResourcesManager instance was created early!" );
			}

			_resources = new Object();

			loadedByTypes[ResourceData.TYPE_BITMAP] = 0;
			loadedByTypes[ResourceData.TYPE_RAW] = 0;
			loadedByTypes[ResourceData.TYPE_SOUND] = 0;
			loadedByTypes[ResourceData.TYPE_SWF] = 0;
//			loadedByTypes[ResourceData.TYPE_TEXT] = 0;
			loadedByTypes[ResourceData.TYPE_XML] = 0;

//			resourcesProxy = new ResourcesProxy();
//			addChild( resourcesProxy );
		}

		/**
		 * @param
		 */
		public function attachTo( target : Sprite ) : void {
			target.addEventListener( AssociationRequest.ASSOCIATE_RESOURCE, onAssociate, false, 0, true );
			target.addEventListener( ResourceDemand.DEMAND, onDemand, false, 0, true );
			target.addEventListener( ResourceCheck.CHECK, onCheck, false, 0, true );
		}

		/**
		 * @param
		 */
		private function onAssociate( event : AssociationRequest ) : void {
			event.stopPropagation();
			associateResource( event.data );
		}

		static public function associateResource( data : ResourceData ) : void {
			var resource : EnhancedResource = _instance._resources[data.id];

			if ( resource == null ) {
				resource = EnhancedResource.create( data );
				_instance._resources[data.id] = resource;
			}

		}

		/**
		 * @param
		 */
		private function onDemand( event : ResourceDemand ) : void {
			event.stopPropagation();
			demandResource( event.id, event.handler );
		}

		static public function demandResource( id : String, resultHandler : Function ) : void {
			var resource : EnhancedResource;

			resource = _instance._resources[id];

			if ( resource is EnhancedResource ) {
				resource.addDemand( resultHandler );
			} else {
				warn( "Resource <" + id + "> does not exist" );
				resultHandler( null );
			}
		}

		/**
		 * @param
		 */
		private function onCheck( event : ResourceCheck ) : void {
			event.stopPropagation();

			var resource : EnhancedResource;

			resource = _resources[event.id];

			if ( resource is EnhancedResource ) {
				var status : Boolean = resource.getStatus();
				if ( !status ) {
					resource.addDemand( onResource );
				}
				event.handler( event.id, status, event.defaultID );
			} else {
				event.handler( event.id, null, event.defaultID );
			}
		}

		/**
		 * @param
		 */
		private function onResource( source : DisplayObject ) : void {

		}

		static public function setNewBytesLoaded( newBytes : uint, type : String ) : void {
			var b : Number = Math.round( newBytes / ( 1024 * 1024 ) * 1000 ) / 1000;
			totalLoadedMB += b;
			totalLoadedMB = Math.round( totalLoadedMB * 100 ) / 100;

			if ( loadedByTypes[type] != null ) {
				loadedByTypes[type]++;
			}
		}

		static public function get infoByTypes() : String {
			var result : String = "";
			for ( var prop : String in loadedByTypes ) {
				result += "/" + prop + ":" + loadedByTypes[prop];
			}
			return result;
		}

		static public function addLib( value : LibraryResource ) : void {
			_instance._libsList.push( value.ID );

			ResourcesMapParser.parse( value.descriptionXML );
		}

		static public function getResourceFromLib( libID : String, resourceID : String ) : DisplayObject {
			var result : DisplayObject;
			var lib : LibraryResource;
			var fileName : String;

			for each ( var id : String in _instance._libsList ) {
				if ( libID == id ) {
					lib = _instance._resources[libID];
					result = lib.getResource( resourceID );
					break;
				}
			}

			return result;
		}
	}
}
