/*
    GMSCore_fnc_addMonitoredMarkers

    Purpuse: Adds any kind of object or array of objects to the cue for deletion. 
    
    Parameters: An array containing the following parameters:
        [
            "_object", // Object, group, marker, vehicle, wreck etc to be deleted; this can also be an array of objects, markers and so forth.
            "_deleteAt"  // Time at which deletion should occur.
        ];

    Returns: None 

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

// params["_marker","_deleteTime"];
GRGCore_monitoredMarkers pushBack _this;