/*
	GMS_fnc_setupGroupGear

	Purpose: to add gear to units of a group.

	Parameters
		_group: the group to be processed
		_gear: an array of gear and probabiliteis it will be added.
		_launchers per group: number of units to have launchers
		_useNVG: whether to use NVG if it is dark

	Return: none

	Copyright 2020 Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group","_gear",["_launchersPerGroup",1],["_useNVG",false],["_addWeaponAttachments",true]];

#define GMS_primary 0
#define GMS_secondary 1
#define GMS_throwable 2
#define GMS_headgear 3
#define GMS_uniforms 4
#define GMS_vests 5
#define GMS_backpacks 6
#define GMS_launchers 7
#define GMS_nvg 8
#define GMS_binocs 9
#define GMS_foodAndDrinks 10
#define GMS_medical 11
#define GMS_loot 12

private _lanchersAdded = 0;

(_gear select GMS_primary) params["_weapons",["_chancePrimary",0.99999],["_chancePrimaryOptic",0.5],["_chancePrimaryMuzzle",0.5],["_chancePrimaryPointer",0.5],["_chancePrimaryUnderbarrel",0.5]];
(_gear select GMS_secondary) params["_secondaryWeapons",["_chanceSecondaryWeapon",0.5],["_chanceSecondaryWeaponOptic",0.5],["_chanceSecondaryWeaponMuzzle",0.5],["_chanceSeconaryWeaponPointer",0.5]];
(_gear select GMS_throwable) params["_throwables",["_chanceThrowables",0.5]];
(_gear select GMS_headgear) params["_headgear",["_chanceHeadgear",0.5]];
(_gear select GMS_uniforms) params["_uniforms",["_chanceUniform",0.99999]];
(_gear select GMS_vests) params["_vests",["_chanceVest",0.5]];
(_gear select GMS_backpacks) params["_backpacks",["_chanceBackpack",0.5]];
(_gear select GMS_launchers) params["_launchers",["_chanceLaunchers",0.9999]];
(_gear select GMS_nvg) params["_nvg",["_chanceNVG",0.9999]];
(_gear select GMS_binocs) params["_binoculars",["_chanceBinoculars",0.5]];
(_gear select GMS_foodAndDrinks) params ["_food",["_chanceFood",0.5]];
(_gear select GMS_medical) params["_medical",["_chanceMedical",0.5]];
(_gear select GMS_loot) params["_loot",["_chanceLoot",0.5]];

{
	private _unit = _x;
	[_unit] call GMS_fnc_unitRemoveAllGear;	
	if (random(1) < _chanceHeadgear && !(_headgear isEqualTo [])) then {_unit addHeadgear (selectRandom _headgear)};
	if (random(1) < _chanceUniform && !(_uniforms isEqualTo [])) then {_unit forceAddUniform (selectRandom (_uniforms))};
	if ( (random(1) < _chanceVest)  isEqualTo [] && !(_vests isEqualTo [])) then {_unit addVest (selectRandom _vests)};	
	if (random(1) < _chanceBackpack && !(_backpacks isEqualTo [])) then {_unit addBackpack selectRandom _backpacks};

	if ((random(1) < _chancePrimary) && !(_weapons isEqualTo [])) then
	{
		private _weap = selectRandom _weapons;  
		_unit addWeaponGlobal  _weap; 

		private _ammoChoices = getArray (configFile >> "CfgWeapons" >> _weap >> "magazines");
		private _underbarrel = getArray (configFile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems");
		_unit addMagazines [selectRandom _ammoChoices, 3];

		{
			private _optics = getArray (configfile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems");
			private _pointers = getArray (configFile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems");
			private _muzzles = getArray (configFile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems");			
			if (random 1 < _chancePrimaryMuzzle ) then {_unit addPrimaryWeaponItem (selectRandom _muzzles)};
			if (random 1 < _chancePrimaryOptic) then {_unit addPrimaryWeaponItem (selectRandom _optics)};
			if (random 1 < _chancePrimaryPointer) then {_unit addPrimaryWeaponItem (selectRandom _pointers)};
			if (random 1 < _chancePrimaryUnderbarrel) then {_unit addPrimaryWeaponItem (selectRandom _underbarrel)};
		};
		if ((count(getArray (configFile >> "cfgWeapons" >> _weap >> "muzzles"))) > 1) then {_unit addMagazine "1Rnd_HE_Grenade_shell"};
	};

	if (random(1) < _chanceSecondaryWeapon && !(_secondaryWeapons isEqualTo [])) then
	{
		private _weap = selectRandom _secondaryWeapons;
		private _ammoChoices = getArray (configFile >> "CfgWeapons" >> _weap >> "magazines");
		_unit addMagazines [selectRandom _ammoChoices, 2];

		{		
			private _optics = getArray (configfile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems");
			private _pointers = getArray (configFile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems");
			private _muzzles = getArray (configFile >> "CfgWeapons" >> _weap >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems");
			if (random 1 < _chanceSecondaryWeaponMuzzle) then {_unit addSecondaryWeaponItem  (selectRandom _muzzles)};
			if (random 1 < _chanceSecondaryWeaponOptic) then {_unit addSecondaryWeaponItem  (selectRandom _optics)};
			if (random 1 < _chanceSeconaryWeaponPointer) then {_unit addSecondaryWeaponItem  (selectRandom _pointers)};			
		};
	};
	if (random(1) < _chanceThrowables && !(_throwables isEqualTo [])) then {_unit addItem selectRandom (_throwables)};
	if (random(1) < _chanceBinoculars && !(_binoculars isEqualTo [])) then {_unit addWeapon (selectRandom _binoculars)};
	if (random(1) < _chanceFood) then 
	{
		for "_i" from 1 to 2 do{_unit addItem (selectRandom _food)};
	};

	if (random(1) < _chanceLoot && !(_food isEqualTo [])) then
	{
		for "_i" from 1 to 2 do {_unit addItem (selectRandom (_medical + _loot))};
	};
	if (random(1) < _chanceLoot && !(_loot isEqualTo [])) then
	{
		for "_i" from 1 to (1+floor(random(5))) do 
		{
			_unit addItem (selectRandom (_loot));
		};
	};
	if !(_launchers isEqualTo []) then
	{
		if (_lanchersAdded < _launchersPerGroup) then
		{
			private _selectedLauncher = selectRandom (_launchers);
			_unit addWeaponGlobal _selectedLauncher;
			_unit setVariable["GMS_launcher",_selectedLauncher];
			for "_i" from 1 to 3 do 
			{
				_unit addItemToBackpack (getArray (configFile >> "CfgWeapons" >> _selectedLauncher >> "magazines") select 0); // call BIS_fnc_selectRandom;
			};
			_lanchersAdded = _lanchersAdded + 1;
		};
	};

	if !(_nvg isEqualTo [] && random(1) < _chanceNVG) then
	{
		if(sunOrMoon < 0.2 && _useNVG)then
		{
			private _selectedNVG = selectRandom _nvg;
			_unit addWeapon _selectedNVG;
			_unit setVariable["GMS_nvg",_selectedNVG];
		};
	};
} forEach (units _group);