/*
* Original plugin by "Potatoz" -> https://forums.alliedmods.net/member.php?u=275895
* Edits by B3none -> http://steamcommunity.com/profiles/76561198028510846
*/

#include <sourcemod>
#include <sdktools>
#include <basecomm>
#pragma semicolon 1

#define TAG_MESSAGE "[\x04Warnings\x01]"
 
int warnings[MAXPLAYERS+1];
int warnings_mic[MAXPLAYERS+1]; 
int roundwarnings[MAXPLAYERS+1];

ConVar sm_warn_maxwarnings_enabled = null;
ConVar sm_warn_maxwarnings = null;
ConVar sm_warn_maxwarnings_reset = null;
ConVar sm_warn_banduration = null;
ConVar sm_warn_maxroundwarnings = null;
ConVar sm_warn_mic = null;
ConVar sm_warn_mictoban = null;
 
public Plugin myinfo =
{
	name = 		"Simple Warnings",
	author = 	"Potatoz, B3none",
	description = 	"Allows Admins to warn players",
	version = 	"1.1",
	url = 		"https://forums.alliedmods.net/showthread.php?t=294358"
};


public void OnPluginStart()
{
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_warn", Command_Warn, ADMFLAG_BAN);
	RegAdminCmd("sm_warnmic", Command_Warn_Mic, ADMFLAG_BAN);
	
	RegAdminCmd("sm_resetwarnings", Command_ResetWarnings, ADMFLAG_ROOT);
	RegConsoleCmd("sm_warnings", Command_Warnings);
	
	HookEvent("round_start", OnRoundStart, EventHookMode_PostNoCopy);
	
	sm_warn_maxwarnings_enabled = 	CreateConVar("sm_warn_maxwarnings_enabled", "1", "Enable automatic ban after max amount of warnings reached? 1 = Enabled 0 = Disabled, Default = 1");
	sm_warn_maxwarnings =		CreateConVar("sm_warn_maxwarnings", "0", "Max amount of total warnings before banning a player (if enabled), 0 = Disabled, Default = 0");
	sm_warn_maxwarnings_reset = 	CreateConVar("sm_warn_maxwarnings_reset", "1", "Reset warnings after automatic ban? 1 = Enabled 0 = Disabled, Default = 1");
	sm_warn_banduration = 		CreateConVar("sm_warn_banduration", "15", "How long shall a player be banned after recieving max amount of warnings (in minutes)? Default = 15");
	sm_warn_maxroundwarnings = 	CreateConVar("sm_warn_maxroundwarnings", "3", "Max amount of warnings in a single round before banning a player (if enabled), Default = 3");
	sm_warn_mic = 			CreateConVar("sm_warn_mic", "0", "Enable mic warnings? 1 = Enabled 0 = Disabled, Default = 0");
	sm_warn_mictoban = 		CreateConVar("sm_warn_mictoban", "0", "Will a mic warning lead to a ban? 1 = Yes | 0 = No, Default = 0");
	AutoExecConfig(true, "plugin_simplewarnings");
}

public OnClientPutInServer(client) 
{
	if(warnings[client] > 0)
    CreateTimer(1.0, WarningsNotify, client);
}

public OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{ 
    for(new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			roundwarnings[i] = 0;
		}
	}
}  

public Action:WarningsNotify(Handle:timer, any:client)
{
	for(new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			if (CheckCommandAccess(i, "PRINT_ONLY_TO_ADMIN", ADMFLAG_GENERIC, true))
			{
				if(i != client) 
				{
					PrintToChat(i, "%s\x07* WARNING:\x01 Player\x07 %N\x01 has \x07%d \x01warning(s) and \x07%d \x01 mic warning(s) on record.", TAG_MESSAGE, client, warnings[client], warnings_mic[client]);
				}
			}
		}
	}
}

public Action Command_Warn(int client, int args)
{
	if(args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_warn <name|#userid> [reason]");
		return Plugin_Handled;
	}
	
	char arg1[32], arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int target = FindTarget(client, arg1);
	if (target == -1)
	{
		return Plugin_Handled;
	}
	
	if(target == client)
	{
		PrintToChat(client, "%s\x07*\x01 You can't warn yourself!",  TAG_MESSAGE);
		return Plugin_Handled;
	}
	
	warnings[target]++;
	roundwarnings[target]++;
	PrintToChat(client, "%s\x07*\x01 You have warned \x07%N \x01for reason: %s", TAG_MESSAGE, target, arg2);
	PrintToChat(target, "%s\x07*\x01 You have been warned by \x07%N \x01for reason: %s", TAG_MESSAGE, client, arg2);
	
	if(roundwarnings[target] >= 2)
	{
		PrintToChat(target, "%s\x07*\x01 You currently have \x07%d \x01warning(s).", TAG_MESSAGE, warnings[target]);
	}
	
	else if(roundwarnings[target] == 1)
	{
		PrintToChat(target, "%s\x07*\x01 You currently have 1 warning.",  TAG_MESSAGE);
	}
	
	for(new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			if (CheckCommandAccess(i, "PRINT_ONLY_TO_ADMIN", ADMFLAG_GENERIC, true)) {
				if(i != client)
				{
					PrintToChat(i, "%s\x07* %N\x01 has warned \x07%N \x01for reason: %s", TAG_MESSAGE, client, target, arg2);
				}
			}
		}
	}
	LogAction(client, target, "\"%N\" warned \"%N\" (reason: %s)", client, target, arg2);
	
	if(GetConVarInt(sm_warn_maxwarnings_enabled) == 1)
	{
		if(roundwarnings[target] >= GetConVarInt(sm_warn_maxroundwarnings))
		{
			// Reset Warnings before ban? 
			if(GetConVarInt(sm_warn_maxwarnings_reset) == 1)
			{
				warnings[target] = 0;
				warnings_mic[target] = 0;
				roundwarnings[target] = 0;
			}
			BanClient(target, GetConVarInt(sm_warn_banduration), BANFLAG_AUTO, "S-WARN: Too many Warnings", "Too many warnings in one round.");
			
		}
		
		else if(warnings[target] >= GetConVarInt(sm_warn_maxwarnings) && GetConVarInt(sm_warn_maxwarnings) != 0)
		{
			// Reset Warnings before ban?
			if(GetConVarInt(sm_warn_maxwarnings_reset) == 1)
			{
				warnings[target] = 0;
				warnings_mic[target] = 0;
				roundwarnings[target] = 0;
			}
			BanClient(target, GetConVarInt(sm_warn_banduration), BANFLAG_AUTO, "S-WARN: Too many Warnings", "Too many total warnings.");
		}
	} 
	
	return Plugin_Handled;
}

