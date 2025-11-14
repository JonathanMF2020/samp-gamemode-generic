

public OnGameModeInit(){
    ConnectServer();
    LoadServer();
    return 1;
}

public OnGameModeExit(){
    foreach (new playerid : Player){
        CleanUser(playerid);
    }
    CleanServer();
    DisconnectServer();
    return 1;
}

public OnPlayerConnect(playerid){
    if(ServerInfo[status] == SERVER_STATUS_ERROR){
        return SendError(playerid,"Servidor en mantenimiento");
    }
    format(UserInfo[playerid][username], MAX_PLAYER_NAME+1, "%s", GetPlayerNameEx(playerid));
    CheckRegister(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason){
    if(GetPVarInt(playerid,T_CONNECTED) == 1){
        SaveAccount(playerid);
    }
    
    CleanUser(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
    {
        case  DIALOG_REGISTER:{
            if(response){
                if(IsStringLengthValid(inputtext, 3, 30)){
                    RegisterUser(playerid, inputtext);
                }else{
                    ShowDialog(playerid, dialogid);
                    return SendError(playerid, "La longitud del texto debe ser entre 3 y 30 caracteres");
                }
            }else{
                Kick(playerid);
            }
            return 1;
        }
        case DIALOG_LOGIN:{
            if(!response) return Kick(playerid);
            if(!IsStringLengthValid(inputtext, 3, 30)){
                ShowDialog(playerid, dialogid);
                return SendError(playerid, "La longitud del texto debe ser entre 3 y 30 caracteres");
            }
            new hash[BCRYPT_HASH_LENGTH];
            GetPVarString(playerid, T_PASSWORD, hash, sizeof(hash));
            bcrypt_verify(playerid, "OnPassswordVerify", inputtext, hash);
            return 1;
        }
        case DIALOG_EDIT_DOOR:{
            if(!response) return 1;
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
        }
        default: {
            SendError(playerid, "Code 01: Ha ocurrido un error intenta mas tarde");
            return Kick(playerid);
        }
        
    }
    return 0;
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
