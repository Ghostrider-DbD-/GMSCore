/*
	GMSCore_fnc_spawnUnmannedVehicle 

	Purpose: spawn and initialize a drone to be used for AI patrols 

	Parameters: 

	Returns: [
		the vehicle configured 
		the group that mans it 

	Copyright 2020 by Ghostrider-GRG-

	Notes: Be sure to select drones from the same faction as GMSCore_Side
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[
	["_className",""],
	//["_group",grpNull],	
	["_pos",[0,0,0]],
	["_dir",0],
	["_height",0],	
	["_disable",0],  // damage value set to this value if less than this value when all crew are dead
	["_removeFuel",0.2],  // fuel set to this value when all crew dead
	["_releaseToPlayers",true],
	["_deleteTimer",300],
	["_vehHitCode",[]],
	["_vehKilledCode",[]],
	["_baseSkill",0.7],
	["_alertDistance",500], 	 // How far GMS will search from the group leader for enemies to alert to the kiillers location
	["_intelligence",0.5],  	// how much to bump knowsAbout after something happens
	["_skills",[]],
	["_bodycleanuptimer",600],  // How long to wait before deleting corpses for that group
	["_maxReloads",-1], 			// How many times the units in the group can reload. If set to -1, infinite reloads are available.
	["_removeLaunchers",true],
	["_removeNVG",true],
	["_minDamageToHeal",0.4],
	["_maxHeals",1],
	//["_smokeShell",""],
	["_aiHitCode",[]],
	["_aiKilledCode",[]]	
];
private "_group";
if !(isClass(configFile >> "CfgVehicles" >> _className)) exitWith
{
	[format["GMSCore_fnc_spawnPatrolUAV called with invalid classname %1",_className],"error"] call GMSCore_fnc_log;
	objNull
};
if !([_className] call GMSCore_fnc_isDrone) exitWith 
{
	[format["GMSCore_fnc_spawnPatrolUAV: class name %1 is not a drone",_className],"error"] call GMSCore_fnc_log;
	objNull
};
if !(_className isKindOf "Car") exitWith 
{
	[format["GMSCore_fnc_spawnPatrolUAV: class name %1 is not kindOf 'Car'",_className],"error"] call GMSCore_fnc_log;
	objNull
};
//[format["GMSCore_fnc_spawnUnmannedVehicle: spawning UGV %1 at pos %2",_className,_pos]] call GMSCore_fnc_log;
private _unmanned = [
	_className,	
	_pos,
	_dir,
	_height,	
	_disable,
	_removeFuel,
	_releaseToPlayers,
	_deleteTimer,
	_vehHitCode,
	_vehKilledCode
] call GMSCore_fnc_spawnPatrolVehicle;
//[format["GMSCore_fnc_spawnUnmannedVehicle: GMSCore_fnc_spawnPatrolVehicle returned _unmanned = %1",_unmanned]] call GMSCore_fnc_log;
private "_group"; 
if !(isNull _unmanned) then 
{
	_group = createVehicleCrew _unmanned;
	//[format["GMSCore_fnc_spawnUnmannedVehicle: _group %1 created for unmanned vehicle",_group]] call GMSCore_fnc_log;
	[
		_group,
		_baseSkill,
		_alertDistance, 	 // How far GMS will search from the group leader for enemies to alert to the kiillers location
		_intelligence,  	// how much to bump knowsAbout after something happens
		_bodycleanuptimer,  // How long to wait before deleting corpses for that group
		_maxReloads, 			// How many times the units in the group can reload. If set to -1, infinite reloads are available.
		_removeLaunchers,
		_removeNVG,
		_minDamageToHeal,
		_maxHeals,
		"",
		_aiHitCode,
		_aiKilledCode		
	] call GMSCore_fnc_initializeGroup;
	[_group,_skills] call GMSCore_fnc_setupGroupSkills;  // confusing because some group characteristics are set in GMS but leave for now: TODO: reconcile this
	_group setVariable[GMS_vehHitCode,_vehHitCode];
	_group setVariable[GMS_vehKilledCode,_vehKilledCode];
	_group call GMSCore_fnc_addUnitEventHandlers;
	[_group,_unmanned] call GMSCore_fnc_setGroupVehicle;
	_group addVehicle _unmanned;
	[_unmanned,_disable,_removeFuel,_releaseToPlayers,_deleteTimer] call GMSCore_fnc_initializePatrolVehicle;
	_unmanned setVariable["GMS_group",_group];
};
[_group,_unmanned]