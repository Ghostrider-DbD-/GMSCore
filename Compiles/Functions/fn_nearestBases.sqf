/*
	GMSCore_fnc_nearestBases 
*/

params["_pos","_radius"];
private _bases = [];

switch (GMSCore_modType) do {
	case ((toLower GMSCore_modType) isEqualTo "epoch"): {
		_bases = nearestObjects[_pos, ["PlotPole_M_SIM_EPOCH", "PlotPole_L_SIM_EPOCH", "PlotPole_XL_SIM_EPOCH", "PlotPole_XXL_SIM_EPOCH"], _radius];
	};
	case ((toLower GMSCore_modType) isEqualTo "exile"): {
		_bases = nearestObjects[_pos, ["Exile_Construction_Flag_Static"], _radius];
	};
};

_bases 


