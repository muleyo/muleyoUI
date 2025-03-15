local Cooldown = mUI:NewModule("mUI.Modules.Actionbars.Cooldown", "AceHook-3.0")

function Cooldown:OnInitialize()
    function Cooldown:Update(button)
        local start, duration, enable, modRate = GetActionCooldown(button.action)
        if (duration and duration >= 1.5) then
            button.icon:SetDesaturated(true)
        else
            button.icon:SetDesaturated(false)
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
