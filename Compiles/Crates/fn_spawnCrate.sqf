/*
    GMSCore_fnc_spawnCrate 

    Purpose: spawn an object, normally a container of some sort, at a location or at [0,0,0] if none specified.

    Parameters: 
        _className: the classname of the object to spawn 
        _location: location at which to spawn it (optional) 

    return: object created of classname specified with all inventory removed 

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params["_className",["_location",[0,0,0]],["_dir",0]];
//diag_log format["GMSCore_fnc_spawnCrate:  _this = %1",_this];
//["2S6M_Tunguska", getMarkerPos "marker1", ["marker2", "marker3"], 0, "NONE"];
private _crate = createVehicle[_className,_location,[],3,"NONE"];
//diag_log format["GMSCore_fnc_spawnCrate: _crate = %1",_crate];
_crate setPosATL _location;
_crate setDir _dir;
_crate call GMSCore_fnc_emptyObjectInventory;
_crate