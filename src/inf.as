package {
	import logger.Logger;

	public function inf(discription : *, ... args) : void {
		Logger.log(Logger.INFO, args, discription);
	}
}