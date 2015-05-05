package by.vnz.framework.resources {

	public class ResourceData {
		static public const TYPE_XML : String = "xml";
		static public const TYPE_SWF : String = "swf";
		static public const TYPE_TEXT : String = "text";
		static public const TYPE_RAW : String = "binary";
		static public const TYPE_SOUND : String = "sound";
		static public const TYPE_BITMAP : String = "bitmap";
		static public const TYPE_LIBRARY : String = "library";

		public var id : String;
		public var type : String = TYPE_SWF;
		public var fileName : String;
		public var filePath : String;
		public var importance : String;
		public var libID : String;

		/**
		 *
		 * Геттер/сеттер.
		 */
		public function get pathName() : String {
			var result : String;

			// Код геттера.
			result = filePath + fileName;

			return ( result );
		}

		public function set pathName( value : String ) : void {
			// Код сеттера.
			fileName = value.substr( value.lastIndexOf( "/" ) + 1 );
			filePath = value.substring( 0, value.length - fileName.length );
		}

		/**
		 * @param
		 * @return
		 */
		static public function create( resourceId : String, file : String, resourceType : String = TYPE_SWF ) : ResourceData {
			var result : ResourceData;

			result = new ResourceData();
			result.type = resourceType;
			result.id = resourceId;
			result.pathName = file;

			return ( result );
		}
	}
}
