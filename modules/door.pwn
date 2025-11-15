enum E_DOOR_CONTEXT {
    dc_doorid,
    dc_action    // 0 = none, 1 = enter, 2 = exit
};
new DoorContext[MAX_PLAYERS][E_DOOR_CONTEXT];

new bool:EnterLoad[MAX_PLAYERS] = false;
new PlayerText: LoadingTD[MAX_PLAYERS][2];

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
  if(DoorInfo[doorId][doorcreated] == false) return 0;
  format(stringBuffer, sizeof stringBuffer, "Usa ~y~%s~w~ para ingresar al ~b~%s~w~.", DoorInfo[doorId][doorname], GetNameKey(UserInfo[playerid][keydoor], KEYS_DOOR));
  ShowNotification(playerid, stringBuffer, NOTIFICATION_INFO);
  DoorContext[playerid][dc_doorid] = doorId;
  DoorContext[playerid][dc_action] = 1; // ENTER
  return 1;
}

function OnPlayerExitDoor(playerid, doorId)
{
  if(DoorInfo[doorId][doorcreated] == false) return 0;
  format(stringBuffer, sizeof stringBuffer, "Usa ~y~%s~w~ para salir al exterior.", GetNameKey(UserInfo[playerid][keydoor], KEYS_DOOR));
  ShowNotification(playerid, stringBuffer, NOTIFICATION_INFO);
  DoorContext[playerid][dc_doorid] = doorId;
  DoorContext[playerid][dc_action] = 2; // EXIT
  return 1;
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
  
  if(DoorInfo[doorId][doorlock] == 1) return SendError(playerid,"Se encuentra cerrado por el momento");
  if(EnterLoad[playerid] == true) return 0;
  ShowTextDrawnLoading(playerid);
  SetPlayerPosEx(playerid, DoorInfo[doorId][doorexitx], DoorInfo[doorId][doorexity], 
  DoorInfo[doorId][doorexitz], DoorInfo[doorId][doorexita], DoorInfo[doorId][doorexitinterior], DoorInfo[doorId][doorexitvirtualworld]);
  SetTimerEx("HideTextDrawnLoading", LOADING_DURATION, false, "%d", playerid);
  return 1;
}

