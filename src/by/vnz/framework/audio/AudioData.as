package by.vnz.framework.audio {

	import flash.geom.Point;

	public class AudioData {
		public var id : String;
		public var radius : int;
		public var audioid : String;
		public var position : Point;

		/**
		 * @param
		 */
		public function parseXML( source : XML ) : void {
			if ( source == null ) {
				return;
			}

			id = source.@objectid;
			audioid = source.@soundid;
			radius = int( source.@radius );
			position = new Point( int( source.@x ), int( source.@y ));
		}

		/**
		 * @param
		 * @return
		 */
		static public function create( source : XML ) : AudioData {
			var result : AudioData;

			result = new AudioData();

			if ( source != null ) {
				result.parseXML( source );
			}

			return ( result );
		}
	}
}
