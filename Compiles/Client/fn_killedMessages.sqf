/*
	GMS_fnc_killedMessages 

	Purpose:
		To be run on players machine 
		Notifies players of a AI Killed event 
		With some data about the AI Death 

	Parameters: 
		_unit: the unit killed 
		_killer: the player who killed the unit  
		_reward: array of [_money, _respect] that was applied to the _killer by the server 
		_killstreak: the _killer's killstreak 0 .. N 

	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
if !(hasInterface) exitWith {};
params["_unit","_killer","_money","_respect","_killStreak"];
diag_log format["GMS_fnc_killedMessages: _this = %1",_this];
if !(player isEqualTo _killer) then 
{
	{
		switch (_x) do 
		{
			case "systemChat": {
				systemChat format["%1 killed %2 with %3 at %4 meters %5X KILLSTREAK",
				name _killer,
				name _unit,
				getText(configFile >> "CfgWeapons" >> currentWeapon _killer >> "displayName"), 
				_unit distance _killer,
				_kills
				];
			};
			case "hint": {
				hint parseText format[
				"<t align='center' size='1.5' color='#f29420'>%1 Killed By</t><br/>
				<t size='1.5' color='#ffff00'>%2</t><br/>
				<t size='1.5' color='#01DF01'>Using a %3</t><br/><br/>
				<t size='1.5' color='#FFFFFF'>From %4 Meters</t><br/><br/>
				<t size='1.5' color='#FFFFFF'>%5X KILLSTREAK Meters</t>",
				name _unit,
				name _killer,
				getText(configFile >> "CfgWeapons" >> currentWeapon _killer >> "displayName"),
				_unit distance _killer,
				_kills
				];	
			};
			case "cutText": {
				cutText[
					format["%1 killed %2 with %3 at %4 meters %5X KILLSTREAK",
					name _killer,	name _unit,	getText(configFile >> "CfgWeapons" >> currentWeapon _killer >> "displayName"), _unit distance _killer,_kills
					],
					"PLAIN DOWN",
					5
				];
			};
			case "toast": {
				if (GMS_modType isEqualTo "exile") then 
				{
					["InfoTitleAndText", [name _unit, 
						format["Killed by %2 with a %3 from %4 meters %5X Killstreak",
						name _killer, 
						getText(configFile >> "CfgWeapons" >> currentWeapon _killer >> "displayName"), 
						_unit distance _killer, 
						_kills
						]
					]
					] call ExileClient_gui_toaster_addTemplateToast;
				};
			};
			case "epochMsg": {
				if (GMS_modType isEqualTo "epoch") then 
				{
					[format["%1 killed %2 with %3 at %4 meters %5X KILLSTREAK",
					name _killer,
					name _unit,
					getText(configFile >> "CfgWeapons" >> currentWeapon _killer >> "displayName"), 
					_unit distance _killer,
					_kills
					]] call Epoch_message;
				};
			};
		};
	} forEach GMS_killedMsgTypes;
};
if (player isEqualTo _killer) then 
{
	//private 
	private["_moneyName","_respectName","_msg1","_msg2","_msg3","_msg4","_msg5"];

	switch (GMS_ModType) do 
	{
		case "epoch": {
			_moneyName = "Crypto";
			_respectName = "Reputation";
			//_msg2 = _msg2 + format["<t color='#7CFC00' size='1.4' align='right'>Crypto <t color='#ffffff'>%1X<br/>",_money];
		};
		case "exile": {
			_moneyName = "Tabs";
			_respectName = "Respect";
		};
		default {
			_moneyName = "";
			_respectName = "";
		};
	};
	_msg1 = format["<t color='#7CFC00' size='1.4' align='right'>AI Killed</t><br/>"];
	_msg2 = if (_money == 0) then 
	{
		""
	} else {
		format["<t color='#7CFC00' size='1.4' align='right'>+%1 %2</t><br/>",_money,_moneyName];
	};
	_msg3 = if (_respect == 0) then 
	{
		""
	} else {
		format["<t color='#7CFC00' size='1.4' align='right'>+%1 %2</t><br/>",_respect,_respectName];
	};
	_msg4 = format["<t color='#7CFC00' size='1.4' align='right'>Killstreak</t>"];
	_msg5 = format["<t color='#ffffff'>%1X</t><br/>",_killStreak];

	[parseText (_msg1 + _msg2 + _msg3 + _msg4 + _msg5),[0.0823437 * safezoneW + safezoneX,0.379 * safezoneH + safezoneY,0.0812109 * safezoneW,0.253 * safezoneH], nil, 7, 0.3, 0] spawn BIS_fnc_textTiles;
};


	