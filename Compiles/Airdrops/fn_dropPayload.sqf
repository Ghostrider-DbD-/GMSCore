/*
	GMS_fnc_dropPayload 

	Purpose: drop a payload of either an object or group of AI at current location of the aircraft 
	Parameters: _aircraft, the aircraft from which the payload will be dropped 
				Note, the script expects that the payload will have been defined as a variable for the aircraft. 
	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
private["_marker","_smoke"];
params["_aircraft"];
private _payload = _aircraft getVariable "payload";
if (isNil "_payload") exitWith {[format["No Payload Defined for Aircraft %1",_aircraft],"warning"] call GMS_fnc_log;};
if (isNull _payload) exitWith {[format["Payload for aircraft %1 is a nullObject",_aircraft],"warning"] call GMS_fnc_log;};
_aircraft setVariable["payload",nil];
if (typeName _payload isEqualTo "GROUP") then 
{
	[_payload,getPosATL _aircraftt, _aircraft] call GMS_fnc_dropParatroops;
} else {
	// Drop a crate as close as possible to the requested location
	private _allowDamage = _aircraft getVariable "allowdamage";
	private _visibleMarker = _aircraft getVariable "visibleMarker";
	private _mapMarker = _aircraft getVariable ["mapMarker",false];
	private _dropHeight = ((getPosATL _aircraft) select 2) - 15;
	private _minDropHeight = 50;
	if (_dropHeight < _minDropHeight) then {_dropHeight = _minDropHeight};
	_pos = [(position _aircraft) select 0,  (position _aircraft) select 1, _dropHeight]; 
	_chute = createVehicle ["I_Parachute_02_F",[0,0,_dropHeight],[],0,"FLY"];
	//_payload setPos  [_pos select 0,_pos select 1,(_pos select 2) - 3];
	_chute setPosATL _pos;
	_payload allowDamage false;
	_payload attachTo [_chute, [0, 0, -1.3]];
	if !(_aircraft getVariable["PayloadDelivered",false]) then
	{
		//diag_log "=================";
		//diag_log "payload delivered";
		_aircraft setVariable["PayloadDelivered",true];
	};	
	private _dimensions = [_payload] call GMS_fnc_getDimensions;
	private _releaseHeight = (_dimensions select 2) + 3;
	while {(getPosATL _payload) select 2 > _releaseHeight} do {_time = diag_tickTime;waitUntil {(diag_tickTime - _time) > 2}};
	detach _payload;
	deleteVehicle _chute;
	_pos = getPosATL _payload;
	_payload setPosATL[_pos select 0,_pos select 1,1];

	//uiSleep 1;
	if (_allowDamage) then {_payload allowDamage true};
	if (_visibleMarker) then {[_payload,300] call GMS_fnc_visibleMarker};

	if (_mapMarker) then 
	{
		_marker = createMarker[format["payload%1",_payload],getPos _payload];
		_marker setMarkerPos (getPos _payload);
		_marker setMarkerType "hd_dot";
		_marker setMarkerColor "COLORBLACK";
		_marker setMarkerText "Supplies";
		_m = format["fn_dropPayload:  _marker = %1",_marker];
		GRGCore_monitoredMarkers pushBack [_marker,_aircraft getvariable["markerDeleteTime",300]];
	};
};

// push the marker to list of monitored markers GMS_var_monitoredMarkers pushBack [_marker, _aircraft getVariable "markerDeleteTime"];
	
	