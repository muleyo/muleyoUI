local Delete = mUI:NewModule("mUI.Modules.General.Delete")

function Delete:OnInitialize()
    self.delete = CreateFrame("Frame")
    self.delete:SetScript("OnEvent", function(_, event)
        if not event == "DELETE_ITEM_CONFIRM" then return end

        if StaticPopup1EditBox:IsVisible() then
            StaticPopup1EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)
        elseif StaticPopup2EditBox:IsVisible() then
            StaticPopup2EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)
        end
    end)
end

function Delete:OnEnable()
    self.delete:RegisterEvent("DELETE_ITEM_CONFIRM")
end

function Delete:OnDisable()
    self.delete:UnregisterEvent("DELETE_ITEM_CONFIRM")
end
