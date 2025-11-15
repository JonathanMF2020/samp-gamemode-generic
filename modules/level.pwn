GetExpForLevel(value){
    return 8*(2^(value - 1));
}

HandlerForLevel(playerid){
    UserInfo[playerid][expminutes]++;
    if (UserInfo[playerid][expminutes] >= 60){
        UserInfo[playerid][expminutes] = 0;
        if(ServerInfo[doblexp] == 1){
            UserInfo[playerid][exp] += 2;
        }else{
            UserInfo[playerid][exp]++;
        }
        
        format(stringBuffer, sizeof stringBuffer, LEVELCOLOR"%d/%d puntos de experiencia", UserInfo[playerid][exp], GetExpForLevel(UserInfo[playerid][level]));
        SendClientMessage(playerid, -1, stringBuffer);
        if(UserInfo[playerid][exp] >= GetExpForLevel(UserInfo[playerid][level])){
            UserInfo[playerid][exp] = 0;
            UserInfo[playerid][level]++;
            SetPlayerScore(playerid,UserInfo[playerid][level]);
            SendClientMessage(playerid, -1, LEVELCOLOR"Has alcanzado un nuevo nivel +1");
        }
    }
}