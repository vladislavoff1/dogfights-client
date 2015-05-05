package by.vnz.framework.view.elements {
	import by.vnz.framework.VO.DialogWindowVO;
	import by.vnz.framework.events.SimpleMessage;
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.components.SimpleButtonProxy;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.framework.view.core.MessageDispatcher;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	public class DialogWindow extends GUIElement {
		static public const MESSAGE_CONFIRM : String = "dialog.message.confirm";
		static public const MESSAGE_CANCEL : String = "dialog.message.cancel";
		static public const MESSAGE_REDRAW : String = "dialog.message.redraw";
		static public const MESSAGE_AUTO_CLOSE : String = "message_auto_close";

		static public const BUTTON_NONE : int = 0;
		static public const BUTTON_CONFIRM : int = 1;
		static public const BUTTON_CANCEL : int = 2;

		static private const CONTENT_PADDING_TOP : int = 10;
		static private const CONTENT_PADDING_LEFT : int = 14;
		static private const CONTENT_MIN_WIDTH : int = 180;
		static private const MARGIN_AFTER_CONTENT : uint = 10;

		private var _autoCloseTimer : Timer;
		private var _allowButtons : uint = BUTTON_NONE;
		private var onlyButton : Sprite;
		private var noButtons : Boolean;
		public var ID : uint;

		private var _data : DialogWindowVO;
		private var ContentObject : DisplayObject = null;
		//UI elements
		public var BG : ImageProxy;
		public var btnCancel : SimpleButtonProxy;
		public var btnConfirm : SimpleButtonProxy;
//		public var TitleText : TextField;
		public var txtMessage : TextField;

		public var messageConfirm : String;
		public var messageCancel : String;
		public var messageRedraw : String;

		public function DialogWindow() {
			super();
			messageConfirm = MESSAGE_CONFIRM;
			messageCancel = MESSAGE_CANCEL;
			messageRedraw = MESSAGE_REDRAW;

			_autoCloseTimer = new Timer( 0, 1 );
			_autoCloseTimer.addEventListener( TimerEvent.TIMER_COMPLETE, timerEventHandler );
		}

		public function get data() : DialogWindowVO {
			var result : DialogWindowVO = _data;

			return result;
		}

		public function set data( value : DialogWindowVO ) : void {
			if ( !value || _data == value ) {
				return;
			}
			_data = value;
			_data.addEventListener( Event.CHANGE, dataChangeHandler );
			dataChangeHandler( null );
		}

		public function dataChangeHandler( event : Event ) : void {
			if ( !isGUIReady || !_data ) {
				return;
			}
			this.ID = data.ID;
			if ( _data.content ) {
				this.content = _data.content;
			} else {
				this.text = _data.text;
			}
			if ( _data.messageConfirm ) {
				this.messageConfirm = _data.messageConfirm;
			}
			if ( _data.messageCancel ) {
				this.messageCancel = _data.messageCancel;
			}
			this.allowButtons( _data.allowButtons );

			if ( data.autoCloseTime > 0 ) {
				_autoCloseTimer.reset();
				_autoCloseTimer.delay = data.autoCloseTime;
				_autoCloseTimer.start();
			}

		}

		override protected function initUI() : void {
			createUIChild( ImageProxy, <ui name="BG" resource="dialogs_bg" x="0" y="0" /> );

			createUIChild( TextField, <ui name="txtMessage" width="220" height="80" x="50" y="60" multiline="true" font="Calibri" size="18" color="0xffffff" bold="true" align="center" /> );
			txtMessage.autoSize = TextFieldAutoSize.CENTER;

			createUIChild( SimpleButtonProxy, <ui name="btnConfirm" resource="btn_ok"  x="26" y="140" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnCancel" resource="btn_cancel" x="145" y="140" /> );

			super.initUI();

			dataChangeHandler( null );
		}

		override protected function initUICompleted() : void {

			btnCancel.addEventListener( MouseEvent.CLICK, onCancel, false, 0, true );
			btnConfirm.addEventListener( MouseEvent.CLICK, onConfirm, false, 0, true );

			if ( !ContentObject ) {
				ContentObject = txtMessage;
			}
			initContent();

			visible = false;

			showButtons();

			super.initUICompleted();
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			btnConfirm.removeEventListener( MouseEvent.CLICK, onConfirm );
			btnCancel.removeEventListener( MouseEvent.CLICK, onCancel );

			ContentObject.removeEventListener( Event.RESIZE, contentResize );

			ContentObject = null;
			onlyButton = null;

			super.destroy();
		}

		/**
		 * @param
		 */
		public function allowButtons( value : int ) : void {
			_allowButtons = value;
			if ( isGUIReady ) {
				showButtons();
			}
		}

		private function showButtons() : void {
			btnConfirm.visible = (( _allowButtons & BUTTON_CONFIRM ) == BUTTON_CONFIRM );
			btnCancel.visible = (( _allowButtons & BUTTON_CANCEL ) == BUTTON_CANCEL );

			if ( _allowButtons == BUTTON_CONFIRM ) {
				onlyButton = btnConfirm;
			} else if ( _allowButtons == BUTTON_CANCEL ) {
				onlyButton = btnCancel;
			} else {
				onlyButton = null;
			}

			noButtons = ( _allowButtons == BUTTON_NONE );

			invalidate();
		}

		/**
		 *
		 * Геттер/сеттер.
		 */
		public function get text() : String {
			var result : String;

			// Код геттера.
			result = txtMessage.htmlText;

			return ( result );
		}

		public function set text( value : String ) : void {
			// Код сеттера.
			value = value.split( "\r\n" ).join( "<br />" );
			value = value.split( "\n\r" ).join( "<br />" );
			value = value.split( "\r" ).join( "<br />" );
			value = value.split( "\n" ).join( "<br />" );

			txtMessage.htmlText = value;
			content = txtMessage;
			invalidate();
		}

		/**
		 *
		 * Геттер/сеттер.
		 */
		public function get content() : DisplayObject {
			var result : DisplayObject;

			// Код геттера.
			result = ContentObject;

			return ( result );
		}

		public function set content( source : DisplayObject ) : void {
			if ( ContentObject ) {
				ContentObject.removeEventListener( Event.RESIZE, contentResize );
				removeChild( ContentObject );
			}
			ContentObject = source;
			if ( isGUIReady ) {
				initContent();
			}
		}

		private function initContent() : void {
//			ContentObject.x = CONTENT_PADDING_LEFT;
//			ContentObject.y = CONTENT_PADDING_TOP;
			listenElement( ContentObject as MessageDispatcher );
			addChild( ContentObject );

			ContentObject.addEventListener( Event.RESIZE, contentResize, false, 0, true );

			invalidate();
		}

		/**
		 * @param
		 */
		private function contentResize( event : Event ) : void {
			redraw();
		}

		/**
		 * @param
		 */
		override protected function redraw() : void {
			if ( !isGUIReady ) {
				invalidate();
				return;
			}

			ContentObject.x = CONTENT_PADDING_LEFT;
			ContentObject.y = CONTENT_PADDING_TOP;
			if ( ContentObject == txtMessage ) {
				txtMessage.height = Math.round( txtMessage.textHeight + 5 );
			}

			BG.width = ContentObject.width + ( CONTENT_PADDING_LEFT * 2 );
			BG.height = ContentObject.y + ContentObject.height + MARGIN_AFTER_CONTENT + ( noButtons ? 0 : btnConfirm.height ) + CONTENT_PADDING_TOP;

			if ( onlyButton == null ) {
				btnConfirm.x = Math.round( BG.width / 2 - btnConfirm.width );
				btnCancel.x = Math.round( BG.width / 2 - btnCancel.width );
			} else {
				onlyButton.x = Math.round( BG.width / 2 - onlyButton.width / 2 );
			}

			if ( !noButtons ) {
				btnConfirm.y = BG.height - btnConfirm.height - CONTENT_PADDING_TOP;
				btnCancel.y = BG.height - btnCancel.height - CONTENT_PADDING_TOP;
			}

			//------------

			dispatchMessage( messageRedraw );

			// Финт ушами. После первого ресайза рассылается
			// сообщение, в ответ на которое экземпляр выравнивается
			// на сцене и делается видимым. Если он остаётся невидимым,
			// раздаётся сигнал тревоги.
			if ( !visible ) {
//				warn("Dialog window is initially invisible!", this);
			}
		}

		/**
		 * @param
		 */
		private function onCancel( event : MouseEvent ) : void {
			dispatchMessage( messageCancel );
		}

		/**
		 * @param
		 */
		private function onConfirm( event : MouseEvent ) : void {
//			debug( this, "onConfirm | " + messageConfirm );
			dispatchMessage( messageConfirm );
		}

		override protected function messageHandler( event : SimpleMessage ) : void {
			dispatchMessage( event.text );
		}

		private function timerEventHandler( event : TimerEvent ) : void {
		}
	}
}
