/*
    GMSCore_fnc_setSwimInDepth 
    Purpose: sets swiminDepth for a submersible
    Params: _vehicle - the submersible
    Returns: None 
*/
params[["_vehicle", objNull],["_max",-1]];
private _calcDepth = swimInDepth (((getPosATL(ASLtoATL(getPosASL(driver _vehicle))) ) select 2)/2);
(driver _vehicle) swimInDepth (_caldDepth max _max);