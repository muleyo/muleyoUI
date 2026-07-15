local mGUI = mUI.mGUI

local fontObjects = {}

local function GetFontObject(key, path)
    local fontObject = fontObjects[key]
    if not fontObject then
        fontObject = CreateFont("mGUIFontPreview_" .. key)
        fontObject:SetFont(path, 12, "")
        fontObject:SetTextColor(1, 1, 1)
        fontObjects[key] = fontObject
    end
    return fontObject
end

function mGUI.Widgets.DropdownFont(parent)
    local container = mGUI.Widgets.Dropdown(parent)
    local LSM = LibStub("LibSharedMedia-3.0")
    container.labelFromKey = true

    container.DecorateEntry = function(radio, key)
        radio:AddInitializer(function(button)
            local fontString = button.fontString
            local path = LSM:Fetch("font", key, true)
            if fontString and path then
                fontString:SetFontObject(GetFontObject(key, path))
            end
        end)
    end

    return container
end
