package by.vnz.view.user {
	import by.vnz.VO.DogVO;
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.idmaps.IDMDogParams;
	import by.vnz.idmaps.IDMDogs;
	import by.vnz.view.dog.DogImage;

	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	public class DogInfoPanel extends GUIElement {
		protected var _data : DogVO;

		public var BG : ImageProxy;
		public var levelIcon : LevelIcon;
		public var titles : ImageProxy;
		public var strInfo : DogParamInfoBox;
		public var dexInfo : DogParamInfoBox;
		public var enduInfo : DogParamInfoBox;
		public var txtName : TextField;
		public var txtBreed : TextField;
		public var txtWins : TextField;
		public var dogImage : DogImage;

		public function DogInfoPanel() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			createUIChild( ImageProxy, <ui name="BG" resource="dog_info_bg" x="13" y="8" /> );
			createUIChild( LevelIcon, <ui name="levelIcon" scaleX="1.7" scaleY="1.7" /> );

			createUIChild( ImageProxy, <ui name="titles" resource="dog_info_titles" x="23" y="24" /> );

			createUIChild( TextField, <ui name="txtName" x="125" y="24" width="120" height="40" text="1" font="Calibri" size="15" color="0xFAC9F5" bold="true"  /> );
			createUIChild( TextField, <ui name="txtBreed" x="125" y="45" width="120" height="40" text="1" font="Calibri" size="15" color="0xFAC9F5" bold="true"  /> );

			createUIChild( DogParamInfoBox, <ui name="strInfo" x="125" y="72" paramName={IDMDogParams.STRENGTH} /> );
			createUIChild( DogParamInfoBox, <ui name="dexInfo" x="125" y="95" paramName={IDMDogParams.DEXTERITY} /> );
			createUIChild( DogParamInfoBox, <ui name="enduInfo" x="125" y="118" paramName={IDMDogParams.ENDURANCE} /> );

			createUIChild( TextField, <ui name="txtWins" x="125" y="131" width="120" height="40" text="1" font="Calibri" size="15" color="0xFAC9F5" bold="true"  /> );

//			createUIChild( DogImage, <ui name="dogImage" x="287" y="41" /> );

			var textShadow : DropShadowFilter = new DropShadowFilter( 1, 45, 0, 0.6, 0, 0, 1, BitmapFilterQuality.HIGH );
			txtName.filters = [textShadow];
			txtBreed.filters = [textShadow];
			txtWins.filters = [textShadow];

			dataChangeHandler( null );
		}

		public function get data() : DogVO {
			var result : DogVO = _data;

			return result;
		}

		public function set data( value : DogVO ) : void {
			if ( !value || _data == value ) {
				return;
			}
			_data = value;
			_data.addEventListener( Event.CHANGE, dataChangeHandler );
			dataChangeHandler( null );
		}

		private function dataChangeHandler( event : Event ) : void {
			if ( !isGUIReady || !_data ) {
				return;
			}
			update();
		}

		public function update() : void {
			levelIcon.data = _data.level;

			txtName.text = _data.name;
			txtBreed.text = _data.breed;
			txtWins.text = _data.win.toString();

			var maxProp : uint = Math.max( _data.str, _data.dex, _data.endu );
			strInfo.update( _data.str, 100 * _data.str / maxProp );
			dexInfo.update( _data.dex, 100 * _data.dex / maxProp );
			enduInfo.update( _data.endu, 100 * _data.endu / maxProp );

		}

		public function show() : void {
			createUIChild( DogImage, <ui name="dogImage" x="287" y="41" sendEndAnimMSG="false" /> );
			dogImage.data = _data;
			visible = true;
		}

		public function hide() : void {
			removeChildSafely( dogImage );
			dogImage = null;
			visible = false;
		}
	}
}