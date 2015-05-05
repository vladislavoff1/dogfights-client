package by.vnz.model {
	import by.vnz.VO.ShopItemVO;
import by.vnz.VO.TrainingItemVO;

public class TrainingDataManager {
//		private var _dataSource : XMLList;
		private var _list : Array;

		public function TrainingDataManager() {
		}

		public function update( data : XMLList ) : void {
			_list = new Array();

			for each ( var item : XML in data ) {
				var itemVO : TrainingItemVO = new TrainingItemVO();
				itemVO.update( item );
				_list.push( itemVO );
			}
		}

		public function getItems( ) : Array {
			return _list;
		}
	}
}