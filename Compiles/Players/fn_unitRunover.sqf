/*
	GMS_fnc_unitRunover 

	Prupose: test if a unit was runover and if so then proceed appropriately 

	Parameters: _this (from mpkilled EH)

	Returns: true/false

	Copyright 2020 by Ghostrider-GRG- 

	Notes: 

*/

params["_unit","_killer","_instigator",["_methods",[1]]];

{
	switch (_method) do 
	{
		case 1: {  // revive unit
			_unit setDamage 0;
			private _hp = getAllHitPointsDamage _unit;
			private _hpNames = _hp select 0;
			private _hpValues = _hp select 2;
			{
				_unit setHitPointDamage [_x, _hpValues select _forEachIndex];
			} forEach _hpnames;		
		};
		case 2: {  // strip unit of all gear
			_unit call GMS_fnc_removeLauncher;
			_unit call GMS_fnc_removeNVG;
			_unit call GMS_fnc_removeAllGear;
		};
		case 3: {  //  random hitpoint damage
				private _hpDamage = GMSCore_onRunoverHitpointDamage;
				private _noHpDamaged = [GMSCore_onRunoverNoHitPointsDamaged] call GMS_fnc_getIntegerFromRange;
				private _hp = getAllHitPointsDamage _veh;
				private _hpNames = _hp select 0;
				private _hpValues = _hp select 2;						
				for "_i" from 0 to (_noHpDamaged) do 
				{
					_hp = round(random(count _hpValues));
					_veh setHitPointDamage [(_hpNames select _hp), (_hpValues select _hp) + [_hpDamage] call GMS_fnc_getIntegerFromRange];
				};
				[] remoteExec ["GMS_fnc_messagingRoadKillSniperPenalty",_killer];					
		};
		case 4: { // attach grenade
				//params["_obj",["_explosive","MiniGrenade"]];
				private _bomb = createVehicle[selectRandom["MiniGrenade","HandGrenade"],[0,0,0]];
				private _hpNames = (getAllHitPointsDamage _obj) select 1;
				_veh attachTo[_bomb,[0,1,0],_hpNames select (round(random(count _hpNames)))];
				[] remoteExec ["GMS_fnc_messagingRoadKillIEDPenalty",_killer];
		};
		case 5: {  // Local Earthquake
				[1] remoteExec[ "BIS_fnc_Earthquake",_player];
				[] remoteExec ["GMS_fnc_messagingRoadKillIEDPenalty",_killer];
		};
		case 6: { // Loose Respect 
			[_killer,_respectRemoved] call GMS_fnc_giveTakeRespect;
			[_respectRemoved] remoteExec ["GMS_fnc_messagingRoadKillRespectPenalty",_killer];
		};
		case 7: { // loose tabs
			[_killer,_tabsRemoved] call GMS_fnc_giveTakeTabs;
			[_tabsRemoved] remoteExec ["GMS_fnc_messagingRoadKillTabsPenalty",_killer]
		};
	};
} forEach _methods;	

