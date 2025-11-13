stock CheckRegister(playerid){
    mysql_format(database,stringScapeDatabase, sizeof stringScapeDatabase, "SELECT id FROM %s WHERE username = '%s'", TABLE_USERS, UserInfo[playerid][username]);
    mysql_tquery(database, stringScapeDatabase, "MYSQL_IsRegister", "d", playerid);
}

forward public MYSQL_IsRegister(playerid);
public MYSQL_IsRegister(playerid){
    new rows = 0;
    cache_get_row_count(rows);
    if(rows == 0){
        ShowDialog(playerid, DIALOG_REGISTER);
    }else{  
        ShowDialog(playerid, DIALOG_LOGIN);
    }
}