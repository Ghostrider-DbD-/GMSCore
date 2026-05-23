/*
    GMSCore_fnc_checkFuel

    Purpose: Top off fuel 

    Parameters: _leader - the leader of the group in command of the vehicle 

    Returns: Nothing 

*/
params["_leader"];

private _veh = objectParent (_leader);
 _veh setFuel 1.0;

