

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
    SaveAccount(playerid);
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
        }
        default: {
            SendError(playerid, "Code 01: Ha ocurrido un error intenta mas tarde");
            return Kick(playerid);
        }
        
    }
    return 0;
}