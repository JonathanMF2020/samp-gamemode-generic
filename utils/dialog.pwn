public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
    {
        case  DIALOG_REGISTER:{
            if(response){
                if(IsStringLengthValid(inputtext, 3, 30)){
                    RegisterUser(playerid, inputtext);
                }else{
                    ShowDialog(playerid, dialogid);
                    return SendError(playerid, "La longitud del texto debe ser entre 3 y 30 caracteres");
                }
            }else{
                Kick(playerid);
            }
            return 1;
        }
        case DIALOG_LOGIN:{
            if(!response) return Kick(playerid);
            if(!IsStringLengthValid(inputtext, 3, 30)){
                ShowDialog(playerid, dialogid);
                return SendError(playerid, "La longitud del texto debe ser entre 3 y 30 caracteres");
            }
            new hash[BCRYPT_HASH_LENGTH];
            GetPVarString(playerid, T_PASSWORD, hash, sizeof(hash));
            bcrypt_verify(playerid, "OnPassswordVerify", inputtext, hash);
            return 1;
        }
        case DIALOG_EDIT_DOOR:{
            if(!response){
                DeletePVar(playerid, T_DOOR_ID);
                return 1;
            }
            switch(listitem){
                case 0: ShowDialog(playerid, DIALOG_EDIT_DOOR_NAME);
                case 1:{
                    new dooridS = GetPVarInt(playerid, T_DOOR_ID);
                    new Float:position[4];
                    GetPlayerPos(playerid,position[0],position[1],position[2]);
                    GetPlayerFacingAngle(playerid,position[3]);
                    DoorInfo[dooridS][doorentracex] = position[0];
                    DoorInfo[dooridS][doorentracey] = position[1];
                    DoorInfo[dooridS][doorentracez] = position[2];
                    DoorInfo[dooridS][doorentracea] = position[3];
                    SendInfo(playerid, "Se ha modificado la entrada de la puerta");
                    ShowDialog(playerid,DIALOG_EDIT_DOOR);
                    UpdateClientDoor(dooridS);
                }
                case 2: ShowDialog(playerid, DIALOG_EDIT_DOOR_ENTRACE_VIRTUAL);
                case 3: ShowDialog(playerid, DIALOG_EDIT_DOOR_ENTRACE_INTERIOR);
                case 4:{
                    new dooridS = GetPVarInt(playerid, T_DOOR_ID);
                    new Float:position[4];
                    GetPlayerPos(playerid,position[0],position[1],position[2]);
                    GetPlayerFacingAngle(playerid,position[3]);
                    DoorInfo[dooridS][doorexitx] = position[0];
                    DoorInfo[dooridS][doorexity] = position[1];
                    DoorInfo[dooridS][doorexitz] = position[2];
                    DoorInfo[dooridS][doorexita] = position[3];
                    SendInfo(playerid, "Se ha modificado la salida de la puerta");
                    ShowDialog(playerid,DIALOG_EDIT_DOOR);
                    UpdateClientDoor(dooridS);
                }
                case 5: ShowDialog(playerid, DIALOG_EDIT_DOOR_EXIT_VIRTUAL);
                case 6: ShowDialog(playerid, DIALOG_EDIT_DOOR_EXIT_INTERIOR);
                case 7:{
                    new dooridS = GetPVarInt(playerid, T_DOOR_ID);
                    DoorInfo[dooridS][doorlock] = !DoorInfo[dooridS][doorlock];
                    SendInfo(playerid, "Se ha modificado el seguro de la puerta");
                    ShowDialog(playerid,DIALOG_EDIT_DOOR);
                    UpdateClientDoor(dooridS);
                }
                case 8: ShowDialog(playerid, DIALOG_EDIT_DOOR_PICKUP);
                case 9:{
                    new dooridS = GetPVarInt(playerid, T_DOOR_ID);
                    format(stringBuffer,sizeof stringBuffer, "Ha eliminado la puerta: %s(%d)", DoorInfo[dooridS][doorname], dooridS);
                    LogAdminAction("/editarpuerta", playerid, -1, stringBuffer);
                    CleanDoor(dooridS);
                    SendInfo(playerid, "Se ha eliminado la puerta");
                    DeletePVar(playerid, T_DOOR_ID);
                    
                }
            }
            return 1;
        }
        case DIALOG_EDIT_DOOR_NAME:{
            if(!response || IsStringLengthValid(inputtext,1,45)){
                ShowDialog(playerid,DIALOG_EDIT_DOOR);
            }
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            format(DoorInfo[dooridS][doorname],45,"%s", inputtext);
            SendInfo(playerid, "Se ha modificado el nombre de la puerta");
            ShowDialog(playerid,DIALOG_EDIT_DOOR);
            return 1;
        }
        case DIALOG_EDIT_DOOR_ENTRACE_VIRTUAL:{
            if(!response || strval(inputtext) >= 0){
                ShowDialog(playerid,DIALOG_EDIT_DOOR);
            }
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            SendInfo(playerid, "Se ha modificado el virtualworld entrada de la puerta");
            DoorInfo[dooridS][doorentracevirtualworld] = strval(inputtext);
            ShowDialog(playerid,DIALOG_EDIT_DOOR);
            UpdateClientDoor(dooridS);
            return 1;
        }
        case DIALOG_EDIT_DOOR_ENTRACE_INTERIOR:{
            if(!response || strval(inputtext) >= 0){
                ShowDialog(playerid,DIALOG_EDIT_DOOR);
            }
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            SendInfo(playerid, "Se ha modificado el interior entrada de la puerta");
            DoorInfo[dooridS][doorentraceinterior] = strval(inputtext);
            ShowDialog(playerid,DIALOG_EDIT_DOOR);
            UpdateClientDoor(dooridS);
            return 1;
        }
        case DIALOG_EDIT_DOOR_EXIT_VIRTUAL:{
            if(!response || strval(inputtext) >= 0){
                ShowDialog(playerid,DIALOG_EDIT_DOOR);
            }
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            SendInfo(playerid, "Se ha modificado el virtualworld salida de la puerta");
            DoorInfo[dooridS][doorexitvirtualworld] = strval(inputtext);
            ShowDialog(playerid,DIALOG_EDIT_DOOR);
            UpdateClientDoor(dooridS);
            return 1;
        }
        case DIALOG_EDIT_DOOR_EXIT_INTERIOR:{
            if(!response || strval(inputtext) >= 0){
                ShowDialog(playerid,DIALOG_EDIT_DOOR);
            }
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            SendInfo(playerid, "Se ha modificado el interior salida de la puerta");
            DoorInfo[dooridS][doorexitinterior] = strval(inputtext);
            ShowDialog(playerid,DIALOG_EDIT_DOOR);
            UpdateClientDoor(dooridS);
            return 1;
        }
        case DIALOG_EDIT_DOOR_PICKUP:{
            if(!response || strval(inputtext) >= 0){
                ShowDialog(playerid,DIALOG_EDIT_DOOR);
            }
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            SendInfo(playerid, "Se ha modificado el pickup de la puerta");
            DoorInfo[dooridS][doorpickupid] = strval(inputtext);
            ShowDialog(playerid,DIALOG_EDIT_DOOR);
            UpdateClientDoor(dooridS);
        }
        default: {
            SendError(playerid, "Code 01: Ha ocurrido un error intenta mas tarde");
            return Kick(playerid);
        }
        
    }
    return 0;
}

