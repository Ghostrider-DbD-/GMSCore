/*

*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_messageType","_message",["_recipients",allPlayers]];
[format["[GMSCore]  _messagePlayers: _messageType = %1 | _message = %2 | _recipients = %3",_messageType,_message,_recipients]] call GMS_fnc_log;
{
	if (isPlayer _x) then {
		//[_messageType,_message] remoteExec["GMS_fnc_handleMessage",(owner _x)]
	};
} forEach _recipients;