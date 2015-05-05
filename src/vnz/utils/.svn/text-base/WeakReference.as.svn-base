package vnz.utils
{
	import flash.utils.Dictionary;

	public class WeakReference
	{
		private var dictionary : Dictionary;

		public function WeakReference( data : Object )
		{
			dictionary = new Dictionary( true ); // weakKeys = true
			dictionary[data] = null; // За счет возможности использования weakKeys, получаем weakReference
		}

		public function get object() : Object
		{
			// Пробегаемся по ключам словаря, позвращаем первый попавшийся
			for ( var n : Object in dictionary )
			{
				return n;
			}
			return null;
		}
	}
}