package by.vnz.view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	public class WaitFullGameDialog extends Sprite {

		public var txtNickname : TextField;
		public var txtKind : TextField;

		public function WaitFullGameDialog() {
			super();
		}

		public function show( dogData : XML ) : void {
			visible = true;

			debug( "WaitFullGameDialog", dogData );

			if ( !dogData || !dogData.hasOwnProperty( "breedID" )) {
				return;
			}

			txtNickname.text = dogData.name.*;
			txtKind.text = dogData.breed.*;

			var breedID : uint = uint( dogData.breedID.* ) - 1;
			var DogClass : Class = getDefinitionByName( "dog" + breedID.toString()) as Class;
			var dog : DisplayObject = new DogClass();
			addChild( dog );
			dog.scaleX = dog.scaleY = 0.7;
			dog.x = ( stage.stageWidth - dog.width ) / 2;
			dog.y = 330;

		}
	}
}