stock RegisterDynamicArea(areaid, type, ownerid)
{
    AreaData[areaid][area_type] = type;
    AreaData[areaid][area_ownerid] = ownerid;
}