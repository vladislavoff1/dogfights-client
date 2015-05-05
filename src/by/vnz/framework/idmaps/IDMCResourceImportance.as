package by.vnz.framework.idmaps {

	public class IDMCResourceImportance {
		static public const IMPORTANT : String = "important";
		static public const NETWORK : String = "network";
		static public const YES : String = "yes";
		static public const NO : String = "no";

		/**
		 * @param
		 * @return
		 */
		static public function getImportance( value : String ) : uint {
			var result : uint;

			switch ( value ) {
				case IMPORTANT:
				case YES: {
					result = 2;
					break;
				}

				case NETWORK: {
					result = 1;
					break;
				}

				default: {
					result = 0;
					break;
				}
			}

			return ( result );
		}
	}
}
