/*
	GMSCore_fnc_visibleMarker 

	Purpose: spawn a temporary visible marker above an object 

	Parameters: 
		_crate: the object above which to spawn the marker 
		_time: how long the marker should be displayed (optionsl)

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
private _defaultSmokeShells = ["SmokeShellOrange","SmokeShellBlue","SmokeShellPurple","SmokeShellRed","SmokeShellGreen","SmokeShellYellow"];

params[
	["_crate",objNull],									// The object to which to apply the smoke or light marker 
	["_time",60],										// Time for which to marke the object in seconds 
	["_smokeShells", _defaultSmokeShells]  // An array of valid smokeshell types. See _defaultSmokeShells for an example 
]; 

if (isNull _crate) exitWith {["\x\addons\GMSCore_fnc_visibleMarker called without referencing a crate object","warning"] call GMSCore_fnc_log};

private _start = diag_tickTime;
private _smokeShell = selectRandom _smokeShells;
private _lightSource = selectRandom ["Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
_crate setVariable["\x\addons\GMSCoreVMStart",_start];
_crate setVariable["\x\addons\GMSCoreVMEnd",_start + _time];
_crate setVariable["\x\addons\GMSCoreMarkerTypes",[_smokeShell,_lightSource]];
[_crate] call GMSCore_fnc_attachCrateMarkers;
// GMSCore_monitoredVisibleMarkers = [];  //  List of objects to which visible markers are attached: variables used are "\x\addons\GMSCoreVMStart" [float], "\x\addons\GMSCoreVMEnd" [float], "\x\addons\GMSCoreMarkers [smoke,chemlight], "\x\addons\GMSCoreMarkerTypes [_smokeShell,_chemLight]
GMSCore_monitoredVisibleMarkers pushBack _crate;