-- TerrorMeter Integration System
-- Connects TerrorMeter with TerrorSquadAI, BigWigs, and DoTimer

local data = TerrorMeter.data
local config = TerrorMeter.config
local sync = TerrorMeter.sync

-- Integration state
local integration = {
  terrorSquadAI = {
    detected = false,
    version = nil,
    lastSync = 0,
  },
  bigWigs = {
    detected = false,
    inBossFight = false,
    currentBoss = nil,
    phaseData = {},
  },
  doTimer = {
    detected = false,
    activeDots = {},
  },
}

TerrorMeter.integration = integration

-- Communication channels
local INTEGRATION_CHANNEL = "TerrorEcosystem"
local SYNC_INTERVAL = 1 -- Sync every second with TerrorSquadAI

-- Register communication channel
if RegisterAddonMessagePrefix then
  RegisterAddonMessagePrefix(INTEGRATION_CHANNEL)
end

-- ============================================
-- DETECTION SYSTEM
-- ============================================

local function DetectAddons()
  -- Detect TerrorSquadAI
  if TerrorSquadAI then
    integration.terrorSquadAI.detected = true
    integration.terrorSquadAI.version = TerrorSquadAI.version or "unknown"
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Detectado TerrorSquadAI v" .. integration.terrorSquadAI.version)
    
    -- Register with TerrorSquadAI
    if TerrorSquadAI.RegisterIntegration then
      TerrorSquadAI.RegisterIntegration("TerrorMeter", {
        GetThreatData = GetThreatDataForSquadAI,
        GetDPSData = GetDPSDataForSquadAI,
        GetPlayerRole = GetPlayerRole,
      })
    end
  end
  
  -- Detect BigWigs
  if BigWigs then
    integration.bigWigs.detected = true
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Detectado BigWigs")
  end
  
  -- Detect DoTimer
  if DoTimer_Settings or DoTimer_SpellData then
    integration.doTimer.detected = true
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Detectado DoTimer")
  end
end

-- ============================================
-- TERRORSQUADAI INTEGRATION
-- ============================================

-- Get current threat data for TerrorSquadAI
function GetThreatDataForSquadAI()
  if not sync then return nil end
  
  local segment = config[1] and config[1].segment or 1
  local myThreat = data.threat[segment]
  
  if not myThreat then return nil end
  
  local playerName = UnitName("player")
  local myData = myThreat[playerName]
  
  if not myData or not myData._sum then return nil end
  
  return {
    player = playerName,
    threat = myData._sum,
    threatPercent = sync.my_threat_percent,
    tank = sync.auto_tank,
    alertState = sync.alert_state,
    inCombat = data.active,
  }
end

-- Get current DPS data for TerrorSquadAI
function GetDPSDataForSquadAI()
  local segment = config[1] and config[1].segment or 1
  local myDamage = data.damage[segment]
  
  if not myDamage then return nil end
  
  local playerName = UnitName("player")
  local myData = myDamage[playerName]
  
  if not myData or not myData._sum then return nil end
  
  local duration = (data.time and data.time[segment]) or 1
  local dps = myData._sum / duration
  
  return {
    player = playerName,
    totalDamage = myData._sum,
    dps = dps,
    duration = duration,
    inCombat = data.active,
  }
end

-- Get player role (Tank, DPS, Healer)
function GetPlayerRole()
  local _, class = UnitClass("player")
  
  -- Check if player is marked as tank or has highest threat
  if sync.auto_tank == UnitName("player") then
    return "TANK"
  end
  
  -- Simple role detection based on class
  if class == "WARRIOR" or class == "DRUID" then
    -- Could be tank or DPS, check threat
    if sync.my_threat_percent > 80 then
      return "TANK"
    end
  end
  
  if class == "PRIEST" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID" then
    -- Could be healer, but if doing damage, probably DPS
    local segment = config[1] and config[1].segment or 1
    local myDamage = data.damage[segment]
    if myDamage and myDamage[UnitName("player")] then
      return "DPS"
    end
    return "HEALER"
  end
  
  return "DPS"
