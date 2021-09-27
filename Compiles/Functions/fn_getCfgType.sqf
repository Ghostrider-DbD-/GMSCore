/*
    GMS_fnc_getCfgType

    Purpose: determine which Cfg file to use for lookups

    Parameters: classname of an object to find a config file for

    Return: The name of the config file to use.

    Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_item"];
private _return = "";
if (isClass(configFile >> "CfgWeapons" >> _item)) then 
{
    _return = "CfgWeapons"
} else {
    if (isClass(configFile >> "CfgVehicles" >> _item)) then 
    {
        _return = "CfgVehicles"
    } else {
        if (isClass(configFile >> "CfgMagazines" >> _item)) then 
        {
            _return = "CfgMagazines"
        } else {
            if (isClass(configFile >> "CfgGlasses" >> _item)) then {_return = "CfgGlasses"};
        };
    };
};
_return