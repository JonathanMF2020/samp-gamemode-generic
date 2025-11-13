function SuccessLoadAccount(playerid){
    // TODO: Add clean chat
    format(stringBuffer, sizeof stringBuffer, "Tu ultima conexion fue: %s", UserInfo[playerid][lastAt]);
    SendInfo(playerid, stringBuffer);
    MigrationPlayer(playerid);
    SetSpawnInfo(playerid, NO_TEAM, 1, UserInfo[playerid][x], UserInfo[playerid][y], UserInfo[playerid][z], UserInfo[playerid][a], WEAPON_SAWEDOFF, 36, WEAPON_UZI, 150, WEAPON_FIST, 0);
    SpawnPlayer(playerid);
    MigrationPlayer(playerid);
}

stock MigrationPlayer(playerid){
    printf("%s - %s",UserInfo[playerid][lastVersion], ServerInfo[version]);
    if(strcmp(UserInfo[playerid][lastVersion], ServerInfo[version]) != 0){
        //TODO: This code is to update database if is neccesary in breaking changes
        format(stringBuffer, sizeof stringBuffer, "Se ha actualizado el server, usa el comando "COMMAND"/notas", ServerInfo[version]);
        SendInfo(playerid, stringBuffer);
        UpdateAccountString(playerid, "lastVersion", ServerInfo[version]);
        format(UserInfo[playerid][lastVersion], 20, "%s", ServerInfo[version]);
    }
}