package vk {
  import flash.net.LocalConnection;
  import flash.events.*;
  
  import vk.events.*;


  /**
   * @author Andrew Rogozov
   */
  public class APIConnection extends EventDispatcher {
  	private var sendingLC: LocalConnection;
  	private var connectionName: String;
  	private var receivingLC: LocalConnection;
  	
  	private var pendingRequests: Array;
  	private var loaded: Boolean = false;
  	
  	public function APIConnection(connectionName: String) {
    	pendingRequests = new Array();
      
    	this.connectionName = connectionName;
    	
    	sendingLC = new LocalConnection();
    	sendingLC.allowDomain('*');
    	
    	receivingLC = new LocalConnection();
    	receivingLC.allowDomain('*');
    	receivingLC.client = {
    	  initConnection: initConnection,
    	  onWindowFocus: onWindowFocus,
    	  onWindowBlur: onWindowBlur,
    	  onApplicationAdded: onApplicationAdded,
    	  onBalanceChanged: onBalanceChanged,
    	  onSettingsChanged: onSettingsChanged
    	};
    	try {
			  receivingLC.connect("_out_" + connectionName);
			} catch (error:ArgumentError) {
				debug("Can't connect from App. The connection name is already being used by another SWF");
			}
			
      sendingLC.addEventListener(StatusEvent.STATUS, onInitStatus);
			sendingLC.send("_in_" + connectionName, "initConnection");
    }
    
    /*
     * Public methods
     */
    public function debug(msg: *): void {
    	if (!msg || !msg.toString) {
    		return;
    	}
    	sendData("debug", msg.toString());
    }
    public function showSettingsBox(mask: uint = 0): void {
    	sendData("showSettingsBox", mask.toString());
    }
    public function showInstallBox(): void {
    	sendData("showInstallBox");
    }
    public function showInviteBox(): void {
    	sendData("showInviteBox");
    }
    public function showPaymentBox(votes: uint = 0): void {
    	sendData("showPaymentBox", votes.toString());
    }
    
    /*
     * Callbacks
     */
    private function initConnection(): void {
    	if (loaded) return;
    	loaded = true;
    	debug("Connection initialized.");
    	dispatchEvent(new CustomEvent(CustomEvent.CONN_INIT));
      sendPendingRequests();
    }
	  private function onWindowBlur(): void {
    	dispatchEvent(new CustomEvent(CustomEvent.WINDOW_BLUR));
    }
		private function onWindowFocus(): void {
    	dispatchEvent(new CustomEvent(CustomEvent.WINDOW_FOCUS));
    }
    private function onBalanceChanged(balance: String): void {
    	var e:BalanceEvent = new BalanceEvent(BalanceEvent.CHANGED);
    	e.balance = parseInt(balance);
    	dispatchEvent(e);
    }
  	private function onSettingsChanged(settings: String): void {
    	var e:SettingsEvent = new SettingsEvent(SettingsEvent.CHANGED);
    	e.settings = parseInt(settings);
    	dispatchEvent(e);
    }
  	private function onApplicationAdded(): void {
    	dispatchEvent(new CustomEvent(CustomEvent.APP_ADDED));
    }
     
    /*
     * Private methods
     */
    private function sendPendingRequests(): void {
			while (pendingRequests.length) {
				sendData.apply(this, pendingRequests.shift());
			}
		}
		private function sendData(...params):void {
			var paramsArr: Array = params as Array;
      if (loaded) {
        paramsArr.unshift("_in_" + connectionName);
        sendingLC.send.apply(null, paramsArr);
      } else {
      	pendingRequests.push(paramsArr);
    	}
    }
    private function onInitStatus(e:StatusEvent):void {
    	e.target.removeEventListener(e.type, onInitStatus);
			if (e.level == "status") {
				receivingLC.client.initConnection();
			}
		}
  }
}