end

-- Send threat update to TerrorSquadAI
local function SendThreatToSquadAI()
  if not integration.terrorSquadAI.detected then return end
  if not TerrorSquadAI then return end
  
  local threatData = GetThreatDataForSquadAI()
  local dpsData = GetDPSDataForSquadAI()
  
  if not threatData and not dpsData then return end
  
  -- Call TerrorSquadAI's threat receiver
  if TerrorSquadAI.ReceiveThreatData then
    TerrorSquadAI.ReceiveThreatData(threatData, dpsData)
  end
  
  -- Send via addon message for other raid members
  if UnitInRaid("player") or GetNumPartyMembers() > 0 then
    local channel = UnitInRaid("player") and "RAID" or "PARTY"
    local message = string.format("THREAT:%s:%d:%d:%.1f", 
      UnitName("player"),
      threatData and threatData.threat or 0,
      dpsData and dpsData.dps or 0,
      threatData and threatData.threatPercent or 0
    )
    SendAddonMessage(INTEGRATION_CHANNEL, message, channel)
  end
end

-- Receive smart suggestions from TerrorSquadAI
function ReceiveSquadAISuggestion(suggestion)
  if not suggestion then return end
  
  -- Display suggestion based on type
  if suggestion.type == "REDUCE_THREAT" then
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[TerrorSquadAI]|r " .. suggestion.message)
    PlaySound("RaidWarning")
  elseif suggestion.type == "INCREASE_DPS" then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorSquadAI]|r " .. suggestion.message)
  elseif suggestion.type == "HOLD_DPS" then
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00[TerrorSquadAI]|r " .. suggestion.message)
  end
end

-- ============================================
-- BIGWIGS INTEGRATION
-- ============================================

local function SetupBigWigsHooks()
  if not BigWigs then return end
  
  DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Configurando hooks de BigWigs...")
  
  -- Create event frame for BigWigs events
  local bigWigsFrame = CreateFrame("Frame")
  bigWigsFrame:RegisterEvent("CHAT_MSG_ADDON")
  bigWigsFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
  bigWigsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
  
  -- Hook BigWigs bar creation using direct function hooks
  if BigWigs.StartBar then
    local originalStartBar = BigWigs.StartBar
    BigWigs.StartBar = function(self, module, text, time, icon)
      -- Boss ability detected
      integration.bigWigs.inBossFight = true
      
      -- Store ability info
      if not integration.bigWigs.abilities then
        integration.bigWigs.abilities = {}
      end
      
      integration.bigWigs.abilities[text] = {
        time = time,
        icon = icon,
        startTime = GetTime(),
      }
      
      -- Call original function
      return originalStartBar(self, module, text, time, icon)
    end
  end
  
  if BigWigs.StopBar then
    local originalStopBar = BigWigs.StopBar
    BigWigs.StopBar = function(self, module, text)
      -- Boss ability ended
      if integration.bigWigs.abilities and integration.bigWigs.abilities[text] then
        integration.bigWigs.abilities[text] = nil
      end
      
      -- Call original function
      return originalStopBar(self, module, text)
    end
  end
  
  -- Monitor combat state for boss detection
  bigWigsFrame:SetScript("OnEvent", function()
    if event == "PLAYER_REGEN_DISABLED" then
      -- Entered combat - check if it's a boss
      if UnitLevel("target") == -1 or (UnitClassification("target") == "worldboss") then
        integration.bigWigs.inBossFight = true
        integration.bigWigs.currentBoss = UnitName("target") or "Unknown Boss"
        integration.bigWigs.phaseData = {}
        integration.bigWigs.currentPhase = 1
        integration.bigWigs.fightStartTime = GetTime()
        
        -- Reset phase DPS tracking
        ResetPhaseDPS()
        
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF6600[TerrorMeter]|r Boss fight iniciado: " .. integration.bigWigs.currentBoss)
      end
    elseif event == "PLAYER_REGEN_ENABLED" then
      -- Left combat
      if integration.bigWigs.inBossFight then
        local fightDuration = GetTime() - (integration.bigWigs.fightStartTime or GetTime())
        
        -- Save final phase data
        SavePhaseDPS(integration.bigWigs.currentPhase, fightDuration)
        
        -- Display phase summary
        DisplayPhaseSummary()
        
        integration.bigWigs.inBossFight = false
        integration.bigWigs.currentBoss = nil
        
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Boss derrotado. Datos de DPS por fase guardados.")
      end
    elseif event == "CHAT_MSG_ADDON" then
      -- Listen for BigWigs addon messages
      local prefix, message, channel, sender = arg1, arg2, arg3, arg4
      if prefix == "BigWigs" then
        -- Parse BigWigs messages for phase changes
        -- Only detect actual phase transitions like "Phase 2", not ability names like "Panther Phase"
        if string.find(message, "^Phase %d") or string.find(message, "^Fase %d") then
          local now = GetTime()
          local phaseDuration = now - (integration.bigWigs.phaseStartTime or integration.bigWigs.fightStartTime or now)
          SavePhaseDPS(integration.bigWigs.currentPhase, phaseDuration)
          
          -- Start new phase
          integration.bigWigs.currentPhase = (integration.bigWigs.currentPhase or 1) + 1
          integration.bigWigs.phaseStartTime = now
          
          DEFAULT_CHAT_FRAME:AddMessage("|cFFFF6600[TerrorMeter]|r Fase " .. integration.bigWigs.currentPhase .. " detectada")
        end
      end
    end
  end)
  
  DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r BigWigs hooks configurados exitosamente (usando eventos de combate)")
