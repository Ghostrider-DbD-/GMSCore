/*
    GMSCore_fnc_updateGroupMarker 

    Purpose: update position of the debug marker for a group
            And create that marker if it does nto already exisit

    Parameters: 
        _group - the group for which the marker is beign updated
        _veh - the vehicle in which teh group is being transported 

    Returns: none 

*/

params[["_group",grpNull]];
//[format["_updateGroupDebugMarker: _group %1 | _veh %2", _group, _veh]];

if (isNull _group) exitWith {};
private _veh = _group getVariable["assignedToVehicle", objNull];
private _mrkr = (_group getVariable["wpMarker",""]);
private _leader = leader _group;
private _pos = getPos _leader;
//[format["_updateGroupDebugMarker: _group %1 | typeOf _veh %2", _group, typeOf _veh]] call GMSCore_fnc_log;
if (_mrkr isEqualTo "") then {
    _mrkr = createMarker[format["wpMarker%1", random(100000)], _pos];
    _mrkr setMarkerType "hd_dot";
    _mrkr setMarkerColor "COLORORANGE";
    private _typeOfVeh = [_veh] call GMSCore_fnc_getVehicleType;
    _mrkr setMarkerText format["group%1|type %2",_group, _typeOfVeh];    
    _group setVariable["wpMarker",_mrkr];
};
_mrkr setMarkerPos _pos;
//[format["_updateGroupDebugMarker: position of marker %1 set to %2", _mrkr, _pos]] call GMSCore_fnc_log;

