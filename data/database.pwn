enum USER_ENUM{
    id,
    username[MAX_PLAYER_NAME],
};
new UserInfo[MAX_PLAYERS][USER_ENUM];

stock CleanUser(playerid){
    UserInfo[playerid][id] = -1;
    MemSet(UserInfo[playerid][username], 0, MAX_PLAYER_NAME);
}