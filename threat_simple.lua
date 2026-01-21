-- TerrorMeter Threat Calculator
-- Simplified version that copies damage data as threat

local data = TerrorMeter.data
local parser = TerrorMeter.parser

-- Initialize threat data
data.threat = data.threat or {
  [0] = {}, -- overall
  [1] = {}, -- current
}

-- Threat multipliers by stance/aura
local threat_multipliers = {
  -- Warrior
  ["Battle Stance"] = 0.8,
  ["Defensive Stance"] = 1.3,
  ["Berserker Stance"] = 0.8,
  
  -- Paladin
  ["Righteous Fury"] = 1.6,
  
  -- Druid
  ["Bear Form"] = 1.3,
  ["Dire Bear Form"] = 1.3,
}

-- Simple threat calculation: use damage as base threat
-- This is a simplified model but works for basic threat tracking
local function UpdateThreat()
  -- Copy damage data to threat data with multipliers
  for segment = 0, 1 do
    if data.damage[segment] then
      for unit, unitdata in pairs(data.damage[segment]) do
        if not data.threat[segment][unit] then
          data.threat[segment][unit] = {}
        end
        
        -- Copy all damage data as threat
        for key, value in pairs(unitdata) do
          data.threat[segment][unit][key] = value
        end
        
        -- Apply threat multiplier for tanks (simplified)
        -- In a real implementation, we'd check the unit's stance/aura
        -- For now, we just copy the damage values
      end
    end
  end
  
  -- Also copy healing as threat (50% of healing)
  for segment = 0, 1 do
    if data.heal[segment] then
      for unit, unitdata in pairs(data.heal[segment]) do
        if not data.threat[segment][unit] then
          data.threat[segment][unit] = {
            _sum = 0,
            _ctime = 0,
            _tick = 0,
          }
        end
        
        -- Add 50% of healing as threat
        if unitdata._sum then
          local healThreat = unitdata._sum * 0.5
          data.threat[segment][unit]._sum = (data.threat[segment][unit]._sum or 0) + healThreat
        end
        
        -- Copy combat time
        if unitdata._ctime then
          data.threat[segment][unit]._ctime = unitdata._ctime
        end
        
        if unitdata._tick then
          data.threat[segment][unit]._tick = unitdata._tick
        end
      end
    end
  end
end

-- Hook into parser refresh callbacks
if parser and parser.callbacks and parser.callbacks.refresh then
  table.insert(parser.callbacks.refresh, UpdateThreat)
end

-- Function to get threat percentage relative to tank
function TerrorMeter.GetThreatPercent(unit, segment)
  segment = segment or 1
  if not data.threat[segment] or not data.threat[segment][unit] then 
    return 0 
  end
  
  -- Find highest threat (assumed to be tank)
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
