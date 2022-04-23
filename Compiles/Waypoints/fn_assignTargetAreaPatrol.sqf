
/*
	GMS_fnc_assignTargetAreaPatrol 

	Pupose: to set the patrol area marker for a group 

	Parameters: 
		_group, the group to handle 
		_target, the marker defining the target patrol area 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes:
	TODO: not sure we should call nextWaypointAreaPatrol here; think this should be done by a higher level function.	
	3-28-0:  Not used at present
*/

#include "\GMSCore\Init\GMS_defines.hpp"

params["_group","_target"];
_group setVariable["GMS_target",_target];
_group setVariable["GMS_targetGroup",group _target];
(leader _group) call GMS_fnc_nextWaypointAreaPatrol;
