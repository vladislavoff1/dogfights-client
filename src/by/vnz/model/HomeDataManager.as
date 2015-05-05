package by.vnz.model {
	import by.vnz.VO.HomeItemVO;

	public class HomeDataManager {
		private var _activeItems : Array;
		private var _inactiveItems : Array;

		public function HomeDataManager() {
		}

		public function update( data : XMLList ) : void {
			_activeItems = new Array();
			_inactiveItems = new Array();

//			debug( "active", data[2]);
			var itemVO : HomeItemVO;
			var item : XML;
			var itemsXMLList : XMLList = data[1].item;
			for each ( item in itemsXMLList ) {
				itemVO = new HomeItemVO();
				itemVO.update( item );
				_activeItems.push( itemVO );
			}
			itemsXMLList = data[0].item;
			for each ( item in itemsXMLList ) {
				itemVO = new HomeItemVO();
				itemVO.update( item );
				_inactiveItems.push( itemVO );
			}

		}

		public function getItems( active : Boolean = true ) : Array {
			var result : Array;

			if ( active ) {
				result = _activeItems;
			} else {
				result = _inactiveItems;
			}

			return result;
		}
	}
}