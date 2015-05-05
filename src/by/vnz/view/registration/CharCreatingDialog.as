package by.vnz.view.registration {
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.components.SimpleButtonProxy;
	import by.vnz.framework.view.core.BaseElement;
	import by.vnz.model.Model;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class CharCreatingDialog extends BaseElement {
		public var BG : ImageProxy;
		public var txtNickname : TextField;
		public var txtKind : TextField;
		public var menu : CarouselMenu;

		public var btnPrev : SimpleButtonProxy;
		public var btnNext : SimpleButtonProxy;
		public var btnOk : SimpleButtonProxy;

		public var strBar : ImageProxy;
		public var dexBar : ImageProxy;
		public var enduBar : ImageProxy;

		public function CharCreatingDialog() {
			super();
		}

		public function show( xml : XML ) : void {
			createUIChild( ImageProxy, <ui name="BG" resource="dogCreatingBG" x="0" y="0" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnPrev" resource="btn_prev_reg" x="156" y="522" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnNext" resource="btn_next_reg" x="452" y="522" /> );
			createUIChild( SimpleButtonProxy, <ui name="btnOk" resource="btn_ok_reg" x="258" y="268" /> );
//			createUIChild( SimpleButtonProxy, <ui name="btnCancel" resource="btn_cancel" x="258" y="300" /> );
			createUIChild( TextField, <child  name="txtNickname" width="144" height="20" x="313" y="123" type={TextFieldType.INPUT} border="true" background="true" align="left" color="0" bold="false" font="Arial" size="14" /> );
            txtNickname.restrict = "a-zA-Z0-9_-*йцукенгшщзхъэждлорпавыфячсмитьбюЙЦУКЕНГШЩЗХЪЭЖДЛОРПАВЫФЯЧСМИТЬБЮ";
			createUIChild( TextField, <child  name="txtKind" width="150" height="30" x="310" y="146" multiline="false" align="left" color="0xffffff" bold="true" font="Calibri" size="16" /> );
			createUIChild( ImageProxy, <ui name="strBar" resource="strengthBar" x="312" y="182" /> );
			createUIChild( ImageProxy, <ui name="dexBar" resource="dexterityBar" x="312" y="208" /> );
			createUIChild( ImageProxy, <ui name="enduBar" resource="enduranceBar" x="312" y="235" /> );

			btnPrev.addEventListener( MouseEvent.CLICK, btnPrev_clickHandler );
			btnNext.addEventListener( MouseEvent.CLICK, btnNext_clickHandler );

			btnOk.addEventListener( MouseEvent.CLICK, btnOk_clickHandler );

			txtNickname.maxChars = 20;
			txtNickname.addEventListener( Event.CHANGE, txtNickname_changeHandler );
			txtNickname_changeHandler();

			menu = new CarouselMenu( 460, 400 );
			addChildAt( menu, 1 );
			menu.x = 10;
			menu.y = 170;
//			menu.scaleX = menu.scaleY = 0.7;
			menu.addEventListener( Event.CHANGE, menu_changeHandler );

			menu.initialize( xml );
			visible = true;
		}

		private function btnPrev_clickHandler( event : MouseEvent ) : void {
				menu.showNext( -1 );
		}
		private function btnNext_clickHandler( event : MouseEvent ) : void {
				menu.showNext( 1 );
		}

		private function menu_changeHandler( event : Event ) : void {
			var curXML : XML = menu.currentItem.data;
			debug( "item xml", curXML );
			strBar.scaleX = Number( uint( curXML.str.* ) / 7 );
			dexBar.scaleX = Number( uint( curXML.dex.* ) / 7 );
			enduBar.scaleX = Number( uint( curXML.endu.* ) / 7 );
			txtKind.text = String( curXML.breed.* );

		}

		private function btnOk_clickHandler( event : MouseEvent ) : void {

			var curXML : XML = menu.currentItem.data;
			debug( "btnOk_clickHandler", curXML );
			var dogID : uint = uint( curXML.breedID.* );
			Model.instance.regUser( dogID, txtNickname.text );
			btnOk.visible = false;
            this.mouseChildren = this.mouseEnabled = false;
		}

		private function txtNickname_changeHandler( event : Event = null ) : void {
			if ( txtNickname.text.length == 0 ) {
				btnOk.alpha = 0.4;
			} else {
				btnOk.alpha = 1;
			}
		}

	}
}