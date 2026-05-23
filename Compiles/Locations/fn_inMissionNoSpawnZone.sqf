/*

*/

params[["_pos",[0,0,0]],["_range",200]];
if (_pos isEqualTo [0,0,0]) exitWith {};
private _noMissions = nearestLocations[_pos, ["GMSCore_MissionNoSpawnZone"], _range];
if (_noMissions isEqualTo []) then {false} else {true};
