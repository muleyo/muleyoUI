local Cooldown = mUI:NewModule("mUI.Modules.Actionbars.Cooldown", "AceHook-3.0")

function Cooldown:OnInitialize()
    Cooldown.duration = C_DurationUtil.CreateDuration()

    function Cooldown:Update(button)
        if button.action then
            -- Get Cooldown Info
            local cd = C_ActionBar.GetActionCooldown(button.action)

            if button.cooldown:IsShown() and not cd.isOnGCD then
                button.icon:SetDesaturated(true)
            else
                button.icon:SetDesaturated(false)
            end
        end
    end
end

function Cooldown:OnEnable()
    Cooldown:SecureHook("ActionButton_UpdateCooldown", function(button)
        Cooldown:Update(button)
    end)
end

function Cooldown:OnCooldownDone()
    Cooldown:UnhookAll()
end
