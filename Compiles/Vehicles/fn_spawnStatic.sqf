/*

*/

params[
    ["_static", ""], 
    ["_pos", []],
    ["_releaseToPlayers",true],
    ["_deleteTimer",300],
    ["_vehHitCode",[]],
    ["_vehKilledCode",[]]    
    ];
/*
	["_vehType",""],
	["_pos",[0,0,0]],
	//["_mode", ""],
	["_dir",random(360)],
	["_height",0],
	["_protect",true]
*/
private _vehicle = [_static, _pos, 0, 0, true] call GMSCore_fnc_createVehicle;
#define disable 1  //  Not pertinent to static Wespons 
#define removeFuel 1  // Not pertinant to static weapons 
[_vehicle, disable, removeFuel,_releaseToPlayers,_deleteTimer] call GMSCore_fnc_initializePatrolVehicle;
private _group = [GMSCore_Side, true] call GMSCore_fnc_createGroup;
private _gunner = [_group, [0,0,0], GMS_baseSkill] call GMSCore_fnc_createUnit;
_gunner moveInGunner _vehicle;
_gunner assignAsGunner _vehicle; 
[_group, _vehicle] call GMSCore_fnc_setGroupVehicle;
_group allowFleeing 0;

[_group, _vehicle]