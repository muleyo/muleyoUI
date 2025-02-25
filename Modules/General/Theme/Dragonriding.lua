local Theme = mUI:GetModule("mUI.Modules.General.Theme")

function Theme:StyleDragonriding()
    for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
        mUI:Skin(child)
        for _, vigor in ipairs({ child:GetChildren() }) do
            if not Theme.forbiddenFrames[select(5, vigor:GetRegions())] then
                Theme.forbiddenFrames[select(5, vigor:GetRegions())] = true
            end
            mUI:Skin(vigor)
        end
    end
end
