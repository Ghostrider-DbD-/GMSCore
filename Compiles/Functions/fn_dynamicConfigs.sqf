/*
	GMS_fnc_dynamicConfigs

	purpose: generate a list of weapons, uniforms and other items from CfgPrices or its equivalent and pass back an array of these items broken itno categories.

	Parameters
		_maximumPrice: the maximal price for items returned
		_blackListedItems an array with classnames of items that should be excluded.
		_blacklistedCategories an array of subcategories to be ignored, such as "watch"
		_blacklistedClassnameRoots an array of strings. Any classname containing one of more of these will be excluded, such as "CUP".

	Returns an array of arrays:
	_return = [
	_wpnAR,			// 0
	_wpnLMG,		// 1
	_wpnSMG,		// 2
	_wpnShotGun,	// 3
	_wpnSniper,		// 4
	_wpnHandGun,	// 5
	_wpnLauncher,	// 6
	_wpnThrow,		// 7
	_wpnOptics,		// 8
	_wpnMuzzles,	// 9
	_wpnPointers,	// 10
	_wpnUnderbarrel, // 11
	_binocular,		// 12
	_gps,			// 13
	_nvg,			// 14
	_map,			// 15
	_medKit,		// 16
	_mineDetector,	// 17
	_radio,			// 18
	_toolKit,		// 19
	_firstAidKit,	// 20
	_UAVTerminal,	// 21
	_watch,			// 22
	_glasses,		// 23
	_headgear,		// 24
	_uniforms,		// 25
	_vests,			// 26
	_backpacks,		// 27
	_foodAndDrinks,	// 28  {mod-specific food and drinks}
	_lootItems		// 24 (mod-specific loot itmes such as car parts, raw materials, defib and the like)
	];

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_maximumPrice",1000],["_blackListedItems",[]],["_blacklistedCategories",[]],["_blacklistedClassnameRoots",[]]];
_GMSCore_headgearList = [];
_GMSCore_SkinList = [];
_GMSCore_vests = [];
_GMSCore_backpacks = [];
_GMSCore_Pistols = [];
_GMSCore_primaryWeapons = [];
//_GMSCore_throwable = [];
_allWeaponRoots = ["Pistol","Rifle","Launcher"];
_allWeaponTypes = ["AssaultRifle","MachineGun","SniperRifle","Shotgun","Rifle","Pistol","SubmachineGun","Handgun","MissileLauncher","RocketLauncher","Throw","GrenadeCore"];
_addedBaseNames = [];
_allBannedWeapons = [];
_wpnAR = []; //Assault Rifles
_wpnARG = []; //Assault Rifles with GL
_wpnLMG = []; //Light Machine Guns
_wpnSMG = []; //Sub Machine Guns
_wpnDMR = []; //Designated Marksman Rifles
_wpnLauncher = [];
_wpnSniper = []; //Sniper rifles
_wpnHandGun = []; //HandGuns/Pistols
_wpnShotGun = []; //Shotguns
_wpnThrow = []; // throwables
_wpnUnknown = []; //Misc
_wpnUnderbarrel = [];
_wpnMagazines = [];
_wpnOptics = [];
_wpnPointers = [];
_wpnMuzzles = [];
_uniforms = [];
_headgear = []; 
_glasses = []; 
_masks = []; 
_backpacks = []; 
_vests = [];
_goggles = []; 
_nvg = []; 
_binocular = [];
_compass = [];
_firstAidKit = [];
_gps = [];
_laserDesignator = [];
_map = [];
_medKit = [];
_mineDetector = [];
_radio = [];
_toolKit = [];
_UAVTerminal = [];
_watch = [];
_unknown = [];
_bullet = [];
_flare = [];
_laser = [];
_missile = [];
_rocket = [];
_shell = [];
_shotgunShell = [];
_smokeShell = [];
_foodAndDrinks = [];
_misc = [];
_lootItems = [];
_baseClasses = [];	
_classnameList = [];
_classNamesAdded = [];
private "_classnameList";
if (toLower(GMS_ModType) isEqualTo "epoch") then
{
	_classnameList = (missionConfigFile >> "CfgPricing" ) call BIS_fnc_getCfgSubClasses;
	_generic = [configFile >> "CfgLootTable" >> "Generic","items",[]] call BIS_fnc_returnConfigEntry;
	_genericBed = [configFile >> "CfgLootTable" >> "GenericBed","items",[]] call BIS_fnc_returnConfigEntry;
	_genericLarge = [configFile >> "CfgLootTable" >> "GenericLarge","items",[]] call BIS_fnc_returnConfigEntry;
	_foodAndDrinksCfg = [configFile >> "CfgLootTable" >> "Food","items",[]] call BIS_fnc_returnConfigEntry;
	_genericAuto = [configFile >> "CfgLootTable" >> "GenericAuto","items",[]] call BIS_fnc_returnConfigEntry;
	_toolsLoot = [configFile >> "CfgLootTable" >> "Tools","items",[]] call BIS_fnc_returnConfigEntry;
	_mineLoot = [configFile >> "CfgLootTable" >> "Mine","items",[]] call BIS_fnc_returnConfigEntry;
	_medicalLoot = [configFile >> "CfgLootTable" >> "Medical","items",[]] call BIS_fnc_returnConfigEntry;
	{
		(_x select 0) params["_itemClassName","_itemCfgTyep"];
		//diag_log format["[GMSCore] fn_dynamicConfigs: _itemClassName = %2 |  _x = %1",_x, _itemClassName];
		if ([_itemClassName, _blacklistedClassnameRoots] call GMS_fnc_substringsPresentInString == 0) then
		{
			if ( (getNumber(missionConfigFile >> "CfgPricing" >> _itemClassName >> "price")) < _maximumPrice  && !(_itemClassName in _blackListedItems) && !(_itemClassName in _classNamesAdded)) then
			{
				_foodAndDrinks pushBack _itemClassName;
				_classNamesAdded pushBack _itemClassName;
			};
		};
	}forEach _foodAndDrinksCfg;
	{
		(_x select 0)	params["_itemClassName","_itemCfg"];
		//diag_log format["[GMSCore] fn_dynamicConfigs: _itemClassName = %2 |  _x = %1",_x, _itemClassName];		
		if (_itemCfg isEqualTo "magazine") then
		{
			if ([_itemClassName, _blacklistedClassnameRoots] call GMS_fnc_substringsPresentInString == 0) then
			{
				if ( (getNumber(missionConfigFile >> "CfgPricing" >> _itemClassName >> "price")) < _maximumPrice  && !(_itemClassName in _blackListedItems) && !(_itemClassName in _classNamesAdded)) then
				{
					_lootItems pushBack _itemClassName;
					_classNamesAdded pushBack _itemClassName;
				};
			};
		};
		if (_itemCfg isEqualTo "CfgLootTable") then
		{
			_itemsList = [configFile >> "CfgLootTable" >> _itemClassName, "items",[]] call BIS_fnc_returnConfigEntry;
			//diag_log format["GMSCore] fn_dynamicConfigs: for _itemClassName %1 | _itemsList was %2",_itemClassName,_itemsList];
			{
				if ([_itemClassName, _blacklistedClassnameRoots] call GMS_fnc_substringsPresentInString == 0) then
				{
					if ( (getNumber(missionConfigFile >> "CfgPricing" >> _itemClassName >> "price")) < _maximumPrice  && !(_itemClassName in _blackListedItems) && !(_itemClassName in _classNamesAdded)) then
					{
						_lootItems pushBack _itemClassName;
						_classNamesAdded pushBack _itemClassName;
					};					
				};
			} forEach _itemsList;
		};
	} forEach (_generic + _genericAuto + _genericBed + _genericLarge + _toolsLoot + _medicalLoot);
};

if (toLower(GMS_modType) isEqualTo "exile") then
{
	_classnameList = (missionConfigFile >> "CfgExileArsenal" ) call BIS_fnc_getCfgSubClasses;
};
private ["_price"];  // here for scope only
{
	_itemClassName = _x;
	if ([_itemClassName, _blacklistedClassnameRoots] call GMS_fnc_substringsPresentInString == 0) then
	{
		if (toLower(GMS_modType) isEqualTo "epoch") then
		{
			_price = getNumber(missionConfigFile >> "CfgPricing" >> _x >> "price");
		};
		if (toLower(GMS_modType)  isEqualTo "exile") then
		{
			_price = getNumber(missionConfigFile >> "CfgExileArsenal" >> _x >> "price");
		};
		if !([_itemClassName] call GMS_fnc_isClass) then 
		{
			[format["Invalid classname used: %1",_itemClassName],"warning"] call GMS_fnc_log;
			_price = _maximumPrice + 100;
		};
		if (_price < _maximumPrice) then
		{
				([_itemClassName] call BIS_fnc_itemType) params["_itemCategory","_itemType"];
				//diag_log format["GMSCore] fn_dynamicConfigs: _x = %1 | _itemCategory = %2 | _itemType = %3 | _price = %4",_x,_itemCategory,_itemType,_price];
				if (!(_itemClassName in _classNamesAdded)  && !(_itemClassName in _blackListedItems) && !(_itemCategory in _blacklistedCategories)) then
				{
						if (_itemCategory isEqualTo "Weapon") then
						{
							switch (_itemType) do
							{
								case "AssaultRifle": {_wpnAR pushBack _itemClassName};
								case "MachineGun": {_wpnLMG pushBack _itemClassName};
								case "SubmachineGun": {_wpnSMG pushBack _itemClassName};
								case "Shotgun": {_wpnShotGun pushBack _itemClassName};
								case "Rifle": {_wpnAR pushBack _itemClassName};
								case "SniperRifle": {_wpnSniper pushBack _itemClassName};
								case "Handgun": {_wpnHandGun pushBack _itemClassName};
								case "Launcher": {_wpnLauncher pushBack _itemClassName};
								case "RocketLauncher": {_wpnLauncher pushBack _itemClassName};
								case "Throw": {_wpnThrow pushBack _itemClassName};
							};
						};
						
						if (_itemCategory isEqualTo "Item") then
						{
							switch (_itemType) do
							{
								case "AccessoryMuzzle": {_wpnMuzzles pushBack _itemClassName};
								case "AccessoryPointer": {_wpnPointers pushBack _itemClassName};
								case "AccessorySights": {_wpnOptics pushBack _itemClassName};
								case "AccessoryBipod": {_wpnUnderbarrel pushBack _itemClassName};
								case "Binocular": {_binocular pushBack _itemClassName};
								case "Compass": {_compass pushBack _itemClassName};
								case "GPS": {_gps pushBack _itemClassName};
								case "NVGoggles": {_nvg pushBack _itemClassName};
								case "Map": {_map pushBack _itemClassName};
								case "MedKit": {_medKit pushBack _itemClassName};
								case "MindDetector": {_mineDetector pushBack _itemClassName};
								case "Radio": {_radio pushBack _itemClassName};
								case "Toolkit": {_toolKit pushBack _itemClassName};
								case "UAVTerminal": {_UAVTerminal pushBack _itemClassName};
								case "Watch": {_watch pushBack _itemClassName};
								//default: {_misc pushBack _itemClassName};
							};
						};
						
						if (_itemCategory isEqualTo "Equipment") then
						{
							switch (_itemType) do
							{
								case "Glasses": {_glasses pushBack _itemClassName};
								case "Headgear": {_headgear pushBack _itemClassName};
								case "Vest": {_vests pushBack _itemClassName};
								case "Uniform": {_uniforms pushBack _itemClassName};
								case "Backpack": {_backpacks pushBack _itemClassName};
							};
						};
				};	
		};
	};
} forEach _classnameList;
_equipment = _map + _watch + _compass + _toolKit;
/*
diag_log format["[GMSCore] fn_dynamicConfigs: _weapons = %1",_wpnAR + _wpnLMG + _wpnSMG + _wpnShotGun + _wpnSniper];
diag_log format["[GMSCore] fn_dynamicConfigs: _wpnHandGun = %1",_wpnHandGun];
diag_log format["[GMSCore] fn_dynamicConfigs: _wpnThrow = %1",_wpnThrow];
diag_log format["[GMSCore] fn_dynamicConfigs: _wpnOptics = %1",_wpnOptics];
diag_log format["[GMSCore] fn_dynamicConfigs: _wpnMuzzles = %1",_wpnMuzzles];
diag_log format["[GMSCore] fn_dynamicConfigs: _wpnPointers = %1",_wpnPointers];
diag_log format["[GMSCore] fn_dynamicConfigs: _wpnUnderbarrel = %1",_wpnUnderbarrel];
diag_log format["[GMSCore] fn_dynamicConfigs: _binocular = %1",_binocular];
diag_log format["[GMSCore] fn_dynamicConfigs: _gps = %1",_gps];
diag_log format["[GMSCore] fn_dynamicConfigs: _nvg = %1",_nvg];
diag_log format["[GMSCore] fn_dynamicConfigs: _map = %1",_equipment];
diag_log format["[GMSCore] fn_dynamicConfigs: _medKit = %1",_medKit];
diag_log format["[GMSCore] fn_dynamicConfigs: _mineDetector = %1",_mineDetector];
diag_log format["[GMSCore] fn_dynamicConfigs: _radio = %1",_radio];
diag_log format["[GMSCore] fn_dynamicConfigs: _firstAidKit = %1",_firstAidKit];
diag_log format["[GMSCore] fn_dynamicConfigs: _UAVTerminal = %1",_UAVTerminal];
diag_log format["[GMSCore] fn_dynamicConfigs: _binocular = %1",_binocular];
diag_log format["[GMSCore] fn_dynamicConfigs: _glasses = %1",_glasses];
diag_log format["[GMSCore] fn_dynamicConfigs: _headgear = %1",_headgear];
diag_log format["[GMSCore] fn_dynamicConfigs: _uniforms = %1",_uniforms];
diag_log format["[GMSCore] fn_dynamicConfigs: _vests = %1",_vests];
diag_log format["[GMSCore] fn_dynamicConfigs: _backpacks = %1",_backpacks];
diag_log format["[GMSCore] fn_dynamicConfigs: _foodAndDrinks = %1",_foodAndDrinks];
diag_log format["[GMSCore] fn_dynamicConfigs: _lootItems = %1",_lootItems];
*/
_return = [
	_wpnAR,			// 0
	_wpnLMG,		// 1
	_wpnSMG,		// 2
	_wpnShotGun,	// 3
	_wpnSniper,		// 4
	_wpnHandGun,	// 5
	_wpnLauncher,	// 6
	_wpnThrow,		// 7
	_wpnOptics,		// 8
	_wpnMuzzles,	// 9
	_wpnPointers,	// 10
	_wpnUnderbarrel, // 11
	_binocular,		// 12
	_gps,			// 13
	_nvg,			// 14
	_map,			// 15
	_medKit,		// 16
	_mineDetector,	// 17
	_radio,			// 18
	_toolKit,		// 19
	_firstAidKit,	// 20
	_UAVTerminal,	// 21
	_watch,			// 22
	_glasses,		// 23
	_headgear,		// 24
	_uniforms,		// 25
	_vests,			// 26
	_backpacks,		// 27
	_foodAndDrinks,	// 28  {mod-specific food and drinks}
	_lootItems		// 24 (mod-specific loot itmes such as car parts, raw materials, defib and the like)
];
//diag_log format["[GMSCore] fn_dynamicConfigs: _return = %1",_return];
//diag_log format["Compilation of dynamic AI Loadouts complete at %1",diag_tickTime];
_return

