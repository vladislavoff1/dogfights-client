package by.vnz.view.dog {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class DogClaws extends MovieClip {
		private var claw : MovieClip;

		public function DogClaws() {
			super();
//			debug( "dog claws", "CREATE" );
//			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
//			addEventListener( Event.REMOVED_FROM_STAGE, destroy, false, 0, true );
//			enterFrameHandler( null );
		}

		private function enterFrameHandler( event : Event ) : void {
			for each ( var dog : DogImage in DogImage.instances ) {
				if ( dog.anim && dog.anim.contains( this ) && dog.claws && dog.claws[0]) {
					claw = dog.claws.shift();
					if ( !this.contains( claw )) {
						addChild( claw )
					}
				}
			}
		}

		public function destroy( event : Event = null ) : void {
			removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			removeEventListener( Event.REMOVED_FROM_STAGE, destroy );
//			debug( "dog claw", "DESTROY" );
		}
	}
}