package by.vnz.view.arena {
	import by.vnz.VO.EnemyVO;
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;
	import by.vnz.idmaps.IDMDogParams;
	import by.vnz.idmaps.IDMItemMsg;
	import by.vnz.view.user.DogParamInfoBox;
	import by.vnz.view.user.LevelIcon;
	import by.vnz.view.user.UserAvatar;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import logger.Logger;

	public class ArenaItem extends GUIElement {
		static public const ITEM_WIDTH : uint = 272;
		static public const ITEM_HEIGHT : uint = 118;
		private var _data : EnemyVO;

		public var BG : ImageProxy;
		public var levelIcon : LevelIcon;
		public var strInfo : DogParamInfoBox;
		public var dexInfo : DogParamInfoBox;
		public var enduInfo : DogParamInfoBox;
		public var txtName : TextField;
		public var highlighter : ImageProxy;
		public var avatar : UserAvatar;

		public function ArenaItem() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			createUIChild( ImageProxy, <ui name="BG" resource="arena_enemy_item" x="0" y="0" /> );
			createUIChild( ImageProxy, <ui name="highlighter" resource="arena_item_highlight" x="-1" y="-1" visible="false" /> );
			createUIChild( UserAvatar, <ui name="avatar" x="24" y="29" /> );

			createUIChild( LevelIcon, <ui name="levelIcon" x="67" y="72" scaleX="1" scaleY="1" /> );

			createUIChild( TextField, <ui name="txtName" x="95" y="6" width="160" height="25" text="1" font="Calibri" size="14" color="0xFFFFFF" bold="true"  /> );

			createUIChild( DogParamInfoBox, <ui name="strInfo" x="100" y="34" paramName={IDMDogParams.STRENGTH} /> );
			createUIChild( DogParamInfoBox, <ui name="dexInfo" x="100" y="57" paramName={IDMDogParams.DEXTERITY} /> );
			createUIChild( DogParamInfoBox, <ui name="enduInfo" x="100" y="81" paramName={IDMDogParams.ENDURANCE} /> );
			createUIChild( ImageProxy, <ui name="highlighter" resource="item_slot_highlight" visible="false" /> );

//			var textShadow : DropShadowFilter = new DropShadowFilter( 1, 45, 0, 0.6, 0, 0, 1, BitmapFilterQuality.HIGH );
//			txtName.filters = [textShadow];
//			txtBreed.filters = [textShadow];
//			txtWins.filters = [textShadow];

			dataChangeHandler( null );
		}

		public function get data() : EnemyVO {
			var result : EnemyVO = _data;

			return result;
		}

		public function set data( value : EnemyVO ) : void {
			if ( !value ) {
				return;
			}
			_data = value;
			debug( _data, "added", Logger.DC_5 );
			_data.addEventListener( Event.CHANGE, dataChangeHandler );
			dataChangeHandler( null );
		}

		private function dataChangeHandler( event : Event ) : void {
			debug( _data, "dataChangeHandler", Logger.DC_2 );
			if ( !isGUIReady || !_data ) {
				return;
			}
			update();
		}

		protected function update() : void {
			debug( _data, "update in parent", Logger.DC_1 );

			txtName.text = _data.name;
			var maxProp : uint = Math.max( _data.str, _data.dex, _data.endu );
			strInfo.update( _data.str, 100 * _data.str / maxProp );
			dexInfo.update( _data.dex, 100 * _data.dex / maxProp );
			enduInfo.update( _data.endu, 100 * _data.endu / maxProp );

			levelIcon.data = _data.level;
			avatar.loadImage( _data.photo );

			addEventListener( MouseEvent.CLICK, clickHandler, false, 0, true );
		}

		public function get selected() : Boolean {
			var result : Boolean = highlighter.visible;

			return result;
		}

		public function set selected( value : Boolean ) : void {
			highlighter.visible = value;
		}

		private function clickHandler( event : MouseEvent ) : void {
			event.stopImmediatePropagation();

			dispatchMessage( IDMItemMsg.SELECT );
		}
	}
}