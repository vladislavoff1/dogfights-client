package vnz.utils
{
	import flash.net.LocalConnection;

	public class ForceGC
	{
		public function ForceGC()
		{
		}

		static public function force() : void
		{
			// flash player version below 9.0.115
			try
			{
				var lc1 : LocalConnection = new LocalConnection();
				lc1.connect( "gcgc" );
				var lc2 : LocalConnection = new LocalConnection();
				lc2.connect( "gcgc" );
			} catch ( error : Error )
			{
				// ignore
			}
		}
	}
}