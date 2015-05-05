package by.vnz.idmaps {
	import vnz.utils.Describer;

	public class IDMBattleStates {
		static public const STATE_INIT : String = "state_init";
		static public const STATE_COUNTDOWN : String = "state_countdown";
		static public const STATE_ATTACK : String = "state_attack";
		static public const STATE_FIGHT : String = "state_fight";
		static public const STATE_FIGHT_END : String = "state_fight_end";
		static public const STATE_FIGHT_BREAK_START : String = "state_fight_break_start";
		static public const STATE_FIGHT_BREAK_WAIT : String = "state_fight_break_wait";
		static public const STATE_FIGHT_BREAK_END : String = "state_fight_break_end";
		static public const STATE_RESULT : String = "state_result";

		public function IDMBattleStates() {
		}

		static public function sequenceList() : Array {
			return [STATE_INIT, STATE_COUNTDOWN, STATE_ATTACK, STATE_FIGHT, STATE_FIGHT_END, STATE_RESULT];

		}
	}
}