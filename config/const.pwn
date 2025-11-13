#define WHITE               "{FFFFFF}"
#define PRIMARY             "{8EE7FF}"
#define ERROR               "{FF3B30}"
#define INFO                "{C8C8C8}"
#define COMMANDBOLD         "{00FFFF}"
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
#define TABLE_SERVER        "server"
//General
#define HASH_SUCCESS        1
#define HASH_ERROR          0
#define HASH_UNKNOW         -1
#define SPAWN_X             1548.5100
#define SPAWN_Y             -1687.1600
#define SPAWN_Z             13.5900
#define SPAWN_A             90.0000
#define SPAWN_INTERIOR      0
#define SPAWN_VIRTUAL       0
#define SERVER_STATUS_SUCCESS    1
#define SERVER_STATUS_ERROR      2
#define SERVER_STATUS_UNKNOWN    0




enum{
    DIALOG_REGISTER,
    DIALOG_LOGIN
}

enum (<<= 1)
{
  CMD_ADMIN = 1, 
  CMD_MODER_G,     // 0b00000000000000000000000000000010
  CMD_MODER_3,   // 0b00000000000000000000000000000100
  CMD_MODER_2,   // 0b00000000000000000000000000000100
  CMD_MODER_1,   // 0b00000000000000000000000000000100
  CMD_HELPER,
  CMD_COMMON_USER  // 0b00000000000000000000000000000100
};
new AdminPermissions[MAX_PLAYERS];

new MySQL:database;
new stringScapeDatabase[512];
new stringBuffer[128];