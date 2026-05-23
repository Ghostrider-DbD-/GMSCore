class CfgGMSCore {
    GMSCore_debug = 0;

    GMSCore_antiStuckTimer = 300; // how long to wait before testing for stuck groups 
    GMSCore_refuelTimer = 300;    // how long to wait before topping off fuel on vehicles
                                  // Set this to a high value if you would like vehicles to run out of fuel for whatever reason 
    GMSCore_huntTimerAir = 60;
    GMSCore_paraUnitsTimer = 300; 

    GMSCore_airDetectChance = 0.4; 
    GMSCore_chanceParaDrop = 0.4; 
    
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