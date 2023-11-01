/*
	GMSCore_fnc_getGroupIntilligence 

	Purpose: get the value used for 'intelligence', which is the amount knowsAbout would be increased if the unit was engaged in any way. 

	Parameters: _group, the group for which to get the value 

	Returns: _intel, a number between 0 and 4 corresponding the the intelligence for that group 

	Copyright 2020 Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group"];
private _intel = _group getVariable[GMS_patrolIntelligence,0];
_intel