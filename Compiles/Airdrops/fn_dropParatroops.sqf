/*
	GMS_fnc_dropParatroops 
	Purpose: drops a group of AI defined in _group at location _pos from the optional aircraft defined in _aircraft
			Where _aircraft is null, AI are dripped in from a point in space with some spacing between them. 

	Parameters: 
		_group, the group of AI to be dropped by parachute 
		_pos, the position at which to drop them (the script will do its best to start the airdrop for them at or near this location)
		_aircraft, (optional) the aircraft from which they are dropped; AI will be dropped behind the aircraft at intervals 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_group",grpNull],["_pos",[0,0,0]],["_aircraft",objNull]];

diag_log format["GMS_fnc_dropParatroops: _group = %1 | _pos = %2 | _aircraft = %3 | typeOf _aircraft = %4",_group,_pos,_aircraft,typeOf _aircraft];

// drop the group of paratroops as close as possible to the desired location 

if !(isNull _aircraft) then 
{
	//(boundingBoxReal _aircraft) params["_b1","_b2"];
	private _length = abs((_b2 select 1) - (_b1 select 1));
	{
		private _spawnPos = (getPosATL _aircraft) getPos[_length/4 + _forEachIndex, (getDir _aircraft) + 180 ];
		private _chute = createVehicle ["Steerable_Parachute_F", _spawnPos, [], 0, "FLY"];
		_x assignAsDriver _chute;
		_x moveInDriver _chute;
		//_x moveInCargo _aircraft;
		//_x action["Eject",vehicle _x];
		uiSleep 3;
		//diag_log format["GMS_fnc_dropParatroops: _unit %1 spawned into chute at pose %2 and alive = %3",_x, getPosATL _x, alive _x];		
	} forEach (units _group);
} else {
	#define spawnHeight 100
	private _spawnPos = [_pos select 0, _pos select 1, spawnHeight];
	{
		private _spawnPos =_spawnPos getPos[_forEachIndex + 3, random(360)];
		private _chute = createVehicle ["Steerable_parachute_F", _pos, [], 0, "FLY"];
		_x assignAsDriver _chute;
		_x moveInDriver _chute;		
		uiSleep 2;
		_offset = _offset + 3;
	} forEach (units _group);
};

[format["GMS_fnc_dropParatroops: all units of group %1 touched down with %2 out of %3 alive",_group, {alive _x} count (units _group), count (units _group)]] call GMS_fnc_log;

