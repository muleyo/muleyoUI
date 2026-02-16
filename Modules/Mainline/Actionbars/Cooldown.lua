local Cooldown = mUI:NewModule("mUI.Modules.Actionbars.Cooldown", "AceEvent-3.0")

function Cooldown:OnInitialize()
    function Cooldown:UpdateAll()
        local _, canGlide = C_PlayerInfo.GetGlidingInfo()
        if canGlide then
            return
        end

        for _, button in pairs(ActionBarButtonEventsFrame.frames) do
            if button.action then
                local cd = C_ActionBar.GetActionCooldown(button.action)

                if button.cooldown:IsShown() and not cd.isOnGCD then
                    button.icon:SetDesaturated(true)
                else
                    button.icon:SetDesaturated(false)
                end
            end
        end
    end
end

function Cooldown:OnEnable()
    Cooldown:RegisterEvent("SPELL_UPDATE_COOLDOWN", "UpdateAll")
end

function Cooldown:OnDisable()
    Cooldown:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
end
