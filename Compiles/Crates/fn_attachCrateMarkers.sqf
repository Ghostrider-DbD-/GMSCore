/*
    GMSCore_fnc_attachCrateMarkers

    Purpose: Attach a smokeShell and chemLight to an object

    Parameters: 
        _crate: the object to which to attach these markers 

    return: none

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_crate"];
(_crate getVariable["\x\addons\GMSCoreMarkerTypes",["",""]]) params ["_smokeShell","_lightSource"];
(_crate getVariable ["\x\addons\GMSCoreMarkers",[objNull,objNull]]) params["_smoke","_light"];
detach _smoke;
deleteVehicle _smoke;
detach _light;
deleteVehicle _smoke;
private _smoke = _smokeShell createVehicle getPosATL _crate;
_smoke setPosATL (getPosATL _crate);
_smoke attachTo [_crate,[0,0,(1.1)]]; // put the smoke a fixed distance above the top of any object to make it as visible as possible
private _light = _lightSource createVehicle getPosATL _crate;
_light setPosATL (getPosATL _crate);
_light attachTo [_crate,[0,0,(0.99)]];
_crate setVariable["\x\addons\GMSCoreMarkers",[_smoke,_light]];
