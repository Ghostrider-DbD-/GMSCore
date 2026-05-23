/*
    GMSCore_fnc_isHunting 

    Purpose: return "isHunting" varable for group either true/false 
    Parameters: _group - the group for which to read the flag 
    Returns: true or false 
    
*/

params[["_group", grpNull]];
if (isNull _group) exitWith {false};
private _isHunting = _group getVariable["isHunting", false];
_isHunting