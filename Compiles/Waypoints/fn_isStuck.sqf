/*
	GMS_fnc_isStuck 
	
	Purpose: test if a group is 'stuck' meaning it has not completed its current waypoitn in a reasonable time. 
		Such groups may have hit a road block or chased players out of the patrol area 

	Parameters: _group, the group about which we want to know things. 

	Returns: true/false  (if true then the group is stuck)

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
private _stuck = _group getVariable["GMS_antiStuck",false];
_stuck