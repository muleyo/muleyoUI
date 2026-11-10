local Cooldown = mUI:NewModule("mUI.Modules.Actionbars.Cooldown", "AceEvent-3.0")

function Cooldown:OnInitialize()
    -- The cooldown of Auto Attack, Auto Shot, Shoot and the like is the swing timer of the weapon, not a cooldown of an ability
    local function IsSwingTimer(action, actionType, id)
        if C_ActionBar.IsAttackAction(action) or C_ActionBar.IsAutoRepeatAction(action) then
            return true
        end

        local spellID
        if actionType == "spell" then
            spellID = id
        elseif actionType == "macro" then
            spellID = GetMacroSpell(id)
        end

        if not spellID then
            return false
        end

        return C_Spell.IsAutoAttackSpell(spellID) or C_Spell.IsRangedAutoAttackSpell(spellID) or
            C_Spell.IsAutoRepeatSpell(spellID)
    end

    function Cooldown:UpdateAll()
        for _, button in pairs(ActionBarButtonEventsFrame.frames) do
            if button.action then
                local actionType, id = GetActionInfo(button.action)

                local cd = C_ActionBar.GetActionCooldown(button.action)

                if actionType == "item" then
                    if button.cooldown:IsShown() then
                        button.icon:SetDesaturated(true)
                    else
                        button.icon:SetDesaturated(false)
                    end
                elseif IsSwingTimer(button.action, actionType, id) then
                    button.icon:SetDesaturated(false)
                else
                    if cd and not issecretvalue(cd.duration) then
                        if cd.duration > 1.5 then
                            button.icon:SetDesaturated(true)
                        else
                            button.icon:SetDesaturated(false)
                        end
                    else
                        if cd and button.cooldown:IsShown() and not cd.isOnGCD then
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
