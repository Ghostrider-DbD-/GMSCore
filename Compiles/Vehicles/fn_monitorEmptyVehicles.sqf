/*
	GMSCore_fnc_monitorEmptyVehicles

	Purpose: deletes empty vehicles after a proscribed period if they are not local

	Parameters: None

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: 
*/
#include "\GMSCore\Init\GMS_defines.hpp"


for "_i" from 1 to (count GMSCore_monitoredEmptyVehicles) do 
{
	if (_i > (count GMSCore_monitoredEmptyVehicles)) exitWith {};
	private _vehData = GMSCore_monitoredEmptyVehicles deleteAt 0;
	_vehData params["_veh","_deleteAt"];
	if (diag_tickTime > _deleteAt) then 
	{
		if (local _veh) then 
		{
			private _playersNear = [getPosATL _veh, 300] call GMSCore_fnc_playersNear;
			if (_playersNear isEqualTo []) then 
			{
				[_veh] call GMSCore_fnc_destroyVehicleAndCrew;
			} else {
				GMSCore_monitoredEmptyVehicles pushBack _vehData;
			};
		} else {
			
		};
	} else {
		GMSCore_monitoredEmptyVehicles pushBack _vehData;
	};
};