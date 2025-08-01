local Dampening = mUI:NewModule("mUI.Modules.Misc.Dampening", "AceHook-3.0")

function Dampening:OnInitialize()
    -- Create Frame
    Dampening.frame = CreateFrame("Frame", "mUIDampeningDisplay", UIParent, "UIWidgetTemplateIconAndText")

    -- Variables
    if mUI:IsClassic() then
        Dampening.widgetInfo = C_UIWidgetManager.GetTopCenterWidgetSetID()
    else
        Dampening.widgetInfo = C_UIWidgetManager.GetWidgetSetInfo(C_UIWidgetManager.GetTopCenterWidgetSetID())
    end
    Dampening.spellInfo = C_Spell.GetSpellInfo(110310)

    if mUI:IsClassic() then
        Dampening.frame:SetPoint("CENTER", UIWidgetTopCenterContainerFrame, "CENTER", 0, -5)
    else
        Dampening.frame:SetPoint(
            UIWidgetTopCenterContainerFrame.verticalAnchorPoint,
            UIWidgetTopCenterContainerFrame,
            UIWidgetTopCenterContainerFrame.verticalRelativePoint,
            0,
            Dampening.widgetInfo.verticalPadding)
    end
    Dampening.frame.Text:SetParent(Dampening.frame)
    Dampening.frame:SetWidth(200)
    Dampening.frame.Text:SetAllPoints()
    Dampening.frame.Text:SetJustifyH("CENTER")


    function Dampening:Update(event)
        Dampening.frame:Show()
        if event == "PLAYER_ENTERING_WORLD" then
            local _, instanceType = IsInInstance()

            if instanceType == "arena" then
                Dampening.frame:RegisterUnitEvent("UNIT_AURA", "player")
                Dampening.frame:Show()
            else
                Dampening.frame:UnregisterEvent("UNIT_AURA")
                Dampening.frame:Hide()
            end
        else
            local percent = C_Commentator.GetDampeningPercent()
            if percent and percent > 0 then
                if not Dampening.frame:IsShown() then Dampening.frame:Show() end
                if Dampening.value ~= percent then
                    Dampening.value = percent
                    Dampening.frame.Text:SetText(Dampening.spellInfo.name .. " " .. percent .. "%")
                end
            elseif Dampening.frame:IsShown() then
                Dampening.frame:Hide()
            end
        end
    end
end

function Dampening:OnEnable()
    Dampening.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    Dampening:SecureHookScript(Dampening.frame, "OnEvent", Dampening.Update)
end

function Dampening:OnDisable()
    Dampening.frame:UnregisterAllEvents()
    Dampening.frame:Hide()
    Dampening:UnhookAll()
end
