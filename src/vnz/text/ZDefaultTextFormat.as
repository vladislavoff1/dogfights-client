package vnz.text
{

	import flash.text.TextFormat;

	/**
	 *
	 * @author vnz
	 */
	public class ZDefaultTextFormat
	{
		/**
		 * @param
		 * @return
		 */
		static public function create() : TextFormat
		{
			var result : TextFormat;

			result = new TextFormat();

			result.font = "_typewriter";
			result.size = 10;
			result.color = 0x000000;

			return ( result );
		}
	}
}
