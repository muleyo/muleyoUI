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
            _G[castbar].update = 0.1
        else
            _G[castbar].timer = _G[castbar]:CreateFontString(nil)
            _G[castbar].timer:SetFont(Casttime.font, 11, "OUTLINE")
            _G[castbar].timer:SetPoint("LEFT", _G[castbar], "RIGHT", 4, 0)
            _G[castbar].update = 0.1
        end
    end

    function Casttime:Update(frame, elapsed)
        if frame.update and frame.update < elapsed then
            if frame.casting then
                frame.timer:SetText(format("%.1f", max(frame.maxValue - frame.value, 0)))
            elseif frame.channeling then
                frame.timer:SetText(format("%.1f", max(frame.value, 0)))
            else
                frame.timer:SetText("")
            end
            frame.update = 0.1
        else
            frame.update = frame.update - elapsed
        end
    end
end

function Casttime:OnEnable()
    PlayerCastingBarFrame.CastTimeText:Hide()
    Casttime:HookScript(PlayerCastingBarFrame, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
        frame.CastTimeText:Hide()
    end)

    Casttime:HookScript(TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)

    Casttime:HookScript(FocusFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)

    Casttime:HookScript(Boss1TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)

    Casttime:HookScript(Boss2TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)

    Casttime:HookScript(Boss3TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)

    Casttime:HookScript(Boss4TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)

    Casttime:HookScript(Boss5TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        Casttime:Update(frame, elapsed)
    end)
end

function Casttime:OnDisable()
    Casttime:UnhookAll()

    for _, castbar in pairs(Casttime.castbars) do
        _G[castbar].timer:SetText("")
    end
end
