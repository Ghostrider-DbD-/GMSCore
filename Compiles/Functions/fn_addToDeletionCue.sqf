/*
    GMSCore_fnc_addToDeletionCue  

    Purpuse: Adds any kind of object or array of objects to the cue for deletion. 
    
    Parameters: An array containing the following parameters:
        [
            "_object", // Object, group, marker, vehicle, wreck etc to be deleted; this can also be an array of objects, markers and so forth.
            "_deleteAt"  // Time at which deletion should occur.
        ];

    Returns: None 

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
GRGCore_monitoredObjects pushBack _this;
//[format["GMSCore_fnc_addObjectToDeletionCue: _this %1 | GRGCore_monitoredObjects %2",_this,GRGCore_monitoredObjects]] call GMSCore_fnc_log;
