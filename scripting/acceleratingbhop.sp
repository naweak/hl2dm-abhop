#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

public Plugin abhop =
{
	name = "Accelerating bhop",
	author = "naweak",
	description = "Acceleration in jumping loop",
	version = "1.0",
	url = "https://github.com/naweak/acceleratingbhop"
};

new ConVar:g_accelerationEnabled
new ConVar:g_accelerationRatio

public OnPluginStart() {
	g_accelerationEnabled = CreateConVar("sm_abhop_acceleration", "1", "Is bhop enabled")
	g_accelerationRatio = CreateConVar("sm_abhop_ratio", "1.3", "Bhop acceleration ratio")
}

new bool:accelerated[MAXPLAYERS+1]

public Action OnPlayerRunCmd(int client, 
	int &buttons, 
	int &impulse, 
	float vel[3],                                                                   
	float angles[3], 
	int &weapon) {
	if (g_accelerationEnabled.BoolValue && IsPlayerAlive(client) && buttons & IN_JUMP) {
		if(!(GetEntityFlags(client) & FL_ONGROUND)) {
			if(!accelerated[client]) {
				GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
				vel[0] *= g_accelerationRatio.FloatValue
				vel[1] *= g_accelerationRatio.FloatValue
				SetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
				accelerated[client] = true
			}
		}
		else {
			accelerated[client] = false
		}
	}

	return Plugin_Continue
}