stock ShowDialog(playerid, dialogid){
    switch(dialogid){
        case DIALOG_REGISTER:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_PASSWORD, WHITE"Registro", WHITE"Parece que aun no tienes una cuenta\n\n Ingresa una contraseña para registrarte en "PRIMARY SERVER_NAME WHITE, "Aceptar", "Cancelar");

        }
        case DIALOG_LOGIN:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_PASSWORD, WHITE"Login", WHITE"Ingresa una contraseña para ingresar a "PRIMARY SERVER_NAME WHITE, "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR:{
            new dooridS = GetPVarInt(playerid, T_DOOR_ID);
            new stringFormat[128];
            new stringFull[700];
            format(stringFormat, sizeof stringFormat, WHITE"Nombre: "COMMANDBOLD"%s(%d)"WHITE"\n", DoorInfo[dooridS][doorname], dooridS); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Entrada: "COMMANDBOLD"x: %f, y: %f, z: %f, angle: %f"WHITE"\n", DoorInfo[dooridS][doorentracex], DoorInfo[dooridS][doorentracey], DoorInfo[dooridS][doorentracez],DoorInfo[dooridS][doorexita]); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Entrada Virtual: "COMMANDBOLD"%d"WHITE"\n", DoorInfo[dooridS][doorentracevirtualworld]); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Entrada Interior: "COMMANDBOLD"%d"WHITE"\n", DoorInfo[dooridS][doorentraceinterior]); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Salida: "COMMANDBOLD"x: %f, y: %f, z: %f, angle: %f"WHITE"\n", DoorInfo[dooridS][doorexitx], DoorInfo[dooridS][doorexity], DoorInfo[dooridS][doorexitz],DoorInfo[dooridS][doorexita]); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Salida Virtual: "COMMANDBOLD"%d"WHITE"\n", DoorInfo[dooridS][doorexitvirtualworld]); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Salida Interior: "COMMANDBOLD"%d"WHITE"\n", DoorInfo[dooridS][doorexitinterior]); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Seguro: "COMMANDBOLD"%s"WHITE"\n",  DoorInfo[dooridS][doorlock] ? "Cerrado" : "Abierto"); 
            strcat(stringFull, stringFormat);
            format(stringFormat, sizeof stringFormat, WHITE"Pickupid: "COMMANDBOLD"%d"WHITE"\n",  DoorInfo[dooridS][doorpickupid]); 
            strcat(stringFull, stringFormat);
            strcat(stringFull, ERROR"Eliminar");
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, WHITE"Editor de puertas", stringFull, "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR_NAME:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, WHITE"Editor de puertas > Nombre", WHITE"Ingresa el nuevo nombre de esta puerta", "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR_ENTRACE_VIRTUAL:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, WHITE"Editor de puertas > E > Virtual", WHITE"Ingresa el nuevo virtualworld de esta puerta", "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR_ENTRACE_INTERIOR:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, WHITE"Editor de puertas > E > Inteior", WHITE"Ingresa el nuevo interior de esta puerta", "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR_EXIT_VIRTUAL:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, WHITE"Editor de puertas > S > Virtual", WHITE"Ingresa el nuevo virtualworld de esta puerta", "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR_EXIT_INTERIOR:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, WHITE"Editor de puertas > S > Inteior", WHITE"Ingresa el nuevo interior de esta puerta", "Aceptar", "Cancelar");
        }
        case DIALOG_EDIT_DOOR_PICKUP:{
            ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, WHITE"Editor de puertas > Pickup", WHITE"Ingresa el nuevo pickup de esta puerta", "Aceptar", "Cancelar");
        }
        default: SendError(playerid, "Code 01: Ha ocurrido un error intenta mas tarde");
    }
}
