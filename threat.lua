-- TerrorMeter REAL Threat Calculator
-- Accurate threat calculation based on Vanilla WoW mechanics

local parser = TerrorMeter.parser
local data = TerrorMeter.data
local config = TerrorMeter.config

-- Initialize threat data
data.threat = data.threat or {
  [0] = {}, -- overall
  [1] = {}, -- current
}

-- Threat multipliers by stance/aura/form
local stance_multipliers = {
  -- Warrior
  ["Battle Stance"] = 0.8,
  ["Defensive Stance"] = 1.3,
  ["Berserker Stance"] = 0.8,
  
  -- Paladin
  ["Righteous Fury"] = 1.6,
  ["Devotion Aura"] = 1.0,
  
  -- Druid
  ["Bear Form"] = 1.3,
  ["Dire Bear Form"] = 1.3,
  ["Cat Form"] = 0.71,
}

-- Ability-specific threat bonuses (added to damage)
local ability_threat = {
  -- Warrior
  ["Sunder Armor"] = 260,
  ["Heroic Strike"] = 145,
  ["Shield Slam"] = 250,
  ["Revenge"] = 315,
  ["Shield Bash"] = 180,
  ["Cleave"] = 100,
  ["Thunder Clap"] = 175,
  ["Demoralizing Shout"] = 55,
  ["Battle Shout"] = 55,
  
  -- Paladin
  ["Holy Shield"] = 175,
  ["Avenger's Shield"] = 225,
  ["Blessing of Salvation"] = -0.3, -- 30% threat reduction
  
  -- Druid
  ["Maul"] = 322,
  ["Swipe"] = 101,
  ["Claw"] = 0,
  ["Rake"] = 0,
  
  -- Rogue
  ["Feint"] = -600, -- Reduces threat
}

-- Taunt abilities (set threat equal to highest)
local taunt_abilities = {
  ["Taunt"] = true,
  ["Growl"] = true,
  ["Righteous Defense"] = true,
  ["Challenging Roar"] = true,
  ["Challenging Shout"] = true,
}

-- Cache for player stances
local player_stance_cache = {}
local stance_cache_time = 0

-- Function to get unit's current stance/form
local function GetUnitStance(unit)
  -- Only cache player stance
  if unit == UnitName("player") then
    local now = GetTime()
    if now - stance_cache_time < 1 then
      return player_stance_cache[unit]
    end
    stance_cache_time = now
  end
  
  -- Check shapeshifts (Druid forms)
  if unit == UnitName("player") then
    local numForms = GetNumShapeshiftForms()
    for i = 1, numForms do
      local _, name, active = GetShapeshiftFormInfo(i)
      if active and stance_multipliers[name] then
        player_stance_cache[unit] = name
        return name
      end
    end
  end
  
  -- Check buffs for stances and auras
  local i = 1
  while true do
    local buffName = UnitBuff(unit == UnitName("player") and "player" or "raid1", i)
    if not buffName then break end
    if stance_multipliers[buffName] then
      if unit == UnitName("player") then
        player_stance_cache[unit] = buffName
      end
      return buffName
    end
    i = i + 1
  end
  
  return nil
end

-- Function to calculate threat from damage
local function CalculateThreat(source, action, value, datatype)
  local threat = value
  local multiplier = 1.0
  local bonus = 0
  
  -- Get stance multiplier
  local stance = GetUnitStance(source)
  if stance and stance_multipliers[stance] then
    multiplier = stance_multipliers[stance]
  end
  
  -- Get ability-specific threat
  if action and ability_threat[action] then
    local abilityMod = ability_threat[action]
    if abilityMod < 0 then
      -- Percentage reduction (like Blessing of Salvation)
      multiplier = multiplier * (1 + abilityMod)
    else
      -- Flat bonus (like Sunder Armor)
      bonus = abilityMod
    end
  end
  
  -- Healing generates 50% threat
  if datatype == "heal" then
    multiplier = multiplier * 0.5
  end
  
  -- Calculate final threat
  threat = (value * multiplier) + bonus
  
  return threat
end

-- Hook into parser.AddData to track threat
local original_AddData = parser.AddData
parser.AddData = function(self, source, action, target, value, school, datatype)
  -- Call original function first
  original_AddData(self, source, action, target, value, school, datatype)
  
  -- Only track damage and heal for threat
  if datatype ~= "damage" and datatype ~= "heal" then
    return
  end
  
  -- Abort on invalid input
  if type(source) ~= "string" then return end
  if not tonumber(value) then return end
  
  -- Trim source name
  source = string.gsub(source, "^%s*(.-)%s*$", "%1")
  
  -- Prevent self-damage
  if datatype == "damage" and source == target then
    return
  end
  
  -- Calculate threat
  local threat = CalculateThreat(source, action, value, datatype)
  
  -- Write to both segments (overall and current)
  for segment = 0, 1 do
    local entry = data.threat[segment]
    
    -- Initialize source if needed
    if not entry[source] then
      local type = parser:ScanName(source)
      if type == "PET" then
        local owner = data["classes"][source]
        if not entry[owner] and parser:ScanName(owner) then
          entry[owner] = { ["_sum"] = 0, ["_ctime"] = 1, ["_tick"] = GetTime() }
        end
      elseif not type then
        break
      end
      
      entry[source] = { ["_sum"] = 0, ["_ctime"] = 1, ["_tick"] = GetTime() }
    end
    
    -- Merge pet threat into owner if enabled
    local threat_source = source
    local threat_action = action
    
    if config.merge_pets == 1 and 
       data["classes"][source] ~= "__other__" and
       entry[data["classes"][source]] then
      
      entry[source] = nil
      threat_action = "Pet: " .. source
      threat_source = data["classes"][source]
      
      if not entry[threat_source] then
        entry[threat_source] = { ["_sum"] = 0, ["_ctime"] = 1, ["_tick"] = GetTime() }
      end
    end
    
    -- Add threat
    entry[threat_source]["_sum"] = entry[threat_source]["_sum"] + threat
    
    -- Track by action
    if threat_action then
      entry[threat_source][threat_action] = (entry[threat_source][threat_action] or 0) + threat
    end
    
    -- Update combat time
    local now = GetTime()
    if entry[threat_source]["_tick"] and now - entry[threat_source]["_tick"] < 2 then
      entry[threat_source]["_ctime"] = entry[threat_source]["_ctime"] + (now - entry[threat_source]["_tick"])
    end
    entry[threat_source]["_tick"] = now
  end
end

-- Function to get threat percentage
function TerrorMeter.GetThreatPercent(unit, segment)
  segment = segment or 1
  if not data.threat[segment] or not data.threat[segment][unit] then 
    return 0 
  end
  
  local maxThreat = 0
  for name, unitdata in pairs(data.threat[segment]) do
    if unitdata._sum and unitdata._sum > maxThreat then
      maxThreat = unitdata._sum
    end
  end
  
  if maxThreat == 0 then return 0 end
  
  return (data.threat[segment][unit]._sum / maxThreat) * 100
end

-- Function to get threat color
function TerrorMeter.GetThreatColor(percent)
  if percent < 70 then
    return 0.2, 1.0, 0.2 -- Green
  elseif percent < 90 then
    return 1.0, 1.0, 0.2 -- Yellow
  else
    return 1.0, 0.2, 0.2 -- Red
  end
end
