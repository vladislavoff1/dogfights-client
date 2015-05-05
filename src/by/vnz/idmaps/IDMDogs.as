package by.vnz.idmaps {
import flash.utils.Dictionary;

public class IDMDogs {
    static private const dogs:Array = [
        "doberman",
        "rotweller",
        "ovcharka",
        "dog",
        "bulterjer",
        "boxer",
        "senbernar",
        "stafford",
        "pitbul",
        "neapolitan",
        "dalmatin",
        "kavkazec"
    ];

    static public function getDogByID(id:uint):String {
        var result:String;
        if (id == 0 || ((id - 1) > dogs.length)) {
            error("On get dog breed", id);
            return null;
        }
        result = dogs[(id - 1)];
        return result;
    }
}
}