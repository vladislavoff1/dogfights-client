package vnz.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	import logging.inf;
	import logging.logger.Logger;

	import vnz.data.LibSWFLoader;

	public class SWFUIParser extends EventDispatcher
	{
		private var _loader : LibSWFLoader;
		private var _UIXML : XML;
		private var _basePropsList : Array = ["name", "width", "height", "x", "y"]; //, "scaleX", "scaleY"];
		private var _textFieldProp : Array = ["text", "multiline", "defaultTextFormat"]; //"selectable",
		private var _textFormatProp : Array = ["size", "align", "color", "bold"]; //"font", "underline", "italic"
		//"backgroundColor", "embedFonts", "maxChars", 	"background", "border", "selectable", "displayAsPassword", "antiAliasType", "restrict"
		private var _customParseList : Array = ["MovieClip", "Sprite", "TextField", "ImageProxy", "ButtonProxy", "Scale9Proxy"];

		private var _functionOnResult : Function = null;

		public function SWFUIParser()
		{
			Logger.enableDebugTraces = true;

//			loadTestSWF();
		}

		public function get UIxml() : XML
		{
			var result : XML = _UIXML;
			return result;
		}

		public function loadTestSWF( functionOnResult : Function ) : void
		{
			_functionOnResult = functionOnResult;
			_loader = new LibSWFLoader();
//			_loader.load( "../temp/lib1.swf" );
			_loader.load( "../debug/resources/modules/HeroCustomizer.swf" );
//			_loader.load( "../temp/battle.swf" );
			_loader.addEventListener( LibSWFLoader.LIB_LOADED, loader_loadedHandler );
		}

		private function loader_loadedHandler( event : Event ) : void
		{
			var swf : MovieClip = _loader.swfLib;

			parseSWF( swf );

		}

		public function parseSWF( swf : MovieClip ) : XML
		{
			_UIXML = <ui width="0" height="0"></ui>;
			if ( !swf )
			{
				return _UIXML;
			}
			_UIXML.@width = swf.width;
			_UIXML.@height = swf.height;
			//start recursion parse children
			getChildren( swf, _UIXML );

			inf( "xml", _UIXML );

			if ( _functionOnResult != null )
			{
				_functionOnResult( _UIXML );
			}
			return _UIXML;
		}

		private function getChildren( clip : DisplayObjectContainer, parentXML : XML ) : void
		{
			var child : DisplayObject;
			var childXML : XML = new XML();
			for ( var i : uint = 0; i < clip.numChildren; i++ )
			{
				child = clip.getChildAt( i );
				var classStr : String = getObjectType( child );
				if ( classStr != "Shape" ) // && classStr != "StaticText" )
				{
					childXML = describeChild( child );
				}
				if ( child is DisplayObjectContainer )
				{
					getChildren( child as DisplayObjectContainer, childXML );
				}
				parentXML.appendChild( childXML );
			}
		}

		private function describeChild( child : DisplayObject ) : XML
		{
			var result : XML = new XML();
			var prop : String;
			var propValue : *;

			var childProp : Array = getObjectPropsList( child );

			var tstr : String = "";
			tstr = '<child ';
			tstr += ' class="' + getObjectType( child ) + '"';
			for each ( prop in childProp )
			{
				if ( prop != "defaultTextFormat" )
				{
					if ( child.hasOwnProperty( prop ))
					{
						propValue = child[prop];
						if ( prop == "x" || prop == "y" || prop == "width" || prop == "height" )
						{
							propValue = int( propValue );
						}

						tstr += prop + '="' + propValue + '"';
					}
				} else
				{
					for each ( var fProp : String in _textFormatProp )
					{
						tstr += fProp + '="' + child["defaultTextFormat"][fProp] + '"';
					}
				}
			}
			tstr += " />";
			result = new XML( tstr );
			return result;
		}

		public function getClassName( ob : Object ) : String
		{
			var result : String;
			var objType : String = getObjectType( ob );
			var className : String = getQualifiedClassName( ob );
			if (( objType == className ) || ( className.indexOf( "_fla" ) != -1 ))
			{
				result = getQualifiedSuperclassName( ob );
			} else
			{
				result = className;
			}
			return result;
		}

		private function getObjectPropsList( ob : Object ) : Array
		{
			var result : Array = [];
			var objType : String = getObjectType( ob );
//			if ( _customParseList.indexOf( objType ) == -1 )
//			{
//
//				result = Describer.getNamesOf( ob, Describer.TYPE_ACCESSOR )
//			} else
//			{
			switch ( objType )
			{
				case "TextField":
					result = _textFieldProp;
					break;
				case "MovieClip":
				case "Sprite":
					result = [];
					break;
				case "Scale9Proxy":
					result.push( "grid" );
				case "ImageProxy":
				case "ButtonProxy":
					result.push( "resource" );
					break;
			}
//			}
			var fullPropList : Array = [];
			for each ( var prop : String in result )
			{
				if ( _basePropsList.indexOf( prop ) == -1 )
				{
					fullPropList.push( prop );
				}
			}
			result = _basePropsList.concat( fullPropList );
			return result;
		}

		private function getObjectType( obj : Object ) : String
		{
			var result : String = obj.toString();
			result = result.substring( 8, result.length - 1 );
			return result;
		}

	}
}