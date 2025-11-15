new timerOneMinute[MAX_PLAYERS];

CreateTimerOneMinute(playerid)
{
   timerOneMinute[playerid] = SetPreciseTimer("TimerOneMinute", ONE_MINUTE, true, "d",playerid);
}

DestroyTimerOneMinute(playerid)
{
    DeletePreciseTimer(timerOneMinute[playerid]);
}

RestartTimerOneMinute(playerid)
{
    ResetPreciseTimer(timerOneMinute[playerid], ONE_MINUTE, true);
}

function TimerOneMinute(playerid)
{
    if (UserInfo[playerid][expminutes] < 60){
        HandlerForLevel(playerid);
    }
    return 1;
}