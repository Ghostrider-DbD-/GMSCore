/*
	GMSCore_fnc_killedMessages 

	Purpose:
		To be run on players machine 
		Notifies players of a AI Killed event 
		With some data about the AI Death 

	Parameters: 
		_killer: the player who killed the unit  
		_money: how many tabs or crypto were awarded 
		_respect: how much respect or karma was awarded 
		_weapon: text name for weapon 
		_killstreak: the _killer's killstreak 0 .. N 
		_messageTypes: array of types of messages wtih which to notify the player
		_maxMessagingRadius: how far away from killers can players be and still get notified
	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
// [_instigator, _reward, _experience, name _unit, _unit distance _instigator, getText(configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName"), _killstreak, GMSAI_killMessageToAl
params["_killer","_money","_respect", "_unitName", "_distance", "_weapon", "_killStreak","_messageTypes"];

params[["_killer",objNull],["_money",0],["_respect",0],["_unitName",""],["_distance",0],["_weapon",""],["_killStreak",0],["_messageTypesPlayers",[]],["_messageTypesKiller",[]],["_maxMessagingRadius",10000]];

//diag_log format["\x\addons\GMSCore_fnc_killedMessages: _this = %1",_this];
private "_messageTypes";
if (player isEqualTo _killer) then 
{
	_messageTypes = _messageTypesKiller;
} else {
	_messageTypes = _messageTypesPlayers;
}; 

{
	if ((player distance _killer) <= _maxMessagingRadius) then {
		switch (_x) do 
		{
			case "systemChat": {
				systemChat format["%1 killed %2 with %3 at %4 meters for a %5X KILLSTREAK",
				name _killer,
				_unitName,
				_weapon,				
				_distance,
				_killstreak
				];
			};
			case "hint": {
				hint parseText format[
				"<t align='center' size='1.5' color='#f29420'>%1 Killed By</t><br/>
				<t size='1.5' color='#ffff00'>%2</t><br/>
				<t size='1.5' color='#01DF01'>Using a %3</t><br/><br/>
				<t size='1.5' color='#FFFFFF'>From %4 Meters</t><br/><br/>
				<t size='1.5' color='#FFFFFF'>%5X KILLSTREAK Meters</t>",
				_unitName,
				name _killer,
				_weapon,
				_distance,
				_killstreak
				];	
			};
			case "cutText": {
				cutText[
					format["%1 killed %2 with %3 at %4 meters %5X KILLSTREAK",
					name _killer,	
					_unitName,	
					_weapon, 
					_distance,
					_killstreak
					],
					"PLAIN DOWN",
					5
				];
			};
			case "toast": {
				if (GMSCore_modType isEqualTo "exile") then 
				{
					["InfoTitleAndText", [
							format["%1 Killed by %2 with a %3 from %4 meters %5X Killstreak",
							_unitName, 
							name _killer, 
							_weapon, 
							_distance, 
							_killstreak
							]
						]
					] call ExileClient_gui_toaster_addTemplateToast;
				};
			};
			case "epochMsg": {
				if (GMSCore_modType isEqualTo "epoch") then 
				{
					[format["%1 killed %2 with %3 at %4 meters %5X KILLSTREAK",
					name _killer,
					_unitName,
					_weapon, 
					_distance,
					_killstreak
					]] call Epoch_message;
				};
			};
			case "dynamic": {
				private["_moneyName","_respectName","_msg1","_msg2","_msg3","_msg4","_msg5"];

				switch (GMSCore_modType) do 
				{
					case "Epoch": {
						_moneyName = "Crypto";
						_respectName = "Karma";
						//_msg2 = _msg2 + format["<t color='#7CFC00' size='1.4' align='right'>Crypto <t color='#ffffff'>%1X<br/>",_money];
					};
					case "Exile": {
						_moneyName = "Tabs";
						_respectName = "Respect";
					};
					default {
						_money = 0;
						_respect = 0;
					};
				};

				_msg1 = format["<t color='#7CFC00' size='1.4' align='right'>AI Killed</t><br/>"];
				if !(_money == 0) then 
				{
					_msg1 = _msg1 + format["<t color='#7CFC00' size='1.4' align='right'>%2</t><t color='#ffffff' size='1.4'>+%1</t><br/>",_money,_moneyName];
				};
				if !(_respect == 0) then 
				{
					_msg1 = _msg1 + format["<t color='#7CFC00' size='1.4' align='right'>%2</t><t color='#ffffff' size='1.4'>+%1</t><br/>",_respect,_respectName];
				};
				_msg1 = _msg1 + format["<t color='#7CFC00' size='1.4' align='right'>Killstreak</t><t size='1.4' color='#ffffff'>%1X</t><br/>",_killStreak];

				[parseText (_msg1),[0.0823437 * safezoneW + safezoneX,0.379 * safezoneH + safezoneY,0.0812109 * safezoneW,0.253 * safezoneH], nil, 7, 0.3, 0] spawn BIS_fnc_textTiles;
			};
		};
	};
} forEach _messageTypes;




