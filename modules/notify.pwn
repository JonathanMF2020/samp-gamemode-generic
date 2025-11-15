new PlayerText:NotifTD[MAX_PLAYERS][4];
new NotifTimer[MAX_PLAYERS];

stock CreateTextDrawnNotifier(playerid){
    NotifTD[playerid][0] = CreatePlayerTextDraw(playerid, 557.000, 286.000, "_");
    PlayerTextDrawLetterSize(playerid, NotifTD[playerid][0], 0.219, 4.000);
    PlayerTextDrawTextSize(playerid, NotifTD[playerid][0], 0.000, 165.000);
    PlayerTextDrawAlignment(playerid, NotifTD[playerid][0], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, NotifTD[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, NotifTD[playerid][0], true);
    PlayerTextDrawBoxColour(playerid, NotifTD[playerid][0], 150);
    PlayerTextDrawSetShadow(playerid, NotifTD[playerid][0], 1);
    PlayerTextDrawSetOutline(playerid, NotifTD[playerid][0], 1);
    PlayerTextDrawBackgroundColour(playerid, NotifTD[playerid][0], 150);
    PlayerTextDrawFont(playerid, NotifTD[playerid][0], TEXT_DRAW_FONT_1);
    PlayerTextDrawSetProportional(playerid, NotifTD[playerid][0], true);

    NotifTD[playerid][1] = CreatePlayerTextDraw(playerid, 476.000, 286.000, "_");
    PlayerTextDrawLetterSize(playerid, NotifTD[playerid][1], 0.219, 4.000);
    PlayerTextDrawTextSize(playerid, NotifTD[playerid][1], 0.000, 3.000);
    PlayerTextDrawAlignment(playerid, NotifTD[playerid][1], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, NotifTD[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, NotifTD[playerid][1], true);
    PlayerTextDrawBoxColour(playerid, NotifTD[playerid][1], 1097458175);
    PlayerTextDrawSetShadow(playerid, NotifTD[playerid][1], 1);
    PlayerTextDrawSetOutline(playerid, NotifTD[playerid][1], 1);
    PlayerTextDrawBackgroundColour(playerid, NotifTD[playerid][1], 1687547391);
    PlayerTextDrawFont(playerid, NotifTD[playerid][1], TEXT_DRAW_FONT_1);
    PlayerTextDrawSetProportional(playerid, NotifTD[playerid][1], true);

    NotifTD[playerid][2] = CreatePlayerTextDraw(playerid, 489.000, 295.000, "HUD:radar_emmetGun");
    PlayerTextDrawTextSize(playerid, NotifTD[playerid][2], 12.000, 14.000);
    PlayerTextDrawAlignment(playerid, NotifTD[playerid][2], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, NotifTD[playerid][2], -1);
    PlayerTextDrawSetShadow(playerid, NotifTD[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, NotifTD[playerid][2], 0);
    PlayerTextDrawBackgroundColour(playerid, NotifTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, NotifTD[playerid][2], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawSetProportional(playerid, NotifTD[playerid][2], true);

    NotifTD[playerid][3] = CreatePlayerTextDraw(playerid, 507.000, 292.000, "Aqui va un texto demasiado largo o tal vez no");
    PlayerTextDrawLetterSize(playerid, NotifTD[playerid][3], 0.319, 0.899);
    PlayerTextDrawTextSize(playerid, NotifTD[playerid][3], 644.000, 1060.000);
    PlayerTextDrawAlignment(playerid, NotifTD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, NotifTD[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, NotifTD[playerid][3], 1);
    PlayerTextDrawSetOutline(playerid, NotifTD[playerid][3], 1);
    PlayerTextDrawBackgroundColour(playerid, NotifTD[playerid][3], 150);
    PlayerTextDrawFont(playerid, NotifTD[playerid][3], TEXT_DRAW_FONT_1);
    PlayerTextDrawSetProportional(playerid, NotifTD[playerid][3], true);
}

stock ShowNotification(playerid, const text[], type = NOTIFICATION_INFO, bool: isTimer = false)
{
    new barColor;

    switch(type)
    {
        case NOTIFICATION_INFO:
        {
            barColor = 0x1E90FFFF;
            PlayerTextDrawSetString(playerid, NotifTD[playerid][2], "HUD:radar_light");
        }
        case NOTIFICATION_ERROR:
        {
            barColor = 0xFF0000FF; 
            PlayerTextDrawSetString(playerid, NotifTD[playerid][2], "HUD:radar_fire");
        }
        case NOTIFICATION_SUCCESS:
        {
            barColor = 0x00FF00FF; 
            PlayerTextDrawSetString(playerid, NotifTD[playerid][2], "HUD:radar_light");
        }
    }

    PlayerTextDrawBoxColour(playerid, NotifTD[playerid][1], barColor);

    PlayerTextDrawSetString(playerid, NotifTD[playerid][3], text);

    for(new i = 0; i < 4; i++)
        PlayerTextDrawShow(playerid, NotifTD[playerid][i]);

    if(isTimer){
        if(NotifTimer[playerid]) KillTimer(NotifTimer[playerid]);
        NotifTimer[playerid] = SetTimerEx("EndNotification", NOTIF_DURATION, false, "i", playerid);
    }
}

stock HideNotification(playerid)
{
    for(new i = 0; i < 4; i++)
        PlayerTextDrawHide(playerid, NotifTD[playerid][i]);
}

function EndNotification(playerid)
{
    HideNotification(playerid);
    NotifTimer[playerid] = 0;
    return 1;
}

stock DestroyNotificationTD(playerid)
{
    for(new i = 0; i < 4; i++)
    {
        if(NotifTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(playerid, NotifTD[playerid][i]);
            NotifTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }

    // Por si un timer quedó vivo
    if(NotifTimer[playerid])
    {
        KillTimer(NotifTimer[playerid]);
        NotifTimer[playerid] = 0;
    }
}