/*
	GMSCore_fnc_setGroupDestination 

	params 
		_group - the group for which the destination is being set  
		_destination - a location or position ATL 

	returns 
		true if valid parameters passed else false 

*/ 

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull],["_destination",""]];
private _success = true; 
try {
	if (isNull _group) throw -1;
	if !(_group isEqualType grpNull) throw -2;
	_group setVariable[GMSCore_groupDestination , _destination];
}

catch {
	switch (_exception) do {
		case -1: {
			[format["_setGroupDestinatiod: function called without any parameters"],'warning'] call GMSCore_fnc_log;
			_success = false;
		};
		case -2: {
			[format["_setGroupDestination: parameter passed for group is not a group"],'warning'] call GMSCore_fnc_log;
			_sucess = false;
		};
	};
};

_success 