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
	["_smokeShells", _defaultSmokeShells]  // An array of valid smokeshell types. See _defaultSmokeShells for an example 
]; 

if (isNull _crate) exitWith {["GMSCore_fnc_visibleMarker called without referencing a crate object","warning"] call GMSCore_fnc_log};

private _start = diag_tickTime;
private _smokeShell = selectRandom _smokeShells;
private _lightSource = selectRandom ["Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
// GMSCore_monitoredVisibleMarkers = [];  //  List of objects to which visible markers are attached: variables used are "GMSCoreVMStart" [float], "GMSCoreVMEnd" [float], "GMSCoreMarkers [smoke,chemlight], "GMSCoreMarkerTypes [_smokeShell,_chemLight]
_crate setVariable["GMSCoreVMStart",_start];
_crate setVariable["GMSCoreVMEnd",_start + _time];
_crate setVariable["GMSCoreMarkerTypes",[_smokeShell,_lightSource]];
private _smoke = _smokeShell createVehicle getPosATL _crate;
_smoke setPosATL (getPosATL _crate);
_smoke attachTo [_crate,[0,0,(0.85)]]; // put the smoke a fixed distance above the top of any object to make it as visible as possible
private _light = _lightSource createVehicle getPosATL _crate;
_light setPosATL (getPosATL _crate);
_light attachTo [_crate,[0,0,(0.90)]];
_crate setVariable["GMSCoreMarkers",[_smoke,_light]];
GMSCore_monitoredVisibleMarkers pushBack _crate;