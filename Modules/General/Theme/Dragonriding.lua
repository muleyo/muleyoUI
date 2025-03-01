local Theme = mUI:GetModule("mUI.Modules.General.Theme")

function Theme:StyleDragonriding()
    for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
        mUI:Skin(child)
        for _, vigor in ipairs({ child:GetChildren() }) do
            Theme.dragonridingDefault = select(5, vigor:GetRegions()):GetVertexColor()
            mUI:Skin(vigor)
        end
    end
end