public Action Command_Warn_Mic(int client, int args)
{
	if(GetConVarBool(sm_warn_mic))
	{
		if(args < 2)
		{
			ReplyToCommand(client, "[SM] Usage: sm_warnmic <name|#userid> [reason]");
			return Plugin_Handled;
		}
		
		char arg1[32], arg2[32];
		GetCmdArg(1, arg1, sizeof(arg1));
		GetCmdArg(2, arg2, sizeof(arg2));
		
		int target = FindTarget(client, arg1);
		if (target == -1)
		{
			return Plugin_Handled;
		}
		
		if(target == client)
		{
			PrintToChat(client, "%s\x07*\x01 You can't mic warn yourself!", TAG_MESSAGE);
			return Plugin_Handled;
		}
		
		warnings_mic[target]++;
		roundwarnings[target]++;
		PrintToChat(client, "%s\x07*\x01 You have mic warned \x07%N \x01for reason: %s", TAG_MESSAGE, target, arg2);
		PrintToChat(target, "%s\x07*\x01 You have been mic warned by \x07%N \x01for reason: %s", TAG_MESSAGE, client, arg2);
		
		if(roundwarnings[target] >= 2)
		{
			PrintToChat(target, "%s\x07*\x01 You currently have \x07%d \x01warnings.", TAG_MESSAGE, warnings[target]);
		}
		
		else if(roundwarnings[target] == 1)
		{
			PrintToChat(target, "%s\x07*\x01 You currently have 1 warning.", TAG_MESSAGE);
		}
		
		for(new i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				if (CheckCommandAccess(i, "PRINT_ONLY_TO_ADMIN", ADMFLAG_GENERIC, true)) {
					if(i != client)
					{
						PrintToChat(i, "%s\x07* %N\x01 has been mic warned \x07%N \x01for reason: %s", TAG_MESSAGE, client, target, arg2);
					}
				}
			}
		}
		LogAction(client, target, "\"%N\" mic warned \"%N\" (reason: %s)", client, target, arg2);
		
		if(GetConVarInt(sm_warn_maxwarnings_enabled) == 1)
		{
			if(roundwarnings[target] >= GetConVarInt(sm_warn_maxroundwarnings))
			{
				if(GetConVarInt(sm_warn_maxwarnings_reset) == 1)
				{
					warnings[target] = 0;
					warnings_mic[target] = 0;
					roundwarnings[target] = 0;
				}
				BaseComm_SetClientMute(client, true);
				PrintToChat(client, "%s You were Mic Warned too many times, muted!", TAG_MESSAGE);
				
				if(GetConVarBool(sm_warn_mictoban))
				{
					BanClient(target, GetConVarInt(sm_warn_banduration), BANFLAG_AUTO, "S-WARN: Too many Warnings", "Too many warnings in one round.");
				}
			}
			
			else if(warnings_mic[target] >= GetConVarInt(sm_warn_maxwarnings) && GetConVarInt(sm_warn_maxwarnings) != 0)
			{
				if(GetConVarInt(sm_warn_maxwarnings_reset) == 1)
				{
					warnings[target] = 0;
					warnings_mic[target] = 0;
					roundwarnings[target] = 0;
				}
				BaseComm_SetClientMute(client, true);
				PrintToChat(client, "%sYou were Mic Warned too many times, muted!", TAG_MESSAGE);
				
				if(GetConVarBool(sm_warn_mictoban))
				{
					BanClient(target, GetConVarInt(sm_warn_banduration), BANFLAG_AUTO, "S-WARN: Too many Mic Warnings", "Too many mic warnings in one round.");
				}
			}
		}
		return Plugin_Handled;
	}	
	
	else
	{
		PrintToChat(client, "%s Mic warnings are currently disabled.", TAG_MESSAGE);
		return Plugin_Handled;
	}
}

public Action Command_ResetWarnings(int client, int args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_resetwarnings <name|#userid>");
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int target = FindTarget(client, arg1);
	if (target == -1)
	{
		return Plugin_Handled;
	}
	
	PrintToChat(client, "%s\x07*\x01 You have reset \x07%N \x01warning(s).", TAG_MESSAGE, target);
	PrintToChat(target, "%s\x07* %N \x01 has reset your warning(s)", TAG_MESSAGE, client);
	warnings[target] = 0;
	warnings_mic[target] = 0;
	roundwarnings[target] = 0;
	
	return Plugin_Handled;
}

public Action Command_Warnings(int client, int args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_warnings <name|#userid>");
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int target = FindTarget(client, arg1);
	if (target == -1)
	{
		return Plugin_Handled;
	}
	
	PrintToChat(client, "%s\x07* %N\x01 has \x07%d \x01warning(s) and \x07%d \x01 mic warning(s) on record.", TAG_MESSAGE, target, warnings[target], warnings_mic[target]);
	
	return Plugin_Handled;
}
