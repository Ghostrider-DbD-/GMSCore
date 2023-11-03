/*
    GMSCore_fnc_spawnCrate 

    Purpose: spawn an object, normally a container of some sort, at a location or at [0,0,0] if none specified.

    Parameters: 
        _className: the classname of the object to spawn 
        _location: location at which to spawn it (optional) 

    return: object created of classname specified with all inventory removed 

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_className",["_location",[0,0,0]],["_dir",0]];
private _crate = createVehicle[_className,_location,[],3,"NONE"];

_crate setPosATL _location;
[_crate, _dir] call GMSCore_fnc_setDirUp;
_crate call GMSCore_fnc_emptyObjectInventory;
_crate