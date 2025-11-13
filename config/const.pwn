#define WHITE               "{FFFFFF}"
#define PRIMARY             "{8EE7FF}"
#define ERROR               "{FF3B30}"
// Mysql Credentials
#define MYSQL_DEBUG         true
#define MYSQL_HOST          "localhost"
#define MYSQL_USER          "root"
#define MYSQL_PASWORD       "root"
#define MYSQL_DATABASE      "samp"
// Server Config
#define SERVER_NAME         "Aknolwedge Roleplay"
// Db tables
#define TABLE_USERS         "users"
//General
#define HASH_SUCCESS        1
#define HASH_ERROR          0
#define HASH_UNKNOW         -1



enum{
    DIALOG_REGISTER,
    DIALOG_LOGIN
}

new MySQL:database;
new stringScapeDatabase[256];