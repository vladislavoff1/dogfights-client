package by.vnz.idmaps {
	public class IDMFightPopups {
		
		    /** Attempts throw id = 1 */
		    static public var list1: Array = [" Cobra Strike ",
			        " Attacking Tiger ",
			        " Strike Sword of Satan ",
			        " Strike Three digit ",
			        " Beat Stomp elephant ",
			        " Strike terror overwhelms ",
			        " Beat Power Hurricane ",
			        " Tornado Strike "];
		    /** Attempts to housing id = 2 */
		    static public var list2: Array = [
			        " Strike the trunk ",
			        " Beat Mantis ",
			        " Beat Bonecrusher ",
			        " Beat Unlimited Power",
			        " Beat Bloodbath ",
			        " Strike Fatality ",
			        " Thunder Strike ",
			        " Beat ferocious tiger ",
		    ] ;
		    /** Attempts to head id = 3 */
		    static public var list3: Array = [
			        " Blow to the head ",
			        " Ferocious Strike skull ",
			        " Concussion Blow ",
			        " Beat Mozgotryaska ",
			        " Strike the skull ",
			        " Beat shrink ",
			        " Beat Hook in the head",
			        " Beat Farewell memory"
		    ] ;
		    /** Attempts to paw id = 4 */
		    static public var list4: Array = [" kick bite paw ",
			        " Strike force Hell ",
			        " Beat crutch ",
			        " Beat prosthetist ",
			        " Beat Anaconda ",
			        " Beat The Curse ",
			        " Beat Painful shock ",
			        " Beat the Sign" ] ;
		
		    /** Attempts bite back id = 5 */
		    static public var list5: Array = [
			       " Beat Banzai",
			        " Beat Caramba ",
			        " Beat Power Dragon",
			        " Beat The great warrior ",
			        " Atlanta Beat ",
			        " Beat Paralysis ",
			        " Blow away the life "];
		    /** Attempts vukus neck id = 6 */
		    static public var list6: Array = [
			        " Strike Choke ",
			        " Beat Hopeless ",
			        " Bloody Strike Adam's apple ",
			        " Beat torn neck ",
			        " Beat Barracuda",
			        " Ferocious Strike moan ",
			        " Beat Dismemberment ",];
		    /** Superudar id = 7 */
		    static public var list7: Array = [
			        " Superb Lightning ",
			        " Superb Apocalypse ",
			        " Superb Rambo ",
			        " Superb Knockout ",
			        " Death is a superb mongrel "
			            
		    ] ;
		
			static public function getByType(type:uint):String {
				var result:String = null;
				var list:Array = IDMFightPopups["list"+type];
				
				
				if (list != null) {
					var r:uint = Math.random() * list.length;
					result = list[r];
					if (!result){
						result =  list[0];
					}
				}
				
				return result;
			}
		
		    public function IDMFightPopups () {
		    }
	}
}