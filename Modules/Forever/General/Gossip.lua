local Gossip = mUI:NewModule("mUI.Modules.General.Gossip", "AceHook-3.0")

function Gossip:OnInitialize()
    Gossip.frame = CreateFrame("Frame")
    Gossip.frame:RegisterEvent("GOSSIP_SHOW")
    function Gossip:Automate()
        if IsModifierKeyDown() then
            return
        end
        local options = C_GossipInfo.GetOptions()
        if #options == 1 then
            C_GossipInfo.SelectOption(options[1].gossipOptionID)
        end
    end
end

function Gossip:OnEnable()
    Gossip:SecureHookScript(Gossip.frame, "OnEvent", Gossip.Automate)
end

function Gossip:OnDisable()
    Gossip:UnhookAll()
end
