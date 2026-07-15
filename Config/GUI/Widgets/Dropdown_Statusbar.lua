local mGUI = mUI.mGUI

function mGUI.Widgets.DropdownStatusbar(parent)
    local container = mGUI.Widgets.Dropdown(parent)
    local LSM = LibStub("LibSharedMedia-3.0")
    container.labelFromKey = true

    container.DecorateEntry = function(radio, key)
        radio:AddInitializer(function(button)
            local path = LSM:Fetch("statusbar", key, true)
            if not path then
                return
            end
            local bar = button:AttachTexture()
            bar:SetDrawLayer("BACKGROUND")
            bar:SetPoint("TOPLEFT", 1, -1)
            bar:SetPoint("BOTTOMRIGHT", -1, 1)
            bar:SetTexture(path)
            bar:SetVertexColor(0.65, 0.65, 0.65, 0.45)
        end)
    end

    return container
end
