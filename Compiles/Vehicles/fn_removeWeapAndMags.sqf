/*
	GMSCore_fnc_removeWeapAndMags

	Purpose: removes specified weapons and magazines from turrets

	Parameters: 
		_veh, the vehicle upon which to do the operations 
		_weaps, weapons to be removed from turrets 
		_mags, magazines to be removed from turrets

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: 
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_veh","_weaps","_mags"];
{
	if (isClass(configFile >> "CfgWeapons" >> _x)) then 
	{
		_veh removeWeaponGlobal _x;
	} else {
		[format["GMSCore_fnc_removeWeapAndMags: invalid weapon name provided: %1",_x],"warning"] call GMSCore_fnc_log;
	};
} foreach _weaps;

{
	private _tur = _x;
	{
		if (isClass(configFile >> "CfgMagazines" >> _x)) then 
		{
			_veh removeMagazinesTurret [_x,_tur];
		} else {
			[format["GMSCore_fnc_removeWeapAndMags: invalid magazine name provided: %1",_x],"warning"] call GMSCore_fnc_log;
		};
	} foreach _mags;
} forEach (allTurrets [_veh, false]);
