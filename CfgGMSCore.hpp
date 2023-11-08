class CfgGMSCore {
    debug = 1;

    /*
    this toggles display of dynamic simulation diagnostic info on the map. 
    1 - > shows entites that are / are not simulated 
    2 - > groups that are or are not simulated 
    1 + 3 -> simulation grid and entities that are / are not simulated 
    1+ 4 -> simulation grid and groups that are / are not simulated 
    */
    debugDynamicSimulation = 1;
    
    GMSCore_maxHuntDuration = 300;
    GMSCore_huntNearestPlayer = false;
    GMSCore_hitKillEventUpdateInterval = 15;  // seconds
    GMSCore_maxSafezoneLoiter = 30; // seconds 
};