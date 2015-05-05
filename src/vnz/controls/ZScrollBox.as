/**
 * @author vnz
 */
package vnz.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;

	import logging.debug;
	import logging.logger.Logger;

	import vnz.core.ZComponent;
	import vnz.core.ZSprite;

	public class ZScrollBox extends ZComponent
	{
		public static var LIST_EMPTY : String = "list_empty";
		protected var itemsBox : ZSprite = new ZSprite();
		public var scrollBar : ZScrollBar = new ZScrollBar();

		private var _nextRecordPos : uint = 0;
		private var _gap : uint = 0;
		private var selectedItem : DisplayObject;

		public function get gap() : uint
		{
			var result : uint = _gap;

			return result;
		}

		public function set gap( value : uint ) : void
		{
			_gap = value;
			updatePositions();
		}

		public function ZScrollBox()
		{
			super();
		}

		override protected function preinitUI() : void
		{
			addChild( itemsBox );
			addChild( scrollBar );
			scrollBar.visible = false;

		}

		override protected function draw() : void
		{
			if ( itemsBox )
			{
				var newScrollRect : Rectangle = itemsBox.scrollRect ? itemsBox.scrollRect : new Rectangle();
				if ( !itemsBox.scrollRect || itemsBox.scrollRect.width != this.width || itemsBox.scrollRect.height != this.height )
				{
					newScrollRect.width = this.width;
					newScrollRect.height = this.height;
					itemsBox.scrollRect = newScrollRect;
//					debug( "update scrollRect", newScrollRect );
				}
			}
			//set scrollBar if need
			if ( !scrollBar.hasTarget && itemsBox.scrollRect && itemsBox.scrollRect.height > 0 )
			{
				scrollBar.attachTo( itemsBox );
				scrollBar.x = this.width;
				scrollBar.visible = true;
			}

			var newHeight : uint = _nextRecordPos > itemsBox.height ? _nextRecordPos : itemsBox.height;
			scrollBar.changeTargetSize( newHeight );
//			debug( "itemsBox", itemsBox );
		}

		public function addItem( item : DisplayObject ) : void
		{
//			debug( "addItem", item, Logger.DC_2 );

			itemsBox.addChild( item );
			setItemPos( item );
			invalidate();
		}

		//update y position
		private function updatePositions() : void
		{
			_nextRecordPos = 0;
			for ( var i : Number = 0; i < itemsBox.numChildren; i++ )
			{
				var item : DisplayObject = itemsBox.getChildAt( i );
				setItemPos( item );
			}
			invalidate();
		}

		private function setItemPos( item : DisplayObject ) : void
		{
			if ( item )
			{
				item.y = _nextRecordPos;
				_nextRecordPos = item.y + item.height + gap;
			}
		}

		public function deleteItem( item : DisplayObject ) : void
		{
			if ( item && itemsBox.parent == itemsBox )
			{
				itemsBox.removeChild( item );
			}
			if ( itemsBox.numChildren == 0 )
			{
				var event : Event = new Event( ZScrollBox.LIST_EMPTY );
				dispatchEvent( event );
			}
			updatePositions();
		}

		public function clear() : void
		{
//			debug( this, "clear" );
			itemsBox.removeChildren11();
			updatePositions();
			scrollBar.resetToZeroPos();
		}

	}
}
