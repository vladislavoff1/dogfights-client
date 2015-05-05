package by.vnz.model {
	import by.vnz.VO.ShopItemVO;

	public class ShopDataManager {
//		private var _dataSource : XMLList;
		private var _list : Array;

		public function ShopDataManager() {
		}

		public function update( data : XMLList ) : void {
			_list = new Array();

			for each ( var item : XML in data ) {
				var itemVO : ShopItemVO = new ShopItemVO();
				itemVO.update( item );
				_list.push( itemVO );
			}
		}

		public function getItemsByType( type : uint ) : Array {
			var result : Array = new Array();

			for each ( var item : ShopItemVO in _list ) {
				if ( item && item.type == type ) {
					result.push( item );
				}
			}

			return result;
		}
	}
}