/*

	GMSCore_fnc_unitReloaded 

	Purpose: called when the "Reloaded" event handler fires for the unit.  

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Reloaded 
		params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: only fires locally (on the machine that owns the AI)
	TODO: broadcast the code to all clients.
*/

#include "\GMSCore\Init\GMS_defines.hpp"
if !(local (_this select 0)) exitWith {};
params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];

private _maxReloads = (group _unit) getVariable[GMS_maxReloads,-1];
if (_maxReloads isEqualTo -1) exitWith 
{
	(_unit) addMagazine (_newMagazine);
	//[format["_unitReloaded:: one magazine of type %1 added to inventory of unit %2",newMagazine,unit]] call GMSCore_fnc_log;
};

private _reloads = (_unit) getVariable ["GMS_reloads",0];
if (_reloads >= _maxReloads) exitWith {};
(_unit) addMagazine (newMagazine);
(_unit) setVariable["GMS_reloads",_reloads + 1];
//[format["_unitReloaded:: one magazine of type %1 added to inventory of unit %2",newMagazine,unit]] call GMSCore_fnc_log;
