/*
	GMSCore_fnc_createObject

	Purpose: Add an object or array of objects to the cue for deletion 

	Parameters:
		_object, the object or array thereof to be deleted 
		_deletionDelay, how long to wait before deleting the objects 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params[
	["_className",""],
	["_isASL",false],  // When true, objects will be spawned relative to sealevel; otherwise, terain level will be used.
						// Allows backwards compatability
	["_pos",[0,0,0]],
	["_orientation",0],
	["_special","CAN_COLLIDE"],
	["_simulation",true],
	["_isSimple",false]
];
private "_obj";
if (_isSimple) then 
{
	_obj = createSimpleObject[_className,[0,0,0]];
} else {
	_obj = createVehicle[_className,[0,0,0],0,_special];
	[_obj] call GMSCore_fnc_clearObjectInventory;	
	_obj enableSimulation _simulation;
};
if !(_isASL) then 
{
	_pos = AGLToASL _pos;
};
_obj setPosATL _pos;

if ((_orientation) isEqualType 0) then {_obj setDir _orientation};
if ((_orientation) isEqualType []) then {_obj setVectorDirAndUp _pos};

_obj
