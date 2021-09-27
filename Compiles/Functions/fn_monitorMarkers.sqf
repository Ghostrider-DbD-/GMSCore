/*
	GMS_fnc_monitorMarkers 

	Purpose: monitor the cue of markers that are scheduled for deletion and delete them at the proper time. 

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
for "_i" from 1 to (count GRGCore_monitoredMarkers) do 
{
	if (_i > (count GRGCore_monitoredMarkers)) exitWith {};
	_m = GRGCore_monitoredMarkers deleteAt 0;
	_m params["_marker","_deleteAt"];
	if (diag_tickTime > _deleteAt) then {deleteMarker _marker} else {GRGCore_monitoredMarkers pushBack _m};
}forEach GRGCore_monitoredMarkers;