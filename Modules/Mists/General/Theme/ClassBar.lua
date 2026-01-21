local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
function Theme:ClassBar()
    if (playerClass == "WARLOCK") then
        -- Destruction
        mUI:Skin({select(1, BurningEmbersBarFrameEmber1:GetRegions()),
                  select(1, BurningEmbersBarFrameEmber2:GetRegions()),
                  select(1, BurningEmbersBarFrameEmber3:GetRegions()),
                  select(1, BurningEmbersBarFrameEmber4:GetRegions()), BurningEmbersBarFrame.background}, true)

        -- Affliction
        mUI:Skin({select(1, select(5, ShardBarFrameShard1:GetRegions())),
                  select(1, select(5, ShardBarFrameShard2:GetRegions())),
                  select(1, select(5, ShardBarFrameShard3:GetRegions())),
                  select(1, select(5, ShardBarFrameShard4:GetRegions()))}, true)

        -- Demonology
        mUI:Skin({select(3, DemonicFuryBarFrame:GetRegions())}, true)
    elseif (playerClass == "MONK") then
        -- Monk
        mUI:Skin({select(2, MonkHarmonyBar:GetRegions()), select(6, MonkStaggerBar:GetRegions())}, true)
    elseif (playerClass == "DEATHKNIGHT") then
        -- Death Knight
        mUI:Skin({Rune1BorderTexture, Rune2BorderTexture, Rune3BorderTexture, Rune4BorderTexture, Rune5BorderTexture,
                  Rune6BorderTexture}, true)
    elseif (playerClass == "PALADIN") then
        -- Paladin
        mUI:Skin(PaladinPowerBar)
    elseif (playerClass == "PRIEST") then
        mUI:Skin({select(1, PriestBarFrame:GetRegions())}, true)
    end
end
