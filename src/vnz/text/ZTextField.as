package vnz.text {
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class ZTextField extends TextField {
		static public var defaultEmbedFonts : Boolean = false;

		public function ZTextField() {
			super();
			defaultTextFormat = ZDefaultTextFormat.create();
			width = 100;
			height = 25;
			selectable = false;
		}

		static public function create( formatParams : Object = null, params : Object = null ) : TextField {
			var result : TextField;

			var format : TextFormat;

			result = new TextField();
			result.width = 100;
			result.height = 25;
			result.embedFonts = defaultEmbedFonts;

			format = ZDefaultTextFormat.create();
			var prop : String
			if ( formatParams ) {
				for ( prop in formatParams ) {
					format[prop] = formatParams[prop];
				}
			}
			if ( params ) {
				for ( prop in params ) {
					result[prop] = params[prop];
				}
			}
			result.defaultTextFormat = format;

			result.wordWrap = result.multiline
			result.selectable = ( result.type == TextFieldType.INPUT );

			return ( result );
		}
	}
}