end

-- Reset phase DPS tracking
function ResetPhaseDPS()
  integration.bigWigs.phaseData = {}
  integration.bigWigs.currentPhase = 1
  integration.bigWigs.phaseStartTime = GetTime()
end

-- Save DPS data for a phase
function SavePhaseDPS(phase, duration)
  if not phase or duration <= 0 then return end
  
  local segment = config[1] and config[1].segment or 1
  local myDamage = data.damage[segment]
  
  if not myDamage then return end
  
  local playerName = UnitName("player")
  local myData = myDamage[playerName]
  
  if not myData or not myData._sum then return end
  
  local dps = myData._sum / duration
  
  integration.bigWigs.phaseData[phase] = {
    damage = myData._sum,
    dps = dps,
    duration = duration,
    timestamp = GetTime(),
  }
end

-- Display phase summary
function DisplayPhaseSummary()
  if not integration.bigWigs.phaseData then return end
  
  DEFAULT_CHAT_FRAME:AddMessage("|cFFFF6600========== RESUMEN DE FASES ==========")
  
  for phase, phaseData in pairs(integration.bigWigs.phaseData) do
    DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF00FF00Fase %d:|r %.0f DPS (%.0f damage en %.0fs)",
      phase, phaseData.dps, phaseData.damage, phaseData.duration))
  end
  
  DEFAULT_CHAT_FRAME:AddMessage("|cFFFF6600=====================================")
end

-- Get current phase DPS
function GetCurrentPhaseDPS()
  if not integration.bigWigs.inBossFight then return nil end
  
  local phase = integration.bigWigs.currentPhase or 1
  return integration.bigWigs.phaseData[phase]
end

-- ============================================
-- DOTIMER INTEGRATION
-- ============================================

local function GetActiveDoTs()
  if not DoTimer then return {} end
  
  local dots = {}
  
  -- DoTimer stores active timers in DoTimer_Timers
  if DoTimer_Timers then
    for target, spells in pairs(DoTimer_Timers) do
      for spell, data in pairs(spells) do
        table.insert(dots, {
          target = target,
          spell = spell,
          timeLeft = data.endTime - GetTime(),
          duration = data.duration,
        })
      end
    end
  end
  
  return dots
end

