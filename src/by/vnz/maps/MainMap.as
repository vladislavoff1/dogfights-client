package by.vnz.maps {
	import by.vnz.events.MainStatesEvent;
	import by.vnz.framework.eventsmap.EventsMap;
	import by.vnz.framework.eventsmap.SubscribeVO;
	import by.vnz.model.Model;

	public class MainMap extends EventsMap {
		public var model : Model;

		public function MainMap() {
			super();
		}

		override protected function init() : void {
			var prVO : SubscribeVO = new SubscribeVO();
			prVO.invokerMethod = model.init;
			add( MainStatesEvent.INIT, prVO );

		}
	}
}