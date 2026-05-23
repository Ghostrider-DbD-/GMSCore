/*
    GMSCore_fnc_removeNVG

    Prupose: remove NVG from unitAddons

    Parameter: 
        __unit: the unit to be processed

    Return: none
*/

params[["_unit", objNull]];
private _items = items _unit;
{
    if (_x isKindOf "NVgoggles") then {
        _unit unassignItem _x;
        _unit removeItem _x;
    };
} forEach _items;