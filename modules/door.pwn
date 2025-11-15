enum E_DOOR_CONTEXT {
    dc_doorid,
    dc_action    // 0 = none, 1 = enter, 2 = exit
};
new DoorContext[MAX_PLAYERS][E_DOOR_CONTEXT];

stock FindFreeDoorID()
{
    for (new i = 0; i < MAX_DOORS; i++)
    {
        if (!DoorInfo[i][doorcreated])
        {
            return i;
        }
    }
    return -1;
}

function OnPlayerEnterDoor(playerid, doorId)
{
  format(stringBuffer, sizeof stringBuffer, "Usa ~y~ENTER~w~ para ingresar al ~b~%s~w~.", DoorInfo[doorId][doorname]);
  ShowNotification(playerid, stringBuffer, NOTIFICATION_INFO);
  DoorContext[playerid][dc_doorid] = doorId;
  DoorContext[playerid][dc_action] = 1; // ENTER
  
}

function OnPlayerExitDoor(playerid, doorId)
{
  ShowNotification(playerid, "Usa ~y~ENTER~w~ para salir al exterior.", NOTIFICATION_INFO);
  DoorContext[playerid][dc_doorid] = doorId;
  DoorContext[playerid][dc_action] = 2; // EXIT
}

stock UpdateClientDoor(idDoor){
    DestroyDynamicArea(DoorInfo[idDoor][doorareaentrace]);
    DestroyDynamicArea(DoorInfo[idDoor][doorareaexit]); 

    DestroyDynamicPickup(DoorInfo[idDoor][doorpickupentrace]);
    DestroyDynamicPickup(DoorInfo[idDoor][doorpickupexit]);

    DoorInfo[idDoor][doorareaentrace] = CreateDynamicSphere(
        DoorInfo[idDoor][doorentracex],
        DoorInfo[idDoor][doorentracey],
        DoorInfo[idDoor][doorentracez],
        RANGE_DOOR,
        DoorInfo[idDoor][doorentracevirtualworld],
        DoorInfo[idDoor][doorentraceinterior]
    );
    RegisterDynamicArea(DoorInfo[idDoor][doorareaentrace], AREA_DOOR_ENTRACE, idDoor);

    DoorInfo[idDoor][doorareaexit] = CreateDynamicSphere(
        DoorInfo[idDoor][doorexitx],
        DoorInfo[idDoor][doorexity],
        DoorInfo[idDoor][doorexitz],
        RANGE_DOOR,
        DoorInfo[idDoor][doorexitvirtualworld],
        DoorInfo[idDoor][doorexitinterior]
    );
    RegisterDynamicArea(DoorInfo[idDoor][doorareaexit], AREA_DOOR_EXIT, idDoor);

    DoorInfo[idDoor][doorpickupentrace] = CreateDynamicPickup(DoorInfo[idDoor][doorpickupid], 1, DoorInfo[idDoor][doorentracex],DoorInfo[idDoor][doorentracey],
        DoorInfo[idDoor][doorentracez],DoorInfo[idDoor][doorentracevirtualworld], DoorInfo[idDoor][doorentraceinterior], -1, STREAMER_PICKUP_SD);

    DoorInfo[idDoor][doorpickupexit] = CreateDynamicPickup(DoorInfo[idDoor][doorpickupid], 1, DoorInfo[idDoor][doorexitx],DoorInfo[idDoor][doorexity],
        DoorInfo[idDoor][doorexitz],DoorInfo[idDoor][doorexitvirtualworld], DoorInfo[idDoor][doorexitinterior], -1, STREAMER_PICKUP_SD);
}

stock HandleDoorAction(playerid)
{
    new doorId = DoorContext[playerid][dc_doorid];
    new action = DoorContext[playerid][dc_action];

    if (action == 0) return 1; // No hay nada que hacer

    switch (action)
    {
        case 1: // ENTER
        {
            EnterDoor(playerid, doorId);
        }
        case 2: // EXIT
        {
            ExitDoor(playerid, doorId);
        }
    }

    return 1;
}

stock EnterDoor(playerid, doorId){

}

stock ExitDoor(playerid, doorId){
  
}

stock ClearDoorContext(playerid)
{
    DoorContext[playerid][dc_action] = 0;
    DoorContext[playerid][dc_doorid] = -1;
}

function OnPlayerLeftDoorArea(playerid, doorId){
  ClearDoorContext(playerid);
  HideNotification(playerid);
}

function OnPlayerLeftDoorExitArea(playerid, doorId){
  ClearDoorContext(playerid);
  HideNotification(playerid);
}

cmd:crearpuerta(playerid, params[])
{
  if (UserInfo[playerid][admin] < CMD_MODER_G)return SendError(playerid, NO_PERMISSION);
  new name[45];
  if (sscanf(params, "s[45]", name)) return SendInfo(playerid, "Uso: /crearpuerta [name]");
  new idDoor = FindFreeDoorID();
  if (idDoor != -1){
    DoorInfo[idDoor][doorcreated] = true;
    format(DoorInfo[idDoor][doorname], 45,"%s",name);
    format(stringBuffer,sizeof stringBuffer, "Se ha creado una nueva puerta: %s(%d)", name, idDoor);
    LogAdminAction("/crearpuerta", playerid, -1, stringBuffer);
    format(stringBuffer,sizeof stringBuffer, "%s(%d) ha creado una nueva puerta %s(%d)", UserInfo[playerid][username],playerid,name, idDoor);
    SendAdminChat(CMD_HELPER,stringBuffer);
    format(stringBuffer,sizeof stringBuffer, "Para completar la puerta usa " COMMANDBOLD"/editarpuerta"WHITE" %d", idDoor);
    SendInfo(playerid, stringBuffer);
    //TODO: Add sql
  }else return SendError(playerid, "Ha ocurrido un error al buscar un id nuevo para la puerta");
  return 1;
}

cmd:editarpuerta(playerid, params[]){
  if (UserInfo[playerid][admin] < CMD_MODER_G)return SendError(playerid, NO_PERMISSION);
  if (sscanf(params, "d", params[0])) return SendInfo(playerid, "Uso: /editarpuerta [doorid]");
  new idDoor = params[0];
  if(!DoorInfo[idDoor][doorcreated])return SendError(playerid, "Esta puerta aun no ha sido generada");
  DeletePVar(playerid, T_DOOR_ID);
  SetPVarInt(playerid, T_DOOR_ID, idDoor);
  ShowDialog(playerid,DIALOG_EDIT_DOOR);
  SendInfo(playerid, "Ejecutando editor de puertas");
  return 1;
}