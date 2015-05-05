package vnz.controls {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class ZCheckBox extends Sprite{
		private var _checked : Boolean = false;
		public var txtLabel : TextField;//text
		public var checker : Sprite;
		
		public function get checked() : Boolean {
			return _checked;
		} 
		public function set checked(value : Boolean) : void {
			_checked = value;		
			if (_checked){
				checker.visible = true;
			} else{
				checker.visible = false;
			}
		}
		public function get label() : String {
			return txtLabel.text;
		} 
		public function set label(value : String) : void {
			txtLabel.text = value;
		}
		
		public function ZCheckBox(){
			super();
			buttonMode = true;
			//--------------------
			checker.visible = false;
			//--------------------
			addEventListener(MouseEvent.CLICK, onClick);
			//--------
			checked = false;
		}
			
		private function onClick(event : MouseEvent) : void {
			checked = !checked;
		}
		
	}
}