/*
Additional Documentation on Specific Arma Functions used.

https://community.bistudio.com/wiki/BIS_fnc_itemClassName
BIS_fnc_itemClassName
Description:
    Returns item category and type.

        Can return:
        Weapon / VehicleWeapon
            AssaultRifle
            BombLauncher
            Cannon
            GrenadeLauncher
            Handgun
            Launcher
            MachineGun
            Magazine
            MissileLauncher
            Mortar
            RocketLauncher
            Shotgun
            Throw
            Rifle
            SubmachineGun
            SniperRifle
        VehicleWeapon
            Horn
            CounterMeasuresLauncher
            LaserDesignator
        Item
            AccessoryMuzzle
            AccessoryPointer
            AccessorySights
            AccessoryBipod
            Binocular
            Compass
            FirstAidKit
            GPS
            LaserDesignator
            Map
            Medikit
            MineDetector
            NVGoggles
            Radio
            Toolkit
            UAVTerminal
            VehicleWeapon
            Unknown
            UnknownEquipment
            UnknownWeapon
            Watch
        Equipment
            Glasses
            Headgear
            Vest
            Uniform
            Backpack
        Magazine
            Artillery
            Bullet
            CounterMeasures
            Flare
            Grenade
            Laser
            Missile
            Rocket
            Shell
            ShotgunShell
            SmokeShell
            UnknownMagazine
        Mine
            Mine
            MineBounding
            MineDirectional

