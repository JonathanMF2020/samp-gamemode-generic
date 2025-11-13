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
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_PASSWORD, WHITE"Registro", WHITE"Parece que aun no tienes una cuenta\n\n Ingresa una contraseña para registrarte en "PRIMARY SERVER_NAME WHITE, "Aceptar", "Cancelar");

        }
        case DIALOG_LOGIN:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_PASSWORD, WHITE"Login", WHITE"Ingresa una contraseña para ingresar a "PRIMARY SERVER_NAME WHITE, "Aceptar", "Cancelar");
        }
        default: SendError(playerid, "Code 01: Ha ocurrido un error intenta mas tarde");
    }
}

stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock IsStringLengthValid(const text[], minLen, maxLen)
{
    new length = strlen(text);
    if (length < minLen || length > maxLen) return false;

    for (new i = 0; i < length; i++)
    {
        if (text[i] != ' ' && text[i] != '\t')
            return true;
    }
    return false;
}

stock SendError(playerid, const text[]){
    new string[128];
    format(string, sizeof string, ERROR"[Error]"WHITE" %s", text);
    return SendClientMessage(playerid, -1, string);
}
