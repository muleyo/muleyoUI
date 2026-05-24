local Powertext = mUI:NewModule("mUI.Modules.Unitframes.Powertext", "AceHook-3.0")

-- "manabar" is Blizzard's name for the primary power bar on each unit
-- frame regardless of resource type (mana, energy, rage, focus, runic
-- power, etc.) -- the field name is legacy and doesn't reflect content.
local function CollectBars()
    local bars = {}
    if PlayerFrame and PlayerFrame.manabar then
        bars[PlayerFrame.manabar] = true
    end
    if TargetFrame and TargetFrame.manabar then
        bars[TargetFrame.manabar] = true
    end
    if FocusFrame and FocusFrame.manabar then
        bars[FocusFrame.manabar] = true
    end
    return bars
end

function Powertext:OnEnable()
    Powertext.bars = CollectBars()

    for bar in pairs(Powertext.bars) do
        bar.alwaysShow = true
        if TextStatusBar_UpdateTextString then
            TextStatusBar_UpdateTextString(bar)
        end
        if bar.TextString then
            bar.TextString:Show()
        end
    end

    Powertext:SecureHook("TextStatusBar_UpdateTextString", function(bar)
        if Powertext.bars[bar] and bar.TextString then
            bar.TextString:Show()
        end
    end)
end

function Powertext:OnDisable()
    Powertext:UnhookAll()
    for bar in pairs(Powertext.bars or {}) do
        bar.alwaysShow = nil
        if TextStatusBar_UpdateTextString then
            TextStatusBar_UpdateTextString(bar)
        end
    end
    Powertext.bars = {}
end
