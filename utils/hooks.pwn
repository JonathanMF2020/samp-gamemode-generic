

public OnGameModeInit(){
    ConnectServer();
    return 1;
}

public OnPlayerConnect(playerid){
    format(UserInfo[playerid][username], MAX_PLAYER_NAME+1, "%s", GetPlayerNameEx(playerid));
    CheckRegister(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
    {
        case  DIALOG_REGISTER:{
            print("Hola mundo");
            return 1;
        }
        default: SendClientMessage(playerid, -1, "Error");
        
    }

    return 0; // Return 0 for unhandled dialogs.
}