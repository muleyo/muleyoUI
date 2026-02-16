local Cooldown = mUI:NewModule("mUI.Modules.Actionbars.Cooldown", "AceEvent-3.0")

function Cooldown:OnInitialize()
    function Cooldown:UpdateAll()
        for _, button in pairs(ActionBarButtonEventsFrame.frames) do
            if button.action then
                local actionType = GetActionInfo(button.action)

                local cd = C_ActionBar.GetActionCooldown(button.action)

                if actionType == "item" then
                    if button.cooldown:IsShown() then
                        button.icon:SetDesaturated(true)
                    else
                        button.icon:SetDesaturated(false)
                    end
                else
                    if not issecretvalue(cd.duration) then
                        if cd.duration > 1.5 then
                            button.icon:SetDesaturated(true)
                        else
                            button.icon:SetDesaturated(false)
                        end
                    else
                        if button.cooldown:IsShown() and not cd.isOnGCD then
                            button.icon:SetDesaturated(true)
                        else
                            button.icon:SetDesaturated(false)
                        end
                    end
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
