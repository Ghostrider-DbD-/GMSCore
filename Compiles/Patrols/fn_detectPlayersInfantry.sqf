
/*
    Purpose: Detect potential targets for aircraft
             Limit targets to players in vehicles 

    Parameters: _group - the group doiing the plane or helicopter patrol 

    Returns: Target Vehicle 


*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_group"];

private _leader = leader _group; 
private _veh = objectParent (_leader);
private _searchDistance = _group getVariable["searchDist", 300]; 
private _canParaDrop = if (diag_tickTime > (_group getVariable["nextParaDrop",10000]) && ({alive _x} count units _group) > 0) then {true} else {false};

private _paraUnitsTimer = _group getVariable["nextParadrop", -1]; // This can be set as diag_tickTime + _paraInterval
private _chanceParaDrop = _group getVariable["paraChance", -1]; //This can be set using GMSCore_fnc_setChanceParaDrop;
private _paraInterval = _group getVariable["paraInt", -1];       // This can be set using GMSCore_fnc_setParaInterval; 
private _chanceDetected = _group getVariable["chanceDetect", -1];
private _huntMarker = _group getVariable["huntMrkr",""];
private _canReveal = if ((CombatMode _group) isEqualTo "BLUE") then {true} else {false};  // Use CombatMode _group isEqualTo "BLUE" a la A3EAI ?
private _aliveUnits = {alive _x} count (units _group);

if ( _aliveUnits > 0) then {
    private _detected = (getPosATL _veh) nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle"]], PLAYER_DETECT_RANGE_AIR];
    if (count _detected > 5) then {_detected resize 5};
    if (count _detected > 0) then {            
        private _target = _x; 
        private _targetPos = getPosATL _target; 
        private _distance = _veh distance2D _target;
        [format["_detectPlayersAir: __target %1 | _targetPos %2 | _waypointDisallowedAreas %3",_target, _targetPos, _waypointDisallowedAreas]] call GMSCore_fnc_log;
        private _waypointDisallowedAreas = nearestLocations[_targetPos,[WAYPOINT_DISALLOWED_AREAS], 300];
        private _isBlacklisted = [_targetPos, _waypointDisallowedAreas, "GMSCore_fnc_detectPlayersInfantry"] call GMSCOre_fnc_isBlacklisted;
        private _isBlacklisted = [_targetPos, _waypointDisallowedAreas, "GMSCore_fnc_detectPlayersInfantry"] call GMSCOre_fnc_isBlacklisted;
        private _numberTargets = 0;
        private _airDetectionChance = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_airDetectChance");
        if !(_isBlackListed) then {
            if (_canParadrop && random(1) < _chanceParaDrop) then {
                _canParadrop = false; 
                _group setVariable["nextParadrop", diag_tickTime + _paraUnitsTimer];
                // spawn paratroop routine 
            };

            {
                if !([_targetPos] call GMSCOre_fnc_inAllowedLocation) then {
                    _group forgetTarget _target;
                } else {
                    if (_canReveal && (_group knowsAbout _x < 2) && (random(1) < _chanceDetected)) then {
                        // can gunner see player ?
                        if (((lineIntersectsSurfaces [(aimPos _veh), (eyePos _x), _veh, _x, true, 1]) isEqualTo []) && random (1) < _airDetectionChance) then {
                            _group reveal [_target, (_group knowsAbout _target) + 2.5];
                        };
                        _numberTargets = _numberTargets + 1;
                        if (_x distance _target < _distance) then {
                            _distance = _x distance2D _target;
                            _target = _x;
                        };                        
                    };
                };
            } forEach _detected; 
        };

        if (_numberTargets > 0) then {
            [_group, true] call GMSCore_fnc_setHunt;
            [_group, _target] call GMSCore_fnc_setTarget;
        } else {
            [_group, false] call GMSCore_fnc_setHunt;
            [_group, objNull] call GMSC0re_fnc_setTarget;
        };
    };
};

 
