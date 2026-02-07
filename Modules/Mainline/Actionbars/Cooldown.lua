local Cooldown = mUI:NewModule("mUI.Modules.Actionbars.Cooldown", "AceHook-3.0")

function Cooldown:OnInitialize()
    Cooldown.duration = C_DurationUtil.CreateDuration()

    function Cooldown:Update(button)
        if button.action then
            -- Get Cooldown Info
            local cd = C_ActionBar.GetActionCooldown(button.action)

            -- Skip if on GCD
            if cd.isOnGCD then
                return
            end

            -- Set Cooldown
            Cooldown.duration:SetTimeFromStart(cd.startTime, cd.duration)

            if Cooldown.duration:IsZero() then
                button.icon:SetDesaturated(false)
            else
                button.icon:SetDesaturated(true)
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
