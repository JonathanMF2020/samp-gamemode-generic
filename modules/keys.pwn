forward KEY:GetKey(value, action);

stock KEY:GetKey(value, action)
{
    new KEY:keyReturn;

    switch (value)
    {
        case INTERACTION_KEY_UNDEFINED:
        {
            if(action == KEYS_DOOR)
                keyReturn = KEY_SECONDARY_ATTACK;
        }
        case INTERACTION_KEY_YES: keyReturn = KEY_YES;
        case INTERACTION_KEY_NO: keyReturn = KEY_NO;
        case INTERACTION_KEY_ENTER: keyReturn = KEY_SECONDARY_ATTACK;
    }
    return keyReturn;
}

stock GetNameKey(value, action){
    new keyname[24];
    switch (value)
    {
        case INTERACTION_KEY_UNDEFINED:
        {
            if(action == KEYS_DOOR)
                format(keyname, sizeof keyname, "Enter");
        }
        case INTERACTION_KEY_YES: format(keyname, sizeof keyname, "Y");
        case INTERACTION_KEY_NO: format(keyname, sizeof keyname, "N");
        case INTERACTION_KEY_ENTER:format(keyname, sizeof keyname, "Enter");
    }
    return keyname;
}

stock KEY:GetParseKey(playerid, action)
{
    switch (action)
    {
        case KEYS_DOOR:
        {
            return GetKey(UserInfo[playerid][keydoor], action);
        }
    }
    return GetKey(INTERACTION_KEY_UNDEFINED, action);
}