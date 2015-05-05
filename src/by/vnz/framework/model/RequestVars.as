package by.vnz.framework.model {

	public dynamic class RequestVars {
		public function RequestVars( source : String = null ) {
			parseString( source );
		}

		public function parseString( source : String ) : void {
			if ( !source ) {
				return;
			}
			var ar : Array = source.split( "&" );
			for each ( var item : String in ar ) {
				var index : uint = item.indexOf( "=" );
				var prop : String = item.substring( 0, index );
				index++;
				var value : String = item.substring( index, item.length );
				this[prop] = value;
			}
		}

		public function toString() : String {
			var result : String = "";
			for ( var prop : String in this ) {
				result += prop + "=" + this[prop] + "&";
			}
			result = result.substr( 0, result.length - 1 );
			return result;
		}
	}
}