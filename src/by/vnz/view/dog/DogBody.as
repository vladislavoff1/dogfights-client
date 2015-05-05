package by.vnz.view.dog {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class DogBody extends MovieClip {

		public function DogBody() {
			super();
			debug( "dog body", "CREATE" );
			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, destroy, false, 0, true );
			enterFrameHandler( null );
		}

		private function enterFrameHandler( event : Event ) : void {
			for each ( var dog : DogImage in DogImage.instances ) {
				if ( dog.anim && dog.anim.contains( this ) && dog.armor && !this.contains( dog.armor )) {
					var armor : MovieClip = dog.armor;
					addChild( armor )
					armor.x = 35;
					armor.y = 8;
				}
			}
		}

		public function destroy( event : Event = null ) : void {
			removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			removeEventListener( Event.REMOVED_FROM_STAGE, destroy );
			debug( "dog body", "DESTROY" );
		}

	}
}