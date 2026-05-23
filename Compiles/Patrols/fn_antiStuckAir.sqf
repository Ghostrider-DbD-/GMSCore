/*
    GMSCore_fnc_antiStuckAir 

    Purpose: detect air patrols that are not moving or not where they should be and get them back on track 

    Parameters:
        _group - the group to check 
        _patrolArealMarker - self eviden 

    Returns: None 

    Credit: used a great deal of the logic from A3EAI by Face 
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params ["_group"];
private _veh = objectParent (leader _group);
//private _wp = [_group,0];
private _checkPos = getPosATL _veh;
//private _minDist = _group getVariable["minWPdist", 500];
//private _maxDist = _group getVariable["maxWPdist", 2500];
private _maxDistEnemy = _group getVariable["maxEnemyDist", 300];
private _maxDistAgro = _group getVariable["maxDistAgro", 300];
private _antiStuckDist = _group getVariable["antiStuckDist", 300];
//private _antiStuckTime = _group getVariable["antiStuckTime", 0];
//private _antiStuckPos = _group getVariable["antiStuckPos",[0,0,0]];
//private _newPos = [0,0,0];
private _antiStuck = false; 
private _nearestEnemy = (getPosATL _veh) nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle"]], _maxDistEnemy];
//[format["_antiStuckAir: _nearestEnemy %1", _nearestEnemy]] call GMSCore_fnc_log;

_antiStuck


