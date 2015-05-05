package by.vnz.model {
	import by.vnz.VO.BattleStepVO;
	import by.vnz.VO.BattleWinVO;
	import by.vnz.VO.DogVO;

	public class BattleManager {
		private var _currentStep : uint = 0;
		/** of BattleStepVO */
		private var _steps : Array = [];
		private var _enemyID : String;

		public var enemyHealth : uint;
		public var userHealth : uint;

		public var winID : String;
		public var winData : BattleWinVO;

		public var enemyData : DogVO = new DogVO();

		public function BattleManager() {
		}

		public function update( data : XML ) : void {
			var step : BattleStepVO;
			var item : XML;
			_steps = [];
			for each ( item in data.battle.block ) {
//				debug( "block", item );
				step = new BattleStepVO();
				step.update( item );
//				debug( "battle step", step );
				_steps.push( step );

			}
			_currentStep = 0;// _steps.length-2;
			_enemyID = String( data.battle.@enemyID );
			for each ( item in data.start.dog ) {
				if ( _enemyID == String( item.@id )) {
					enemyHealth = uint( item.health.* );
				} else {
					userHealth = uint( item.health.* );
				}
			}
			winID = data.battle.win.*;
			winData = new BattleWinVO();
			winData.update( data.dog[0] as XML );
		}

		public function get enemyID() : String {
			var result : String = _enemyID;

			return result;
		}

		public function set enemyID( value : String ) : void {
			_enemyID = value;
		}

		public function get nextStep() : BattleStepVO {
			var result : BattleStepVO;
			_currentStep++;
			if ( _currentStep < _steps.length ) {
				result = _steps[_currentStep];
			}
			return result;
		}

		public function get hasNextStep() : Boolean {
			var result : Boolean = true;
			var lastIndex : uint = _steps.length - 1;
			if ( _currentStep >= lastIndex ) {
				result = false;
			}
			return result;
		}
	}
}