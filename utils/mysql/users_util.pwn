stock CheckRegister(playerid){
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, "SELECT id, password FROM `%s` WHERE `username` = '%s'", TABLE_USERS, UserInfo[playerid][username]);
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
    mysql_format(database, stringScapeDatabase, sizeof stringScapeDatabase,
    "INSERT INTO `%s` (`username`, `password`) VALUES ('%s', '%s')",
    TABLE_USERS, UserInfo[playerid][username], hash);
    mysql_tquery(database, stringScapeDatabase, "OnPlayerRegister", "d", playerid);
}

function OnPlayerRegister(playerid){
    UserInfo[playerid][id] = cache_insert_id();
    SetSpawnInfo(playerid, NO_TEAM, 0, 1958.33, 1343.12, 15.36, 269.15, WEAPON_SAWEDOFF, 36, WEAPON_UZI, 150, WEAPON_FIST, 0);
    SpawnPlayer(playerid);
}

 function OnPassswordVerify(playerid, bool:success)
 {	
 	if (success)
 	{
        DeletePVar(playerid, T_PASSWORD);
 		SetSpawnInfo(playerid, NO_TEAM, 0, 1958.33, 1343.12, 15.36, 269.15, WEAPON_SAWEDOFF, 36, WEAPON_UZI, 150, WEAPON_FIST, 0);
        SpawnPlayer(playerid);
 	} 
 	else
 	{
 		SendError(playerid, "Contraseña incorrecta, vuelve a intentarlo");
        ShowDialog(playerid, DIALOG_LOGIN);
 	}
    return 1;
 }