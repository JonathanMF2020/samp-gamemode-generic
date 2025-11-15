enum USER_ENUM{
    id,
    username[MAX_PLAYER_NAME],
    Float:x,
    Float:y,
    Float:z,
    Float:a,
    sampInterior,
    sampVirtual,
    createdAt[45],
    lastAt[45],
    lastVersion[20],
    admin,
    keydoor,
};
new UserInfo[MAX_PLAYERS][USER_ENUM];

stock CleanUser(playerid){
    UserInfo[playerid][id] = -1;
    MemSet(UserInfo[playerid][username], 0, MAX_PLAYER_NAME);
    MemSet(UserInfo[playerid][createdAt], 0, 45);
    MemSet(UserInfo[playerid][lastAt], 0, 45);
    MemSet(UserInfo[playerid][lastVersion], 0, 20);
    UserInfo[playerid][x] = 0.000000;
    UserInfo[playerid][y] = 0.000000;
    UserInfo[playerid][z] = 0.000000;
    UserInfo[playerid][a] = 0.000000;
    UserInfo[playerid][sampInterior] = -1;
    UserInfo[playerid][sampVirtual] = -1;
    UserInfo[playerid][admin] = 0;
    UserInfo[playerid][keydoor] = 0;
    DeletePVar(playerid, T_CONNECTED);
}

enum SERVER_ENUM{
    hostname[45],
    version[20],
    owner[MAX_PLAYER_NAME],
    status,
    doorLength
};
new ServerInfo[SERVER_ENUM];

stock CleanServer(){
    MemSet(ServerInfo[hostname], 0, 45);
    MemSet(ServerInfo[version], 0, 20);
    MemSet(ServerInfo[owner], 0, 24);
    ServerInfo[version] = SERVER_STATUS_UNKNOWN;
}

enum DOOR_ENUM{
    doorid,
    doorname[45],
    doorpickupid,
    doorpickupentrace,
    doorpickupexit,
    Float:doorentracex,
    Float:doorentracey,
    Float:doorentracez,
    Float:doorentracea,
    doorentraceinterior,
    doorentracevirtualworld,
    Float:doorexitx,
    Float:doorexity,
    Float:doorexitz,
    Float:doorexita,
    doorexitinterior,
    doorexitvirtualworld,
    doorlock,
    bool:doorcreated,
    doorareaentrace,
    doorareaexit
};
new DoorInfo[MAX_DOORS][DOOR_ENUM];

stock CleanDoor(i){
    MemSet(DoorInfo[i][doorname], 0, 45);
    DoorInfo[i][doorid] = 0;
    DoorInfo[i][doorpickupid] = 0;
    DestroyDynamicArea(DoorInfo[i][doorareaentrace]);
    DestroyDynamicArea(DoorInfo[i][doorareaexit]);
    DestroyDynamicPickup(DoorInfo[i][doorpickupentrace]);
    DestroyDynamicPickup(DoorInfo[i][doorpickupexit]);
    DoorInfo[i][doorentracex] = 0.0;
    DoorInfo[i][doorentracey] = 0.0;
    DoorInfo[i][doorentracez] = 0.0;
    DoorInfo[i][doorentracea] = 0.0;
    DoorInfo[i][doorentraceinterior] = 0;
    DoorInfo[i][doorentracevirtualworld] = 0;
    DoorInfo[i][doorexitx] = 0.0;
    DoorInfo[i][doorexity] = 0.0;
    DoorInfo[i][doorexitz] = 0.0;
    DoorInfo[i][doorexita] = 0.0;
    DoorInfo[i][doorexitinterior] = 0;
    DoorInfo[i][doorexitvirtualworld] = 0;
    DoorInfo[i][doorlock] = 0;
    DoorInfo[i][doorcreated] = false;
}