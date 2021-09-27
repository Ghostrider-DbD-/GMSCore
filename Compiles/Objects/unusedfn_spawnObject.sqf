/*

	GMS_fnc_emptyObjectInventory
	
	Purpose: remove all items from a unitAddons

	Parameters: the unit to be processDiaryLink

	Return: _obj, the object spawned 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_className","_location",["_direction",0],["_useVector",false],["_special","NONE"]];
private _obj = createVehicle[_className,_location,[],0,_special];
[_obj] call GMS_fnc_clearObjectInventory;
if (_useVector) then 
{
	_obj setVectorDir _direction;
} else {
	_obj setDir _direction;
};

_obj