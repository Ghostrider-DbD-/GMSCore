/*
    GMS_fnc_spawnCrate 

    Purpose: spawn an object, normally a container of some sort, at a location or at [0,0,0] if none specified.

    Parameters: 
        _className: the classname of the object to spawn 
        _location: location at which to spawn it (optional) 

    return: object created of classname specified with all inventory removed 

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_className",["_location",[0,0,0]]];
private _crate = _className createVehicle _location;
_crate call GMS_fnc_emptyObjectInventory;
_crate