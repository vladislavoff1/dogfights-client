package by.vnz.view.registration {
	import by.vnz.framework.view.components.ImageProxy;
	import by.vnz.idmaps.IDMDogs;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *
	 * @author newman
	 */
	public class CarouselMenu extends Sprite {
		private const RADIUS : Number = 400;
		static public const INACTIVE_ALPHA : Number = 1;
		static public const onlineShowing : uint = 4;

		//Мы вычисляем угловую скорость в слушателе ENTER_FRAME 
		private var angleSpeed : Number = 0;

		//3D пол для картинок
		private var floor : Number = 40;

		private var itemsCache : Array = new Array();
		//Этот массив будет содержать все контейнеры картинок
		private var items : Array = new Array();

		//Общее число картинок в соответствии с XML файлом
		private var allItems : uint = 0;

		//Мы хотим знать, сколько картинок было загружено
		private var numberOfLoadedImages : uint = 0;

		//Установим точку исчезновения
		private var vanishingPointX : Number;
		private var vanishingPointY : Number;

		//Мы сохраним загружаемый XML в переменную
		private var xml : XML;

		//Определим путь к XML файлу.
		private var resourcesPath : String = "resources/menu/";
		private var xmlFileName : String = "menu.xml";

		private var steps : uint = 0;
		private var duration : Number = 0.3;

		public function CarouselMenu( w : uint, h : uint ) {
			super();

			//Установим точку исчезновения
			vanishingPointX = w / 2;
			vanishingPointY = h / 2;

			//Загружаем XML файл.
//			var loader : URLLoader = new URLLoader();
//			loader.load( new URLRequest( resourcesPath + xmlFileName ));
//			loader.addEventListener( Event.COMPLETE, xmlLoaded );

		}

		//Эта функция вызывается, когда все картинки загружены.
		//Теперь мы готовы создать 3D карусель.
		public function initialize( xmlData : XML = null ) : void {
			allItems = xmlData.dog.length();
			var item : CarouselMenuItem;
			var i : uint
			for ( i = 0; i < allItems; i++ ) {
//				var DogClass : Class = getDefinitionByName( "dog" + i.toString()) as Class;
				//Создаем новый контейнер картинки 
				item = new CarouselMenuItem();
				item.data = xmlData.dog[i] as XML;
				var dogResource : String = IDMDogs.getDogByID( uint( item.data.breedID )) + "_wait";
				debug( "dogResource", dogResource );
				var dog : ImageProxy = new ImageProxy( dogResource );
				item.addChild( dog );
				item.mouseChildren = false;

				//выравнивам центру по низу 
				dog.x = -( dog.width / 2 );
				dog.y = -( dog.height / 2 );

				//Мы хотим знать, когда мышь над imageHolder и когда уходит с imageHolder
				//				item.addEventListener( MouseEvent.MOUSE_OVER, mouseOverImage );
				//				item.addEventListener( MouseEvent.MOUSE_OUT, mouseOutImage );

				//Мы также хотим прослушать все клики
				//				item.addEventListener( MouseEvent.CLICK, imageClicked );

				itemsCache.push( item );
					//				items.push( item );
			}

			for ( i = 0; i < onlineShowing; i++ ) {
				item = itemsCache[i];
				items.push( item );
			}

			//Цикл по всем картинкам
			for ( i = 0; i < items.length; i++ ) {

				//Присвоим imageHolder локальной переменной
				item = items[i] as CarouselMenuItem;

				//начальный угол
				item.currentAngle = angleDifference * i;

				//ypos3D в процессе меняться не будет
				item.ypos3D = floor;

				//Добавляем imageHolder на сцену
				addChild( item );
			}

			//update for init
			//set current user with 0 index
			rotateTo( 90 * Math.PI / 180 );

			updateAfterShowNext();

			//Добавляем ENTER_FRAME для поворота
//			addEventListener( Event.ENTER_FRAME, enterFrameHandler );

		}

		//обработка поворота карусели
		private function rotateTo( angel : Number ) : void {
			var item : CarouselMenuItem
			for each ( item in items ) {
				//Изменим текущий угол для item
				item.currentAngle += angel;

				//Установим новое 3D положение для item
				item.xpos3D = RADIUS * Math.cos( item.currentAngle );
				item.zpos3D = RADIUS * Math.sin( item.currentAngle );
				if ( item.zpos3D > 0 && item.zpos3D < 0.1 ) {
					item.zpos3D = 1;
				}
			}

			//Вызываем функцию, которая сортирует items так, что они корректно накладываются друг друга
			sortZ();

			for each ( item in items ) {
				//Вычисляем коэффициент масштабирования
				var scaleRatio : Number = getScaleRatio( item );

				//Масштабируем в соответствии с коэффициентом масштабирования
				item.scaleX = item.scaleY = scaleRatio;

				//Изменяем координаты imageHolder
				item.x = vanishingPointX + item.xpos3D * scaleRatio;
				item.y = vanishingPointY + item.ypos3D * scaleRatio;

			}

		}

		//Эта функция упорядочивает картинки таким образом, что они корректно перекрывают друг друга
		private function sortZ() : void {
//			debug( "*************************sortZ**********************" );

			//Сортировка массива таким образом, что картинка, имеющая самое высокое 
			//положение z  (= самая дальняя) будет первой в массиве
			items.sortOn( "zpos3D", Array.NUMERIC | Array.DESCENDING );

			//Установим новые дочерние индексы для картинок
			for ( var i : uint = 0; i < items.length; i++ ) {
				var item : CarouselMenuItem = items[i] as CarouselMenuItem;
				setChildIndex( item, i );
			}
		}

		//Эта функция вызывается, когда мышь уходит с imageHolder
		private function mouseOutImage( e : Event ) : void {

			e.target.alpha = INACTIVE_ALPHA;
		}

		//Эта функция вызывается, когда мышь находится над imageHolder
		private function mouseOverImage( e : Event ) : void {

			e.target.alpha = 1;
		}

		//Эта функция вызывается,когда происходит клик по  imageHolder 
		private function imageClicked( e : Event ) : void {

			//Навигация на URL, который в переменной "linkTo" 
			//			navigateToURL(new URLRequest(e.target.linkTo));

//			rotateTo( angleDifference );
			showNext( 1 );
		}

		public function showNext( direction : int ) : void {
//			var FPS : uint = 4;

			//подменяем задний item при прокрутке
			var backItem : CarouselMenuItem = getChildAt( 0 ) as CarouselMenuItem;
			var curItem : CarouselMenuItem = currentItem;
			var curItemIndex : int = itemsCache.indexOf( curItem );
			var newIndex : int = curItemIndex + direction * 2;
//			debug( "newIndex", newIndex );
			if ( newIndex < 0 ) {
				newIndex = itemsCache.length + newIndex;
			}
			if ( newIndex > ( itemsCache.length - 1 )) {
				newIndex = newIndex - itemsCache.length;
			}
//			debug( "newIndex 2", newIndex );
			var newItem : CarouselMenuItem = itemsCache[newIndex];

			newItem.ypos3D = backItem.ypos3D;
			newItem.xpos3D = backItem.xpos3D;
			newItem.zpos3D = backItem.zpos3D;
			newItem.currentAngle = backItem.currentAngle;
			removeChild( backItem );
			addChildAt( newItem, 0 );
			items[items.indexOf( backItem )] = newItem;
			rotateTo( 0 );

			//начинаем поворот
			var FPS : uint = this.stage ? stage.frameRate : 21;
			steps = FPS * duration;
			//Вычисляем угловую скорость angleSpeed 
			angleSpeed = angleDifference / steps;
			angleSpeed *= -direction;
			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
		}

		private function updateAfterShowNext() : void {
			dispatchEvent( new Event( Event.CHANGE ));
		}

		private function enterFrameHandler( event : Event ) : void {
//			debug( "step" + steps );
			if ( steps <= 0 ) {
				removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
				steps = 0;
				updateAfterShowNext();
				return;
			}
			rotateTo( angleSpeed );
			steps--;
		}

		//Вычисляем коэффициент масштабирования для imageHolder (чем дальше картинка -> тем меньше масштаб)
		public function getScaleRatio( item : CarouselMenuItem ) : Number {
			var result : Number;

//			var t : uint = RADIUS * 11;
//			result = t / ( t + item.zpos3D );

			result = (( RADIUS - item.zpos3D ) / ( RADIUS * 2 ));
			result = Math.round( result * 100 ) / 100;
//			debug( "scale:", result, Logger.DC_4 );
			return result;
		}

		//угол между items (в радианах)
		public function get angleDifference() : Number {
			var result : Number = Math.PI * ( 360 / onlineShowing ) / 180;
			return result;
		}

		public function get currentItem() : CarouselMenuItem {
			var result : CarouselMenuItem = getChildAt( numChildren - 1 ) as CarouselMenuItem;
			return result;
		}

		/**
		 * XML файл загружен
		 * @param e
		 */
		private function xmlLoaded( e : Event ) : void {

			//Создаем новый  XML объект из загруженных XML данных
			xml = new XML(( e.target as URLLoader ).data );
			xml.ignoreWhitespace = true;

			//Вызывем функцию, которая загружает картинки
			loadImages();
		}

		//Эта функция загружает и создает контейнеры для картинок, определенных в 3D-carousel-settings.xml
		private function loadImages() : void {

			//Получим общее число картинок из XML файла
			allItems = xml.item.length();

			//Цикл по всем картинкам, найденным в XML файле
			for each ( var item : XML in xml.item ) {

				//Создаем новый контейнер картинки 
				var imageHolder : CarouselMenuItem = new CarouselMenuItem();

				//Создаем загрузчик для загрузки картинки
				var imageLoader : Loader = new Loader();

				//Добавим загрузчик картинки к контейнеру картинки
				imageHolder.addChild( imageLoader );

				//Мы не хотим отлавливать никикие события мыши из загрузчика
				imageHolder.mouseChildren = false;

				//Положение imageLoader такое, что точка регистрации контейнера - в центре
//				imageLoader.x = -( IMAGE_WIDTH / 2 );
//				imageLoader.y = -( IMAGE_HEIGHT / 2 );

				//				//Запомним ссылку для imageHolder
				//				imageHolder.linkTo = item.link_to;

				//Добавим  imageHolder в массив  imageHolders 
				items.push( imageHolder );

				//Загружаем картинку
				var itemURL : String = resourcesPath + item.@url;
				imageLoader.load( new URLRequest( itemURL ));

				//Слушаем когда картинка грузится
				imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, imageLoaded );
			}
		}

		//Эта функция вызывается, когда картинка грузится
		private function imageLoaded( e : Event ) : void {

			//Изменяем число загруженных картинок
			numberOfLoadedImages++;

			//Установим bitmap smoothing в true для картинки (мы знаем, что загруженное содержимое - это bitmap).
			e.target.content.smoothing = true;

			//Сделаем проверку, загружена ли последняя картинка
			if ( numberOfLoadedImages == allItems ) {

				//установим карусель
				initialize();
			}
		}

	}
}