/*
	GMS_fnc_addObjectToDeletionCue 

	Purpose: Add an object or array of objects to the cue for deletion 

	Parameters:
		_object, the object or array thereof to be deleted 
		_deletionDelay, how long to wait before deleting the objects 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_object","_deletionDelay"];
//[format["GMS_fnc_addObjectToDeletionCue: _object = %1 | _deletionDelay = %2",_object,_deletionDelay]] call GMS_fnc_log;
GRGCore_monitoredObjects pushBack [_object,diag_tickTime + _deletionDelay];
true