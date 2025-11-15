

public OnGameModeInit(){
    ConnectServer();
    LoadServer();
    LoadDoors();
    return 1;
}

public OnGameModeExit(){
    foreach (new playerid : Player){
        CleanUser(playerid);
    }
    CleanServer();
    for (new i = 0; i < MAX_DOORS; i++)
    {
        if (DoorInfo[i][doorcreated])
        {
            CleanDoor(i);
        }
    }
    DisconnectServer();
    return 1;
}

public OnPlayerConnect(playerid){
    if(ServerInfo[status] == SERVER_STATUS_ERROR){
        return SendError(playerid,"Servidor en mantenimiento");
    }
    CreateTextDrawnNotifier(playerid);
    CreateTextDrawnLoading(playerid);
    format(UserInfo[playerid][username], MAX_PLAYER_NAME+1, "%s", GetPlayerNameEx(playerid));
    CheckRegister(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason){
    if(GetPVarInt(playerid,T_CONNECTED) == 1){
        SaveAccount(playerid);
    }
    DestroyNotificationTD(playerid);
    CleanUser(playerid);
    return 1;
}


public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if (UserInfo[playerid][admin] < flags)
    {
        SendError(playerid, "No tienes permiso para usar este comando");
        return 0;
    }
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
  if (result == -1)
  {
    SendError(playerid,"Comando desconocido");
    return 0;
  }

  return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    new type = AreaData[areaid][area_type];
    new ownerId = AreaData[areaid][area_ownerid];
    
    switch (type)
    {
        case AREA_DOOR_ENTRACE:
        {
            OnPlayerEnterDoor(playerid, ownerId);
        }
        case AREA_DOOR_EXIT:{
            OnPlayerExitDoor(playerid, ownerId);
        }
    }
    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    new type = AreaData[areaid][area_type];
    new ownerId = AreaData[areaid][area_ownerid];

    switch (type)
    {
        case AREA_DOOR_ENTRACE:
        {
            OnPlayerLeftDoorArea(playerid, ownerId);
        }
        case AREA_DOOR_EXIT:
        {
            OnPlayerLeftDoorExitArea(playerid, ownerId);
        }
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if (PRESSED(GetParseKey(playerid, KEYS_DOOR)))
    {
        HandleDoorAction(playerid);
    }
    return 1;
}