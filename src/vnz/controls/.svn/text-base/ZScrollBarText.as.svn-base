/**
 * @author vnz
 */
package vnz.controls {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import vnz.events.ZComponentEvent;	
	
	public class ZScrollBarText extends Sprite {
		public var btnUp : ZScrollButton;	
		public var btnDown : ZScrollButton;
		public var thumb : Sprite;
		public var track : Sprite;
		
		private var _target : TextField;
		private var _isScrolling : Boolean;
		private var _hasThumbFixedHeight : Boolean = true;
		private var _thumbMaxHeight : Number = 1000; 
		private var _thumbMinHeight : Number = 3;

		public function set target(value : TextField) : void {
			_target = value;
			init();
		}
		
		public function set hasThumbFixedHeight(value : Boolean) : void {
			if (value) {
				_thumbMaxHeight = thumb.height; 		
				_thumbMinHeight = thumb.height;
			} else {
				_thumbMaxHeight = track.height;
				_thumbMinHeight = 3;
			}
			_hasThumbFixedHeight = value;	
		}
		
		public function ZScrollBarText() {
			config();
			
		}
		
		protected function config() : void {
			btnUp.addEventListener(ZComponentEvent.BUTTON_DOWN, pressButtonUp);
			btnDown.addEventListener(ZComponentEvent.BUTTON_DOWN, pressButtonDown); 
			
//			track.y = btnUp.y + btnUp.height;

			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onPressThumb);
			thumb.addEventListener(MouseEvent.MOUSE_UP, onReleaseThumb);
			
			//set max and min thumb height
			hasThumbFixedHeight = _hasThumbFixedHeight;
			
			thumb.height = _thumbMaxHeight;
			
			thumb.y = track.y;	
		}
		
		private function init() : void {
			_target.addEventListener(Event.SCROLL, onMouseScroll);	
		}

		private function onMouseScroll(event : Event) : void {
			updateAfterTextScroll(_target.numLines, _target.scrollV, _target.bottomScrollV, _target.maxScrollV);
			if ( (!visible) && (_target.textHeight >= _target.height) ) {
				visible = true;
			}  
		}

		private function updateAfterTextScroll(numLines : int, scrollV : int, bottomScrollV : int, maxScrollV : int) : void {
			if (!_isScrolling) {
				thumb.height = track.height * (bottomScrollV - scrollV + 1) / (numLines - 1) ;
				thumb.height = Math.round(thumb.height * 10) / 10;
				updateThumbHeight();

				thumb.y = track.y + ((scrollV - 1) * (track.height - thumb.height) / (maxScrollV - 1));
				thumb.y = Math.round(thumb.y * 10) / 10;
				//check min position
				checkMinPos();
			}
		}
		
		/**
		* check max and min thumb size
		 */ 
		private function updateThumbHeight() : void {
			if (thumb.height > _thumbMaxHeight) {
				thumb.height = _thumbMaxHeight;
			}
			if (thumb.height < _thumbMinHeight) {
				thumb.height = _thumbMinHeight;
			}
		}
		
		/**
		*onPress for track 
		*/
		private function onPressThumb (event : MouseEvent) : void {
			var dragRect : Rectangle = new Rectangle(thumb.x, track.y, 0, Math.round(track.height - thumb.height))
			thumb.startDrag(false, dragRect);
			stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseThumbOutside);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_isScrolling = true;			 
		};
		/**
		*onRelease thumb
		*/
		private function onReleaseThumb (event : MouseEvent) : void {
			thumb.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);	
			_isScrolling = false;
			setScroll();
		};
		private function onReleaseThumbOutside(event:MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseThumbOutside);
			if (event.target != thumb){
				thumb.stopDrag();
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				setScroll();
				_isScrolling = false;
			}
		}
		private function mouseMove(event : MouseEvent) : void {
			setScroll();
		}

		private function setScroll() : void {
			thumb.y = Math.round(thumb.y);
			
			_target.scrollV	= Math.round(((thumb.y - track.y) * (_target.maxScrollV - 1)) / (track.height - thumb.height)) + 1;
		}
		
		private function checkMinPos() : void {
			if (thumb.y < track.y) {
				thumb.y  = track.y;
			}			
		}
		
		private function pressButtonUp(event : 	Event) : void {
			scrollOnButton(-1);
		}
		private function pressButtonDown(event : Event) : void {
			scrollOnButton(1);
		}
		/*
		 * direction: -1 - up, 1 - down
		 */
		private function scrollOnButton(direction : int) : void {
			var newScroll : int =  _target.scrollV + 3 * direction;
			if (newScroll < 0) {
				newScroll = 0;
			} 
			if (newScroll > _target.maxScrollV) {
				newScroll = _target.maxScrollV;
			} 
			_target.scrollV = newScroll;
		}	
	}
}
