package by.vnz.framework.resources.loading {
	/**
	 * Загружает базовые UI-ресурсы, нужные в самом начале
	 */
	import flash.events.Event;

	import logging.debug;
	import logging.logger.Logger;
	import by.vnz.framework.resources.loading.ResourceLoader;

	public class InitialResourceLoader extends ResourceLoader {
		public function InitialResourceLoader() {
			super();
		}

		/**
		 * @param
		 */
		override public function load( mapPath : String = null ) : void {
			if ( !mapPath ) {
				return;
			}
			loadFile( mapPath, onList );
		}

		/**
		 * @param
		 */
		private function onList( source : XML ) : void {
//			debug( "InitialResourceLoader", source, Logger.DC_5 );
			writeMapList( source );

			var aMap : XML;

			aMap = <resources path="resources/" />;
			aMap.appendChild( source );
			parseXML( aMap );

			addEventListener( Event.COMPLETE, onComplete, false, 0, true );
			demandImportant( aMap );
		}

		/**
		 * @param
		 */
		private function onComplete( event : Event ) : void {
//			debug( "InitialResourceLoader", "onComplete", Logger.DC_5 );
			removeEventListener( Event.COMPLETE, onComplete );
			dispatchMessage( completeMessage );
		}
	}
}
