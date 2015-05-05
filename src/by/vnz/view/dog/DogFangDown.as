package by.vnz.view.dog {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class DogFangDown extends MovieClip {
		public function DogFangDown() {
			super();
//			debug( "dog fang down", "CREATE" );
			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, destroy, false, 0, true );
			enterFrameHandler( null );
		}

		private function enterFrameHandler( event : Event ) : void {
			for each ( var dog : DogImage in DogImage.instances ) {
				if ( dog.anim && dog.anim.contains( this ) && dog.fangsDown && !this.contains( dog.fangsDown )) {
					var fang : MovieClip = dog.fangsDown;
					addChild( fang )
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