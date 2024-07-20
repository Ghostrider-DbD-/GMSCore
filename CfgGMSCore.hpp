class CfgGMSCore {
    GMSCore_debug = 1;
    GMSCore_maxHuntDuration = 300;
    GMSCore_huntNearestPlayer = false;
    GMSCore_hitKillEventUpdateInterval = 15;  // seconds

    GMSInfantryGroup[] = {
        {"CAPTAIN","assault"},
        {"LIEUTENANT","assault"},
        {"SERGEANT","support"},
        {"CORPORAL","sniper"},
        {"PRIVATE","assault"}
    };
    
    GMSCore_killedMsgTypes[] = {
        //"toast",
        //"epochMsg",
        //"hint",
        //"cutText",
        "dynamic"
        //"systemChat"
    };

    GMSCore_huntedMsgTypes[] = {
        //"toast",
        //"epochMsg",
        //"hint",
        //"cutText",
        //"dynamic",
        "systemChat"
    };

    GMSCore_alertMsgTypes[] = {
        //"toast",
        //"epochMsg",
        //"hint",
        //"cutText",
        //"dynamic",
        "systemChat"
    };
};