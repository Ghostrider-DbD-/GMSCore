
#include "\GMSCore\Init\GMS_defines.hpp"
if (GMSCore_monitoredRoadPatrols isEqualTo []) exitWith {};
for "_i" from 1 to (count GMSCore_monitoredRoadPatrols) do 
{
	if (_i > (count GMSCore_monitoredRoadPatrols)) exitWith {};
	private _patrol = GMSCore_monitoredRoadPatrols deleteAt 0;
	
} forEach GMSCore_monitoredRoadPatrols;