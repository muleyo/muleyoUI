local mGUI = mUI.mGUI

mGUI.categories = {}

function mGUI:RegisterCategory(key, options)
    self.categories[key] = {
        options = options
    }
end

function mGUI:Select(key)
    local Gui = mUI:GetModule("mUI.Config.Gui")
    Gui:SelectByKey(key)
end
