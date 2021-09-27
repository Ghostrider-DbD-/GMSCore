/*
	GMS_fnc_spawnPatrolAircraft

	Purpose: spawn and initialize an aircraft or UAV to be used for AI patrols 
			This is a special case because additional stuff needs to be done to be sure 
			the aircraft is flying and has a pilot right off the bat. 
			Note that there is a small movement of 300 meters specified at spawnin. 

	Parameters: 

	Returns:
		_aircraft, the vehicle configured 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: 
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[
	["_pos",[0,0,0]],
	["_dir",0],
	["_group",grpNull],
	["_className",""],
	["_disable",0],  // a value greater than 0 will increase damage of the object to that level; set to 1.0 to disable turretes, 0.7 to neutralize vehciles
	["_removeFuel",false],  // when true fuel is removed from the vehicle
	["_releaseToPlayers",true],
	["_deleteTimer",300],
	["_height",0],
	["_vehHitCode",[]],
	["_vehKilledCode",[]]
];

//diag_log format["GMS_fnc_spawnPatrolAircraft: _className = %1 | height = %2",_className,_height];

private _aircraft = [_className,_pos,_dir,_disable,_removeFuel,_releaseToPlayers,_deleteTimer,_height] call GMS_fnc_spawnPatrolVehicle;
_group setVariable[GMS_groupVehicle,_aircraft];
_group setVariable[GMS_flyinHeight,_height];
[_aircraft,(units _group)] call GMS_fnc_loadVehicleCrew;
_group setVariable[GMS_vehHitCode,_vehHitCode];
_group setVariable[GMS_vehKilledCode,_vehKilledCode];

//diag_log format["GMS_fnc_spawnPatrolAircraft: _aircraft = %1 | and iskindOf 'Air' %2",_aircraft,if (_aircraft isKindOf 'Air') then {true} else {false}];
//diag_log format["GMS_fnc_spawnPatrolAircraft: crew _aircraft = %1",crew _aircraft];
_aircraft engineOn true;
_aircraft flyInHeight _height;
_aircraft