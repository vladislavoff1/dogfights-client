package by.vnz.view.battle {
import by.vnz.VO.BattleStepDogVO;
import by.vnz.VO.BattleStepVO;
import by.vnz.VO.EnemyVO;
import by.vnz.VO.vkontakte.AdsVkontakteVO;
import by.vnz.framework.VO.DialogWindowVO;
import by.vnz.framework.events.DialogEvent;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.events.StateEvent;
import by.vnz.framework.audio.SoundsManager;
import by.vnz.framework.view.components.ImageProxy;
import by.vnz.framework.view.core.BaseElement;
import by.vnz.framework.view.elements.DialogWindow;
import by.vnz.idmaps.IDMBattleStates;
import by.vnz.idmaps.IDMFightPopups;
import by.vnz.model.BattleManager;
import by.vnz.model.Model;
import by.vnz.view.user.DogInfoPanel;

public class Battle extends BaseElement {
    static public const STEPS_BETWEEN_BREAK:uint = 1;

    private var _battleManager:BattleManager;
    private var _popupSequence:Array = [];
    private var _stepsAfterLastBreak:uint = 0;

    public var BG:ImageProxy;
    public var countDown:BattleCountDown;
    public var dogLeft:BattleDog;
    public var dogRight:BattleDog;
    public var leftPanel:BattleUserPanel;
    public var rightPanel:BattleUserPanel;
    public var fightBoom:ImageProxy;
    public var leftPopup:FightPopup;
    public var rightPopup:FightPopup;
    public var resultDialog:BattleResultDialog = new BattleResultDialog();
    public var dogInfo:DogInfoPanel;
    

    public function Battle() {
        super();
    }

    override protected function initUI():void {
        var bgNumber:uint = Math.round(Math.random() * 11);
        if (bgNumber <= 0) {
            bgNumber = 1;
        }
        if (bgNumber > 11) {
            bgNumber = 11;
        }
        createUIChild(ImageProxy, <ui name="BG" resource={"arena_bg_0" + bgNumber } x="0" y="0" />);
        createUIChild(BattleCountDown, <ui name="countDown" x="262" y="20" />);
        createUIChild(BattleUserPanel, <ui name="leftPanel" x="9" y="23" />);
        createUIChild(BattleUserPanel, <ui name="rightPanel" x="355" y="23" rightHanded="true" />);

        createUIChild(BattleDog, <ui name="dogLeft" x="40" y="325"  rightHanded="false" />);
        createUIChild(BattleDog, <ui name="dogRight" x="430" y="325"  />);

        createUIChild(ImageProxy, <ui name="fightBoom" resource="fight_boom" x="194" y="142" visible="false" />);

        createUIChild(FightPopup, <ui name="leftPopup" x="17" y="235" rightHanded="false" visible="false" />);
        createUIChild(FightPopup, <ui name="rightPopup" x="400" y="235" visible="false" />);


        //			listenElement( countDown );
        //			listenElement( dogRight );
        //			listenElement( leftPopup );
        //			listenElement( rightPopup );
        //			listenElement( resultDialog );
        //			listenElement( leftPanel );
        //			listenElement( rightPanel );

        _battleManager = Model.instance.battleManager;

        currentState = IDMBattleStates.STATE_INIT;

    }

    override protected function onEnterState(event:StateEvent):void {
        with (IDMBattleStates) {
            switch (event.state) {
                case STATE_INIT: {
                    var enemy:EnemyVO = Model.instance.arenaManager.selectedEnemy;

                    dogLeft.breedID = Model.userData.breedID;
                    dogRight.breedID = enemy.breedID;
                    dogLeft.userID = Model.userID;
                    dogRight.userID = _battleManager.enemyID;
                    dogLeft.winner = ( dogLeft.userID == _battleManager.winID );
                    dogRight.winner = !dogLeft.winner;
                    dogLeft.data = Model.userData;
                    dogRight.data = _battleManager.enemyData;

                    leftPanel.init(Model.userData.name, _battleManager.userHealth, Model.userData.photo);
                    rightPanel.init(enemy.name, _battleManager.enemyHealth, enemy.photo);
                    currentState = STATE_COUNTDOWN;

                    break;
                }
                case STATE_COUNTDOWN: {
                    countDown.countdown();
                    break;
                }
                case STATE_ATTACK: {
                    //					timer.countdown();
                    break;
                }
                case STATE_FIGHT: {
                    fightBoom.visible = true;
                    SoundsManager.requestSound("audio.fight", true);

                    fightStep();
                    break;
                }
                case STATE_FIGHT_END: {
                    //						currentState = STATE_RESULT;
                    break;
                }
                case STATE_RESULT: {
                    var dialogData:DialogWindowVO = new DialogWindowVO();
                    dialogData.allowButtons = DialogWindow.BUTTON_NONE;
                    resultDialog.update(_battleManager.winData);
                    dialogData.content = resultDialog;
                    var dEvent:DialogEvent = new DialogEvent(dialogData);
                    dispatchEvent(dEvent);
                    if (dogLeft.winner) {
                        SoundsManager.requestSound("audio.win", false);
                    }
                    break;
                }

            }

            dogLeft.currentState = event.state;
            dogRight.currentState = event.state;
        }
    }

    override protected function onExitState(event:StateEvent):void {
        with (IDMBattleStates)
            switch (event.state) {
                case STATE_INIT: {
                    //					dogLeft.currentState = event.state;
                    break;
                }
                case STATE_FIGHT: {
                    fightBoom.visible = false;
                    SoundsManager.requestStopSound("audio.fight");
                    break;
                }

            }

    }

    override protected function messageHandler(msg:SimpleMessage):void {
        super.messageHandler(msg);

        switch (msg.text) {
            case BattleCountDown.MSG_COUNTDOWN_COMPLETE:
                currentState = IDMBattleStates.STATE_ATTACK;
                break;
            case BattleDog.MSG_ANIM_COMPLETE:
                if (msg.target != dogRight || currentState == IDMBattleStates.STATE_RESULT) {
                    break;
                }
                var newState:String;
                if (currentState == IDMBattleStates.STATE_FIGHT_BREAK_START) {
                    newState = IDMBattleStates.STATE_FIGHT_BREAK_WAIT;

                }
                if (currentState == IDMBattleStates.STATE_FIGHT_BREAK_WAIT) {
                    newState = IDMBattleStates.STATE_FIGHT_BREAK_END;

                }
                if (currentState == IDMBattleStates.STATE_FIGHT_BREAK_END) {
                    newState = IDMBattleStates.STATE_FIGHT;

                }
                if (newState) {
                    currentState = newState;
                    break;
                }
                var states:Array = IDMBattleStates.sequenceList();
                newState = states[states.indexOf(currentState) + 1];
                currentState = newState;
                break;
            case BattleCountDown.MSG_COUNTDOWN_COMPLETE:
                currentState = IDMBattleStates.STATE_ATTACK;
                break;
            case FightPopup.MSG_HIDE:
                //					fightStep();
                //					setTimeout( fightStep, 200 );
                showNextPopup();
                break;
            case BattleUserPanel.SHOW_INFO:
                createUIChild(DogInfoPanel, <ui name="dogInfo" y="100" />);
                if (msg.target == leftPanel) {
                    dogInfo.data = Model.userData;
                    dogInfo.x = 10;
                } else if (msg.target == rightPanel) {
                    dogInfo.data = _battleManager.enemyData;
                    dogInfo.x = 140;
                }
                dogInfo.show();
                break;
            case BattleUserPanel.HIDE_INFO:
                dogInfo.hide();
                removeChildSafely(dogInfo);
                dogInfo = null;
                break;
        }
    }

    private function fightStep():void {
        if (_stepsAfterLastBreak > STEPS_BETWEEN_BREAK && _battleManager.hasNextStep) {
            _stepsAfterLastBreak = 0;
            currentState = IDMBattleStates.STATE_FIGHT_BREAK_START;
            return;
        }

        var step:BattleStepVO = _battleManager.nextStep;
        if (!step) {
            currentState = IDMBattleStates.STATE_FIGHT_END;
            return;
        }

        _stepsAfterLastBreak++;
        _popupSequence.length = 0;
        for each (var item:BattleStepDogVO in step.steps) {
            _popupSequence.push(item);
        }
        showNextPopup();

    }

    private function showNextPopup():void {
        if (_popupSequence.length == 0) {
            fightStep();
            return;
        }
        
        var step:BattleStepDogVO = _popupSequence.shift();
        //			if ( !step ) {
        //				error( "step", step );
        //			}
        var value:String = IDMFightPopups.getByType(step.stroke);
        value += "(" + step.damage.toString() + ")";
        if (step.contr) {
            value = "Сounterblow " + value;
        }
        if (step.id == dogLeft.userID) {

            leftPopup.show(value);
            rightPanel.updateHealth(step.health);

        } else {
            rightPopup.show(value);
            leftPanel.updateHealth(step.health);

        }

    }
    
    public function setAds(data:AdsVkontakteVO) : void {
       resultDialog.setAds(data);
    }

}
}