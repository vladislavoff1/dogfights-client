package by.vnz.view.dog {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class DogFangsUp extends MovieClip {
		public function DogFangsUp() {
			super();

//			debug( "dog fang up", "CREATE" );
			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, destroy, false, 0, true );
			enterFrameHandler( null );
		}

		private function enterFrameHandler( event : Event ) : void {
			for each ( var dog : DogImage in DogImage.instances ) {
				if ( dog.anim && dog.anim.contains( this ) && dog.fangsUp && !this.contains( dog.fangsUp )) {
					var fang : MovieClip = dog.fangsUp;
					addChild( fang );
					fang.y = -3;
				}
			}
		}

		public function destroy( event : Event = null ) : void {
			removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			removeEventListener( Event.REMOVED_FROM_STAGE, destroy );
//			debug( "dog fang down", "DESTROY" );
		}
	}
}