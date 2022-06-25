
/*
	GMSCore_fnc_addMonitoredAreaPatrol 

	Purpose: Adds a group and its patrol area marker

	Parameters: 
		_group 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 	

	Notes: 
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_group","_marker","_deleteMarkerOnNullGroup"];
if (_marker isEqualTo GMS_mapMarker) then {_deleteMarkerOnNullGroup = false};   // Just so we dont accidentally delete a globally used marker
//diag_log format["GMSCore_fnc_addMonitoredAreaPatrol: _group %1 | _marker %2 | _delete %3",_group,_marker,_deleteMarkerOnNullGroup];
GMSCore_monitoredAreaPatrols pushBack [_group,_marker,_deleteMarkerOnNullGroup];
