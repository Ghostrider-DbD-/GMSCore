
#define leaderGroup _this 
diag_log format["_GMSCore_fnc_completeWaypointAreaPatrol: vehicle %1 | leader %2 | position %3 | nearestLocation %4",typeOf (vehicle leaderGroup), leaderGroup, position leaderGroup, nearestLocation [position leaderGroup, GMSCore_locationsForWaypoints, 500]];
[leaderGroup, "Completed"] call GMSCore_fnc_nextWaypointAreaPatrol;