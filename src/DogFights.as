package {
import flash.system.Security;
import flash.system.System;

import by.vnz.VO.vkontakte.AdsVkontakteVO;
import by.vnz.VO.vkontakte.FlashVarsVkontakteVO;
import by.vnz.events.MainStatesEvent;
import by.vnz.framework.VO.DialogWindowVO;
import by.vnz.framework.events.DialogEvent;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.events.StateEvent;
import by.vnz.framework.view.MainView;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.elements.DialogWindow;
import by.vnz.idmaps.IDMMainMessages;
import by.vnz.maps.MainMap;
import by.vnz.model.Model;
import by.vnz.view.MainScreen;
import by.vnz.view.arena.Arena;
import by.vnz.view.arena.BuyFightDialog;
import by.vnz.view.bank.VoiceExchange;
import by.vnz.view.battle.Battle;
import by.vnz.view.home.DogHome;
import by.vnz.view.registration.CharCreatingDialog;
import by.vnz.view.shop.Shop;
import by.vnz.view.training_camp.TrainingCamp;

import vnz.text.ZTextField;

[SWF( width="610", height="590", frameRate="31", backgroundColor="#797C86" )]
public class DogFights extends MainView {

    static public const STATE_ARENA:String = "state_arena";
    static public const STATE_BATTLE:String = "state_battle";
    static public const STATE_DOG_HOME:String = "state_dog_home";
    static public const STATE_BANK:String = "state_bank";
    static public const STATE_MAIN_SCREEN:String = "state_main_sreen";
    static public const STATE_WAIT_ADS:String = "state_wait_ads";
    static public const STATE_BUY_FIGHT:String = "state_buy_fight";
    static public const STATE_PRELOADING:String = "state_preloading";
    static public const STATE_REG_APP:String = "state_reg_app";
    static public const STATE_APP_SETTINGS:String = "state_app_settings";
    static public const STATE_REG_DOG:String = "state_reg_dog";
    static public const STATE_SHOP:String = "state_shop";
    static public const STATE_WAIT_DOG_DATA:String = "state_wait_dog_data";
    static public const STATE_TRAINING:String = "state_training";

    private var model:Model
    public var specInfo:ImageProxy;
    public var charCreatingDialog:CharCreatingDialog;

    public var currentService:BaseElement;
    public var mainScreen:MainScreen;

   
	public function DogFights() {
		super();
    }

    override protected function preinitUI():void {
        MainView.CURRENT_VERSION = "1.7.22";
        MainView.BOUNDS_WIDTH = 610;
        MainView.BOUNDS_HEIGHT = 590;
        debug("version", MainView.CURRENT_VERSION);
        super.preinitUI();

//		Security.allowDomain("http://dogfightsgame.com/");
//		Security.allowDomain("https://dogfightsgame.com/");
//		
//      Security.allowDomain("https://*");
//		Security.allowDomain("http://api.facebook.com");
//		Security.allowDomain("http://*.facebook.com");
//		Security.allowDomain("http://facebook.com");
//		Security.allowDomain("https://graph.facebook.com");
//		Security.allowDomain("https://graph.facebook.com/");
//		Security.allowDomain("https://graph.facebook.com/*");
//		Security.allowDomain("https://*.facebook.com");
		Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
		Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
		Security.allowDomain("*");
		Security.allowInsecureDomain("*");
		
        System.useCodePage = false;

        model = new Model(this);
		if(loaderInfo.parameters.viewer_id == undefined)
			model.parseFlashVars({
				//vid: "10877618286447609121",
				//oid: "10877618286447609121",
				//referer_id: "4930430024314628755",
				//app_id : "3611126",
				//api_id:"3611126",
				is_app_user:"1",
				viewer_id: "45564123",
				//lc_name: "b2adf266",
				api_settings: "262146"
			});
		else 
			model.parseFlashVars(loaderInfo.parameters);
		/*if (ExternalInterface.available) 
		{
			ExternalInterface.call('print', 'some text');
		}*/
        var mainMap:MainMap = new MainMap();
        mainMap.model = model;
        addChild(mainMap);

    }

    public function showRegistration(data:XML):void {
        currentState = STATE_REG_DOG;
        charCreatingDialog.show(data);
    }

    public function updateState(newState:String):void {

    }

    override protected function initUI():void {
        ZTextField.defaultEmbedFonts = false;

        var newEvent:MainStatesEvent = new MainStatesEvent(MainStatesEvent.INIT);
        newEvent.callback = updateState;
        dispatchEvent(newEvent);
    }

    override protected function messageHandler(event:SimpleMessage):void {
        switch (event.text) {
            case IDMMainMessages.MSG_SHOP_ENTER:
                currentState = STATE_SHOP;
                break;

            case IDMMainMessages.MSG_HOME_ENTER:
                currentState = STATE_DOG_HOME;
                break;
			                          
            case IDMMainMessages.MSG_ARENA_ENTER:
                model.battleGetEnemies();
                break;

            case IDMMainMessages.MSG_BATTLE_ENTER:
                currentState = STATE_BATTLE;
                break;

            case IDMMainMessages.MSG_BANK_ENTER:
                currentState = STATE_BANK;
                break;
            case IDMMainMessages.MSG_TRAINING_ENTER:
                currentState = STATE_TRAINING;
                    break;
            case IDMMainMessages.MSG_HUNTING_ENTER:
                showMessage("Win hunting the beast and get a decent reward. COMING SOON !!!");
                break;
            case IDMMainMessages.MSG_BUY_FIGHT_EXIT:
            case IDMMainMessages.MSG_ARENA_EXIT:
            case IDMMainMessages.MSG_HOME_EXIT:
            case IDMMainMessages.MSG_BATTLE_EXIT:
            case IDMMainMessages.MSG_SHOP_EXIT:
            case IDMMainMessages.MSG_TRAINING_EXIT:
            case IDMMainMessages.MSG_BANK_EXIT: {
                currentState = STATE_MAIN_SCREEN;
                break;
            }
        }
    }

    override protected function onEnterState(event:StateEvent):void {
        switch (event.state) {
            case STATE_REG_APP: {
                createUIChild(ImageProxy, <ui name="specInfo" resource="AddAppDialog" x="0" y="0" />);
                break;
            }
            case STATE_PRELOADING: {
                createUIChild(ImageProxy, <ui name="specInfo" resource="LoadingDialog" x="215" y="205" />);
                break;
            }
                case STATE_APP_SETTINGS: {
                createUIChild(ImageProxy, <ui name="specInfo" resource="app_settings" x="0" y="0" />);
                break;
            }
            case STATE_REG_DOG: {
                createUIChild(CharCreatingDialog, <ui name="charCreatingDialog" />);
                break;
            }
            case STATE_MAIN_SCREEN: {
                hideWaitServerAnswer();
                if (!mainScreen) {
                    createUIChild(MainScreen, <ui name="mainScreen" />);
                    listenElement(mainScreen);
                    mainScreen.userPanel.data = Model.userData;
                }

                break;
            }
            case STATE_BUY_FIGHT: {
                var buyFight:BuyFightDialog = new BuyFightDialog();
                currentService = buyFight as BaseElement;
                break;
            }
            case STATE_SHOP: {
                removeChildSafely(currentService);
                currentService = createUIChild(Shop, <ui name="currentService" x="3" y="85"/>, null, ( getChildIndex(mainScreen) + 1 ));
                listenElement(currentService);
                model.getShopItems();
                //					msgDialog.visible = true;
                break;
            }
            case STATE_DOG_HOME: {
                removeChildSafely(currentService);
                currentService = createUIChild(DogHome, <ui name="currentService" x="3" y="85"/>, null, ( getChildIndex(mainScreen) + 1 ));
                listenElement(currentService);
                dialogsLayer.visible = true;
                model.getDogHome();
                break;
            }
            case STATE_ARENA: {
                removeChildSafely(currentService);
                currentService = createUIChild(Arena, <ui name="currentService" x="5" y="85"/>, null, ( getChildIndex(mainScreen) + 1 ));
                listenElement(currentService);
                break;
            }
            case STATE_BATTLE: {
                removeChildSafely(currentService);
                currentService = createUIChild(Battle, <ui name="currentService" y="0"/>, null, ( getChildIndex(mainScreen) + 1 ));
                listenElement(currentService);
                break;
            }
            case STATE_BANK: {
                removeChildSafely(currentService);
                currentService = createUIChild(VoiceExchange, <ui name="currentService" y="0"/>, null, ( getChildIndex(mainScreen) + 1 ));
                listenElement(currentService);
                model.getUserBalance();
                break;

            }
            case STATE_TRAINING: {
                removeChildSafely(currentService);
                currentService = createUIChild(TrainingCamp, <ui name="currentService" x="5" y="85"/>, null, ( getChildIndex(mainScreen) + 1 ));
                listenElement(currentService);
                model.getTrainingCamp();
                break;

            }

        }
    }

    override protected function onExitState(event:StateEvent):void {
        switch (event.state) {
            case STATE_REG_APP:
            case STATE_PRELOADING:
            case STATE_APP_SETTINGS:
                removeChildSafely(specInfo);
                break;
            case STATE_REG_DOG: {
                removeChildSafely(charCreatingDialog);
                charCreatingDialog = null;
            }
            case STATE_MAIN_SCREEN: {
                break;
            }
            case STATE_BATTLE:
                model.getDog();
            //                dialogsLayer.removeDialogs();
            case STATE_ARENA:
            case STATE_SHOP:
            case STATE_TRAINING:
            case STATE_DOG_HOME: {
                currentService.destroy();
                ignoreElement(currentService);
                removeChildSafely(currentService);
                currentService = null;
                break;
            }
        }
    }

    public function shopBuyResult(result:Boolean, text:String):void {
        var dialogData:DialogWindowVO = new DialogWindowVO();
        dialogData.allowButtons = DialogWindow.BUTTON_CONFIRM;
        //			if ( result ) {
        dialogData.text = text;
        //			} else {
        //				dialogData.text = "Недостаточно денег!";
        //
        //			}
        var dEvent:DialogEvent = new DialogEvent(dialogData);
        dispatchEvent(dEvent);
    }

    public function showMessage(text:String):void    {              
  //ч();

        var dialogData:DialogWindowVO = new DialogWindowVO();
        dialogData.allowButtons = DialogWindow.BUTTON_CONFIRM;
        dialogData.text = text;
        var dEvent:DialogEvent = new DialogEvent(dialogData);
        dispatchEvent(dEvent);
    }

    public function showFightLocked(ads:AdsVkontakteVO):void {
        var dialogData:DialogWindowVO = new DialogWindowVO();
        dialogData.allowButtons = DialogWindow.BUTTON_NONE;
        (currentService as BuyFightDialog).setAds(ads);
        dialogData.content = currentService;
        var dEvent:DialogEvent = new DialogEvent(dialogData);
        dispatchEvent(dEvent);
    }

    public function showUserLocked(text:String):void {
        var dialogData:DialogWindowVO = new DialogWindowVO();
        dialogData.allowButtons = DialogWindow.BUTTON_NONE;
        dialogData.text = text;
        var dEvent:DialogEvent = new DialogEvent(dialogData);
        dispatchEvent(dEvent);
    }

    public function showError(text:String, critical:Boolean = false):void {
        var dialogData:DialogWindowVO = new DialogWindowVO();
        dialogData.allowButtons = DialogWindow.BUTTON_CONFIRM;

        var title:String = "ERROR!!!";
        if (critical) {
            this.mouseEnabled = this.mouseChildren = false;
        }
        dialogData.text = title + "\n" + text;
        var dEvent:DialogEvent = new DialogEvent(dialogData);
        dispatchEvent(dEvent);

    }

    public function showWaitServerAnswer():void {
        var dialogData:DialogWindowVO = new DialogWindowVO();
        dialogData.allowButtons = DialogWindow.BUTTON_NONE;
        dialogData.text = "Please wait...";
        var dEvent:DialogEvent = new DialogEvent(dialogData);
        dispatchEvent(dEvent);
    }

    public function hideWaitServerAnswer():void {
        dialogsLayer.removeDialogs();
    }
}
}