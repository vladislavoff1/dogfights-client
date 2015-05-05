/**
 * @author vnz
 */
package vnz.data
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;

	[Event( name="mediaLoaded",type="vnz.data.MediaLoader" )]
	[Event( name="loadError",type="vnz.data.MediaLoader" )]

	public class MediaLoader extends EventDispatcher
	{
		public static const MEDIA_LOADED : String = "mediaLoaded";
		public static const LOAD_ERROR : String = "loadError";
		public static const MEDIA_TYPE_SWF : String = "swf";
		public static const MEDIA_TYPE_BITMAP : String = "bitmap";
		private var _isLoaded : Boolean = false;
		private var _isError : Boolean = false;
		private var _isLoading : Boolean = false;
		private var _loader : Loader;
		private var _media : DisplayObject; //read-only
		private var _url : String;
		/** swf or bitmap(read-only) */
		private var _mediaType : String;

		public function get mediaType() : String
		{
			return _mediaType;
		}

		public function get media() : DisplayObject
		{
			return _media;
		}

		public function get loaderInfo() : LoaderInfo
		{
			return _loader.contentLoaderInfo;
		}

		public function get mediaURL() : String
		{
			return _url;
		}

		public function get isLoading() : Boolean
		{
			return _isLoading;
		}

		public function MediaLoader()
		{
			initLoader();
		}

		private function initLoader() : void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
		}

		public function load( url : String ) : void
		{
			_url = url;
			if (( !_url ) || ( _url == "" ))
			{
				dispatchError();
				return;
			}
			initNewLoad();
//			trace("[INFO] init loading new file from URL: " + _url);
			_loader.load( new URLRequest( _url ), new LoaderContext( true ));
			_isLoading = true;
		}

		private function initNewLoad() : void
		{
			try
			{
				_loader.unload();
			} catch ( error : Error )
			{

			}
			clear();
		}

		private function loadComplete( event : Event ) : void
		{
//			trace(_media is Sprite);
//			trace(_media is MovieClip);
//			trace(_media is DisplayObject);
//			trace("is bitmap: " + _media is Bitmap);
//			trace("contentType: " + _loader.contentLoaderInfo.contentType);			
//			trace("url2: " + _loader.contentLoaderInfo._url);
//			try {
			if ( _loader.contentLoaderInfo.contentType == "application/x-shockwave-flash" )
			{
				_mediaType = MEDIA_TYPE_SWF;
//				trace("swf loaded | version AS : " + _loader.contentLoaderInfo.actionScriptVersion);
				_media = _loader.content;
//				_loader.unload();
//				_media = _loader;
			} else
			{
				_mediaType = MEDIA_TYPE_BITMAP;
				_media = _loader.content as Bitmap;
			}
			_isLoading = false;
			afterMediaLoaded();
		}

		private function afterMediaLoaded() : void
		{
			_isLoaded = true;
			var e : Event = new Event( MediaLoader.MEDIA_LOADED );
			dispatchEvent( e );
		}

		private function ioErrorHandler( event : IOErrorEvent ) : void
		{
			trace( "ZMediaLoader: IOError on load media file from url: " + _url );
			event.stopPropagation();
			dispatchError();
		}

		private function securityErrorHandler( event : SecurityErrorEvent ) : void
		{
			trace( "ZMediaLoader: security Error on load media file from url: " + _url );
			event.stopPropagation();
			dispatchError();
		}

		private function dispatchError() : void
		{
			_isLoaded = false;
			var newEvent : Event = new Event( MediaLoader.LOAD_ERROR );
			dispatchEvent( newEvent );
		}

		private function onProgress( event : ProgressEvent ) : void
		{
			//debug("ZMediaLoader: " + event.bytesLoaded/1024/1024 + " of " + event.bytesTotal/1024/1024);
			dispatchEvent( event );
		}

		public function close() : void
		{
			_url = "";
			clear();
			try
			{
				_loader.close();
			} catch ( e : Error )
			{
				//
			}
		}

		private function clear() : void
		{
			_isLoaded = false;
			_media = null;

		}

	}

}
