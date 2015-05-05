package by.vnz.framework.VO {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import logger.Logger;

	public class BaseVO extends EventDispatcher {

		public function BaseVO(source:Object = null) {
            update(source);
		}

		public function update( source : * ) : void {
			if ( !source ) {
				return;
			}
			parseSource( source );
			dispatchEvent( new Event( Event.CHANGE ));
		}

		/**
		 * ovveride method
		 * @param source
		 */
		protected function parseSource( source : * ) : void {
			if ( source is XML ) {
				var xml : XML = source as XML;
				parseXML( xml );
			}
		}

		/**
		 * auto parsing
		 * sample :
		   <result>
		   <name>my_name</name>
		   <title>my_title</title>
		   </result>
		 */
		protected function parseXML( xml : XML ) : void {
			var item : XML;
			var propName : String;
			for each ( item in xml.children()) {
				propName = String(item.name());
				if ( this.hasOwnProperty( propName )) {
					this[propName] = item.*;
//					debug( "set var | " + propName, this[propName]);
				}
			}
			var atrList : XMLList = xml.attributes();
			for each ( item in atrList ) {
				propName = String(item.name());
				if ( this.hasOwnProperty( propName )) {
					var propValue : * = item.toString();
					this[propName] = propValue;
				}
			}
//			debug( this, this );
		}

	}
}