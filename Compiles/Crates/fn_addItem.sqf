	/*
		GMS_fnc_addItem 
		Purpose: Add an item of any type to an object. 
			// Ensures that the right calls are made for the object type 

		Parameters: 
			_container: the object to which the item should be added 
			_itemInfo: an item to be loaded formated as "classnName", ["className", count], or ["className",min count, max count]
			_addAmmo:  # of magazines to add for a weapon

		Returns: None 

		Copyright 2020 by Ghostrider-GRG-
	*/
	#include "\GMSCore\Init\GMS_defines.hpp"
	
	params[
		"_container",  
		"_itemInfo",    
		["_addAmmo",0]  
	];
	private _quant = 0;
	private _itemClassName = "";
	private _isClass = false;
	private _errorCode = 0;
	// check to be sure the _itemclassName is a valid classname 
	//diag_log format["_fn_addItem:: -- >> _container = %3 | itemInfo = %1 | typeName itemInfo %2",_itemInfo,typeName _itemInfo,_container];
	if (typeName _itemInfo isEqualTo "STRING") then {_itemClassName = _itemInfo; _quant = 1};  // case where only the item descriptor was provided
	if (typeName _itemInfo isEqualTo "ARRAY") then {
		
		if (count _itemInfo isEqualTo 2) then {_itemClassName = _itemInfo select 0; _quant = _itemInfo select 1;}; // case where item descriptor and quantity were provided
		if (count _itemInfo isEqualto 3) then {
			_itemClassName = _itemInfo select 0; 
			_quant = (_itemInfo select 1) + round(random((_itemInfo select 2) - (_itemInfo select 1)));
		}; // case where item descriptor, min number and max number were provided.
	};
	//diag_log format["_itemClassName %1 | _quant %2",_itemClassName,_quant];
	try {
		private _isLoaded = false;

		if (!isClass(configFile >> "CfgWeapons" >> _itemClassName) && !isClass(configFile >> "CfgMagazines" >> _itemClassName) && !isClass(ConfigFile >> "CfgVehicles")) then {throw 1};
		if !((typeName _itemClassName) isEqualTo "STRING") then {throw 2};
		if (_itemClassName isEqualTo "") then {throw 3};
		
		if (_itemClassName isKindOf ["Rifle", configFile >> "CfgWeapons"] || _itemClassName isKindOf ["Pistol", configFile >> "CfgWeapons"] || _itemClassName isKindOf ["Launcher", configFile >> "CfgWeapons"]) then
		{
			_container addWeaponCargoGlobal [_itemClassName,_quant]; 
			_isLoaded = true;
			_count = -1;
			if (typeName _addAmmo isEqualTo "SCALAR") then
			{
				_count = _addAmmo;
			};
			if (typeName _addAmmo isEqualto "ARRAY") then
			{
				_count = (_addAmmo select 0) + (round(random((_addAmmo select 1) - (_addAmmo select 0))));
			};
			if (_count isEqualTo -1) then {throw 4};
			_ammo = getArray (configFile >> "CfgWeapons" >> _itemClassName >> "magazines");			
			for "_i" from 1 to _count do
			{
					_container addMagazineCargoGlobal [selectRandom _ammo,1];
			};
		};
		if (_itemClassName isKindOf ["Bag_Base", configFile >> "CfgVehicles"]) then {_container addBackpackCargoGlobal [_itemClassName,_quant]; _isLoaded = true;};
		if (!_isLoaded ) then {_container addItemCargoGlobal [_itemClassName,_quant]};
	} catch {
		switch (_exception) do 
		{
			case 1: {diag_log format["fn_addItem [ERROR] invalid classname %1",_itemClassName]};
			case 2: {diag_log format["fn_addItem [ERROR] STRING expected  but %1 passed",typeName _itemClassName]};
			case 3: {diag_log format["fn_addItem [ERROR] invalid classname %1: class name has 0 characters"]};
			case 4: {diag_log format["fn_addItem [ERROR] Invalid data type for _addAmmo"]};
			default {diag_log format["fn_addItem [GENERIC ERROR]"]};
		};
	};
