/*
    GMSCore_fnc_addVehcleCrew 

    Purpose: Add driver, gunners and cargo crew as specified
    Parameters:
        _group: group to which to associate any crew added
        _veh: vehicle into which to load crew 
        _maxGunner: maximum number of gunners to load
        _maxCargo: maximal number of cargo units including units that can fire through portals or windows etc. 

    Returns: nothing 
*/

params[["_group",grpNull], ["_veh", objNull],["_maxGunner",0],["_maxCargo", 0]];
private _crewAdded = 0;
private _gunnersAdded = 0;
private _unitsAdded = 0;
private _crewAvailable = units _group;
private _unitsAvailable = count (units _group);
private _createUnits = if (_unitsAvailable isEqualTo 0) then {true} else {false};

// Add Driver 
private _driver = objNull;
if (_createUnits) then {
    _driver = [_group] call GMSCore_fnc_createUnit;
} else {
    _driver = _crewAvailable deleteAt 0;
};
_driver moveInDriver _veh;
_driver assignAsDriver _veh; 
_unitsAdded = _unitsAdded + 1; 

// Add gunners 

private _turrets = allTurrets[_veh, false];
private _maxGunnerAllowed = _maxGunner min (count _turrets); 
{
    if (_gunnersAdded isEqualTo _maxGunnerAllowed) exitWith {};
    if (_crewAvailable isEqualTo []) exitWith {};
    private _turretWeapons = _veh weaponsTurret _x;
    private _gunner = objNull; 
    private _addGunner = true;
    if !(_turretWeapons isEqualTo []) then {
        if (_createUnits) then {
            _gunner = [_group] call GMSCore_fnc_createUnit;
        } else {
            if !(_crewAvailable isEqualTo []) then {
                _gunner = _crewAvailable deleteAt 0;
            } else {
                _addGunner = false;
            };
        };
        if (_addGunner) then {
            [_gunner, true] call GMSCore_fnc_addNVG;
            _gunner assignAsTurret [_veh, _x];
            _gunner moveInTurret [_veh, _x];
            _gunnersAdded = _gunnersAdded + 1;
            _unitsAdded = _unitsAdded + 1;
        };
    };
} forEach _turrets;

// Add Commander if there is a seat for one 
private _commanderSlots = _veh emptyPositions "Commander";
if (!(_commanderSlots isEqualTo [])) then {
    private _commander = objNull;
    if (_createUnits) then {
        _commander = [_group] call GMSCore_fnc_createUnit;
    } else {
        if !(_crewAvailable isEqualTo []) then {_commander = _crewAvailable deleteAt 0};
    };
    if !(isNull _commander) then {
        _commander moveInCommander _veh;
        _commander assignAsCommander _veh;
        _crewAdded = _crewAdded + 1;
    };
};

// Add Crew to Cargo Seats 
private _emptyCargo = _veh emptyPositions "Cargo";
private _allEmpty = _veh emptyPositions "";
//[format["_addVehicleCrew: _emptyCargo %1 | _allEmpty %2",_emptyCargo, _allEmpty]] call GMSCore_fnc_log;
for "_i" from 0 to _emptyCargo do  {
    if (_crewAdded >= _maxCargo) exitWith {};
    //[format["_addVehicleCrew: empty position _veh %1 = %2", _forEachIndex, _x]] call GMSCore_fnc_log; 
    private _crew = objNull;
    if (_createUnits) then {
        _crew = [_group] call GMSCore_fnc_createUnit;
    } else {
        if !(_crewAvailable isEqualTo []) then {
            _crew = _crewAvailable deleteAt 0;
        };
    };
    if (isNull _crew) exitWith {};

    _crew moveInCargo _veh; 
    _crew assignAsCargo _veh; 
    _crewAdded = _crewAdded + 1;
};
//[format["_addVehicleCrew: crew _veh %1"]] call GMSCore_fnc_log;
