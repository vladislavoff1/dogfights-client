package by.vnz.framework.dragdrop {

	import by.vnz.framework.events.DragEvent;
	import by.vnz.framework.view.core.MessageDispatcher;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;

import logger.Logger;

import vnz.utils.CopyMaker;

	public class DragManager extends MessageDispatcher {
		static public var isDragging : Boolean = false;

		static private var _instance : DragManager;
		static private var _dragInitiator : EventDispatcher;
		static private var _dragImage : Bitmap;
		static private var _dragData : Object;
		static private var _offset : Point = new Point();
		static private var _targetsList : Array;

		public function DragManager() {
			super();

			if ( !_instance ) {
				_instance = this;
				_instance.addEventListener( Event.ADDED_TO_STAGE, addedHandler );
			}

			mouseEnabled = false;
			mouseChildren = false;

			reset();
		}


		public function get position() : Point {
			var point : Point = new Point( _dragImage.x, _dragImage.y );

			return point;
		}

		private function addedHandler( event : Event ) : void {
			graphics.clear();
			graphics.beginFill( 0xff0000, 0 );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
		}


		static public function reset() : void {
//			debug( "dragManager reset", numChildren, Logger.DC_3 );
			while ( _instance.numChildren > 0 ) {
				_instance.removeChildAt( 0 );
			}
			_dragImage = null;
			_targetsList = [];
			isDragging = false;
		}


		static public function cancelDrag() : void {
//			debug( "cancelMoveItems", _dragSite, Logger.DC_3 );
			if ( _dragImage ) {
				_dragImage.visible = false;
			}
			contextUnfix();
			reset();
		}


		static private function contextFix() : void {
			var aMenu : ContextMenu;

			aMenu = new ContextMenu();
			aMenu.addEventListener( ContextMenuEvent.MENU_SELECT, onContext, false, 0, true );

			_instance.parent.contextMenu = aMenu;
		}


		static private function contextUnfix() : void {
			if ( _instance.parent != null ) {
				_instance.parent.contextMenu = null;
			}
		}

		static private function onContext( event : ContextMenuEvent ) : void {
			onDestination( null );
		}

		static public function get draggingObject() : Object {
			return _dragData;
		}

		static public function doDrag( dragInitiator : EventDispatcher, dragData : Object, dragImage : Bitmap, offset : Point = null, imageAlpha : Number = 0.5 ) : void {
			if ( isDragging || !dragInitiator ) {
				return;
			}
			_dragInitiator = dragInitiator;
			_dragData = dragData;
			_dragImage = dragImage;
			if ( !_dragImage ) {
				if ( _dragData is DisplayObject ) {
					_dragImage = CopyMaker.getBitmapCopy( _dragData as DisplayObject );
				} else if ( _dragInitiator is DisplayObject ) {
					_dragImage = CopyMaker.getBitmapCopy( _dragInitiator as DisplayObject );
				}
			}
			_dragImage.alpha = imageAlpha;
			_instance.addChild( _dragImage );

			if ( offset ) {
				_offset.x = offset.x;
				_offset.y = offset.y;
			}
//			_offsetPos = _dragImage.width / 2;

			_instance.stage.addEventListener( MouseEvent.MOUSE_MOVE, onDragging, false, 0, true );
			_instance.stage.addEventListener( MouseEvent.MOUSE_UP, onDestination, false, 0, true );

			isDragging = true;
			dispatchDragEvent( DragEvent.DRAG_START, _dragInitiator );
			onDragging( null );
			contextFix();

		}


		static private function onDragging( event : MouseEvent ) : void {
			if ( !_dragImage ) {
				return;
			}
			_dragImage.x = _instance.mouseX - _offset.x;
			_dragImage.y = _instance.mouseY - _offset.y;

			dispatchDragEvent( DragEvent.DRAG_ENTER, _dragInitiator );
		}
                                                 
		static private function onDestination( event : MouseEvent ) : void {
            debug("DragManager", "onDestination", Logger.DC_3);
			_instance.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onDragging );
			_instance.stage.removeEventListener( MouseEvent.MOUSE_UP, onDestination );

			var target : DisplayObject;
			for each ( var item : DisplayObject in _targetsList ) {
				if ( checkDrop( item )) {
					target = item;
					break;
				}
			}
			dispatchDragEvent( DragEvent.DROP_REQUEST, target );

			reset();
		}

		static private function dispatchDragEvent( type : String, dispatcher : EventDispatcher = null ) : void {
			var dadEvent : DragEvent = new DragEvent( type );
			dadEvent.dragData = _dragData;
			dadEvent.dragInitiator = _dragInitiator;
			if ( !dispatcher ) {
				_instance.dispatchEvent( dadEvent );
			} else {
				dispatcher.dispatchEvent( dadEvent );
			}
		}

		static private function checkDrop( target : DisplayObject ) : Boolean {
			var result : Boolean;

			var point : Point;
			var objectsList : Array;

			point = new Point( _instance.stage.mouseX + _offset.x, _instance.stage.mouseY + _offset.y );
//			point = _instance.localToGlobal( _offset );

			result = target.hitTestPoint( point.x, point.y, true );

			return result;
		}

		static public function acceptDragDrop( targetsList : Array ) : void {

			for each ( var item : Object in targetsList ) {
				if ( item is DisplayObject ) {
					_targetsList.push( item );
				}
			}
		}
	}
}
