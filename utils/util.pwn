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
    new value = tickEnd - tickStart;
    if(value >= 30){
        print("[WARNING] Este calculo se ha demorado bastante, favor de optimizar esto");
    }
    return value;
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
    format(stringBuffer, sizeof stringBuffer, ERROR"[Error]"WHITE" %s", text);
    return SendClientMessage(playerid, -1, stringBuffer);
}

stock SendInfo(playerid, const text[]){
    format(stringBuffer, sizeof stringBuffer, INFO"[Info]"WHITE" %s", text);
    return SendClientMessage(playerid, -1, stringBuffer);
}


stock SendAdminChat(levelAdmin,const text[]){
    foreach (new i : Player){
        if(UserInfo[i][admin] >= levelAdmin){
            format(stringBuffer, sizeof stringBuffer, STAFF"[Staff]"WHITE" %s", text);
            SendClientMessage(i, -1, stringBuffer);
        }
    }
}



stock SetPlayerPosEx(playerid, Float: spawnx, Float: spawny, Float: spawnz, Float: spawna, interior = 0, virtualworld = 0){
    SetPlayerPos(playerid, spawnx, spawny, spawnz);
    SetPlayerFacingAngle(playerid, spawna);
    SetPlayerFacingAngle(playerid, interior); 
    SetPlayerInterior(playerid, virtualworld);
}

stock FormatDateString(output[], size)
{
    new year, month, day;
    new hour, minute, second;
    getdate(year, month, day); 
    gettime(hour, minute, second); 
    new const meses[13][] =
    {
        " ",          
        "Enero",      
        "Febrero",    
        "Marzo",      
        "Abril",      
        "Mayo",       
        "Junio",      
        "Julio",      
        "Agosto",     
        "Septiembre", 
        "Octubre",    
        "Noviembre",  
        "Diciembre"   
    };
    format(output, size, "%02d de %s del %d", day, meses[month], year);
    return 1;
}

stock KickAll(){
    foreach (new playerid : Player){
        Kick(playerid);
    }
}

stock LogAdminAction(const command_name[], admin_id, target_id, const details[])
{
    new 
        timestamp[40], // Para la fecha y hora: YYYY-MM-DD HH:MM:SS
        log_line[MAX_LOG_LENGTH], // Línea completa que se escribirá.
        file_path[MAX_PATH]; // Ruta completa del archivo de log.
    new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour, minute, second);
    format(timestamp, sizeof(timestamp), "[%04d-%02d-%02d %02d:%02d:%02d]", 
        year, month, day, hour, minute, second);
    new admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
    GetPlayerName(admin_id, admin_name, sizeof(admin_name));
    if(target_id != -1){
        GetPlayerName(target_id, target_name, sizeof(target_name));
        format(log_line, sizeof(log_line), "%s (ID:%d) %s %s -> %s (ID:%d) (Detalles: %s)\n",
            timestamp,
            admin_id, admin_name,
            command_name,
            target_name, target_id,
            details
        );
    }else{
        format(log_line, sizeof(log_line), "%s (ID:%d) %s %s -> (Detalles: %s)\n",
            timestamp,
            admin_id, admin_name,
            command_name,
            details
        );
    }
    
    format(file_path, sizeof(file_path), "%s%04d-%02d-%02d.log", ADMIN_LOG_PATH, year, month, day);
    new File:file = fopen(file_path, io_append);
    if (file)
    {
        fwrite(file, log_line);
        fclose(file);
        return 1; // Éxito
    }
    else
    {
        // Esto es un error CRÍTICO, deberías notificar al RCON o a un administrador principal.
        printf("[ERROR LOG] No se pudo abrir/crear el archivo de log: %s", file_path);
        return 0; // Error
    }
}