/*
    GMSCore_fnc_isSubmersible 

    Purpose: Test if an object is one of the submersibles in Arma 
    Parameters: _veh - the vehcle in question 
    Returns: True if the vehicle has SDV_01_base_F as its base class and is therefore a submersible 
*/

params[["_veh",objNull]];

private "_isSubmersible";
_isSubmersible = if (typeOf _veh isEqualTo "SDV_01_base_F") then {true} else {false};
_isSubmersible 