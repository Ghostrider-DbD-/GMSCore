/*
    GMS_fnc_removeNVG

    Prupose: remove NVG from unitAddons

    Parameter: 
        __unit: the unit to be processed

    Return: none

	Copyright 2020 by Ghostrider-GRG-    
*/

#include "\GMSCore\Init\GMS_defines.hpp"
private _unit = _this;
private _nvg = _unit getVariable["GMS_nvg",""];
if !(_nvg isEqualTo "") then
{
    _unit unassignitem _nvg; 
    _unit removeweapon _nvg;
};