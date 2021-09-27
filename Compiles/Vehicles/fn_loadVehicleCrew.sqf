/*
	GMS_fnc_loadVehicleCrew 

	Purpose: provides a way to load a group containing units into a vehicle for AI vehicle patrols 

	Parameters:
		_vehicle, the vehicle into which to load the crew 
		_crew, the group containing units to load 
		_blockedTurrets, turrets which should not be manned using turret paths 
		_blockedPositions, positions which should not be manned base on fullCrew

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: Needs some more rigorous testing
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_vehicle","_crew"];
//diag_log format["GMSCore] _loadVehiclePatrol: _vehicle = %1 | _crew = %2",_vehicle,_crew];
private _driver = _crew deleteAt 0;
_driver moveInDriver _vehicle;
(group _driver) selectLeader _driver;
(group _driver) setVariable[GMS_groupVehicle,_vehicle];
private _turrets = allTurrets[_vehicle,false];
{
	if (_crew isEqualTo []) exitWith {};
	private _gunner = _crew deleteAt 0;
	_gunner moveInTurret [_vehicle,_x];		
} forEach _turrets;
private _turretsFFV = (allTurrets [_vehicle,true]) - (_turrets);
{
	if (_crew isEqualTo []) exitWith {};
	private _ffv = _crew deleteAt 0;
	_ffv moveInTurret [_vehicle,_x];
}forEach _turretsFFV;
private _empty = fullCrew[_vehicle,"cargo",true];
{	
	if (_crew isEqualTo []) exitWith {};
	//diag_log format["_loadVehicleCrew (39):  _x = %1",_x];
	private _unit = _crew deleteAt 0;
	_unit moveInCargo [_vehicle, _x select 2];
}forEach _empty;
