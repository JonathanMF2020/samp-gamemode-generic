function SuccessLoadAccount(playerid){
    // TODO: Add clean chat
    format(stringBuffer, sizeof stringBuffer, "Tu ultima conexion fue: %s", UserInfo[playerid][lastAt]);
    SendInfo(playerid, stringBuffer);
    MigrationPlayer(playerid);
    SetSpawnInfo(playerid, NO_TEAM, 1, UserInfo[playerid][x], UserInfo[playerid][y], UserInfo[playerid][z], UserInfo[playerid][a], WEAPON_SAWEDOFF, 36, WEAPON_UZI, 150, WEAPON_FIST, 0);
    SpawnPlayer(playerid);
    MigrationPlayer(playerid);
    //AdminPermissions[playerid] = CMD_ADMIN | CMD_MODER_G | CMD_MODER_3;
    AdminPermissions[playerid] = CMD_COMMON_USER;
}

stock MigrationPlayer(playerid){

    if(strcmp(UserInfo[playerid][lastVersion], ServerInfo[version]) != 0){
        if (strcmp(ServerInfo[version], "0.0.2") == 0)
        {
            printf("[Migration] Aplicando cambios para la versión 0.0.2 a la cuenta [%s].", UserInfo[playerid][username]);
        }
        format(stringBuffer, sizeof stringBuffer, "Se ha actualizado el server, usa el comando "COMMANDBOLD"/notas", ServerInfo[version]);
        SendInfo(playerid, stringBuffer);
        UpdateAccountString(playerid, "lastVersion", ServerInfo[version]);
        format(UserInfo[playerid][lastVersion], 20, "%s", ServerInfo[version]);
    }
}

flags:notas(CMD_COMMON_USER)
cmd:notas(playerid, params[])
{
  SendInfo(playerid, "Mantenimiento");
  return 1;
}