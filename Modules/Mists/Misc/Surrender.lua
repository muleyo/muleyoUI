local Surrender = mUI:NewModule("mUI.Modules.Misc.Surrender")

function Surrender:OnEnable()
    SLASH_SURRENDERGG1 = "/gg"
    SlashCmdList.SURRENDERGG = SurrenderArena

    SLASH_SURRENDERSR1 = "/sr"
    SlashCmdList.SURRENDERSR = SurrenderArena
end
