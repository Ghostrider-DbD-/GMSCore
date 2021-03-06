/*
	GMS_fnc_unitHit 

	Purpose: fired by the "MPHit" eventhandler for the unit. 
		It should put the group in combat mode 
		And test if the unit should heal. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"

private _unit = _this select 0;
[group _unit,"combat"] call GMS_fnc_setGroupBehaviors;
// TODO: send information to nearby units ?
// let GMSAI or GMS handle that
_unit call GMS_fnc_healSelf;

