/*
	GMS_ fnc_vehicleHit 
	
	Purpose: called when the GMS MPHit EH is fired for the vehicle to handle allerting crew to enemy activities. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit  

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: check the parameters here to be sure they are correct.	
*/

#include "\GMSCore\Init\GMS_defines.hpp"
if !(local (_this select 0)) exitWith {};
params ["_veh", "_source", "_damage", "_instigator"];
[format["GMS_fnc_vehicleHit: _vehicle %1 | _source %2 | _damage %3 | _instigator %4",_veh,_source,_damage,_instigator]] call GMS_fnc_log;
private _vehHC = _veh getVariable[GMS_vehHitCode, []];
//[format["GMS_fnc_vehicleHit: count _vehHC = %1",count _vehHC]] call GMS_fnc_log;
{
	_this call _x;
} forEach _vehHC;



