stock CheckRegister(playerid){
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, "SELECT id, password FROM `%s` WHERE `username` = '%s' LIMIT 1", TABLE_USERS, UserInfo[playerid][username]);
    mysql_tquery(database, stringScapeDatabase, "MYSQL_IsRegister", "d", playerid);
}

function MYSQL_IsRegister(playerid){
    new rows = 0;
    cache_get_row_count(rows);
    if(rows == 0){
        ShowDialog(playerid, DIALOG_REGISTER);
    }else{
        new hash[BCRYPT_HASH_LENGTH];
        cache_get_value_name(0, "password", hash, sizeof(hash));
        SetPVarString(playerid, T_PASSWORD, hash);
        cache_get_value_int(0, "id", UserInfo[playerid][id]);
        ShowDialog(playerid, DIALOG_LOGIN);
    }
}

stock RegisterUser(playerid, const password[])
{
    bcrypt_hash(playerid, "OnHashDone_Register", password, BCRYPT_COST);
    return 1;
}

function OnHashDone_Register(playerid){
    new hash[BCRYPT_HASH_LENGTH];
 	bcrypt_get_hash(hash);
    UserInfo[playerid][x] = SPAWN_X;
    UserInfo[playerid][y] = SPAWN_Y;
    UserInfo[playerid][z] = SPAWN_Z;
    UserInfo[playerid][a] = SPAWN_A;
    UserInfo[playerid][sampVirtual] = SPAWN_VIRTUAL;
    UserInfo[playerid][sampInterior] = SPAWN_INTERIOR;
    FormatDateString(UserInfo[playerid][createdAt], 45);
    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase,
    "INSERT INTO `%s` (`username`, `password`, `x`, `y`, `z`, `a`, `sampVirtual`, `sampInterior`, `createdAt`) VALUES ('%s', '%s', '%f', '%f', '%f', '%f', '%d', '%d', '%s')",
    TABLE_USERS, UserInfo[playerid][username], hash,UserInfo[playerid][x],UserInfo[playerid][y],
    UserInfo[playerid][z],UserInfo[playerid][a],UserInfo[playerid][sampVirtual],UserInfo[playerid][sampInterior],
    UserInfo[playerid][createdAt]);
    mysql_tquery(database, stringScapeDatabase, "OnPlayerRegister", "d", playerid);
}

function OnPlayerRegister(playerid){
    ShowTextDrawnLoading(playerid);
    UserInfo[playerid][id] = cache_insert_id();
    UserInfo[playerid][admin] = CMD_COMMON_USER;
    UpdateAccountInt(playerid, "admin", UserInfo[playerid][admin]);
    SetPVarInt(playerid, T_CONNECTED, 1);
    SetSpawnInfo(playerid, NO_TEAM, 1, UserInfo[playerid][x], UserInfo[playerid][y], UserInfo[playerid][z], UserInfo[playerid][a], WEAPON_SAWEDOFF, 36, WEAPON_UZI, 150, WEAPON_FIST, 0);
    SpawnPlayer(playerid);
    SetTimerEx("HideTextDrawnLoading", LOADING_DURATION, false, "%d", playerid);
}

 function OnPassswordVerify(playerid, bool:success)
 {	
 	if (success)
 	{
        DeletePVar(playerid, T_PASSWORD);
        LoadAccount(playerid);
 	} 
 	else
 	{
 		SendError(playerid, "Contraseña incorrecta, vuelve a intentarlo");
        ShowDialog(playerid, DIALOG_LOGIN);
 	}
    return 1;
 }

 stock LoadAccount(playerid){
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, "SELECT x,y,z,a,sampInterior,sampVirtual,createdAt,lastAt,lastVersion,admin \
     FROM `%s` WHERE `id` = '%d' LIMIT 1", TABLE_USERS, UserInfo[playerid][id]);
    mysql_tquery(database, stringScapeDatabase, "MYSQL_IsLoading", "d", playerid);
 }

 function MYSQL_IsLoading(playerid){
    new rows = 0;
    cache_get_row_count(rows);
    if(rows > 0){
        cache_get_value_name_float(0, "x", UserInfo[playerid][x]);
        cache_get_value_name_float(0, "y", UserInfo[playerid][y]);
        cache_get_value_name_float(0, "z", UserInfo[playerid][z]);
        cache_get_value_name_float(0, "a", UserInfo[playerid][a]);
        cache_get_value_name_int(0, "sampInterior", UserInfo[playerid][sampInterior]);
        cache_get_value_name_int(0, "sampVirtual", UserInfo[playerid][sampVirtual]);
        cache_get_value_name(0, "createdAt", UserInfo[playerid][createdAt], 45);
        cache_get_value_name(0, "lastAt", UserInfo[playerid][lastAt], 45);
        cache_get_value_name(0, "lastVersion", UserInfo[playerid][lastVersion], 20);
        cache_get_value_name_int(0, "admin", UserInfo[playerid][admin]);
        SuccessLoadAccount(playerid);
        SetPVarInt(playerid, T_CONNECTED, 1);
    }else{
        SendError(playerid, "Ha ocurrido un error al intentar cargar los datos, intenta mas tarde");
        Kick(playerid);
    }
 }

function SaveAccount(playerid){
    GetPlayerPos(playerid,UserInfo[playerid][x], UserInfo[playerid][y], UserInfo[playerid][z]);
    GetPlayerFacingAngle(playerid,UserInfo[playerid][a]);
    UserInfo[playerid][sampInterior] = GetPlayerInterior(playerid);
    UserInfo[playerid][sampVirtual] = GetPlayerVirtualWorld(playerid);
    FormatDateString(UserInfo[playerid][lastAt], 45);
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, "UPDATE `%s` SET `x` = '%f', `y` = '%f', `z` = '%f', `a` = '%f', `sampInterior` = '%d', `sampVirtual` = '%d', `lastAt` = '%s', `lastVersion` = '%s' WHERE `id` = '%d' LIMIT 1", 
    TABLE_USERS, UserInfo[playerid][x], UserInfo[playerid][y], UserInfo[playerid][z], UserInfo[playerid][a], UserInfo[playerid][sampInterior], UserInfo[playerid][sampVirtual], UserInfo[playerid][lastAt],ServerInfo[version],UserInfo[playerid][id]);
    mysql_tquery(database, stringScapeDatabase);
}

stock UpdateAccountInt(playerid, const fieldName[], value)
{
    if (UserInfo[playerid][id] == 0) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase, 
        "UPDATE `%s` SET `%s` = '%d' WHERE `id` = '%d' LIMIT 1", 
        TABLE_USERS, fieldName, value, UserInfo[playerid][id]);

    mysql_tquery(database, stringScapeDatabase);

    return 1;
}

stock UpdateAccountString(playerid, const fieldName[], const value[])
{
    if (UserInfo[playerid][id] == 0) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase, 
        "UPDATE `%s` SET `%s` = '%s' WHERE `id` = '%d' LIMIT 1", 
        TABLE_USERS, fieldName, value, UserInfo[playerid][id]);

    mysql_tquery(database, stringScapeDatabase);

    return 1;
}

stock UpdateAccountFloat(playerid, const fieldName[], Float:value)
{
    if (UserInfo[playerid][id] == 0) return 0;

    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase, 
        "UPDATE `%s` SET `%s` = '%f' WHERE `id` = '%d' LIMIT 1", 
        TABLE_USERS, fieldName, value, UserInfo[playerid][id]);

    mysql_tquery(database, stringScapeDatabase);

    return 1;
}