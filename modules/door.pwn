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
  //ShowPlayerConfirmBox(playerid, DeagleBox, "Are you sure you want to get a Desert Eagle?", "Desert Eagle"); https://github.com/denisbranisteanu/samp-confirm-box
}

function OnPlayerExitDoor(playerid, doorId)
{

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