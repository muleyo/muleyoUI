local Style = mUI:GetModule("mUI.Modules.Chat.Style")

-- Lua
local _G = getfenv(0)

local alertingFrames = {}

-- Fading constants
local DOCK_FADE_IN_DURATION = 0.2

local _, class = UnitClass("player")
local color = C_ClassColor.GetClassColor(class)

-- Check whether any alerting chat frame has its tab hidden (behind the
-- overflow) and update the overflow button glow accordingly.
local function UpdateOverflowGlow()
    local overflowButton = GeneralDockManager and GeneralDockManager.overflowButton
    if not overflowButton then
        return
    end

    for chatFrame in next, alertingFrames do
        local tab = _G[chatFrame:GetName() .. "Tab"]
        if tab and not tab:IsShown() then
            break
        end
    end
end

function Style:HandleDock(frame)
    frame:SetHeight(20)
    frame.scrollFrame:SetHeight(20)
    frame.scrollFrame.child:SetHeight(20)

    frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    Style:SecureHook(frame.scrollFrame, "SetPoint", function(self, p, anchor, rP, x, _, shouldIgnore)
        if shouldIgnore then
            return
        end

        if p == "BOTTOMRIGHT" and anchor == frame then
            self:SetPoint(p, anchor, rP, x, 1, true)
        end
    end)

    Style:HandleOverflowButton(frame.overflowButton)
end

function Style:EnableAlerts()
    Style:SecureHook("FCF_StartAlertFlash", function(chatFrame)
        alertingFrames[chatFrame] = true

        Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION)
        UpdateOverflowGlow()
    end)

    Style:SecureHook("FCF_StopAlertFlash", function(chatFrame)
        alertingFrames[chatFrame] = nil
        UpdateOverflowGlow()
    end)
end

function Style:ForChatFrame(id, method, ...)
    local frame = _G["ChatFrame" .. id]
    if frame and frame[method] then
        frame[method](frame, ...)
    end
end
