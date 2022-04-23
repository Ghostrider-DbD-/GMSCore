/*
	GMS_fnc_allertNearbyGroups

	Purpose: increases all units ofthe group nearest to a target other than the targets group.

	Parameters:
		_anchorPos 
		_enemyGroup
		_searchDistance
		_knowsAboutBump

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_anchorPos","_enemyGroup",["_searchDistance",300],["_knowsAboutBump",1]];
// [position, types, radius, 2Dmode]
{
	_x reveal [_x, (_x knowsAbout _enemyGroup) + _knowsAboutBump];
} forEach nearestObjects[_anchorPos, [GMS_unitType],_searchDistance]; ;