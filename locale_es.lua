-- TerrorMeter Spanish Localization
-- El Sequito del Terror Edition
-- Soporte para clientes esES y esMX

if GetLocale() == "esES" or GetLocale() == "esMX" then
    TM_L = TM_L or {}

    TM_L["Damage"]    = "Dano"
    TM_L["DPS"]       = "DPS"
    TM_L["Heal"]      = "Sanacion"
    TM_L["HPS"]       = "SPS"
    TM_L["Threat"]    = "Amenaza"
    TM_L["Current"]   = "Actual"
    TM_L["Overall"]   = "Total"
    TM_L["Details"]   = "Detalles"
    TM_L["Reset"]     = "Reiniciar"
    TM_L["Segment"]   = "Segmento"
    TM_L["SegDesc"]   = "Total, Actual"
    TM_L["Mode"]      = "Modo"
    TM_L["ModeDesc"]  = "Dano, DPS, Sanacion, SPS, Amenaza"
    TM_L["ResetDesc"] = "Reiniciar todos los datos"
end
