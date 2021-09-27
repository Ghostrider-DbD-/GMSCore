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

params[["_group",grpNull],["_pos",[0,0,0]],["_aircraft",objNull]];

// drop the group of paratroops as close as possible to the desired location 

if !(isNull _aircraft) then 
{
	(boundingBoxReal _aircraft) params["_b1","_b2"];
	private _length = abs((_b2 select 1) - (_b1 select 1));
	{
		private _spawnPos = (getPosATL _aircraft) getPos[10,(getDir _aircraft) + 180 + _forEachIndex];
		private _chute = createVehicle ["Steerable_Parachute_F", [_spawnPos select 0, _spawnPos select 1, (getPosATL _aircraft) select 2], [], 0, "FLY"];
		_x assignAsDriver _chute;
		_x moveInDriver _chute;
		uiSleep 2;
	} forEach (units _group);
} else {
	#define spawnHeight 100
	private _offset = 0;
	{
		private _spawnPos = [(_pos select 0) + _offset, (spawnHeight select 1) + _offset, _pos select 2];
		private _chute = createVehicle ["Steerable_parachute_F", _spawnPos, [], 0, "FLY"];
		_x assignAsDriver _chute;
		_x moveInDriver _chute;		
		uiSleep 2;
	} forEach (units _group);
};

(units _group) doMove [_pos select 0,_pos select 1,0];

private _fn_monitorUnits = {
	params["_group"]; 
	private _loop = true;
	// deteach chutes as units hit the ground
	while {_loop} do 
	{
		_loop = false;
		{
			private _z = (getPosATL _x) select 2;
			if (_z > 1) then 
			{
				_loop = true;
			} else {
				private _v = vehicle _x;
				_x action["Eject", vehicle _x]; 
				deleteVehicle _v;
			};
		} forEach (units _group);
		uiSleep 1;
	};
	[format["GMS_fnc_dropParatroops: all units of group %1 touched down",_group]] call GMS_fnc_log;
};
[_group] spawn _fn_monitorUnits;