/*
	GMSCore_fnc_addUnitEventHandlers 

	Purpose: Adds the basic GMS event handlers to units 

	Parameters:
		_this is the _group to add the EH to 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
private _group = _this;
{
	_x addMPEventHandler["MPKilled",{if (isServer) then {_this call GMSCore_fnc_unitKilled;};}];  // Bare minimum killed EH
	_x addMpEventHandler["MPHit",{if (isServer) then {_this call GMSCore_fnc_unitHit;};}];			// bare minimum hit EH
	_x addEventHandler["Reloaded",{_this call GMSCore_fnc_unitReloaded;}];	// Handle all reloads up to the max reloads set for the group; NOTE, this EH is local to the machine owning the Unit.
} forEach (units _group);