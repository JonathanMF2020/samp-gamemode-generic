stock LoadServer(){
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, "SELECT hostname, version FROM `%s` WHERE `id` = '1' LIMIT 1", TABLE_SERVER);
    mysql_tquery(database, stringScapeDatabase, "MYSQL_IsServer");
}

function MYSQL_IsServer(){
    new rows = 0;
    cache_get_row_count(rows);
    if(rows > 0){
        cache_get_value_name(0, "hostname", ServerInfo[hostname], 45);
        cache_get_value_name(0, "version", ServerInfo[version], 20);
        print("[Server] Servidor cargado exitosamente");
        ServerInfo[status] = SERVER_STATUS_SUCCESS;
        SetServerInfo();
    }else{
        ServerInfo[status] = SERVER_STATUS_ERROR;
        print("[Server] Ha ocurrido un error al cargar el servidor");
        KickAll();
    }
}

stock SetServerInfo(){
    SendRconCommand("name %s V%s", ServerInfo[hostname], ServerInfo[version]);
}