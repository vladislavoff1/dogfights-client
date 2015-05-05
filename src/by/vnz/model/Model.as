package by.vnz.model {
import flash.external.ExternalInterface;
import com.facebook.graph.Facebook;
import by.vnz.VO.DogVO;
import by.vnz.VO.EnemyVO;
import by.vnz.VO.FriendVO;
import by.vnz.VO.ShopItemVO;
import by.vnz.VO.TrainingItemVO;
import by.vnz.VO.mail_ru.APIMailRuVO;
import by.vnz.VO.mail_ru.FlashVarsMailRu;
import by.vnz.VO.vkontakte.APIVkontakteVO;
import by.vnz.VO.vkontakte.AdsVkontakteVO;
import by.vnz.VO.vkontakte.AppSettingsVkontakteVO;
import by.vnz.VO.vkontakte.FlashVarsVkontakteVO;
import by.vnz.framework.VO.WebRequestVO;
import by.vnz.framework.model.HTTPRequester;
import by.vnz.framework.model.RequestVars;
import by.vnz.framework.resources.EnhancedResource;
import by.vnz.framework.resources.ResourcesManager;
import by.vnz.framework.resources.loading.ResourceLoader;
import by.vnz.framework.social_net.BaseFlashVarsVO;
import by.vnz.framework.social_net.ISocialAPI;
import by.vnz.framework.view.MainView;
import by.vnz.idmaps.IDMServerMethods;
import by.vnz.model.TrainingDataManager;
import by.vnz.view.arena.Arena;
import by.vnz.view.arena.BuyFightDialog;
import by.vnz.view.bank.VoiceExchange;
import by.vnz.view.battle.Battle;
import by.vnz.view.home.DogHome;
import by.vnz.view.shop.Shop;

import by.vnz.view.staff.VKAPIConnection;
import by.vnz.view.staff.VKWrapper;
import by.vnz.view.training_camp.TrainingCamp;

import flash.events.Event;

import logger.Logger;

import vnz.utils.MD5;

public class Model {
	static private var _instance:Model = null;

	static public var userData:DogVO = new DogVO(); //"53620871"

	private var _flashVars:BaseFlashVarsVO;
	private var _resourcesManager:ResourcesManager;
	private var _webProxy:HTTPRequester;
	private var _queryList:Array = new Array();
	private var _vkAPIConn:VKAPIConnection;
	private var _view:DogFights;

	public var shopManager:ShopDataManager = new ShopDataManager();
	public var homeManager:HomeDataManager = new HomeDataManager();
	public var arenaManager:ArenaManager = new ArenaManager();
	public var battleManager:BattleManager = new BattleManager();
	public var trainingManager:TrainingDataManager = new TrainingDataManager();

	private var needStartInfo:Boolean = true;

	public function Model(target:MainView) {
		super();
		BuildConfig.init();
	
		_webProxy = new HTTPRequester(BuildConfig.BASE_URL, BuildConfig.SOCIAL_API_URL)
		_view = target as DogFights;

		if (!_instance) {
			_instance = this;
		} else {
			throw( "!" );
		}
	}

	static public function get instance():Model {
		var result:Model;
		result = _instance;
		return result;
	}

	public function get flashVars():BaseFlashVarsVO {
		return _flashVars;
	}

	public function parseFlashVars(flashParameters:Object):void {
		userData.viewer_id = flashParameters.viewer_id;
		var vars:BaseFlashVarsVO;
		if (!BuildConfig.onMailRu) {
			vars = new FlashVarsVkontakteVO();
		} else {
			vars = new FlashVarsMailRu();
		}
		for (var prop:String in flashParameters) {
			debug("loaderInfo.parameters | " + prop, flashParameters[prop]);
			if (vars.hasOwnProperty(prop)) {
				vars[prop] = flashParameters[prop];
				debug("set var | " + prop, vars[prop]);
			}
		}

		_flashVars = vars;
		APIVkontakteVO.appID = _flashVars.apiID;
		//APIMailRuVO.appID = _flashVars.apiID;
		if (!userID) {
			_view.showError("Problem with facebook.com. Relogin please!", true);
		}
		//if (!BuildConfig.onMailRu) {
			_vkAPIConn = new VKAPIConnection();
			_vkAPIConn.init((_flashVars as FlashVarsVkontakteVO).lc_name);
		//}
	}

	static public function get userID():String {
		return _instance.flashVars.viewerID;
	}

	public function get sig():String {
		var result:String = MD5.encrypt(userID + APIVkontakteVO.secret_key);
		return result;
	}

	public function init():void {
		_resourcesManager = new ResourcesManager();
		_resourcesManager.attachTo(_view);

		var resLoader:ResourceLoader = new ResourceLoader();
		resLoader.addEventListener(Event.COMPLETE, startResourcesLoaded);
		resLoader.load("resources/start_resources.xml");
	}

	private function startResourcesLoaded(event:Event):void {
		debug("start resources loaded!");

		if (flashVars.is_app_user == 0) {
			if (BuildConfig.onMailRu) {
				_view.currentState = DogFights.STATE_REG_APP;
			} else {
				_vkAPIConn.showInstallApp(appInstallHandler);
			}
		} else {
			appInstallHandler();
		}
	}

	public function appInstallHandler():void {
		if (BuildConfig.OFFLINE_MODE) {
			needStartInfo = false;
			loadMainResources();
		} else {
			if (BuildConfig.onMailRu) {
				loadMainResources();
			} else {
				parseSettings((_flashVars as FlashVarsVkontakteVO).api_settings);
			}
			//                getSettings();
		}
	}

	public function loadMainResources():void {
		debug("loading main resources...");
		_view.currentState = DogFights.STATE_PRELOADING;
		var resLoader:ResourceLoader = new ResourceLoader();
		resLoader.addEventListener(Event.COMPLETE, mainResourcesLoaded);
		resLoader.load("resources/resources.xml");
	}

	private function mainResourcesLoaded(event:Event):void {
		debug("main resources loaded!");
		//			_view.currentState = DogFights.STATE_WAIT_DOG_DATA;
		_view.currentState = DogFights.STATE_MAIN_SCREEN;
		getDog();
		//_view.currentState = DogFights.STATE_MAIN_SCREEN;
	}

	/**
	 ***********************
	 * Requests to API vkontakte
	 **********************
	 */
	protected function getFriends():void {
		var params:String = null;
		var method:String;
		//debug('facebook getFriends');

		/*Facebook.api(
			'/me/friends?fields=id,first_name,photo', 
			function Ansver(response):void {
				ExternalInterface.call('print', response);
				debug('facebook ' + response);
			}
		);*/
		//method = APIVkontakteVO.GET_FRIENDS;
		//var requestData:WebRequestVO = getRequestData(method, params, true);
		//_webProxy.request(requestData, true);
	}

	public function isAppUser():void {
		//var params : String = "uid=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.IS_APP_USER, null, true);
		_webProxy.request(requestData, true);
	}

	public function getSettings():void {
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.GET_APP_SETTINGS, null, true);
		_webProxy.request(requestData, true);
	}

	public function getUsersProfiles(users:Array, usersType:String = "friends"):void {
		var params:String;
		var method:String;
		/*debug('facebook getFriends');
		Facebook.api(
			'/me?fields=id,first_name,photo', 
			function Ansver(response):void {
				ExternalInterface.call('print', response);
				debug('facebook ' + response);
			}
		);*/
		/*if (!BuildConfig.onMailRu) {
			params = "uids=" + users.join(",") + "&fields=uid,photo"; //,photo_medium,photo_big";
			method = APIVkontakteVO.USER_PROFILES;
		} else {
			params = "uid=" + userID + "&uids=" + users.join(",");
			method = APIMailRuVO.USER_PROFILES;
		}
		var requestData:WebRequestVO = getRequestData(method, params, true);
		requestData.special = usersType;
		_webProxy.request(requestData, true);*/
	}

	public function getAds():void {
		var params:String = "type=3" + "&count=1";//&" + "test_mode=1";
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.GET_ADS, params, true);
		_webProxy.request(requestData, true);
	}

	public function inviteFriends():void {
		if (ExternalInterface.available) {
			ExternalInterface.call("invite");
		}
	}

	/**
	 ***********************
	 *request for internal server
	 ********************** 
	 */
	public function getDog():void {
		if (needStartInfo) {
			_view.showWaitServerAnswer();
		}
		var params:String = "user=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.GET_DOG, params);
		requestData.special = "user";
		_webProxy.request(requestData);
	}

	public function getStartInfo():void {
		getUsersProfiles([userID], "user");
		getFriends();
	}

	public function getDogList():void {
		var params:String = "user=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.DOG_LIST, params);
		_webProxy.request(requestData);

	}

	public function chooseDog():void {
		//        if (itemData.price > userData.money) {
		//            _view.showMessage("Недостаточно денег!");
		//            return;
		//        }
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.CHOOSE_DOG, null);
		_webProxy.request(requestData);

	}


	public function regUser(dogID:uint, nickName:String):void {
		var params:String = "breed=" + dogID + "&user=" + userID + "&name=" + nickName;
		var method:String = IDMServerMethods.REG_DOG;
		if (userData.breedID > 0) {
			method = IDMServerMethods.CHANGE_DOG;
		} else {
			var refID:String = BuildConfig.onMailRu ? (flashVars as FlashVarsMailRu).referer_id : userID;
			if (refID) {
				params += "&invite=" + refID;
			}
		}
		var requestData:WebRequestVO = getRequestData(method, params);
		_webProxy.request(requestData);

	}

	public function getShopItems():void {
		_view.showWaitServerAnswer();
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.SHOP_ITEMS);
		_webProxy.request(requestData);

	}

	public function buyShopItem(itemData:ShopItemVO, amount:uint = 1):void {
		if (itemData.price > userData.money) {
			_view.showMessage("No money!");
			return;
		}
		var params:String = "user=" + userID + "&item=" + itemData.itemID + "&amount=" + amount;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.SHOP_BUY_ITEM, params);
		_webProxy.request(requestData);

	}

	public function getDogHome():void {
		_view.showWaitServerAnswer();
		var params:String = "user=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.DOG_HOME_INFO, params);
		_webProxy.request(requestData);

	}

	public function dogHomeMoveItem(itemID:uint, amount:uint, slot:uint, from:uint):void {
		for each(var item:WebRequestVO in _webProxy.activeRequests) {
			if (item.method == IDMServerMethods.DOG_HOME_MOVE_ITEM) {
				warn("request MOVE ITEM Repeated!!!");
				return;
			}
		}

		_view.showWaitServerAnswer();
		var params:String = "user=" + userID + "&item=" + itemID + "&amount=" + amount + "&slot=" + slot;
		if (from > 0) {
			params += "&from=" + from;
		}
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.DOG_HOME_MOVE_ITEM, params);
		_webProxy.request(requestData);

	}

	public function dogHomeSellItem(itemID:uint, amount:uint, slot:uint):void {
		var params:String = "user=" + userID + "&item=" + itemID + "&amount=" + amount + "&slot=" + slot;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.DOG_HOME_SELL_ITEM, params);
		_webProxy.request(requestData);

	}

	public function buyFight():void {
		var params:String = "user=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.BUY_FIGHT, params);
		_webProxy.request(requestData);

	}

	public function battleGetEnemies():void {
		_view.showWaitServerAnswer();
		var params:String = "user=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.BATTLE_GET_ENEMIES, params);
		_webProxy.request(requestData);

	}

	public function battleFight(enemy:EnemyVO):void {
		_view.showWaitServerAnswer();
		getDogInfo(enemy.user, "enemy");

		arenaManager.selectedEnemy = enemy;
		var params:String = "user=" + userID + "&enemy=" + enemy.user;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.BATTLE_FIGHT, params);
		_webProxy.request(requestData);

	}

	public function getDogInfo(id:String, userType:String = "friend"):void {
		var params:String = "user=" + id;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.GET_DOG, params);
		requestData.special = userType;
		_webProxy.request(requestData);
	}

	public function getFightEnabled():void {
		var params:String = "user=" + userID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.FIGHT_ENABLED, params);
		_webProxy.request(requestData);
	}

	public function getUserBalance():void {
		return;
	}

	public function addUserBalance(voices:uint, bySMS = true):void {
		if (ExternalInterface.available) {
			ExternalInterface.call("buy", voices);
		}
		debug("addUserBalance", voices);
		var params:String = "user=" + userID + "&votes=" + voices; //userID;
		var method:String = IDMServerMethods.VOICES_EXCHANGE;

		var requestData:WebRequestVO = getRequestData(method, params, BuildConfig.onMailRu);
		_webProxy.request(requestData, BuildConfig.onMailRu);

	}

	private function getFriendsReting(friends:String):void {
		var params:String = "user=" + userID + "&friends=" + friends;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.FRIENDS_REITING, params);
		_webProxy.request(requestData);
	}

	public function getTrainingCamp():void {
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.TRAINING_CAMP_ITEMS, null);
		_webProxy.request(requestData);
	}

	public function trainingCampUse(trainingData:TrainingItemVO):void {
		var params:String = "user=" + userID + "&training=" + trainingData.itemID;
		var requestData:WebRequestVO = getRequestData(IDMServerMethods.TRAINING_CAMP_USE, params);
		_webProxy.request(requestData);

	}

	//----------------------

	private function getRequestData(method:String, params:String = null, socialNet:Boolean = false, handler:Function = null):WebRequestVO {
		var requestData:WebRequestVO = new WebRequestVO();
		requestData.method = method;
		requestData.resultHandler = ( handler != null ? handler : requestHandler );
		if (!socialNet) {
			if (!params) {
				params = "sig=" + sig; //+ "32"
			} else {
				params += "&sig=" + sig; // + "32"
			}
			params += "&anticache=" + Math.round(Math.random() * (uint.MAX_VALUE - 100));
		}
		requestData.params = new RequestVars(params);
		if (socialNet) {
			initSNetRequestData(requestData);
		}
		return requestData;
	}


	private function initSNetRequestData(data:WebRequestVO):void {
		var api:ISocialAPI = new APIVkontakteVO();
		var props:Array = APIVkontakteVO.requiredProps;
		if (BuildConfig.onMailRu) {
			api = new APIMailRuVO();
			props = APIMailRuVO.requiredProps;
		}


		for each (var prop:String in props) {
			data.params[prop] = api[prop];
		}
		data.params["method"] = data.method;
		data.params["sig"] = api.initSig(data.params, userID);

		data.useBase64 = false;
	}

	//parse request answers
	private function parseSettings(value:uint):void {
		var settings:AppSettingsVkontakteVO = new AppSettingsVkontakteVO();
		settings.update(value);
		if (!settings.friends) {
			//            _view.currentState = DogFights.STATE_APP_SETTINGS;
			_vkAPIConn.showSettings(parseSettings);
		} else {
			loadMainResources();
		}
	}

	private function requestHandler(requestVO:WebRequestVO, data:*):void {
		var xml:XML = data as XML;

		if (!xml || xml.hasOwnProperty("@error")) {
			parseRequestError(requestVO, xml);
			return;
		}
		var resultType:int = 0;
		if (xml.hasOwnProperty("@type")) {
			resultType = uint(xml.@type);
		}
		var msg:String = String(xml.msg.*);
		with (IDMServerMethods) {
			switch (requestVO.method) {
				case GET_DOG:
					if (resultType == 2) {
						getDogList();
					} else if (resultType == 1) {
						var dogXML:XML = xml.dog[0];
						if (requestVO.special == "user") {
							userData.update(dogXML);
							if (needStartInfo) {
								_view.hideWaitServerAnswer();
								needStartInfo = false;
								getStartInfo();
							}
							if (parseInt(xml.bonus.*) == 1) {
								_view.showMessage("You enrolled daily bonus - 50 coins!");
							}
						} else {
							if (requestVO.special == "friend") {
								_view.mainScreen.friends.setDogInfo(dogXML);
							} else {
								battleManager.enemyData.update(dogXML);
							}
						}
					} else if (resultType == 3) {
						_view.showUserLocked(msg);
					}
					break;
				case APIVkontakteVO.USER_PROFILES:
				case APIMailRuVO.USER_PROFILES:
					if (requestVO.special == "user") {
						var item:XML = xml.user[0];
						if (String(item.uid.*) == userID) {
							userData.update(item);
						}
					} else {
						if (requestVO.special == "friends") {
							_view.mainScreen.friends.addUserProfiles(xml.user);
						} else {
							arenaManager.addUserProfiles(xml.user);
						}
					}

					break;
				case FRIENDS_REITING   :
					if (resultType == 4) {
						var rFriends:Array = new Array();
						var friendsIDs:Array = new Array();
						for each(var item:XML in xml.friend) {
							var friend:FriendVO = new FriendVO(item);
							rFriends.push(friend);
							friendsIDs.push(friend.user);
						}
						_view.mainScreen.friends.setFriendsList(rFriends);
						getUsersProfiles(friendsIDs);
					}
					break;
				case APIMailRuVO.GET_FRIENDS  :
				case APIVkontakteVO.GET_FRIENDS  :
					var friends:Array = new Array();
					for each(var userXML:XML in xml.children()) {
						friends.push(String(userXML.*));
					}
					if (friends.length > 0) {
						getFriendsReting(friends.join(","));

					}
					break;
				case DOG_LIST:
					_view.hideWaitServerAnswer();
					_view.showRegistration(xml);
					break;
				case REG_DOG:
				case CHANGE_DOG:
					_view.currentState = DogFights.STATE_MAIN_SCREEN;
					getDog();
					_view.showMessage(msg);
					break;
				case SHOP_ITEMS:
					_view.hideWaitServerAnswer();
					shopManager.update(xml.item);
					if (_view.currentService && _view.currentService is Shop) {
						( _view.currentService as Shop ).init();

					}
					break;
				case SHOP_BUY_ITEM:
					if (resultType == 4) {
						_view.shopBuyResult(false, msg);
					} else {
						_view.shopBuyResult(true, msg);
						getDog();
					}
					break;

				case DOG_HOME_INFO:
					_view.hideWaitServerAnswer();
					homeManager.update(xml.children());
					if (_view.currentService && _view.currentService is DogHome) {
						( _view.currentService as DogHome ).init(homeManager.getItems(), homeManager.getItems(false), userData);

					}
					break;
				case DOG_HOME_MOVE_ITEM:
				case DOG_HOME_SELL_ITEM:
					_queryList.push(getDog, getDogHome);
					break;
				case CHOOSE_DOG:
					_view.hideWaitServerAnswer();
					_view.showRegistration(xml);
					break;
				case BUY_FIGHT:
					if (resultType == 5) {
						getDog();
						battleGetEnemies();
					} else if (resultType == 3) {
						_view.showMessage(msg);
					}
					break;
				case BATTLE_GET_ENEMIES:
					if (resultType == 1) {
						_view.hideWaitServerAnswer();
						_view.currentState = DogFights.STATE_ARENA;
						arenaManager.update(xml);
						var arena:Arena = _view.currentService as Arena;
						if (arena) {
							arena.init(arenaManager.enemiesList);
						}
						getUsersProfiles(arenaManager.usersIDs, "enemies");
					} else if (resultType == 4) {
						_view.currentState = DogFights.STATE_BUY_FIGHT;
						var buyFight:BuyFightDialog = _view.currentService as BuyFightDialog;
						buyFight.waiting = String(xml.time.*);
						if (BuildConfig.onMailRu) {
							_view.showFightLocked(null);
						} else {
							getAds();
						}
					} else if (resultType == 6) {
						_view.showMessage(msg);
					}

					break;
				case BATTLE_FIGHT:
					_view.hideWaitServerAnswer();
					battleManager.update(xml);
					_view.currentState = DogFights.STATE_BATTLE;
					getAds();
					break;
				case GET_USER_BALANCE:
					var bank:VoiceExchange = _view.currentService as VoiceExchange;
					if (bank) {
						bank.voices = uint(xml.votes.*);

					}
					break;
				case VOICES_EXCHANGE:
					//_view.showMessage(String(xml.msg.*));
					getDog();
					break;
				case GET_APP_SETTINGS:
					//                    parseSettings(xml)

					break;
				case GET_ADS:
					var ads:AdsVkontakteVO;
					if (xml.ad.length() > 0) {
						var adsXML:XML = xml.ad[0]
						ads = new AdsVkontakteVO();
						ads.update(adsXML);
					}

					if (_view.currentState == DogFights.STATE_BATTLE) {
						var battle:Battle = _view.currentService as Battle;
						if (battle) {
							battle.setAds(ads);
						}
					} else if (_view.currentState == DogFights.STATE_BUY_FIGHT) {
						_view.showFightLocked(ads);
					}
					break;
				case TRAINING_CAMP_ITEMS:
					_view.hideWaitServerAnswer();
					trainingManager.update(xml.item);
					if (_view.currentService && _view.currentService is TrainingCamp) {
						( _view.currentService as TrainingCamp).init();

					}
					break;
				case TRAINING_CAMP_USE:
					_view.currentState = DogFights.STATE_MAIN_SCREEN;
					_view.showMessage(msg);
					getDog();
					break;
				case TRAINING_CAMP_USE:
					_view.currentState = DogFights.STATE_MAIN_SCREEN;
					_view.showMessage(msg);
					getDog();
					break;

			}
		}

		if (_queryList.length > 0) {
			var curRequest:Function = _queryList.shift() as Function;
			if (curRequest != null) {
				curRequest();
			}
		}
		//			var vars : URLVariables = new URLVariables( loader.data );
		//			trace( "The answer is " + vars.answer );
	}

	private function parseRequestError(requestVO:WebRequestVO, xml:XML):void {
		_view.hideWaitServerAnswer();
		if (!xml) {
			_view.showError("Error on parse server data", false);
			return;
		}
		//        debug("РѕС€РёР±РєР° РѕС‚ СЃРµСЂРІРµСЂР°", xml.error.msg.*);
		_view.showError(String(xml.error.msg.*), false);
	}

	//		private function getScriptName( methodID : String ) : String {
	//			var result : String = "";
	//			var tempArray : Array = methodID.split( "|" );
	//			if ( tempArray.length > 0 ) {
	//				result = String( tempArray[0]);
	//			}
	//
	//			return result;
	//		}
	//
	//		public function getActionParam( methodID : String ) : String {
	//			var result : String = "";
	//			var tempArray : Array = methodID.split( "|" );
	//			if ( tempArray.length > 1 ) {
	//				result = tempArray[1];
	//				if ( result.indexOf( "do=" ) == -1 ) {
	//					result = "";
	//				} else {
	//
	//				}
	//			}
	//
	//			return result;
	//		}
}
}