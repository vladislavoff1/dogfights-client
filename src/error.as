package {
	import logger.Logger;

	public function error(discription : *, ... args) : void {
		Logger.log(Logger.ERROR, args, discription);
	}
}