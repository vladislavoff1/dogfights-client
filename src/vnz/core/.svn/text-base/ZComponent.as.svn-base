/**
 * @author vnz
 */
package vnz.core
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.utils.*;

	import vnz.events.*;

	public class ZComponent extends ZSprite
	{
		static public const ELEMENT_STATUS_NEW : String = "element_status_new";
		static public const ELEMENT_STATUS_INIT_COMPLETED : String = "element_status_init_completed";
		static public const ELEMENT_STATUS_ADDED : String = "element_status_added";
		static public const ELEMENT_STATUS_DESTROYED : String = "element_status_destroyed";

		protected var _status : String;
		protected var _enabled : Boolean = true;
		protected var _width : uint = 0;
		protected var _height : uint = 0;
		private var _unscrollWidth : uint = 0;
		private var _unscrollHeight : uint = 0;
		protected var startWidth : uint = 0;
		protected var startHeight : uint = 0;
		private var invalidated : Boolean = false;

		/////////////////////////////////////////
		//getter setter
		////////////////////////////////////////
		public function get status() : String
		{
			var result : String = _status;
			return result;
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			if ( value == _enabled )
			{
				return;
			}
			_enabled = value;
		}

		override public function get width() : Number
		{
			return _width;
		}

		override public function set width( value : Number ) : void
		{
			if ( _width == value )
			{
				return;
			}
			setSize( value, height );
		}

		override public function get height() : Number
		{
			return _height;
		}

		override public function set height( value : Number ) : void
		{
			if ( _height == value )
			{
				return;
			}
			setSize( width, value );
		}

		/////////////////////////////////////////		
		//constructor
		/////////////////////////////////////////

		public function ZComponent()
		{
			super();
			_status = ELEMENT_STATUS_NEW;
			config();
			preinitUI();
		}

		/**
		 * init method
		 */
		private function config() : void
		{
			rotation = 0;
			super.scaleX = super.scaleY = 1;
//			setSize( startWidth, startHeight );
			_status = ELEMENT_STATUS_INIT_COMPLETED;
			addEventListener( ZComponentEvent.RESIZE, firstResizeHandler, false, 0, true );
			addEventListener( Event.ADDED_TO_STAGE, onAdded, false, 0, true );
		}

		protected function preinitUI() : void
		{

		}

		/**
		 * @param
		 */
		private function onAdded( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			configOnAdded();
			_status = ELEMENT_STATUS_ADDED;
		}

		/**
		 * use in descendants
		 * override method
		 */
		protected function configOnAdded() : void
		{
			//override method
		}

		public function setSize( w : uint, h : uint ) : void
		{
			_width = w;
			_height = h;
			draw();
			dispatchEvent( new ZComponentEvent( ZComponentEvent.RESIZE, false ));
		}

		public function move( x : Number, y : Number ) : void
		{
			this.x = x;
			this.y = y;
			dispatchEvent( new ZComponentEvent( ZComponentEvent.MOVE ));
		}

		protected function draw() : void
		{
			//draw should call when need update view
		}

		private function firstResizeHandler( event : Event ) : void
		{
			removeEventListener( ZComponentEvent.RESIZE, firstResizeHandler );
			startWidth = _width;
			startHeight = height;
		}

		/**
		 * @param
		 */
		protected function invalidate() : void
		{
			if ( !invalidated )
			{
				addEventListener( Event.ENTER_FRAME, onInvalidate );
				invalidated = true;
			}
		}

		/**
		 * @param
		 */
		private function onInvalidate( event : Event ) : void
		{
			removeEventListener( Event.ENTER_FRAME, onInvalidate );
			draw();
			invalidated = false;
		}

//		override public function set scrollRect( value : Rectangle ) : void
//		{
//			_unscrollWidth = _width;
//			_unscrollHeight = _height;
//			super.scrollRect = value;
//		}

	}
}
