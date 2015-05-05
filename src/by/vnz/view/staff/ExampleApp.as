package by.vnz.view.staff{
  import flash.display.Sprite;
  import flash.text.*;
  import flash.events.*;
  import flash.display.*;

  
  /**
   * @author Andrew Rogozov
   */
  public class ExampleApp extends Sprite {
  	public var wrapper: Object;
  	
    public function ExampleApp() {
    	this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
    
    public function onAddedToStage(e: Event): void {
    	wrapper = Object(this.parent.parent);
    
      drawRect(wrapper.application.stageWidth, wrapper.application.stageHeight);
    	
    	var tf: TextField = new TextField();
    	tf.x = 15;
    	tf.y = 50;
    	tf.width = wrapper.application.stageWidth - 30;
    	tf.height = 2000;
    	tf.embedFonts = false;

 			var format:TextFormat = new TextFormat();
      format.font = "Tahoma";
			format.color = 0x000000;
			format.size = 11;
			tf.defaultTextFormat = format;
    	addChild(tf);
    	
    	tf.appendText("Application initialized\n");
    	tf.appendText("Frame rate: "+ wrapper.application.frameRate + "\n");
    	tf.appendText("Viewer Id: "+ wrapper.application.parameters.viewer_id + "\n");
//      try {
//      	var btn: VKButton = new VKButton('Settings');
//      	btn.x = 15;
//      	btn.y = 15;
//      	addChild(btn);
//
//      	var btn1: VKButton = new VKButton('Invite friends');
//      	btn1.x = btn.x + btn.width + 12;
//      	btn1.y = btn.y;
//      	addChild(btn1);
//
//      	var btn2: VKButton = new VKButton('Install application');
//      	btn2.x = btn1.x + btn1.width + 12;
//      	btn2.y = btn1.y;
//      	addChild(btn2);
//
//      	var btn3: VKButton = new VKButton('Resize stage');
//      	btn3.x = btn2.x + btn2.width + 12;
//      	btn3.y = btn2.y;
//      	addChild(btn3);
//
//      	var btn4: VKButton = new VKButton('Add votes');
//      	btn4.x = btn3.x + btn3.width + 12;
//      	btn4.y = btn3.y;
//      	addChild(btn4);
//
//
//      	btn.addEventListener(MouseEvent.CLICK, function(e: MouseEvent):void {
//      		wrapper.external.showSettingsBox();
//      	});
//      	btn1.addEventListener(MouseEvent.CLICK, function(e: MouseEvent):void {
//      		wrapper.external.showInviteBox();
//      	});
//      	btn2.addEventListener(MouseEvent.CLICK, function(e: MouseEvent):void {
//      		wrapper.external.showInstallBox();
//      	});
//      	btn3.addEventListener(MouseEvent.CLICK, function(e: MouseEvent):void {
//      		var newHeight: Number = wrapper.application.stageHeight + 50;
//      		wrapper.external.resizeWindow(wrapper.application.stageWidth, newHeight);
//      		wrapper.external.setLocation(newHeight.toString());
//      		drawRect(wrapper.application.stageWidth, newHeight);
//      	});
//      	btn4.addEventListener(MouseEvent.CLICK, function(e: MouseEvent):void {
//      		wrapper.external.showPaymentBox(1);
//      	});
//
//        wrapper.addEventListener('onWindowResize', function(e: Object): void {
//          tf.appendText("Window resized: (" + e.width + ", " + e.height + ")\n");
//        });
//
//        wrapper.addEventListener('onLocationChanged', function(e: Object): void {
//        	var height: Number = parseInt(e.location);
//        	if (!e.location) {
//        		height = 400;
//        	}
//        	tf.appendText("Location: " + e.location + "\n");
//          wrapper.external.resizeWindow(wrapper.application.stageWidth, height);
//          drawRect(wrapper.application.stageWidth, height);
//        });
//
//        wrapper.addEventListener('onApplicationAdded', function(e: Object): void {
//          tf.appendText("Application added\n");
//        });
//        wrapper.addEventListener('onSettingsChanged', function(e: Object): void {
//          tf.appendText("Settings changed: " + e.settings + "\n");
//        });
//        wrapper.addEventListener('onBalanceChanged', function(e: Object): void {
//          tf.appendText("Balance changed: " + e.balance + "\n");
//        });
//    	} catch (e:Error) {
//    	  tf.appendText(e.message + "\n");
//      }
    }
    
    private function drawRect(width: Number, height: Number): void {
    	graphics.clear();
    	graphics.beginFill(0xFFFFFF);
    	graphics.lineStyle(1, 0x36638E, 0.8, false, LineScaleMode.NONE, CapsStyle.SQUARE);
      graphics.moveTo(0, 0);
      graphics.lineTo(width - 1, 0);
      graphics.lineTo(width - 1, height - 1);
      graphics.lineTo(0, height);
    	graphics.lineTo(0, 0);
    	graphics.endFill();
    }
  }
}
