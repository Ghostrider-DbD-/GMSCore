/*

	GMSCore_fnc_spawnObject
	
	Purpose: remove all items from a unitAddons

	Parameters: the unit to be processDiaryLink

	Return: _obj, the object spawned 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_className","_location",["_direction",0],["_useVector",false],["_special","NONE"]];
private _obj = createVehicle[_className,_location,[],0,_special];
[_obj] call GMSCore_fnc_clearObjectInventory;
[_obj,_dir] call GMSCore_fnc_setDirUp;

_obj