package by.vnz.framework.social_net {
import by.vnz.framework.model.RequestVars;

public interface ISocialAPI {

    function initSig( params : RequestVars, userID : String) : String
}

}