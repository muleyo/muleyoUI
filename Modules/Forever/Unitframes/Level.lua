local Level = mUI:NewModule("mUI.Modules.Unitframes.Level", "AceHook-3.0")

function Level:OnEnable()
    PlayerLevelText:SetText(nil)
    Level:SecureHook("PlayerFrame_UpdateLevel", function()
        PlayerLevelText:SetText(nil)
    end)

    TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText:SetAlpha(0)
    FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText:SetAlpha(0)
end

function Level:OnDisable()
    Level:Unhook("PlayerFrame_UpdateLevel")
    PlayerLevelText:SetText(UnitLevel("player"))

    TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText:SetAlpha(1)
    FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText:SetAlpha(1)
end
