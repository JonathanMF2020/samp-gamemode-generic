
stock LoadDoors(){
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, 
    "SELECT id, name, pickupid, entracex, entracey, entracez, entracea, entraceinterior, entracevirtualworld, exitx, exity, exitz, exita, exitinterior, exitvirtualworld, lockDoor \
    FROM `%s`", TABLE_DOORS);
    mysql_tquery(database, stringScapeDatabase, "MYSQL_IsDoor");
}

stock InsertDoor(doorId){
    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase,
        "INSERT INTO `%s` \
        (`name`, `pickupid`, `entracex`, `entracey`, `entracez`, `entracea`, `entraceinterior`, `entracevirtualworld`, \
        `exitx`, `exity`, `exitz`, `exita`, `exitinterior`, `exitvirtualworld`, `lockDoor`) \
        VALUES ('%s', %d, %f, %f, %f, %f, %d, %d, %f, %f, %f, %f, %d, %d, %d)",
        TABLE_DOORS,
        DoorInfo[doorId][doorname],
        DoorInfo[doorId][doorpickupid],
        DoorInfo[doorId][doorentracex],
        DoorInfo[doorId][doorentracey],
        DoorInfo[doorId][doorentracez],
        DoorInfo[doorId][doorentracea],
        DoorInfo[doorId][doorentraceinterior],
        DoorInfo[doorId][doorentracevirtualworld],
        DoorInfo[doorId][doorexitx],
        DoorInfo[doorId][doorexity],
        DoorInfo[doorId][doorexitz],
        DoorInfo[doorId][doorexita],
        DoorInfo[doorId][doorexitinterior],
        DoorInfo[doorId][doorexitvirtualworld],
        DoorInfo[doorId][doorlock]
    );
    mysql_tquery(database, stringScapeDatabase, "OnDoorRegistered", "d", doorId);
}

stock DeleteDoor(doorId)
{
    if (DoorInfo[doorId][doorcreated] == false) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase,
        "DELETE FROM `%s` WHERE `id` = %d LIMIT 1",
        TABLE_DOORS,
        DoorInfo[doorId][doorid]
    );

    mysql_tquery(database, stringScapeDatabase, "OnDoorDeleted", "d", doorId);
    return 1;
}

function OnDoorDeleted(doorId){
    DeleteDoorE(doorId);
}

stock UpdateDoorInt(doorId, const fieldName[], value)
{
    if (DoorInfo[doorId][doorcreated] == false) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase, 
        "UPDATE `%s` SET `%s` = %d WHERE `id` = %d LIMIT 1",
        TABLE_DOORS, fieldName, value, DoorInfo[doorId][doorid]);

    mysql_tquery(database, stringScapeDatabase);
    return 1;
}

stock UpdateDoorString(doorId, const fieldName[], const value[])
{
    if (DoorInfo[doorId][doorcreated] == false) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase, 
        "UPDATE `%s` SET `%s` = '%e' WHERE `id` = %d LIMIT 1",
        TABLE_DOORS, fieldName, value, DoorInfo[doorId][doorid]);

    mysql_tquery(database, stringScapeDatabase);
    return 1;
}

stock UpdateDoorFloat(doorId, const fieldName[], Float:value)
{
    if (DoorInfo[doorId][doorcreated] == false) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase, 
        "UPDATE `%s` SET `%s` = %f WHERE `id` = %d LIMIT 1",
        TABLE_DOORS, fieldName, value, DoorInfo[doorId][doorid]);

    mysql_tquery(database, stringScapeDatabase);
    return 1;
}

function OnDoorRegistered(doorId){
    DoorInfo[doorId][doorid] = cache_insert_id();
    ServerInfo[doorLength]++;
}

function MYSQL_IsDoor(){
    new tickStart = GetTickCount();
    ServerInfo[doorLength] = 0;
    new rows = 0;
    cache_get_row_count(rows);
    if(rows > 0){
        // Esta línea asegura que el número de elementos a cargar (max_to_load)
        // nunca exceda el tamaño máximo de tu array (MAX_DOORS).
        new max_to_load = (rows > MAX_DOORS) ? (MAX_DOORS) : (rows);

        for (new i = 0; i < max_to_load; i++)
        {
            cache_get_value_name_int(i, "id", DoorInfo[i][doorid]);
            cache_get_value_name(i, "name", DoorInfo[i][doorname], 45);
            cache_get_value_name_int(i, "pickupid", DoorInfo[i][doorpickupid]);
            cache_get_value_name_float(i, "entracex", DoorInfo[i][doorentracex]);
            cache_get_value_name_float(i, "entracey", DoorInfo[i][doorentracey]);
            cache_get_value_name_float(i, "entracez", DoorInfo[i][doorentracez]);
            cache_get_value_name_float(i, "entracea", DoorInfo[i][doorentracea]);
            cache_get_value_name_int(i, "entraceinterior", DoorInfo[i][doorentraceinterior]);
            cache_get_value_name_int(i, "entracevirtualworld", DoorInfo[i][doorentracevirtualworld]);
            cache_get_value_name_float(i, "exitx", DoorInfo[i][doorexitx]);
            cache_get_value_name_float(i, "exity", DoorInfo[i][doorexity]);
            cache_get_value_name_float(i, "exitz", DoorInfo[i][doorexitz]);
            cache_get_value_name_float(i, "exita", DoorInfo[i][doorexita]);
            cache_get_value_name_int(i, "exitinterior", DoorInfo[i][doorexitinterior]);
            cache_get_value_name_int(i, "exitvirtualworld", DoorInfo[i][doorexitvirtualworld]);
            cache_get_value_name_int(i, "lock", DoorInfo[i][doorlock]);
            DoorInfo[i][doorcreated] = true;
            UpdateClientDoor(i);
        }
        ServerInfo[doorLength] = max_to_load;
        new tickEnd = GetTickCount();
        printf("[Server] Doors cargado exitosamente: %d(%d segundos)", ServerInfo[doorLength], CalculateMs(tickStart,tickEnd));
        if (rows > MAX_DOORS) {
            printf("[WARNING] Se encontraron %d puertas, pero solo se pudieron cargar %d (MAX_DOORS). Aumenta MAX_DOORS.", rows, MAX_DOORS);
        }
    }else{
        print("[Server] Sin doors encontradas");
    }
}