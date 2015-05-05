package by.vnz.framework.resources.loading {
	/**
	 * Загружает основную карту ресурсов и
	 * важные ресурсы
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	import ru.delimiter.game.hexwarz.components.DialogWindow;
	import ru.delimiter.game.hexwarz.data.events.StateEvent;
	import ru.delimiter.game.hexwarz.patterns.ui.PreloaderDialog;

	public class MassiveResourceLoader extends ResourceLoader {
		private var _autoLoadImportantResources : Boolean;

		private var loadingBG : Sprite;
		private var messageDialog : DialogWindow;
		private var preloader : PreloaderDialog;

		public function MassiveResourceLoader( autoLoadImportantResources : Boolean = true ) {
			super();

			_autoLoadImportantResources = autoLoadImportantResources;

			createBounds();
			demandResource( "auth.background.welcome", onBGGraphics );

			messageDialog = new DialogWindow();
			messageDialog.localize( "title", "${map.initializing.hint.title}", "Hint" );
			addDialog( messageDialog );

			preloader = new PreloaderDialog();
//			addChild( preloader );
			messageDialog.content = preloader;

		}

		private function onBGGraphics( source : Sprite ) : void {
			if ( source ) {
				loadingBG = source;
				addChildAt( loadingBG, 0 );
//				source.alpha = 0.3;
			}
		}

		/**
		 * @param
		 */
		override public function load( mapPath : String = null ) : void {
			addEventListener( ProgressEvent.PROGRESS, onMapProgress, false, 0, true );
			addEventListener( Event.COMPLETE, onMapComplete, false, 0, true );

			demandMap( <map path="resources/" external="resources.xml" /> );
		}

		/**
		 * @param
		 */
		private function onMapProgress( event : ProgressEvent ) : void {
			preloader.updateProgress( event.bytesLoaded, event.bytesTotal, 15, 0 );

//			var aProgress : String;
//			aProgress = "(" + event.bytesLoaded + "/" + event.bytesTotal + ")";
//
//			messageDialog.localize( "text", "${game.loading.resource.map}\n" + aProgress, "Loading Moon resource map.\nPlease wait.\n" + aProgress );

		}

		/**
		 * @param
		 */
		private function onMapComplete( event : Event ) : void {
			removeEventListener( ProgressEvent.PROGRESS, onMapProgress );
			removeEventListener( Event.COMPLETE, onMapComplete );

			parseXML( wholeMap );
			filterMaps();

			if ( !_autoLoadImportantResources ) {
				dispatchMessage( completeMessage );
				return;
			}

			addEventListener( ProgressEvent.PROGRESS, onImportantProgress, false, 0, true );
			addEventListener( Event.COMPLETE, onImportantComplete, false, 0, true );

			demandImportant( wholeMap );
		}

		/**
		 * @param
		 */
		private function onImportantProgress( event : ProgressEvent ) : void {

			preloader.updateProgress( event.bytesLoaded, event.bytesTotal, 85, 15 );

//			var aProgress : String;
//			aProgress = "(" +  + ")";
//
//			messageDialog.localize( "text", "${game.loading.resources}\n" + aProgress, "Loading Moon resources.\nPlease wait.\n" + aProgress );
		}

		/**
		 * @param
		 */
		private function onImportantComplete( event : Event ) : void {
			removeEventListener( ProgressEvent.PROGRESS, onImportantProgress );
			removeEventListener( Event.COMPLETE, onImportantComplete );

			dispatchMessage( completeMessage );
		}

		/**
		 * @param
		 */
		override protected function onEnterState( event : StateEvent ) : void {
			switch ( event.state ) {

				case STATE_IMPORTANT: {
					break;
				}

				case STATE_LOADING: {
					preloader.startShowHints();
					break;
				}
			}
		}

		/**
		 * @param
		 */
		override protected function onExitState( event : StateEvent ) : void {
			switch ( event.state ) {
				case STATE_IMPORTANT:
				case STATE_LOADING: {
//					removeDialog( messageDialog );
					break;
				}
			}
		}

		/**
		 * @param
		 */
		override public function destroy() : void {
			super.destroy();
			removeDialog( messageDialog );

//			removeChildSafely( preloader );
		}
	}
}
