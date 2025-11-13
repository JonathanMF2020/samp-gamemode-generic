/*
 Only functions that will be reused throughout the project will live here, only ‘stock’ type functions.
*/
stock CountChars(const string[], const ch[2]) {
    new i, found;
    while(string[i] != EOS) {
        if(string[i] == ch[0]) {
            found++;
        }
        i++;
    }
    return found;
}

stock CalculateMs(tickStart, tickEnd){
    return tickEnd - tickStart;
}


stock ShowDialog(playerid, dialogid){
    switch(dialogid){
        case DIALOG_REGISTER:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, WHITE"Registro", WHITE"Parece que aun no tienes una cuenta\n\n ¿Deseas registrarte en "PRIMARY SERVER_NAME WHITE, "Yes", "No");

        }
        default: SendClientMessage(playerid, -1, "Error");
    }
}

stock TQuery(MySQL:handle, const query[], const callback[] = "", const format[] = "", {Float,_}:...)
{
    #if MYSQL_DEBUG
        printf("[Database - Debug] Execute: %s", query);
    #endif

    if (format[0])
    {
        mysql_tquery(handle, query, callback, format, va_start<5>);
    }
    else
    {
        mysql_tquery(handle, query, callback);
    }
}


stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}