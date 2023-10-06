

// GMSCore_monitoredVisibleMarkers = [];  //  List of objects to which visible markers are attached: variables used are "GMSCoreVMStart" [float], "GMSCoreVMEnd" [float], "GMSCoreMarkers [smoke,chemlight], "GMSCoreMarkerTypes [_smokeShell,_chemLight]

for "_i" from 1 to (count GMSCore_monitoredVisibleMarkers) do 
{
	if (_i > (count GMSCore_monitoredVisibleMarkers)) exitWith {}; 
	private _crate = GMSCore_monitoredVisibleMarkers deleteAt 0;
	if (diag_tickTime > (_crate getVariable["GMSCoreVMEnd",diag_tickTime - 1])) then 
	{
			(_crate getVariable ["GMSCoreMarkers",[objNull,objNull]]) params["_smoke","_light"];
			detach _smoke;
			deleteVehicle _smoke;
			detach _light;
			deleteVehicle _smoke;
	} else {
		if (diag_tickTime > (_crate getVariable["GMSCoreVMStart",diag_tickTime]) + 60) then {  // Let's refresh the markers every 60 seconds 
			_crate setVariable ["GMSCoreVMStart",diag_tickTime];
			(_crate getVariable ["GMSCoreMarkers",[objNull,objNull]]) params["_smoke","_light"];
			detach _smoke;
			deleteVehicle _smoke;
			detach _light;
			deleteVehicle _smoke;
			private _shells = (_crate getVariable["GMSCoreMarkerTypes",[]]);
			if !(_shells isEqualTo []) then {
				_shells params["_smokeShell","_chemLight"];
				_smoke = _smokeShell createVehicle getPosATL _crate;
				_smoke setPosATL (getPosATL _crate);
				_smoke attachTo [_crate,[0,0,(0.75)]]; // put the smoke a fixed distance above the top of any object to make it as visible as possible
				_light = _chemLight createVehicle getPosATL _crate;
				_light setPosATL (getPosATL _crate);
				_light attachTo [_crate,[0,0,(0.55)]];
				_crate setVariable["GMSCoreMarkers",[_smoke,_light]];			
			};
		};
		GMSCore_monitoredVisibleMarkers pushBack _crate;
	};
};