package by.vnz.framework.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class DataManager extends EventDispatcher
	{
		public function DataManager(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}