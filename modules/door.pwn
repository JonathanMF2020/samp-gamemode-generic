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
    format(stringBuffer,sizeof stringBuffer, "Para completar la puerta usa" COMMANDBOLD"/editarpuerta"WHITE" %d", idDoor);
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