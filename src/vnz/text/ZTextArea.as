/**
 * @author vnz
 */

package vnz.text {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;

	import vnz.controls.*;
	import vnz.core.ZComponent;

	public class ZTextArea extends ZComponent {
		public var txt : TextField;
		private var txtBox : Sprite = new Sprite();
		public var scrollBar : ZScrollBar = new ZScrollBar();
		private var htmlTextValue : String = new String();

		public function get defaultTextFormat() : TextFormat {
			return txt.defaultTextFormat;
		}

		public function set defaultTextFormat( value : TextFormat ) : void {
			txt.defaultTextFormat = value;
		}

		public function get text() : String {
			return txt.text;
		}

		public function set text( value : String ) : void {
			txt.text = value;
			updateHeight();
		}

		public function ZTextArea() {
			super();
		}

		override protected function preinitUI() : void {
			super.preinitUI();

			txt = ZTextField.create({size:10, color:0xffffff}, {height:25, multiline:true, selectable:true});
			this.txt.text = "";
			this.txt.htmlText = "";
			txtBox.addChild( txt );
			addChild( txtBox );
			addChild( scrollBar );
		}

		public function appendText( value : String ) : void {
			txt.appendText( value );
			updateHeight();
//			txt.scrollV = txt.maxScrollV;
		}

		public function appendHTMLText( value : String ) : void {
			if ( value != "" ) {
				htmlTextValue = htmlTextValue + value;
				txt.htmlText = "";
				txt.htmlText = "<body>" + htmlTextValue + "</body>";
			}
			updateHeight();
//			txt.scrollV = 1;
//			txt.setTextFormat(txt.defaultTextFormat);
//			txt.scrollV = txt.bottomScrollV;
		}

		public function clearText() : void {
			this.txt.text = "";
			htmlTextValue = "";
			txt.scrollV = 1;
			txt.height = 25;
		}

		public function setTextFormat( format : TextFormat ) : void {
			txt.setTextFormat( format );
		}

		public function setTextFormatSubstring( format : TextFormat, beginIndex : int, endIndex : int ) : void {
			txt.setTextFormat( format, beginIndex, endIndex );
		}

		public function setStyleSheet( value : StyleSheet ) : void {
			txt.styleSheet = value;
		}

		override protected function draw() : void {
			if ( txt ) {
				var newScrollRect : Rectangle = txt.scrollRect ? txt.scrollRect : new Rectangle();
				if ( !txtBox.scrollRect || txtBox.scrollRect.width != this.width || txtBox.scrollRect.height != this.height ) {
					newScrollRect.width = this.width;
					newScrollRect.height = this.height;
					txtBox.scrollRect = newScrollRect;
				}
				if ( txt.width != this.width ) {
					txt.width = this.width;
				}
			}
			trace( "!!!!!!!!!!!!!!!!!!!!!!!!!!" + txtBox.scrollRect );
			trace( "!!!!!!!!!!!!!!!!!!!!!!!!!!" + txt.height );
			//set scrollBar if need
			if ( !scrollBar.hasTarget && txtBox.scrollRect && txtBox.scrollRect.height > 0 ) {
				scrollBar.attachTo( txtBox );
				scrollBar.x = this.width;
				scrollBar.visible = true;
			}

			var newHeight : uint = txt.height < txt.textHeight ? txt.textHeight + 10 : txt.height;
			txt.height = newHeight;
			scrollBar.changeTargetSize( newHeight );
			//			debug( "itemsBox", itemsBox );
		}

		private function updateHeight() : void {
			var newHeight : uint = txt.height < txt.textHeight ? txt.textHeight + 5 : txt.height;
			if ( txt.height != newHeight ) {
				txt.height = newHeight;
			}
			scrollBar.changeTargetSize( newHeight );
		}

	}
}
