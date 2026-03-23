-- TerrorMeter Threat Synchronization System
-- Allows threat data sharing between raid members

local data = TerrorMeter.data
local config = TerrorMeter.config

-- Sync configuration
local SYNC_CHANNEL = "TerrorMeterSync"
local SYNC_VERSION = "1.0"
local SYNC_INTERVAL = 2 -- Send updates every 2 seconds
local THREAT_WARNING_THRESHOLD = 70 -- Yellow warning at 70%
local THREAT_DANGER_THRESHOLD = 90 -- Red alert at 90%

-- Sync data
local sync_data = {
  last_send = 0,
  received_threat = {}, -- Threat data from other players
  marked_tanks = {}, -- Manually marked tanks
  auto_tank = nil, -- Auto-detected tank (highest threat)
  my_threat_percent = 0,
  alert_state = "safe", -- safe, warning, danger
  last_alert_sound = 0,
}

-- Make sync data accessible
TerrorMeter.sync = sync_data

-- Register addon communication channel (only in TBC+)
if RegisterAddonMessagePrefix then
  RegisterAddonMessagePrefix(SYNC_CHANNEL)
end

-- Compress threat data for sending
local function CompressThreatData()
  local segment = config[1] and config[1].segment or 1
  local myThreat = data.threat[segment]
  
  if not myThreat then return nil end
  
  local playerName = UnitName("player")
  local myData = myThreat[playerName]
  
  if not myData or not myData._sum then return nil end
  
  -- Format: "PlayerName:ThreatAmount:Class"
  local _, class = UnitClass("player")
  local message = string.format("%s:%d:%s", playerName, myData._sum, class or "UNKNOWN")
  
  return message
end

-- Parse received threat data
local function ParseThreatData(message, sender)
  -- Format: "PlayerName:ThreatAmount:Class"
  -- Lua 5.0 compatible: use string.gsub to extract values
  local name, threat, class
  string.gsub(message, "([^:]+):(%d+):([^:]+)", function(n, t, c)
    name, threat, class = n, t, c
  end)
  
  if name and threat and class then
    sync_data.received_threat[name] = {
      threat = tonumber(threat),
      class = class,
      timestamp = GetTime(),
    }
    return true
  end
  
  return false
end

-- Get combined threat data (local + received)
local function GetCombinedThreat()
  local combined = {}
  local segment = config[1] and config[1].segment or 1
  
  -- Add local threat data
  if data.threat[segment] then
    for name, unitdata in pairs(data.threat[segment]) do
      if unitdata._sum then
        combined[name] = {
          threat = unitdata._sum,
          class = data.classes[name] or "UNKNOWN",
          source = "local",
        }
      end
    end
  end
  
  -- Add received threat data (only if recent)
  local now = GetTime()
  for name, unitdata in pairs(sync_data.received_threat) do
    if now - unitdata.timestamp < 5 then -- Data valid for 5 seconds
      -- Use received data if we don't have local data
      if not combined[name] then
        combined[name] = {
          threat = unitdata.threat,
          class = unitdata.class,
          source = "sync",
        }
      end
    end
  end
  
  return combined
end

-- Detect who is the main tank (highest threat)
local function DetectMainTank()
  local combined = GetCombinedThreat()
  local maxThreat = 0
  local tankName = nil
  
  for name, data in pairs(combined) do
    if data.threat > maxThreat then
      maxThreat = data.threat
      tankName = name
    end
  end
  
  sync_data.auto_tank = tankName
  return tankName, maxThreat
end

-- Calculate my threat percentage vs tank
local function CalculateMyThreatPercent()
  local playerName = UnitName("player")
  local combined = GetCombinedThreat()
  
  -- Get tank threat
  local tankName, tankThreat = DetectMainTank()
  
  if not tankName or tankThreat == 0 then
    sync_data.my_threat_percent = 0
    return 0
  end
  
  -- Get my threat
  local myData = combined[playerName]
  if not myData then
    sync_data.my_threat_percent = 0
    return 0
  end
  
  -- Calculate percentage
  local percent = (myData.threat / tankThreat) * 100
  sync_data.my_threat_percent = percent
  
  return percent
end

-- Update alert state based on threat
local function UpdateAlertState()
  local percent = CalculateMyThreatPercent()
  local playerName = UnitName("player")
  local tankName = sync_data.auto_tank
  
  -- Don't alert if I'm the tank
  if playerName == tankName then
    sync_data.alert_state = "safe"
    return
  end
  
  -- Update state
  local oldState = sync_data.alert_state
  
  if percent >= THREAT_DANGER_THRESHOLD then
    sync_data.alert_state = "danger"
  elseif percent >= THREAT_WARNING_THRESHOLD then
    sync_data.alert_state = "warning"
  else
    sync_data.alert_state = "safe"
  end
  
  -- Play sound on state change to danger
  if sync_data.alert_state == "danger" and oldState ~= "danger" then
    local now = GetTime()
    if now - sync_data.last_alert_sound > 3 then -- Don't spam sounds
      PlaySound("RaidWarning")
      sync_data.last_alert_sound = now
    end
  end
end

-- Send my threat data to raid
local function SendThreatUpdate()
  local now = GetTime()
  
  -- Only send if enough time has passed
  if now - sync_data.last_send < SYNC_INTERVAL then
    return
  end
  
  -- Only send if in a group
  if not UnitInRaid("player") and not UnitInParty("player") then
    return
  end
  
  -- Compress and send data
  local message = CompressThreatData()
  if message then
    local channel = UnitInRaid("player") and "RAID" or "PARTY"
    if SendAddonMessage then
      SendAddonMessage(SYNC_CHANNEL, message, channel)
    end
    sync_data.last_send = now
  end
end

-- Handle received addon messages
local sync_frame = CreateFrame("Frame")
sync_frame:RegisterEvent("CHAT_MSG_ADDON")
sync_frame:SetScript("OnEvent", function()
  if event == "CHAT_MSG_ADDON" then
    local prefix, message, channel, sender = arg1, arg2, arg3, arg4
    
    if prefix == SYNC_CHANNEL then
      ParseThreatData(message, sender)
    end
  end
end)

-- Update loop
local update_frame = CreateFrame("Frame")
update_frame:SetScript("OnUpdate", function()
  if (this.tick or 0) > GetTime() then return end
  this.tick = GetTime() + 0.5 -- Update every 0.5 seconds
  
  -- Send my threat data
  SendThreatUpdate()
  
  -- Update alert state
  UpdateAlertState()
end)

-- Public functions
function TerrorMeter.GetTankName()
  return sync_data.auto_tank
end

function TerrorMeter.GetMyThreatPercent()
  return sync_data.my_threat_percent
end

function TerrorMeter.GetAlertState()
  return sync_data.alert_state
end

function TerrorMeter.GetCombinedThreat()
  return GetCombinedThreat()
end

-- Mark/unmark a player as tank manually
function TerrorMeter.MarkAsTank(playerName)
  if sync_data.marked_tanks[playerName] then
    sync_data.marked_tanks[playerName] = nil
  else
    sync_data.marked_tanks[playerName] = true
  end
end

function TerrorMeter.IsTank(playerName)
  return sync_data.marked_tanks[playerName] or (sync_data.auto_tank == playerName)
end
