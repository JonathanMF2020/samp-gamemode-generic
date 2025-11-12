function ConnectServer(){
    new tickStart = GetTickCount();
    database = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASWORD, MYSQL_DATABASE);
    new tickEnd = GetTickCount();
    new errno = mysql_errno(database);
    if (errno != 0) 
    {
        new error[100];

        mysql_error(error, sizeof (error), database);
        printf("[Database] #%d '%s' DATA: %s, %s, %s, %s", errno, error,MYSQL_HOST,MYSQL_USER, MYSQL_PASWORD , MYSQL_DATABASE);
    }else{
        printf("[Database] Connected: %d ms", CalculateMs(tickStart,tickEnd));

    }

    
    
    return 1;
}
