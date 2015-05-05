package {
	import logger.Logger;

	public function warn(discription : *, ... args) : void {
		Logger.log(Logger.WARN, args, discription);
	}
}