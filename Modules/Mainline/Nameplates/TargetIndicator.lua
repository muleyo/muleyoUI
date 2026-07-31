local TargetIndicator = mUI:NewModule("mUI.Modules.Nameplates.TargetIndicator")

function TargetIndicator:OnInitialize()
    -- Load Database
    TargetIndicator.db = mUI.db.profile.nameplates

    TargetIndicator.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    TargetIndicator.Units = mUI:GetModule("mUI.Modules.Nameplates.Units")

    local Core = TargetIndicator.Core
    local Units = TargetIndicator.Units

    local ARROW_LEFT = [[Interface\AddOns\mUI\Media\Textures\Nameplates\arrowLeft.png]]
    local ARROW_RIGHT = [[Interface\AddOns\mUI\Media\Textures\Nameplates\arrowRight.png]]

    TargetIndicator.handler = {}

    function TargetIndicator.handler.Create(plate)
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetFrameLevel(plate:GetFrameLevel() + 6)
        holder:SetAllPoints(plate)
        holder:Hide()

        holder.left = holder:CreateTexture(nil, "OVERLAY")
        holder.left:SetTexture(ARROW_LEFT)

        holder.right = holder:CreateTexture(nil, "OVERLAY")
        holder.right:SetTexture(ARROW_RIGHT)

        plate.TargetIndicator = holder
    end

    function TargetIndicator.handler.Update(plate, data)
        local holder = plate.TargetIndicator
        if not holder then
            return
        end

        local hideBar = data.isFriend and data.isPlayer and not data.canAttack and TargetIndicator.db.friendly.hidehealthbar

        holder:SetShown(data.isTarget == true and not hideBar)
    end

    function TargetIndicator.handler.Layout(plate, data)
        local holder = plate.TargetIndicator
        local health = holder and holder:IsShown() and Core:GetHealthBar(plate)
        if not health then
            return
        end

        local config = TargetIndicator.db.target

        holder.left:SetShown(config.arrows)
        holder.right:SetShown(config.arrows)

        if not config.arrows then
            return
        end

        local size = config.size
        local r, g, b, a = config.color[1], config.color[2], config.color[3], config.color[4] or 1
        local classFile = config.classcolor and Units:GetClassFile(data)
        if classFile then
            local classColor = C_ClassColor.GetClassColor(classFile)
            if classColor then
                r, g, b, a = classColor.r, classColor.g, classColor.b, 1
            end
        end

        holder.left:SetSize(size, size)
        holder.right:SetSize(size, size)
        holder.left:ClearAllPoints()
        holder.right:ClearAllPoints()
        holder.left:SetPoint("RIGHT", health, "LEFT", -config.offset, 0)
        holder.right:SetPoint("LEFT", health, "RIGHT", config.offset, 0)
        holder.left:SetVertexColor(r, g, b, a)
        holder.right:SetVertexColor(r, g, b, a)
    end

    function TargetIndicator.handler.Remove(plate)
        local holder = plate.TargetIndicator
        if holder then
            holder:Hide()
        end
    end

    function TargetIndicator:Update()
        Core:UpdateAll()
    end
end

function TargetIndicator:OnEnable()
    TargetIndicator.db = mUI.db.profile.nameplates
    TargetIndicator.Core:Register("TargetIndicator", TargetIndicator.handler)
end

function TargetIndicator:OnDisable()
    TargetIndicator.Core:Unregister("TargetIndicator")
end