stock ExitDoor(playerid, doorId){
  if(EnterLoad[playerid] == true) return 0;
  ShowTextDrawnLoading(playerid);
  SetPlayerPosEx(playerid, DoorInfo[doorId][doorentracex], DoorInfo[doorId][doorentracey], 
  DoorInfo[doorId][doorentracez], DoorInfo[doorId][doorentracea], DoorInfo[doorId][doorentraceinterior], DoorInfo[doorId][doorentracevirtualworld]);
  SetTimerEx("HideTextDrawnLoading", LOADING_DURATION, false, "%d", playerid);
  return 1;
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

stock CreateTextDrawnLoading(playerid){
  LoadingTD[playerid][0] = CreatePlayerTextDraw(playerid, 317.000, -5.000, "_");
  PlayerTextDrawLetterSize(playerid, LoadingTD[playerid][0], 0.300, 52.999);
  PlayerTextDrawTextSize(playerid, LoadingTD[playerid][0], 12.000, 643.000);
  PlayerTextDrawAlignment(playerid, LoadingTD[playerid][0], TEXT_DRAW_ALIGN_CENTER);
  PlayerTextDrawColour(playerid, LoadingTD[playerid][0], -1);
  PlayerTextDrawUseBox(playerid, LoadingTD[playerid][0], true);
  PlayerTextDrawBoxColour(playerid, LoadingTD[playerid][0], 255);
  PlayerTextDrawSetShadow(playerid, LoadingTD[playerid][0], 1);
  PlayerTextDrawSetOutline(playerid, LoadingTD[playerid][0], 1);
  PlayerTextDrawBackgroundColour(playerid, LoadingTD[playerid][0], 150);
  PlayerTextDrawFont(playerid, LoadingTD[playerid][0], TEXT_DRAW_FONT_1);
  PlayerTextDrawSetProportional(playerid, LoadingTD[playerid][0], true);

  LoadingTD[playerid][1] = CreatePlayerTextDraw(playerid, 325.000, 20.000, "Cargando...");
  PlayerTextDrawLetterSize(playerid, LoadingTD[playerid][1], 0.469, 2.099);
  PlayerTextDrawAlignment(playerid, LoadingTD[playerid][1], TEXT_DRAW_ALIGN_CENTER);
  PlayerTextDrawColour(playerid, LoadingTD[playerid][1], -1);
  PlayerTextDrawSetShadow(playerid, LoadingTD[playerid][1], 1);
  PlayerTextDrawSetOutline(playerid, LoadingTD[playerid][1], 1);
  PlayerTextDrawBackgroundColour(playerid, LoadingTD[playerid][1], 150);
  PlayerTextDrawFont(playerid, LoadingTD[playerid][1], TEXT_DRAW_FONT_2);
  PlayerTextDrawSetProportional(playerid, LoadingTD[playerid][1], true);
}



stock ShowTextDrawnLoading(playerid)
{
    EnterLoad[playerid] = true;
    TogglePlayerControllable(playerid, false);
    for (new i = 0; i < 2; i++)
    {
        PlayerTextDrawShow(playerid, LoadingTD[playerid][i]);
    }
}

function HideTextDrawnLoading(playerid)
{
    EnterLoad[playerid] = false;
    TogglePlayerControllable(playerid, true);
    for (new i = 0; i < 2; i++)
    {
        PlayerTextDrawHide(playerid, LoadingTD[playerid][i]);
    }
}

stock DeleteDoorE(doorId){
  new a1 = DoorInfo[doorId][doorareaentrace];
  new a2 = DoorInfo[doorId][doorareaexit];

  DestroyDynamicArea(DoorInfo[doorId][doorareaentrace]);
  DestroyDynamicArea(DoorInfo[doorId][doorareaexit]); 

  DestroyDynamicPickup(DoorInfo[doorId][doorpickupentrace]);
  DestroyDynamicPickup(DoorInfo[doorId][doorpickupexit]);

  ClearAreaData(a1);
  ClearAreaData(a2);

  DoorInfo[doorId][doorcreated] = false;
  ServerInfo[doorLength]--;
  CleanDoor(doorId);
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
    InsertDoor(idDoor);
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

cmd:puertaid(playerid, params[]){
  if (UserInfo[playerid][admin] < CMD_MODER_G)return SendError(playerid, NO_PERMISSION);
  new idDoor = DoorContext[playerid][dc_doorid];
  if (idDoor == -1 || !DoorInfo[idDoor][doorcreated])
        return SendError(playerid, "No estás cerca de ninguna puerta.");

  new action = DoorContext[playerid][dc_action];
  switch (action)
  {
      case AREA_DOOR_ENTRACE: format(stringBuffer, sizeof stringBuffer, "Estás en la "COMMANDBOLD"ENTRADA"WHITE" de la puerta ID: %d (%s).", idDoor, DoorInfo[idDoor][doorname]);
      case AREA_DOOR_EXIT: format(stringBuffer, sizeof stringBuffer, "Estás en la "COMMANDBOLD"SALIDA"WHITE" de la puerta ID: %d (%s).", idDoor, DoorInfo[idDoor][doorname]);
      default: format(stringBuffer, sizeof stringBuffer, "Puerta ID: %d (%s).", idDoor, DoorInfo[idDoor][doorname]);
  }

  SendInfo(playerid, stringBuffer);
  return 1;
}

cmd:irpuerta(playerid, params[])
{
    if (UserInfo[playerid][admin] < CMD_MODER_G)
        return SendError(playerid, NO_PERMISSION);

    new idDoor;
    new option[8];

    if (sscanf(params, "ds[8]", idDoor, option))
        return SendInfo(playerid, "Uso: /irpuerta [id] [entrada/salida]");

    if (!DoorInfo[idDoor][doorcreated])
        return SendError(playerid, "La puerta especificada no existe.");

    if (!strcmp(option, "entrada", true))
    {
        SetPlayerPosEx(
            playerid,
            DoorInfo[idDoor][doorentracex],
            DoorInfo[idDoor][doorentracey],
            DoorInfo[idDoor][doorentracez],
            DoorInfo[idDoor][doorentracea],
            DoorInfo[idDoor][doorentraceinterior],
            DoorInfo[idDoor][doorentracevirtualworld]
        );
    }
    else if (!strcmp(option, "salida", true))
    {
        SetPlayerPosEx(
            playerid,
            DoorInfo[idDoor][doorexitx],
            DoorInfo[idDoor][doorexity],
            DoorInfo[idDoor][doorexitz],
            DoorInfo[idDoor][doorexita],
            DoorInfo[idDoor][doorexitinterior],
            DoorInfo[idDoor][doorexitvirtualworld]
        );
    }
    else
    {
        return SendError(playerid, "Opción inválida: usa entrada o salida.");
    }

    format(stringBuffer, sizeof stringBuffer, "Teletransportado a la %s de la puerta %d (%s).", option, idDoor, DoorInfo[idDoor][doorname]);
    SendInfo(playerid, stringBuffer);
    return 1;
}