-- Calculate projected DPS from active DoTs
local function CalculateProjectedDPS()
  local dots = GetActiveDoTs()
  if table.getn(dots) == 0 then return 0 end
  
  -- Simple estimation: assume average DoT does 100 DPS per tick
  -- This should be improved with actual spell data
  local projectedDPS = 0
  for i = 1, table.getn(dots) do
    local dot = dots[i]
    if dot.timeLeft > 0 then
      projectedDPS = projectedDPS + 50 -- Rough estimate
    end
  end
  
  return projectedDPS
end

-- Check for expiring DoTs and alert
local lastDotCheck = 0
local DOT_CHECK_INTERVAL = 1
local DOT_WARNING_TIME = 3 -- Warn when DoT has 3 seconds left

local function CheckExpiringDoTs()
  local now = GetTime()
  if now - lastDotCheck < DOT_CHECK_INTERVAL then return end
  lastDotCheck = now
  
  local dots = GetActiveDoTs()
  if table.getn(dots) == 0 then return end
  
  for i = 1, table.getn(dots) do
    local dot = dots[i]
    if dot.timeLeft > 0 and dot.timeLeft <= DOT_WARNING_TIME then
      -- Important DoT about to expire
      if IsImportantDoT(dot.spell) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFFFF6600[TerrorMeter]|r ¡%s en %s expira en %.0fs!",
          dot.spell, dot.target, dot.timeLeft))
        
        -- Send to TerrorSquadAI
        if integration.terrorSquadAI.detected and TerrorSquadAI then
          if TerrorSquadAI.ReceiveDotWarning then
            TerrorSquadAI.ReceiveDotWarning(dot)
          end
        end
      end
    end
  end
end

-- Check if DoT is important (high DPS DoTs)
function IsImportantDoT(spellName)
  local importantDoTs = {
    -- Warlock
    ["Corruption"] = true,
    ["Corrupción"] = true,
    ["Immolate"] = true,
    ["Inmolar"] = true,
    ["Curse of Agony"] = true,
    ["Maldición de agonía"] = true,
    ["Siphon Life"] = true,
    ["Succionar vida"] = true,
    
    -- Priest
    ["Shadow Word: Pain"] = true,
    ["Palabra de las Sombras: dolor"] = true,
    ["Vampiric Embrace"] = true,
    ["Abrazo vampírico"] = true,
    
    -- Druid
    ["Moonfire"] = true,
    ["Fuego lunar"] = true,
    ["Insect Swarm"] = true,
    ["Enjambre de insectos"] = true,
    ["Rip"] = true,
    ["Despedazar"] = true,
    
    -- Hunter
    ["Serpent Sting"] = true,
    ["Picadura de serpiente"] = true,
    
    -- Rogue
    ["Rupture"] = true,
    ["Ruptura"] = true,
    ["Garrote"] = true,
  }
  
  return importantDoTs[spellName] or false
end

-- Get DoT uptime percentage
function GetDotUptime(spellName)
  if not integration.doTimer.detected then return 0 end
  
  -- This would require tracking DoT application/expiration over time
  -- For now, return simple active/inactive
  local dots = GetActiveDoTs()
  for i = 1, table.getn(dots) do
    if dots[i].spell == spellName then
      return 100 -- Active
    end
  end
  
  return 0 -- Not active
end

-- ============================================
-- UPDATE LOOP
-- ============================================

local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function()
  local now = GetTime()
  
  -- Sync with TerrorSquadAI every second
  if integration.terrorSquadAI.detected then
    if now - integration.terrorSquadAI.lastSync >= SYNC_INTERVAL then
      SendThreatToSquadAI()
      integration.terrorSquadAI.lastSync = now
    end
  end
  
  -- Update DoTimer data and check for expiring DoTs
  if integration.doTimer.detected then
    integration.doTimer.activeDots = GetActiveDoTs()
    CheckExpiringDoTs()
  end
end)

-- ============================================
-- ADDON MESSAGE HANDLER
-- ============================================

