package {
	import logger.Logger;

	public function debug(discription : *, ... args) : void {
		Logger.log(Logger.DEBUG, args, discription);
	}
}