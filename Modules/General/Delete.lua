local Delete = mUI:NewModule("mUI.Modules.General.Delete", "AceHook-3.0")

function Delete:OnInitialize()
    Delete.delete = CreateFrame("Frame")

    function Delete:Update(event)
        if not event == "DELETE_ITEM_CONFIRM" then return end

        if StaticPopup1EditBox:IsVisible() then
            StaticPopup1EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)
        elseif StaticPopup2EditBox:IsVisible() then
            StaticPopup2EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)
        end
    end
end

function Delete:OnEnable()
    Delete.delete:RegisterEvent("DELETE_ITEM_CONFIRM")
    Delete:HookScript(Delete.delete, "OnEvent", function(_, event)
        Delete:Update(event)
    end)
end

function Delete:OnDisable()
    Delete.delete:UnregisterEvent("DELETE_ITEM_CONFIRM")
    Delete:UnhookAll()
end