local function OnAddonMessage(prefix, message, channel, sender)
  if prefix ~= INTEGRATION_CHANNEL then return end
  
  -- Parse messages from other addons
  local parts = {}
  for part in string.gfind(message, "[^:]+") do
    table.insert(parts, part)
  end
  
  if parts[1] == "SQUADAI_SUGGEST" then
    -- Suggestion from TerrorSquadAI
    local suggestion = {
      type = parts[2],
      message = parts[3],
      sender = sender,
    }
    ReceiveSquadAISuggestion(suggestion)
  end
end

-- Register event handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")
eventFrame:SetScript("OnEvent", function()
  if event == "CHAT_MSG_ADDON" then
    OnAddonMessage(arg1, arg2, arg3, arg4)
  end
end)

-- ============================================
-- INITIALIZATION
-- ============================================

local function Initialize()
  DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Integration System loaded")
  
  -- Detect addons after a short delay
  local initFrame = CreateFrame("Frame")
  initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  initFrame:SetScript("OnEvent", function()
    DetectAddons()
    SetupBigWigsHooks()
    this:UnregisterAllEvents()
  end)
end

Initialize()

-- ============================================
-- SLASH COMMANDS
-- ============================================

SLASH_TMINTEGRATION1 = "/tmintegration"
SLASH_TMINTEGRATION2 = "/tmi"
SlashCmdList["TMINTEGRATION"] = function(msg)
  if msg == "status" then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter Integration]|r Status:")
    DEFAULT_CHAT_FRAME:AddMessage("  TerrorSquadAI: " .. (integration.terrorSquadAI.detected and "|cFF00FF00Detected|r" or "|cFFFF0000Not Found|r"))
    DEFAULT_CHAT_FRAME:AddMessage("  BigWigs: " .. (integration.bigWigs.detected and "|cFF00FF00Detected|r" or "|cFFFF0000Not Found|r"))
    if integration.bigWigs.detected and integration.bigWigs.inBossFight then
      DEFAULT_CHAT_FRAME:AddMessage("    Boss: " .. (integration.bigWigs.currentBoss or "Unknown"))
      DEFAULT_CHAT_FRAME:AddMessage("    Fase: " .. (integration.bigWigs.currentPhase or 1))
    end
    DEFAULT_CHAT_FRAME:AddMessage("  DoTimer: " .. (integration.doTimer.detected and "|cFF00FF00Detected|r" or "|cFFFF0000Not Found|r"))
    if integration.doTimer.detected then
      local dots = GetActiveDoTs()
      DEFAULT_CHAT_FRAME:AddMessage("    DoTs activos: " .. table.getn(dots))
    end
  elseif msg == "test" then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Testing integration...")
    SendThreatToSquadAI()
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter]|r Test data sent to TerrorSquadAI")
  elseif msg == "phases" or msg == "fases" then
    if integration.bigWigs.detected then
      DisplayPhaseSummary()
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[TerrorMeter]|r BigWigs no detectado")
    end
  elseif msg == "dots" then
    if integration.doTimer.detected then
      local dots = GetActiveDoTs()
      DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[DoTs Activos]|r (" .. table.getn(dots) .. " total)")
      for i = 1, table.getn(dots) do
        local dot = dots[i]
        DEFAULT_CHAT_FRAME:AddMessage(string.format("  %s en %s: %.1fs restantes",
          dot.spell, dot.target, dot.timeLeft))
      end
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[TerrorMeter]|r DoTimer no detectado")
    end
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[TerrorMeter Integration]|r Commands:")
    DEFAULT_CHAT_FRAME:AddMessage("  /tmi status - Show integration status")
    DEFAULT_CHAT_FRAME:AddMessage("  /tmi test - Test integration")
    DEFAULT_CHAT_FRAME:AddMessage("  /tmi phases - Show phase DPS summary (BigWigs)")
    DEFAULT_CHAT_FRAME:AddMessage("  /tmi dots - Show active DoTs (DoTimer)")
  end
end
