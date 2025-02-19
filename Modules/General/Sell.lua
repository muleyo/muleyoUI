local Sell = mUI:NewModule("mUI.Modules.General.Sell")

function Sell:OnInitialize()
    self.sell = CreateFrame("Frame")
    self.sell:SetScript("OnEvent", function(_, event)
        if not event == "MERCHANT_SHOW" then return end

        local bag, slot
        for bag = 0, 4 do
            for slot = 0, C_Container.GetContainerNumSlots(bag) do
                local link = C_Container.GetContainerItemLink(bag, slot)
                if link and (select(3, C_Item.GetItemInfo(link)) == 0) then
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end)
end

function Sell:OnEnable()
    self.sell:RegisterEvent("MERCHANT_SHOW")
end

function Sell:OnDisable()
    self.sell:UnregisterEvent("MERCHANT_SHOW")
end
