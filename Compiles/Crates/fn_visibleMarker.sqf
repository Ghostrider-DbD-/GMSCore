/*
	GMS_fnc_visibleMarker 

	Purpose: spawn a temporary visible marker above an object 

	Parameters: 
		_crate: the object above which to spawn the marker 
		_time: how long the marker should be displayed (optionsl)

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

private ["_start","_maxHeight","_smokeShell","_light","_lightSource"];
params["_crate",["_time",60]]; 
_start = diag_tickTime;
_smokeShell = selectRandom ["SmokeShellOrange","SmokeShellBlue","SmokeShellPurple","SmokeShellRed","SmokeShellGreen","SmokeShellYellow"];
_lightSource = selectRandom ["Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
while {diag_tickTime - _start < (_time)} do  // loop for 5 min accounting for the fact that smoke grenades do not last very long
{
	_smoke = _smokeShell createVehicle getPosATL _crate;
	_smoke setPosATL (getPosATL _crate);
	_smoke attachTo [_crate,[0,0,(0.5)]]; // put the smoke a fixed distance above the top of any object to make it as visible as possible
	if(sunOrMoon < 0.2) then
	{
		_light = _lightSource createVehicle getPosATL _crate;
		_light setPosATL (getPosATL _crate);
		_light attachTo [_crate,[0,0,(0.55)]];
	};
	uiSleep 120;
	detach _smoke;
	deleteVehicle _smoke;
	if(sunOrMoon < 0.2) then
	{
		detach _light;
		deleteVehicle _light;
	};
};