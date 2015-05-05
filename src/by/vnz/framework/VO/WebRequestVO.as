package by.vnz.framework.VO {
	import by.vnz.framework.model.RequestVars;

	import flash.net.URLLoader;

	public class WebRequestVO {
		public var method : String;
		public var resultHandler : Function;
		public var loader : URLLoader;
		public var params : RequestVars; //URLVariables;
		public var useBase64 : Boolean = true;
        public var special : String;

		public function WebRequestVO() {
		}
	}
}