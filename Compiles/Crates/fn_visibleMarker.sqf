/*
	GMSCore_fnc_visibleMarker 

	Purpose: spawn a temporary visible marker above an object 

	Parameters: 
		_crate: the object above which to spawn the marker 
		_time: how long the marker should be displayed (optionsl)

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
private _defaultSmokeShells = ["SmokeShellOrange","SmokeShellBlue","SmokeShellPurple","SmokeShellRed","SmokeShellGreen","SmokeShellYellow"];

params[
	["_crate",objNull],									// The object to which to apply the smoke or light marker 
	["_time",60],										// Time for which to marke the object in seconds 
	["_smokeShells", selectRandom _defaultSmokeShells]  // An array of valid smokeshell types. See _defaultSmokeShells for an example 
]; 

if (isNull _crate) exitWith {["GMSCore_fnc_visibleMarker called without referencing a crate object","warning"] call GMSCore_fnc_log};

private _start = diag_tickTime;
private _smokeShell = selectRandom _smokeShells;
private _lightSource = selectRandom ["Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];

private _fn_markObject = {
	params["_obj","_start","_duration","_smokeShell","_chemLight"];
	private _endTime = diag_tickTime + _duration;
	while {(diag_tickTime - _start) < _endTime} do  // loop for 5 min accounting for the fact that smoke grenades do not last very long
	{
		private _smoke = _smokeShell createVehicle getPosATL _obj;
		_smoke setPosATL (getPosATL _obj);
		_smoke attachTo [_obj,[0,0,(0.75)]]; // put the smoke a fixed distance above the top of any object to make it as visible as possible
		private "_light";
		_light = _lightSource createVehicle getPosATL _obj;
		_light setPosATL (getPosATL _obj);
		_light attachTo [_obj,[0,0,(0.55)]];
		uiSleep 180;
		detach _smoke;
		deleteVehicle _smoke;
		detach _light;
		deleteVehicle _light;
	};
};
[_crate,_start,_time,_smokeShell, _lightSource] spawn _fn_markObject;