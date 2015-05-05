package by.vnz.framework.view {
	import by.vnz.framework.dragdrop.DragManager;
	import by.vnz.framework.audio.SoundsManager;
	import by.vnz.framework.view.core.BaseElement;
	import by.vnz.framework.view.elements.DialogsLayer;
	import by.vnz.framework.view.elements.HintLayer;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import logger.Logger;

	import vnz.debug.DebugPanel;

	public class MainView extends BaseElement { //BaseElement
		static private const BASE_LAYERS_NUMBER : uint = 4;
		/**
		 * current flash client version
		 */
		static public var CURRENT_VERSION : String = "";

        static public var BOUNDS_WIDTH : uint = 300;
        static public var BOUNDS_HEIGHT : uint = 300;
		//controller
//		private var eventsMap : EventsMap;
        
		//main layers
		protected var debugPanel : DebugPanel;
		protected var dialogsLayer : DialogsLayer;
		protected var hintLayer : HintLayer;
		protected var dragManager : DragManager;
		protected var soundsManager : SoundsManager;

		public function MainView() {
			super();
		}

		override protected function preinitUI() : void {
			super.preinitUI();
//			_childrenBox = new Sprite();
//			super.addChild( _childrenBox );

			soundsManager = new SoundsManager();
			super.addChild( soundsManager );
			soundsManager.attachTo( this );

			dialogsLayer = new DialogsLayer(); // width={stage.stageWidth} height={stage.stageHeight} 
			super.addChild( dialogsLayer );
			listenElement( dialogsLayer );
			dialogsLayer.attachTo( this );

			dragManager = new DragManager();
			super.addChild( dragManager );

			debugPanel = new DebugPanel();
			super.addChild( debugPanel );
			Logger.externalLogMethod = debugPanel.log;

		}

		override public function addChild( child : DisplayObject ) : DisplayObject {
			var result : DisplayObject;
			result = addChildAt( child, ( numChildren - BASE_LAYERS_NUMBER ));
//			result = _childrenBox.addChild( child );
			return result;
		}

//		protected function removeChildSafely( child : DisplayObject ) : DisplayObject {
//			
//		}
	}
}