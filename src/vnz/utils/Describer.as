package vnz.utils {
	import flash.utils.*;

	/**
	 *
	 * @author vnz
	 */
	public class Describer {
		static public const TYPE_ACCESSOR : String = "accessor";
		static public const TYPE_VARIABLE : String = "variable";
		static public const TYPE_METHOD : String = "method";
		static public const TYPE_EXTENDS_CLASS : String = "extendsClass";
		static public const TYPE_INTERFACE : String = "implementsInterface";

		static private var _curClass : Class = null;
		static private var _fullClassName : String = null;
		static private var _object : Object = null;

		public function Describer() {
		}

		private static function setFullClassName() : void {
			if ( _curClass ) {
				_fullClassName = getQualifiedClassName( _curClass );
			}
		}

		static private function set curClass( value : Class ) : void {
			_curClass = value;
			setFullClassName();
		}

		private static function getDescribeXML( full : Boolean = false ) : XML {
			var dXML : XML = null;
			if ( !full ) {
				dXML = describeType( _object );
			} else if ( _fullClassName && _fullClassName != "" ) {
				var obDef : Object = getDefinitionByName( _fullClassName );
				if ( obDef ) {
					dXML = describeType( obDef );
				}
			}
			return dXML;
		}

		/**
		 *
		 * @param className ( like flash.display.Sprite)
		 * @return Array
		 */
		public static function getConstsListOfClass( value : Class ) : Array {
			curClass = value;
			var dXML : XML = getDescribeXML( true );
			var constList : Array = [];
			if ( dXML ) {
				for each ( var xml : XML in dXML.constant ) {
					constList.push( xml.@name );
				}
			}
			return constList
		}

		/**
		 *
		 * @param className
		 * @param type
		 * @param classLevel
		 * @return array with names
		 */
		public static function getNamesOf( value : *, type : String, classLevel : int = -1 ) : Array {
			_fullClassName = getQualifiedClassName( value );
//			_object = value;

			var result : Array = [];
			var dXML : XML = describeType( value );
			if ( dXML.hasOwnProperty( "factory" )) {
				dXML = dXML.factory[0];
			}
			var items : XMLList = dXML.child( type );
//			inf( _fullClassName, dXML );
			var filterLevel : String;
			var nameValue : String = "";
			if ( classLevel == -1 ) {
				filterLevel = _fullClassName;
			} else {
				filterLevel = dXML.child( TYPE_EXTENDS_CLASS )[classLevel];
			}
//			inf( filterLevel, filterLevel );
			for each ( var xml : XML in items ) {
				nameValue = "";
//				debug( type + " xml", xml );
				if ( !xml.hasOwnProperty( "@declaredBy" ) || ( xml.hasOwnProperty( "@declaredBy" ) && xml.@declaredBy == filterLevel )) {
					nameValue = xml.@name;
				}
				if ( nameValue != "" ) {
					result.push( nameValue );
				}
			}
//			debug( "result", result );
			return result;
		}

		static public function getClassExtendsList( value : Class ) : Array {
			var result : Array = [];
			var dXML : XML = describeType( value );
			if ( dXML.hasOwnProperty( "factory" )) {
				dXML = dXML.factory[0];
			}
			var items : XMLList = dXML.child( TYPE_EXTENDS_CLASS );

			for each ( var item : XML in items ) {
				result.push( item.@type );
			}

			return result;
		}

		static public function checkClassExtended( value : Class, classForCheck : Class ) : Boolean {
			var exList : Array = getClassExtendsList( value );
			if ( exList && exList.length > 0 ) {
				for each ( var extendClassName : String in exList ) {
					if ( extendClassName == getQualifiedClassName( classForCheck )) {
						return true;
					}

				}
			}

			return false
		}
	}
}