/*
	GMSCore_fnc_getGroupDestination 

	Parameters 
		_group // The group for which to return a destination 

	Returns 
		A location to which the group should be headed or "" 
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull]];
private _destination = ""; 
try {
	if (isNull _group) throw -1;
	if !(_group isEqualType grpNull) throw -2;
	_destination = _group getVariable[GMSCore_groupDestination ,""];
}

catch {
	switch (_exception) do {
		case -1: {
			[format["_getGroupDestinatiod: function called without any parameters"],'warning'] call GMSCore_fnc_log;
		};
		case -2: {
			[format["_getGroupDestination: parameter passed for group is not a group"],'warning'] call GMSCore_fnc_log;
		};
	};
};

_destination 