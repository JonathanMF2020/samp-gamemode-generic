stock RegisterDynamicArea(areaid, type, ownerid)
{
    AreaData[areaid][area_type] = type;
    AreaData[areaid][area_ownerid] = ownerid;
}

stock ClearAreaData(areaid)
{
    AreaData[areaid][area_type] = AREA_NONE;
    AreaData[areaid][area_ownerid] = -1;
}