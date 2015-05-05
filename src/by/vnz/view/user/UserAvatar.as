package by.vnz.view.user {
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.framework.view.core.GUIElement;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import vnz.data.MediaLoader;

	public class UserAvatar extends GUIElement {
		static public const IMAGE_SIZE : uint = 50;

		public var userImage : Sprite;
		private var _loader : MediaLoader = new MediaLoader();

		public function UserAvatar() {
			super();
		}

		override protected function initUI() : void {
			super.initUI();

			buttonMode = true;

			createUIChild( ImageProxy, <ui name="BG" resource="avatar_bg" x="-2" y="-2" /> );
//			createUIChild( ImageProxy, <ui name="userImage" resource="user_image_no_image" /> );
			createUIChild( Sprite, <ui name="userImage"  /> );
			createUIChild( ImageProxy, <ui name="glow" resource="avatar_over_glow" x="2" y="2"/> );
		}

		public function loadImage( url : String ) : void {
			if ( !url ) {
				return;
			}
			_loader.addEventListener( MediaLoader.MEDIA_LOADED, loaderLoadedHandler );
			_loader.load( url );
		}

		private function loaderLoadedHandler( event : Event ) : void {
			var image : Bitmap = _loader.media as Bitmap;
			userImage.addChild( image );
			userImage.scrollRect = new Rectangle( 0, 0, IMAGE_SIZE, IMAGE_SIZE );
			if ( image.width > IMAGE_SIZE ) {
				image.x -= ( image.width - IMAGE_SIZE ) / 2;
			}
			if ( image.height > IMAGE_SIZE ) {
				image.y -= ( image.height - IMAGE_SIZE ) / 2;
			}

		}
	}
}