package by.vnz.model {
	import by.vnz.VO.DogVO;
	import by.vnz.VO.EnemyVO;

	public class ArenaManager {
		public var enemiesList : Array = [];
		private var _selEnemy : EnemyVO;

		public function ArenaManager() {

			for ( var i : uint = 0; i < 6; i++ ) {
				var enemy : EnemyVO = new EnemyVO();
				enemiesList.push( enemy );
			}
		}

		public function update( xml : XML ) : void {
//			enemiesList = [];
			var dogsXMLList : XMLList = xml.dog;
			var i : uint = 0;
			var enemy : EnemyVO
			for each ( var item : XML in dogsXMLList ) {
				if ( i >= enemiesList.length ) {
					break;
				}
				enemy = enemiesList[i] as EnemyVO;
				enemy.update( item );
				i++;
			}
		}

		public function get selectedEnemy() : EnemyVO {
			var result : EnemyVO = _selEnemy;
			return result;
		}

		public function set selectedEnemy( data : EnemyVO ) : void {
			_selEnemy = data;
		}

		public function get enemyDogInfo() : DogVO {
			var result : DogVO;
			return result;
		}

		public function get usersIDs() : Array {
			var result : Array = [];
			for each ( var item : EnemyVO in enemiesList ) {
				result.push( item.user );
			}
			return result;
		}

		public function addUserProfiles( list : XMLList ) : void {
			for each ( var item : XML in list ) {
				var userID : String = String( item.uid.* );
				var userData : EnemyVO = getUserByID( userID );
				if ( userData ) {
					userData.update( item );
				}
			}
		}

		public function getUserByID( id : String ) : EnemyVO {
			for each ( var item : EnemyVO in enemiesList ) {
				if ( item.user == id ) {
					return item;
				}
			}
			return null;
		}
	}
}