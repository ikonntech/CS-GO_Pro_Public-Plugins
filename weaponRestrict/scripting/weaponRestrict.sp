#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <cstrike>
#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name		= "weaponRestrict",
	author		= "StannArax",
	description = "Restricts weapons",
	version		= "1.0.0",
	url			= "https://github.com/StannArax/weaponRestrict"
};

public void OnPluginStart()
{
	PrintToServer("Weapon Restriction Plugin Has Been Loaded Successfully");
	HookEvent("round_start", OnRoundStart);
}

int whoUsedTaser[20];
int currentIndex = 0;
int roundCounter = 0;

public Action CS_OnBuyCommand(int client, const char[] weapon)
{
	char formattedWeapon[30];

	Format(formattedWeapon, sizeof(formattedWeapon), "weapon_%s", weapon);

	if (!IsClientInGame(client))
	{
		return Plugin_Continue;
	}
	else if (strcmp(weapon, "weapon_xm1014") == 0 || strcmp(weapon, "weapon_mag7") == 0 || strcmp(weapon, "weapon_sawedoff") == 0 || strcmp(weapon, "weapon_nova") == 0)
	{
		char message[128];
		Format(message, sizeof(message), "You cannot buy this weapon: %s", weapon);
		PrintToChat(client, message);
	}
	else if (strcmp(weapon, "weapon_m249") == 0 || strcmp(weapon, "weapon_negev") == 0 || strcmp(weapon, "weapon_p90") == 0 || strcmp(weapon, "weapon_bizon") == 0 || strcmp(weapon, "weapon_awp") == 0 || strcmp(weapon, "weapon_g3sg1") == 0 || strcmp(weapon, "weapon_scar20") == 0)
	{
		if (GetTeamClientCount(2) + GetTeamClientCount(3) < 6)
		{
			char message[128];
			Format(message, sizeof(message), "You cannot buy this weapon until both teams have minimum 6 players: %s", weapon);
			PrintToChat(client, message);
		}
		else {
			giveItemToPlayer(client, weapon);
		}
	}
	else if (strcmp(weapon, "weapon_taser") == 0)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (GetClientSerial(client) == whoUsedTaser[i])
			{
				char message[128];
				Format(message, sizeof(message), "You can buy this weapon on every half: %s", weapon);
				PrintToChat(client, message);
			}
			else {
				whoUsedTaser[currentIndex] = GetClientSerial(client);
				currentIndex++;
				giveItemToPlayer(client, weapon);
			}
		}
	}
	else if (strcmp(weapon, "weapon_kevlar") == 0 || strcmp(weapon, "weapon_assaultsuit") == 0)
	{
		if (strcmp(weapon, "weapon_kevlar") == 0)
		{
			giveItemToPlayer(client, "item_kevlar");
		}
		else {
			giveItemToPlayer(client, "item_assaultsuit");
		}
	}
	else
	{
		char message[128];
		Format(message, sizeof(message), "Undefined Weapon: %s", weapon);
		PrintToChat(client, message);
	}

	return Plugin_Handled;
}

public void giveItemToPlayer(int client, const char[] item)
{
	int weapon_money = getWeaponMoney(client, item);
	int player_money = GetEntProp(client, Prop_Send, "m_iAccount");

	if (player_money >= weapon_money)
	{
		GivePlayerItem(client, item);
		SetEntProp(client, Prop_Send, "m_iAccount", player_money - weapon_money);
	}
}

public Action OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	roundCounter++;
	if (roundCounter == 16)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			whoUsedTaser[i] = 0;
		}
		currentIndex = 0;
	}

	return Plugin_Continue;
}

public int getWeaponMoney(int client, const char[] itemName)
{
	if (strcmp(itemName, "weapon_glock") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_GLOCK, false);
	}
	else if (strcmp(itemName, "weapon_usp_silencer") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_USP, false);
	}
	else if (strcmp(itemName, "weapon_hkp2000") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_HKP2000, false);
	}
	else if (strcmp(itemName, "weapon_p250") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_P250, false);
	}
	else if (strcmp(itemName, "weapon_elite") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_GLOCK, false);
	}
	else if (strcmp(itemName, "CSWeapon_ELITE") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_GLOCK, false);
	}
	else if (strcmp(itemName, "weapon_fiveseven") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_FIVESEVEN, false);
	}
	else if (strcmp(itemName, "weapon_cz75a") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_CZ75A, false);
	}
	else if (strcmp(itemName, "weapon_deagle") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_DEAGLE, false);
	}
	else if (strcmp(itemName, "weapon_revolver") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_REVOLVER, false);
	}
	else if (strcmp(itemName, "weapon_m249") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_M249, false);
	}
	else if (strcmp(itemName, "weapon_negev") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_NEGEV, false);
	}
	else if (strcmp(itemName, "weapon_mac10") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_MAC10, false);
	}
	else if (strcmp(itemName, "weapon_mp9") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_MP9, false);
	}
	else if (strcmp(itemName, "weapon_mp7") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_MP7, false);
	}
	else if (strcmp(itemName, "weapon_ump45") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_UMP45, false);
	}
	else if (strcmp(itemName, "weapon_bizon") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_BIZON, false);
	}
	else if (strcmp(itemName, "weapon_galilar") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_GALILAR, false);
	}
	else if (strcmp(itemName, "weapon_famas") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_FAMAS, false);
	}
	else if (strcmp(itemName, "weapon_ak47") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_AK47, false);
	}
	else if (strcmp(itemName, "weapon_m4a1") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_M4A1, false);
	}
	else if (strcmp(itemName, "weapon_m4a1_silencer") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_M4A1_SILENCER, false);
	}
	else if (strcmp(itemName, "weapon_ssg08") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_SSG08, false);
	}
	else if (strcmp(itemName, "weapon_sg556") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_SG556, false);
	}
	else if (strcmp(itemName, "weapon_aug") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_AUG, false);
	}
	else if (strcmp(itemName, "weapon_awp") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_AWP, false);
	}
	else if (strcmp(itemName, "weapon_g3sg1") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_G3SG1, false);
	}
	else if (strcmp(itemName, "weapon_scar20") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_SCAR20, false);
	}
	else if (strcmp(itemName, "weapon_flashbang") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_FLASHBANG, false);
	}
	else if (strcmp(itemName, "weapon_decoy") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_DECOY, false);
	}
	else if (strcmp(itemName, "weapon_hegrenade") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_HEGRENADE, false);
	}
	else if (strcmp(itemName, "weapon_incgrenade") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_INCGRENADE, false);
	}
	else if (strcmp(itemName, "weapon_molotov") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_MOLOTOV, false);
	}
	else if (strcmp(itemName, "weapon_smokegrenade") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_SMOKEGRENADE, false);
	}
	else if (strcmp(itemName, "item_kevlar") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_KEVLAR, false);
	}
	else if (strcmp(itemName, "item_assaultsuit") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_ASSAULTSUIT, true);
	}
	else if (strcmp(itemName, "item_defuser") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_DEFUSER, false);
	}
	else if (strcmp(itemName, "weapon_taser") == 0)
	{
		return CS_GetWeaponPrice(client, CSWeapon_TASER, false);
	}

	return 0;
}

public void OnPluginEnd()
{
	UnhookEvent("round_start", OnRoundStart);
}

public void OnMapStart()
{
	currentIndex = 0;
	for (int i = 0; i < sizeof(whoUsedTaser); i++)
	{
		whoUsedTaser[i] = -1;
	}
}