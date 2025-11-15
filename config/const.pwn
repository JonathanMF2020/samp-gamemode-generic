#define WHITE               "{FFFFFF}"
#define PRIMARY             "{8EE7FF}"
#define ERROR               "{FF3B30}"
#define INFO                "{C8C8C8}"
#define COMMANDBOLD         "{00FFFF}"
#define STAFF               "{3B82F6}"
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
#define TABLE_DOORS         "doors"
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
#define NOTIF_DURATION 3000
#define LOADING_DURATION 3000

#define RANGE_DOOR 5.0

#define MAX_DOORS           50

#define ADMIN_LOG_PATH "logs/commands/"
#define MAX_LOG_LENGTH 256
#define MAX_PATH 256
#define MAX_DYNAMIC_AREAS 5000



#define NO_PERMISSION "No tienes permiso para usar este comando"

enum {
    AREA_NONE = 0,
    AREA_DOOR_ENTRACE,
    AREA_DOOR_EXIT,
};

enum E_AREA_DATA {
    area_type,
    area_ownerid 
};
new AreaData[MAX_DYNAMIC_AREAS][E_AREA_DATA];

enum{
    DIALOG_REGISTER,
    DIALOG_LOGIN,
    DIALOG_EDIT_DOOR,
    DIALOG_EDIT_DOOR_NAME,
    DIALOG_EDIT_DOOR_ENTRACE_VIRTUAL,
    DIALOG_EDIT_DOOR_ENTRACE_INTERIOR,
    DIALOG_EDIT_DOOR_EXIT_VIRTUAL,
    DIALOG_EDIT_DOOR_EXIT_INTERIOR,
    DIALOG_EDIT_DOOR_PICKUP,
    DIALOG_EDIT_KEYS,
    DIALOG_EDIT_KEYS_EDIT,
}

enum{
    NOTIFICATION_INFO = 1,
    NOTIFICATION_ERROR,
    NOTIFICATION_SUCCESS,
}

enum
{
    CMD_COMMON_USER,   // 0  (nivel más bajo)
    CMD_HELPER,        // 1
    CMD_MODER_1,       // 2
    CMD_MODER_2,       // 3
    CMD_MODER_3,       // 4
    CMD_MODER_G,       // 5
    CMD_ADMIN          // 6 (nivel más alto)
};


enum{
    INTERACTION_KEY_UNDEFINED,
    INTERACTION_KEY_YES,
    INTERACTION_KEY_NO,
    INTERACTION_KEY_ENTER
};

enum{
    KEYS_DOOR
}

new MySQL:database;
new stringScapeDatabase[512];
new stringBuffer[128];