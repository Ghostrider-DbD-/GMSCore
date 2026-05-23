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
private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];
private _veh = objectParent (leader _group);
private _wp = [_group,0];
private _typeOf = _veh call BIS_fnc_objectType;
private _speed = speed _veh;
private _blacklist = [];
private _minDist = _group getVariable["minWPdist", 150];
private _maxDist = _group getVariable["maxWPdist", 500];
private _maxDistEnemy = _group getVariable["maxEnemyDist", 300];
private _maxDistAgro = _group getVariable["maxDistAgro", 300];
private _antiStuckDist = _group getVariable["antiStuckDist", 300];
private _antiStuckTime = _group getVariable["antiStuckTime", 0];
private _newPos = [0,0,0];
private _antiStuck = false; 
private _nearestEnemy = (leader _group) findNearestEnemy _veh;

if (
    ((leader _group) distance _nearestEnemy > 900) or 
    [getPosATL _veh] call GMSCOre_fnc_inAllowedLocation && 
    (getPosATL _veh) distance2D (WaypointPosition _wp) < _antiStuckDist &&
    {canMove _veh}
    ) then {
        _isBlacklisted = true;
        private _tries = 0;
        
        // find a new location to patrol 
        _newPos = position leader _group;
        while {_isBlackListed} do {
            _newPos = _veh getPos[300, random(365)];
            _blacklistedAreas = nearestLocations[_newPos,[WAYPOINT_DISALLOWED_AREAS], 300];
            _isBlacklisted = [_newPos, _blacklistedAreas, "GMSCore_fnc_antiStuckAir"] call GMSCOre_fnc_isBlacklisted;					
            _tries = _tries + 1;
        };

        _wp setWPPos _newPos;
        _wp setWaypointType "MOVE";
        _wp setWaypointTimeout [1, 2, 3];
        _wp setWaypointCompletionRadius 150;	
        [_group, "Ignore"] call GMSCore_fnc_setGroupBehavior;

        _antiStuck = true; 
        if (GMSCore_debug == 1) then {
            deleteMarker (_group getVariable["wpMarker",""]);
            private _mrkr = createMarker[format["wpMarker%1", random(100000)], _newPos];
            _group setVariable["wpMarker",_mrkr];
            _mrkr setMarkerType "hd_dot";
            _mrkr setMarkerColor "COLORORANGE";
            _mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"Drone"} else {"Air"}];
        };
};

_antiStuck

