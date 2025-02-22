local Casttime = mUI:NewModule("mUI.Modules.Castbars.Casttime")

function Casttime:OnInitialize()
    -- Tables
    self.castbars = {
        player = "PlayerCastingBarFrame",
        target = "TargetFrameSpellBar",
        focus = "FocusFrameSpellBar",
        boss1 = "Boss1TargetFrameSpellBar",
        boss2 = "Boss2TargetFrameSpellBar",
        boss3 = "Boss3TargetFrameSpellBar",
        boss4 = "Boss4TargetFrameSpellBar",
        boss5 = "Boss5TargetFrameSpellBar"
    }

    for unitframe, castbar in pairs(self.castbars) do
        if unitframe == "player" then
            _G[castbar].timer = _G[castbar]:CreateFontString(nil)
            _G[castbar].timer:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            _G[castbar].timer:SetPoint("LEFT", _G[castbar], "RIGHT", 5, 0)
            _G[castbar].update = 0.1
        else
            _G[castbar].timer = _G[castbar]:CreateFontString(nil)
            _G[castbar].timer:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            _G[castbar].timer:SetPoint("LEFT", _G[castbar], "RIGHT", 4, 0)
            _G[castbar].update = 0.1
        end
    end

    function self:Update(frame, elapsed)
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
    mUI:HookScript(PlayerCastingBarFrame, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(FocusFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(Boss1TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(Boss2TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(Boss3TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(Boss4TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)

    mUI:HookScript(Boss5TargetFrameSpellBar, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)
end

function Casttime:OnDisable()
    mUI:Unhook(PlayerCastingBarFrame, "OnUpdate")
    mUI:Unhook(TargetFrameSpellBar, "OnUpdate")
    mUI:Unhook(FocusFrameSpellBar, "OnUpdate")
    mUI:Unhook(Boss1TargetFrameSpellBar, "OnUpdate")
    mUI:Unhook(Boss2TargetFrameSpellBar, "OnUpdate")
    mUI:Unhook(Boss3TargetFrameSpellBar, "OnUpdate")
    mUI:Unhook(Boss4TargetFrameSpellBar, "OnUpdate")
    mUI:Unhook(Boss5TargetFrameSpellBar, "OnUpdate")

    for unitframe, castbar in pairs(self.castbars) do
        _G[castbar].timer:SetText("")
    end
end
