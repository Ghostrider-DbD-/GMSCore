/*
    GMSCore_fnc_addNVG

    Purpose: add NVG to unit if it does not already wear them
    
    Parameters
        _unit: the unit in question
        _temp: if true all NVG will be deleted upon unit death

    Returns: None 
*/

params[["_unit", objNull], ["_temp", true]];
private _items = items _unit;
private _addNVG = true;
{if (_x isKindOf "NVGoggles") exitWith {_addNVG = false}} forEach _items; 
if (_addNVG) then {
    _unit addItem "NVGoggles";
    _unit assignItem "NVGoggles";
    _unit setVariable["isTempNVG", _temp];
};