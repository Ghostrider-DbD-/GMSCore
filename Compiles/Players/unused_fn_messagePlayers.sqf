/*

*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_messageType","_message",["_recipients",allPlayers]];
[format["[GMSCore]  _messagePlayers: _messageType = %1 | _message = %2 | _recipients = %3",_messageType,_message,_recipients]] call GMSCore_fnc_log;
{
	[_messageType,_message] remoteExec["GMSCore_fnc_handleMessage",(owner _x)]
} forEach _recipients;