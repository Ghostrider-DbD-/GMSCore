/*
	GMSCore_fnc_disableVehicleWeapons

	Purpose: provides a way to disable turrets or remove their ammo

	Parameters:
		_vehicle, the vehicle into which to load the crew 
		_blockedTurrets, turrets which should not be manned using turret paths 
		_blockedMagazines, positions which should not be manned base on fullCrew

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: 
	TODO: Needs some more rigorous testing
	TODO: Does not deal with pylons
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_vehicle",objNull],
	["_blockedTurrets",[]], // List of weapons that will be removed
	["_blockedMagazines",[]]  // List of magazines that will be removed 
];
private _turrets = allTurrets[_vehicle,false];
{
	private _turretPath = _x;
	private _weps = _vehicle weaponsTurret _turretPath;
	{
		if (_x in _blockedTurrets) then 
		{
			_vehicle removeWeaponTurret [_x,_turretPath];
		} else {		
			private _mags = _vehicle magazinesTurret _turretPath;
			{
				private _magazine = _x;
				if (_magazine in _blockedMagazines) then 
				{
					_vehicle removeMagazinesTurret [_x,_turretPath];
				};
			} forEach _mags;
		};
	} forEach _weps;
};

