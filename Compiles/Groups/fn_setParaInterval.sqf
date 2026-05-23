/*
    Purpose: set a value for how long to wait before each time that paratroops are deployed by a heli or drone 
            This allows GMS_RC or GMSAI to configure this parameter for the group. 
    Parameters:
        _group - the group to be modified 
        _interval - the interval between each paratroop deploymen 

    Returns: None 
*/

params["_group","_interval"];
_group setVariable["paraInt", _interval];