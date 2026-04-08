local Casttime = mUI:NewModule("mUI.Modules.Castbars.Casttime", "AceHook-3.0")

function Casttime:OnInitialize()
    -- Load Database
    Casttime.db = mUI.db.profile.general

    -- Tables
    Casttime.castbars = {
        player = "PlayerCastingBarFrame",
        target = "TargetFrameSpellBar",
        focus = "FocusFrameSpellBar",
        boss1 = "Boss1TargetFrameSpellBar",
        boss2 = "Boss2TargetFrameSpellBar",
        boss3 = "Boss3TargetFrameSpellBar",
        boss4 = "Boss4TargetFrameSpellBar",
        boss5 = "Boss5TargetFrameSpellBar"
    }

    Casttime.LSM = LibStub("LibSharedMedia-3.0")
    Casttime.font = Casttime.LSM:Fetch('font', Casttime.db.font)

    -- Store timer fontstrings in a separate table to avoid tainting secure frame tables (barType)
    Casttime.timers = {}

    for unitframe, castbar in pairs(Casttime.castbars) do
        local frame = _G[castbar]
        Casttime.timers[frame] = frame:CreateFontString(nil)
        if unitframe == "player" then
            Casttime.timers[frame]:SetFont(Casttime.font, 14, "OUTLINE")
            Casttime.timers[frame]:SetPoint("LEFT", frame, "RIGHT", 5, 0)
        else
            Casttime.timers[frame]:SetFont(Casttime.font, 11, "OUTLINE")
            Casttime.timers[frame]:SetPoint("LEFT", frame, "RIGHT", 4, 0)
        end
    end

    function Casttime:Update(frame)
        local timer = Casttime.timers[frame]
        if not timer then
            return
        end
        if frame.casting then
            local duration = UnitCastingDuration(frame.unit)
            if duration then
                local remaining = duration:GetRemainingDuration()
                timer:SetText(format("%.1f", remaining))
            end
        elseif frame.channeling then
            local duration = UnitChannelDuration(frame.unit)
            if duration then
                local remaining = duration:GetRemainingDuration()
                timer:SetText(format("%.1f", remaining, 0))
            end
        else
            timer:SetText("")
        end
    end
end

function Casttime:OnEnable()
    for _, castbar in pairs(Casttime.castbars) do
        local frame = _G[castbar]
        if frame then
            Casttime:SecureHookScript(frame, "OnUpdate", function(frame)
                Casttime:Update(frame)
            end)
        end
    end
end

function Casttime:OnDisable()
    Casttime:UnhookAll()

    for _, castbar in pairs(Casttime.castbars) do
        local timer = Casttime.timers[_G[castbar]]
        if timer then
            timer:SetText("")
        end
    end
end
