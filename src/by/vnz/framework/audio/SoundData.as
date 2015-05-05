package by.vnz.framework.audio {

	public class SoundData {
		public var id : String;
		public var loop : Boolean;
		public var stop : Boolean;

		public function SoundData() {
			loop = false;
			stop = false;
		}

		/**
		 * @param
		 */
		public function parseXML( source : XML ) : void {
			if ( source == null ) {
				return;
			}

			id = source.@objectid;
			loop = source.@loop;
		}

		/**
		 * @param
		 * @return
		 */
		static public function create( source : XML ) : SoundData {
			var result : SoundData;

			result = new SoundData();

			if ( source != null ) {
				result.parseXML( source );
			}

			return ( result );
		}
	}
}
