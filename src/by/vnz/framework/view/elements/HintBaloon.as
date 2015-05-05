package by.vnz.framework.view.elements {
	import by.vnz.framework.events.HintBubble;
	import by.vnz.framework.view.components.Scale9Proxy;
	import by.vnz.framework.view.core.GUIElement;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;

	import vnz.text.ZTextField;

	public class HintBaloon extends GUIElement {
		static public const ALIGN_RIGHT_BOTTOM : String = ALIGN_RIGHT + ALIGN_BOTTOM;
		static public const ALIGN_LEFT_BOTTOM : String = ALIGN_LEFT + ALIGN_BOTTOM;
		static public const ALIGN_RIGHT_TOP : String = ALIGN_RIGHT + ALIGN_TOP;
		static public const ALIGN_LEFT_TOP : String = ALIGN_LEFT + ALIGN_TOP;

		static public const ALIGN_BOTTOM : String = "+bottom";
		static public const ALIGN_RIGHT : String = "+right";
		static public const ALIGN_LEFT : String = "+left";
		static public const ALIGN_TOP : String = "+top";

		private var hintAlign : String;
		private var hintText : String;

		private var ContentObject : DisplayObject;
		public var MessageText : TextField;
		public var BagRound : Scale9Proxy;

		private var BagTainer : MovieClip;

		public function HintBaloon() {
			super();

			constructComponent();

			mouseEnabled = false;
			mouseChildren = false;

			BagTainer = new MovieClip();

			BagTainer.addChild( BagRound );
			addChildAt( BagTainer, 0 );

			ContentObject = MessageText;
		}

		/**
		 * @param
		 */
		private function constructComponent() : void {
			BagRound = new Scale9Proxy();

			BagRound.width = 87;
			BagRound.height = 74;
			BagRound.resource = "ui.hint.bg";
			BagRound.grid = [20, 20, 54, 41];

			addChild( BagRound );

			MessageText = ZTextField.create({leading:-3, align:"center"});

			// Дебаг.
			//MessageText.border = true;

			MessageText.multiline = true;
			MessageText.wordWrap = true;
			MessageText.width = 300;
			MessageText.height = 62;
			MessageText.x = 20;
			MessageText.y = 20;
			MessageText.condenseWhite = true;

			addChild( MessageText );
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			try {
				BagTainer.removeChild( BagRound );
			} catch ( error : Error ) {
			}

			MessageText = null;
			BagTainer = null;
			BagRound = null;

			super.destroy();
		}

		/**
		 *
		 * Сеттер.
		 */
		public function set content( source : * ) : void {
			//inf("Hint source: " + source);

			if ( source is String ) {
				hintText = source as String;

				if ( MessageText != null ) {
					MessageText.width = 400;
					MessageText.htmlText = hintText;

					MessageText.width = Math.round( MessageText.textWidth + 5 );
					MessageText.height = Math.round( MessageText.textHeight + 10 );

					redraw();
				}
			}

			if ( source is DisplayObject ) {
				MessageText.visible = false;

				ContentObject = source as DisplayObject;
				ContentObject.addEventListener( Event.RESIZE, onResize );

				addChild( ContentObject );
			}
		}

		/**
		 * @param
		 */
		private function onResize( event : Event ) : void {
			redraw();
		}

		/**
		 *
		 * Сеттер.
		 */
		public function set align( value : String ) : void {
			// Код сеттера.
			switch ( value ) {
				case ALIGN_RIGHT_BOTTOM:
				case ALIGN_LEFT_BOTTOM:
				case ALIGN_RIGHT_TOP:
				case ALIGN_LEFT_TOP: {
					break;
				}

				default: {
					value = ALIGN_LEFT_TOP;
					break;
				}
			}

			hintAlign = value;

			redraw();
		}

		/**
		 * @param
		 */
		override protected function redraw() : void {
			switch ( hintAlign ) {
				case ALIGN_RIGHT_BOTTOM:
				case ALIGN_RIGHT_TOP: {
					BagTainer.scaleX = -1;
					ContentObject.x = -20 - ContentObject.width;
					break;
				}

				case ALIGN_LEFT_BOTTOM:
				case ALIGN_LEFT_TOP: {
					BagTainer.scaleX = 1;
					ContentObject.x = 20;
					break;
				}
			}

			switch ( hintAlign ) {
				case ALIGN_RIGHT_BOTTOM:
				case ALIGN_LEFT_BOTTOM: {
					BagTainer.scaleY = -1;
					ContentObject.y = -20 - ContentObject.height;
					break;
				}

				case ALIGN_RIGHT_TOP:
				case ALIGN_LEFT_TOP: {
					BagTainer.scaleY = 1;
					ContentObject.y = 20;
					break;
				}
			}

			BagRound.height = 20 + 13 + ContentObject.height;
			BagRound.width = 20 + 13 + ContentObject.width;
		}

		/**
		 * @param
		 */
		static public function show( target : DisplayObject, source : * = null, localX : Number = 0, localY : Number = 0 ) : void {
			if ( !target ) {
				return;
			}
			var anEvent : HintBubble;
			var aPoint : Point;

			aPoint = new Point( localX, localY );
			aPoint = target.localToGlobal( aPoint );

			anEvent = new HintBubble();

			anEvent.globalX = aPoint.x;
			anEvent.globalY = aPoint.y;
			anEvent.data = source;

			target.dispatchEvent( anEvent );
		}

		static public function hide( target : DisplayObject ) : void {
			if ( !target ) {
				return;
			}
			var anEvent : HintBubble = new HintBubble( HintBubble.HIDE_HINT );
			target.dispatchEvent( anEvent );
		}

	}
}
