local Healthtext = mUI:NewModule("mUI.Modules.Unitframes.Healthtext", "AceHook-3.0")

local function CollectBars()
    local bars = {}
    if PlayerFrame and PlayerFrame.healthbar then
        bars[PlayerFrame.healthbar] = true
    end
    if TargetFrame and TargetFrame.healthbar then
        bars[TargetFrame.healthbar] = true
    end
    if FocusFrame and FocusFrame.healthbar then
        bars[FocusFrame.healthbar] = true
    end
    return bars
end

function Healthtext:OnEnable()
    Healthtext.bars = CollectBars()

    -- alwaysShow makes TextStatusBar_UpdateTextStringWithValues format the
    -- numeric value/max even when the per-frame status-text CVar is "0".
    for bar in pairs(Healthtext.bars) do
        bar.alwaysShow = true
        if TextStatusBar_UpdateTextString then
            TextStatusBar_UpdateTextString(bar)
        end
        if bar.TextString then
            bar.TextString:Show()
        end
    end

    -- Blizzard re-runs UpdateTextString on every value change and may :Hide()
    -- the text when lockShow drops to 0 (mouse leave). Re-show ours after.
    Healthtext:SecureHook("TextStatusBar_UpdateTextString", function(bar)
        if Healthtext.bars[bar] and bar.TextString then
            bar.TextString:Show()
        end
    end)
end

function Healthtext:OnDisable()
    Healthtext:UnhookAll()
    for bar in pairs(Healthtext.bars or {}) do
        bar.alwaysShow = nil
        if TextStatusBar_UpdateTextString then
            TextStatusBar_UpdateTextString(bar)
        end
    end
    Healthtext.bars = {}
end
