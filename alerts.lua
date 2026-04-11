-- TerrorMeter Threat Alert System
-- Visual and audio warnings when threat is too high

local sync = TerrorMeter.sync

-- Create alert frame
local alertFrame = CreateFrame("Frame", "TerrorMeterAlertFrame", UIParent)
alertFrame:SetWidth(300)
alertFrame:SetHeight(60)
alertFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
alertFrame:SetFrameStrata("HIGH")
alertFrame:Hide()

-- Background
alertFrame.bg = alertFrame:CreateTexture(nil, "BACKGROUND")
alertFrame.bg:SetAllPoints()
alertFrame.bg:SetTexture(0, 0, 0, 0.8)

-- Border
alertFrame.border = CreateFrame("Frame", nil, alertFrame)
alertFrame.border:SetPoint("TOPLEFT", alertFrame, "TOPLEFT", -2, 2)
alertFrame.border:SetPoint("BOTTOMRIGHT", alertFrame, "BOTTOMRIGHT", 2, -2)
alertFrame.border:SetBackdrop({
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
alertFrame.border:SetBackdropBorderColor(0.8, 0, 0, 1)

-- Warning text
alertFrame.text = alertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
alertFrame.text:SetPoint("TOP", alertFrame, "TOP", 0, -10)
alertFrame.text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
alertFrame.text:SetShadowOffset(1, -1)
alertFrame.text:SetText("¡ALTO THREAT!")

-- Threat percentage text
alertFrame.percent = alertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
alertFrame.percent:SetPoint("TOP", alertFrame.text, "BOTTOM", 0, -5)
alertFrame.percent:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
alertFrame.percent:SetText("95% del Tank")

-- Flash animation
alertFrame.flash = 0
alertFrame.flashDir = 1

-- Create threat bar (personal threat meter)
local threatBar = CreateFrame("Frame", "TerrorMeterThreatBar", UIParent)
threatBar:SetWidth(200)
threatBar:SetHeight(20)
threatBar:SetPoint("TOP", UIParent, "TOP", 0, -100)
threatBar:SetFrameStrata("MEDIUM")
threatBar:Hide()

-- Threat bar background
threatBar.bg = threatBar:CreateTexture(nil, "BACKGROUND")
threatBar.bg:SetAllPoints()
threatBar.bg:SetTexture(0, 0, 0, 0.7)

-- Threat bar border
threatBar.border = CreateFrame("Frame", nil, threatBar)
threatBar.border:SetPoint("TOPLEFT", threatBar, "TOPLEFT", -1, 1)
threatBar.border:SetPoint("BOTTOMRIGHT", threatBar, "BOTTOMRIGHT", 1, -1)
threatBar.border:SetBackdrop({
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 8,
  insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
threatBar.border:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

-- Threat bar fill
threatBar.bar = CreateFrame("StatusBar", nil, threatBar)
threatBar.bar:SetPoint("TOPLEFT", threatBar, "TOPLEFT", 2, -2)
threatBar.bar:SetPoint("BOTTOMRIGHT", threatBar, "BOTTOMRIGHT", -2, 2)
threatBar.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
threatBar.bar:SetMinMaxValues(0, 100)
threatBar.bar:SetValue(0)
threatBar.bar:SetStatusBarColor(0.2, 1.0, 0.2) -- Green by default

-- Threat bar text
threatBar.text = threatBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
threatBar.text:SetPoint("CENTER", threatBar, "CENTER", 0, 0)
threatBar.text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
threatBar.text:SetShadowOffset(1, -1)
threatBar.text:SetText("Threat: 0%")

-- Tank name text
threatBar.tankText = threatBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
threatBar.tankText:SetPoint("TOP", threatBar, "BOTTOM", 0, -2)
threatBar.tankText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
threatBar.tankText:SetText("Tank: Ninguno")
threatBar.tankText:SetTextColor(0.7, 0.7, 0.7)

-- Update alert display
local function UpdateAlerts()
  local state = TerrorMeter.GetAlertState()
  local percent = TerrorMeter.GetMyThreatPercent()
  local tankName = TerrorMeter.GetTankName()
  local playerName = UnitName("player")
  
  -- Don't show alerts if I'm the tank
  if playerName == tankName then
    alertFrame:Hide()
    threatBar:Hide()
    return
  end
  
  -- Only show in combat
  if not UnitAffectingCombat("player") then
    alertFrame:Hide()
    threatBar:Hide()
    return
  end
  
  -- Update threat bar
  threatBar:Show()
  threatBar.bar:SetValue(percent)
  threatBar.text:SetText(string.format("Threat: %.0f%%", percent))
  
  if tankName then
    threatBar.tankText:SetText("Tank: " .. tankName)
  else
    threatBar.tankText:SetText("Tank: Detectando...")
  end
  
  -- Update bar color based on threat level
  if percent >= 90 then
    threatBar.bar:SetStatusBarColor(1.0, 0.2, 0.2) -- Red
  elseif percent >= 70 then
    threatBar.bar:SetStatusBarColor(1.0, 1.0, 0.2) -- Yellow
  else
    threatBar.bar:SetStatusBarColor(0.2, 1.0, 0.2) -- Green
  end
  
  -- Show/hide alert based on state
  if state == "danger" then
    alertFrame:Show()
    alertFrame.text:SetText("¡REDUCE DPS!")
    alertFrame.percent:SetText(string.format("%.0f%% del Tank", percent))
    alertFrame.border:SetBackdropBorderColor(1, 0, 0, 1) -- Red
    alertFrame.text:SetTextColor(1, 0.2, 0.2)
  elseif state == "warning" then
    alertFrame:Show()
    alertFrame.text:SetText("¡CUIDADO THREAT!")
    alertFrame.percent:SetText(string.format("%.0f%% del Tank", percent))
    alertFrame.border:SetBackdropBorderColor(1, 1, 0, 1) -- Yellow
    alertFrame.text:SetTextColor(1, 1, 0.2)
  else
    alertFrame:Hide()
  end
end

-- Animation loop
alertFrame:SetScript("OnUpdate", function()
  if not this:IsShown() then return end
  
  local elapsed = arg1
  if type(elapsed) ~= "number" then elapsed = 1/60 end
  
  local multiplier = elapsed * 60
  -- Flash effect
  this.flash = this.flash + (0.05 * this.flashDir * multiplier)
  if this.flash >= 1 then
    this.flashDir = -1
    this.flash = 1
  elseif this.flash <= 0.3 then
    this.flashDir = 1
    this.flash = 0.3
  end
  
  this.bg:SetTexture(0, 0, 0, 0.8 * this.flash)
end)

-- Update loop
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function()
  if (this.tick or 0) > GetTime() then return end
  this.tick = GetTime() + 0.2 -- Update 5 times per second
  
  UpdateAlerts()
end)

-- Slash command to toggle threat bar
SLASH_TMTHREAT1 = "/tmthreat"
SlashCmdList["TMTHREAT"] = function(msg)
  if msg == "bar" then
    if threatBar:IsShown() then
      threatBar:Hide()
      DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Terror|cffffffffMeter: Barra de threat ocultada")
    else
      threatBar:Show()
      DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Terror|cffffffffMeter: Barra de threat mostrada")
    end
  elseif msg == "alert" then
    if alertFrame:IsShown() then
      alertFrame:Hide()
      DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Terror|cffffffffMeter: Alertas desactivadas")
    else
      alertFrame:Show()
      DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Terror|cffffffffMeter: Alertas activadas")
    end
  else
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Terror|cffffffffMeter Threat:")
    DEFAULT_CHAT_FRAME:AddMessage("  /tmthreat bar - Mostrar/ocultar barra de threat")
    DEFAULT_CHAT_FRAME:AddMessage("  /tmthreat alert - Activar/desactivar alertas")
  end
end

-- Make frames accessible
TerrorMeter.alertFrame = alertFrame
TerrorMeter.threatBar = threatBar
