/*
    GMS_fnc_removeAllMPEventHandlers 

    Purpose: generic function to remove all MP Event handlers from an object 

    Parameters:
        _object, the object to handle 

    Returns: None 

    Copyright 2020 by Ghostrider-GRG-
    Notes: may not be used 
    TODO: Check if this is needed
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_object"];

{
    _object removeAllMPEventHandlers _x;
} forEach ["MPHit","MPKilled"];