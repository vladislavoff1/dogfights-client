package by.vnz.framework.view.elements {
import by.vnz.framework.events.DialogEvent;
import by.vnz.framework.events.SimpleMessage;
import by.vnz.framework.view.MainView;
import by.vnz.framework.view.core.BaseElement;

import flash.display.Sprite;
import flash.events.MouseEvent;

import vnz.core.ZSprite;

public class DialogsLayer extends BaseElement {
    private var _modalBlocker:ZSprite;
    private var dialogStack:Array;

    public function DialogsLayer() {
        super();

        this.mouseEnabled = false;
        dialogStack = new Array();
    }


    public function attachTo(target:Sprite):void {
        target.addEventListener(DialogEvent.ADD_DIALOG, onRequest, false, 0, true);
        target.addEventListener(DialogEvent.REMOVE_DIALOG, onRequest, false, 0, true);
    }

    override protected function initUI():void {
        super.initUI();

        setSize(MainView.BOUNDS_WIDTH, MainView.BOUNDS_HEIGHT);
        createModality();
    }

    public function removeDialogs():void {
        for each (var item:DialogWindow in dialogStack) {
            ignoreElement(item);
            removeChild(item);
        }
        dialogStack = [];
        _modalBlocker.visible = false;
    }


    override protected function messageHandler(event:SimpleMessage):void {
        var aDialog:DialogWindow;

        switch (event.text) {
            case DialogWindow.MESSAGE_CANCEL:
            case DialogWindow.MESSAGE_CONFIRM: {
                var anIndex:int;

                aDialog = event.target as DialogWindow;
                anIndex = dialogStack.indexOf(aDialog);
                dialogStack.splice(anIndex, 1);
                ignoreElement(aDialog);
                removeChildSafely(aDialog);
                //invalidate();
                break;
            }

            case DialogWindow.MESSAGE_REDRAW: {
                aDialog = event.target as DialogWindow;
                aDialog.visible = true;
                arrangeDialogs();
                //					aDialog.x = ( this.width - aDialog.width ) / 2;
                //					aDialog.y = ( this.height - aDialog.height ) / 2;

                break;
            }
        }

        _modalBlocker.visible = ( dialogStack.length > 0 );
    }


    override protected function redraw():void {
        arrangeDialogs();
    }


    private function arrangeDialogs():void {
        var aDialog:DialogWindow;
        var prevDialog:DialogWindow;

        if (dialogStack.length > 0) {
            arrangeFirst();
        }

        for (var i:int = 1; i < dialogStack.length; i++) {
            aDialog = dialogStack[i];
            prevDialog = dialogStack[i - 1];

            arrangeFirst(aDialog);
        }
    }


    private function arrangeFirst(dialog:DialogWindow = null):void {
        if (dialog == null) {
            dialog = dialogStack[0];
        }

        dialog.x = Math.round(( width - dialog.width ) / 2);
        dialog.y = Math.round(( height - dialog.height ) / 2);
        //dialog.visible = true;
    }


    private function createModality():void {
        _modalBlocker = new ZSprite();

        _modalBlocker.graphicsDrawRect(width, height, 0x000000, 0.3);
        _modalBlocker.visible = false;
        _modalBlocker.addEventListener(MouseEvent.CLICK, blocker_clickHandler);

        addChild(_modalBlocker);
    }

    private function blocker_clickHandler(event:MouseEvent):void {
        //bloked
    }

    private function onRequest(event:DialogEvent):void {
        switch (event.type) {
            case DialogEvent.ADD_DIALOG: {
                var newDialog:DialogWindow = new DialogWindow();
                listenElement(newDialog);
                addChild(newDialog);
                newDialog.data = event.dialogData;
                dialogStack.push(newDialog);
                //					debug( this, newDialog, Logger.DC_5 );
                //invalidate();
                break;
            }

            case DialogEvent.REMOVE_DIALOG: {
                var anIndex:int;

                //					anIndex = dialogStack.indexOf( event.dialog );
                //					dialogStack.splice( anIndex, 1 );
                //					ignoreElement( event.dialog );
                //					removeChild( event.dialog );
                //					debug( this, event.dialog, Logger.DC_2 );
                //invalidate();
                break;
            }
        }

        _modalBlocker.visible = ( dialogStack.length > 0 );
    }

}
}
