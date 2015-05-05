/**
 * @author vnz
 */
package vnz.data
{
	import flash.display.*;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.*;

	public class LibSWFLoader extends EventDispatcher
	{
		public static var LIB_LOADED : String = "lib_loaded";
		public static var LOAD_ERROR : String = "load_error";
		private var loader : Loader;
		private var url : String;
		private var _isLoaded : Boolean = false;

		public function get swfLib() : MovieClip
		{
			var result : MovieClip;
			if ( _isLoaded )
			{
				result = loader.content as MovieClip;
			}
			return result;
		}

		public function LibSWFLoader( swfURL : String = "null" )
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, completeHandler );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			if ( swfURL != "null" )
			{
				load( swfURL );
			}
		}

		public function load( swfURL : String ) : void
		{
			url = swfURL;
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = new ApplicationDomain();
			loader.load( new URLRequest( swfURL ), context );
		}

		public function getClass( className : String ) : Class
		{
			if ( _isLoaded )
			{
				if ( loader.contentLoaderInfo.applicationDomain.hasDefinition( className ))
				{
					return loader.contentLoaderInfo.applicationDomain.getDefinition( className ) as Class;
				}
			}
//			try
//			{
//				return loader.contentLoaderInfo.applicationDomain.getDefinition( className ) as Class;
//			} catch ( e : Error )
//			{
////				throw new IllegalOperationError( className + " definition not found in " + url );
//			}
			return null;
		}

		private function completeHandler( e : Event ) : void
		{
			if ( loader.contentLoaderInfo.contentType == "application/x-shockwave-flash" )
			{
				_isLoaded = true;
				dispatchEvent( new Event( LIB_LOADED ));
			} else
			{
				dispatchError();
			}
		}

		private function ioErrorHandler( e : Event ) : void
		{
			dispatchError();
		}

		private function securityErrorHandler( e : Event ) : void
		{
			dispatchError()
		}

		private function dispatchError() : void
		{
			_isLoaded = false;
			var newEvent : Event = new Event( LOAD_ERROR );
			dispatchEvent( newEvent );
		}

	}
}

