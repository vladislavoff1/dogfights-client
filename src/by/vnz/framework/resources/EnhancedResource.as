package by.vnz.framework.resources {

	import by.vnz.framework.resources.types.BitmapResource;
	import by.vnz.framework.resources.types.LibraryResource;
	import by.vnz.framework.resources.types.MovieResource;
	import by.vnz.framework.resources.types.RawResource;
	import by.vnz.framework.resources.types.SoundResource;
	import by.vnz.framework.resources.types.TextResource;
	import by.vnz.framework.view.MainView;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.describeType;

	public class EnhancedResource extends EventDispatcher {
		static public const STATUS_EMPTY : String = "status_empty";
		static public const STATUS_LOADED : String = "status_loaded";
		static public const STATUS_LOADING : String = "status_loading";
		static public const STATUS_ERROR : String = "status_error";

		static public var cacheByVersionEnabled : Boolean = true;
		static public var anticacheAnyway : Boolean = true;
		static public var baseURL : String = "";

		protected var data : ResourceData;

		private var demandQueue : Array;
		private var satisfyQueue : int;
		private var status : String;

		public function get ID() : String {
			var result : String;

			if ( data ) {
				result = data.id;
			}

			return result;
		}

		public function EnhancedResource( source : ResourceData ) {
			data = source;
			status = STATUS_EMPTY;
			satisfyQueue = 0;
			demandQueue = new Array();
		}

		/**
		 * @param
		 */
		public function addDemand( handler : Function ) : void {
			demandQueue.push( handler );

			switch ( status ) {
				case STATUS_LOADED: {
					satisfyDemand();
					break;
				}

				case STATUS_EMPTY: {
					loadResource();
					break;
				}
			}
		}

		/**
		 * Этот метод, реализованный в потомках,
		 * приводит к цели: вызову метода finallySatisfy(...).
		 * @param
		 */
		protected function normalSatisfy() : void {

		}

		/**
		 * @param
		 */
		protected function finallySatisfy( source : * = null ) : void {
			var aHandler : Function;

			aHandler = demandQueue.shift() as Function;
			var hasError : Boolean = false;

			if ( source == null ) {
				source = generateSatifsyError( source );
			} else {

				try {
					aHandler( source );
				} catch ( er : Error ) {

					if ( er.name == "ArgumentError" ) {
						aHandler( source, data );
					} else {
//					throw(er);
						error( "finallySatisfy", "Unsupported error >> " + er, data );
						hasError = true;
					}
				}
			}
			satisfyQueue--;
//			satisfyAll();
		}

		private function satisfy() : void {

		}

		/**
		 * @param
		 */
		private function satisfyDemand() : void {
			satisfyQueue++;

			switch ( status ) {
				case STATUS_LOADED: {
//					satisfyAll();
					normalSatisfy();
					break;
				}

				case STATUS_ERROR: {
					finallySatisfy();
					break;
				}
			}
		}

		/**
		 * @param
		 */
		private function satisfyAll() : void {
			//inf(satisfyQueue, demandQueue.length);

			while ( satisfyQueue < demandQueue.length ) {
				satisfyDemand();
			}
		}

		/**
		 * @param
		 */
		protected function loadResource() : void {
			status = STATUS_LOADING;
		}

		/**
		 * @param
		 * @return
		 */
		protected function createRequest() : URLRequest {
			var result : URLRequest;

			result = new URLRequest();

			result.url = baseURL + data.pathName;
			var antiCache : String = "";
			if ( cacheByVersionEnabled ) {
				antiCache += MainView.CURRENT_VERSION;
			}
			if ( anticacheAnyway ) {
				antiCache += ( Math.random() * 10000 ).toString();
			}
			result.data = antiCache;

			result.method = URLRequestMethod.GET;

			return ( result );
		}

		/**
		 * @param
		 */
		protected function onError( event : IOErrorEvent ) : void {
			warn( "Error loading resource <" + data.id + "> from file <" + data.pathName + ">" );
			status = STATUS_ERROR;
			satisfyAll();
		}

		/**
		 * @param
		 */
		protected function onResource( event : Event = null ) : void {
//			debug("Resource <" + data.id + "> from file <" + data.pathName + "> loaded!");
			status = STATUS_LOADED;
			satisfyAll();
		}

		/**
		 * @param
		 * @return
		 */
		static public function create( source : ResourceData ) : EnhancedResource {
			var result : EnhancedResource;

			switch ( source.type ) {
				case ResourceData.TYPE_TEXT:
				case ResourceData.TYPE_XML: {
					result = new TextResource( source );
					break;
				}

				case ResourceData.TYPE_RAW: {
					result = new RawResource( source );
					break;
				}

				case ResourceData.TYPE_SOUND: {
					result = new SoundResource( source );
					break;
				}

				case ResourceData.TYPE_BITMAP: {
					result = new BitmapResource( source );
					break;
				}

				case ResourceData.TYPE_LIBRARY: {
					result = new LibraryResource( source );
					break;
				}

				case ResourceData.TYPE_SWF:
				default: {
					result = new MovieResource( source );
					break;
				}
			}

			return ( result );
		}

		/**
		 * @param
		 */ /*private function loadSound(request:URLRequest):void
		   {
		   var aLoader:Sound;

		   aLoader = new Sound();

		   resourceLoader = aLoader;
		   subscribeLoader();
		   aLoader.load(request);
		 }*/

		/**
		 * @param
		 */
		public function getStatus() : Boolean {
			if ( status == STATUS_LOADED ) {
				return true;
			}

			return false;
		}

		private function generateSatifsyError( source : * ) : Object {
			var result : Object = null;
			var errorText : String;
			switch ( data.type ) {
				case ResourceData.TYPE_TEXT: {
					errorText = "Text resource <" + data.id + "> is not here.";
					result = "not found!"
					break;
				}

				case ResourceData.TYPE_XML: {
					errorText = "XML resource <" + data.id + "> is not here.";
					result = <empty />;
					break;
				}

				case ResourceData.TYPE_BITMAP:
				case ResourceData.TYPE_SWF: {
					errorText = "Visual resource <" + data.id + "> is not here.";
					break;
				}
				case ResourceData.TYPE_LIBRARY: {
					errorText = "Library resource <" + data.id + "> is not here.";
					break;
				}

				default: {
					errorText = "Resource <" + data.id + "> of unknown type is not here.";
					break;
				}
			}
			error( this, errorText );
			return result;
		}

		protected function clearContent() : void {
			status = STATUS_EMPTY;
		}

	}
}
