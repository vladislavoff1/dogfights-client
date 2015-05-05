/**
 * @author vnz
 */
package vnz.data
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import logging.warn;

	public class XMLLoader extends URLLoader
	{
		public static const XML_LOADED : String = "xmlLoaded";
		public var xmlData : XML;
		private var xmlURL : String;

		public function XMLLoader()
		{
			addEventListener( Event.COMPLETE, onLoadComplete );
			addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			addEventListener( IOErrorEvent.IO_ERROR, onError );

		}

		public function loadXML( URL : String, nocache : Boolean = true ) : void
		{
			if ( nocache )
			{
				this.xmlURL = URL + "?" + Math.round( Math.random() * 5000 );
			}
			this.xmlURL = URL;
			var request : URLRequest = new URLRequest( xmlURL );
			load( request );
		}

		override public function load( request : URLRequest ) : void
		{
			xmlURL = request.url;
			super.load( request );
		}

		private function onLoadComplete( event : Event ) : void
		{
			try
			{
				xmlData = XML( this.data );
				dispatchEvent( new Event( XML_LOADED ));
			} catch ( error : Error )
			{
				onLoadError( "error when try load" );
			}
		}

		private function onSecurityError( event : SecurityErrorEvent ) : void
		{
			this.onLoadError( event.text );
		}

		private function onError( event : IOErrorEvent ) : void
		{
			this.onLoadError( event.text );
		}

		private function onLoadError( errorText : String ) : void
		{
			warn( "XMLLoader error on load " + xmlURL + " errorText: " + errorText );
		}

	}
}
