package by.vnz.framework.resources {
	import by.vnz.framework.idmaps.IDMCResourceImportance;

	public class ResourcesMapParser {
		public function ResourcesMapParser() {
		}

		/**
		 * Составляет из данного XML-узла
		 * карту ассоциаций айди:файл.
		 * @param
		 */
		static public function parse( source : XML ) : void {
			var resData : ResourceData;
			var list : XMLList;

			list = source.descendants().( hasOwnProperty( "@id" ) && hasOwnProperty( "@file" ));

			for each ( var itemXML : XML in list ) {
				resData = getData( itemXML );
				ResourcesManager.associateResource( resData );
			}
		}

		/**
		 * @param
		 * @return
		 */
		static public function getData( source : XML ) : ResourceData {
			var result : ResourceData;

			result = new ResourceData();

			result.id = source.@id;
			result.fileName = source.@file;
			result.filePath = getPath( source );

			if ( source.hasOwnProperty( "@type" )) {
				result.type = source.@type;
			}

			if ( source.hasOwnProperty( "@importance" )) {
				result.importance = source.@importance;
			} else {
				result.importance = IDMCResourceImportance.NO;
			}

			if ( source.hasOwnProperty( "@lib" )) {
				result.libID = source.@lib;
			}
			//inf(result.pathName);

			return ( result );
		}

		/**
		 * @param
		 * @return
		 */
		static public function getPath( source : XML ) : String {
			var result : String;

			var node : XML;

			node = source;
			result = "";

			do {
				result = node.@path.toXMLString() + result;
				node = node.parent();
			} while ( node != null );

			return result;
		}
	}
}