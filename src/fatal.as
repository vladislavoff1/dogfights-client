package {
	import logger.Logger;

	public function fatal(discription : *, ... args) : void {
		Logger.log(Logger.FATAL, args, discription);
	}
}