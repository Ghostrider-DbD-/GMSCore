/*
   GMSCore_fnc_maxMarkerDimension 

   Purpose: returns the radius of a circle or max dimension / 2 or elipse ro rectangle.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_marker",""];
if (_marker isEqualTo "") exitWith {["maxMarkerDimension: no marker parameter specified",'error'] call GMSCore_fnc_log};
private _size = getMarkerSize _marker;
// Returns the max value of the two dimensions
(size select 0) max (size select 1);


