--[[
   TTHide.lua - disable tooltips during combat

   Copyright 2020 James Kean Johnston. All rights reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

local function no_combat_onshow()
  if (not TTHideEnabled or IsShiftKeyDown()) then return end
  if (UnitAffectingCombat("player")) then
    GameTooltip:Hide()
  end
end

local function enable_disable(which)
  local v = which and "on" or "off"
  DEFAULT_CHAT_FRAME:AddMessage("Tooltips hidden during combat: " .. v)
end

local function tthide_cmd(input)
  if (input == "on") then
    TTHideEnabled = true
  elseif (input == "off") then
    TTHideEnabled = false
  elseif (input ~= "status") then
    return
  end
  enable_disable(TTHideEnabled)
end

-- Should only happen first time around so we want it enabled
if (TTHideEnabled == nil) then
  TTHideEnabled = true
end

enable_disable(TTHideEnabled)
SlashCmdList["TTHIDE"] = tthide_cmd
_G["SLASH_TTHIDE1"] = "/tthide"
GameTooltip:HookScript("OnShow", no_combat_onshow)

local eframe = CreateFrame("Frame", "TTHideEvents")
eframe:UnregisterAllEvents()
eframe:SetScript("OnEvent", function(this, evt)
  if (TTHideEnabled and evt == "PLAYER_REGEN_DISABLED") then
    GameTooltip:Hide()
  end
end)
eframe:RegisterEvent("PLAYER_REGEN_DISABLED")
