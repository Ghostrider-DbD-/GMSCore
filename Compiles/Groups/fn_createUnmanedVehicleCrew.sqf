/*
	GMS_fnc_createUnmanedVehicleCrew 

	Purpose: Add a crew to an unmaned vehicle and properly configure it for GMSCore by adding event handlers and anything else that is required 

	Parameters: 
		_this: the vehicle to which a crew should be added 

	Returns: _group, the group for the units added 

	Copyright 2020 by Ghostrider-GRG- 
*/

[format["_createUnmanedVehicleCrew: _this = %1 | typeName _this = %2",_this, typeName _this]];
private _veh = _this;  // just for ease of decyphering the code 
private _group = createVehicleCrew _veh;
_group call GMS_fnc_addUnitEventHandlers;
_group