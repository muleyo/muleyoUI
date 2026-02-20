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

    for unitframe, castbar in pairs(Casttime.castbars) do
        if unitframe == "player" then
            _G[castbar].timer = _G[castbar]:CreateFontString(nil)
            _G[castbar].timer:SetFont(Casttime.font, 14, "OUTLINE")
            _G[castbar].timer:SetPoint("LEFT", _G[castbar], "RIGHT", 5, 0)
        else
            _G[castbar].timer = _G[castbar]:CreateFontString(nil)
            _G[castbar].timer:SetFont(Casttime.font, 11, "OUTLINE")
            _G[castbar].timer:SetPoint("LEFT", _G[castbar], "RIGHT", 4, 0)
        end
    end

    function Casttime:Update(frame)
        if frame.casting then
            local duration = UnitCastingDuration(frame.unit)
            local remaining = duration:GetRemainingDuration()
            frame.timer:SetText(format("%.1f", remaining))
        elseif frame.channeling then
            local duration = UnitChannelDuration(frame.unit)
            local remaining = duration:GetRemainingDuration()
            frame.timer:SetText(format("%.1f", remaining, 0))
        else
            frame.timer:SetText("")
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
        _G[castbar].timer:SetText("")
    end
end
