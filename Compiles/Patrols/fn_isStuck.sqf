/*
	GMSCore_fnc_isStuck 
	
	Purpose: readds  _group getVariable["isStuck"]

	Parameters: _group, the group about which we want to know things. 

	Returns: true/false  (if true then the group is stuck)

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group"];
private _isStuck = _group getVariable["isStuck", false];
_isStuck