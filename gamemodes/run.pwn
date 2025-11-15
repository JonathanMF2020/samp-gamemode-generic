#include <open.mp>

forward KEY:GetKey(value, action);
forward KEY:GetParseKey(playerid, action);

//Libs
#include <a_mysql>
#include <YSI/YSI_Coding/y_va>
#include <samp_bcrypt>
#include <YSI/YSI_Data/y_iterate>
#include <samp-precise-timers>
#include <Pawn.CMD>
#include <sscanf2>
#include <file>
#include <streamer>

// Configuration
#include "../config/const.pwn"
#include "../config/pvar.pwn"
#include "../config/macros.pwn"

//Enums
#include "../data/database.pwn"

// Utilities
#include "../utils/hooks.pwn"
#include "../utils/mysql/users_util.pwn"
#include "../utils/mysql/server_util.pwn"
#include "../utils/mysql/doors_util.pwn"
#include "../utils/util.pwn"
#include "../utils/dialog.pwn"

// Modules
#include "../modules/mysql.pwn"
#include "../modules/user.pwn"
#include "../modules/door.pwn"
#include "../modules/administration.pwn"
#include "../modules/area.pwn"
#include "../modules/notify.pwn"
#include "../modules/keys.pwn"
#include "../modules/timers.pwn"
#include "../modules/level.pwn"







main()
{
    print("----------------------------------\n");
    print(" Develop by: Flopjack");
    print("----------------------------------\n");
}