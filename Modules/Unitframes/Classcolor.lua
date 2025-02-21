local Classcolor = mUI:NewModule("mUI.Modules.Unitframes.Classcolor")

function Classcolor:OnInitialize()
    function self:SetColor(healthbar, unit)
        healthbar:SetStatusBarDesaturated(1)
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
            _, class = UnitClass(unit)
            local color = RAID_CLASS_COLORS[class]
            healthbar:SetStatusBarColor(color.r, color.g, color.b)
        elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
            healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
        else
            if UnitExists(unit) then
                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                    healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
                elseif (not UnitIsTapDenied(unit)) then
                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                    if reaction then
                        healthbar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                    end
                end
            end
        end
    end
end

function Classcolor:OnEnable()
    mUI:SecureHook("UnitFrameHealthBar_Update", function(frame)
        self:SetColor(frame, frame.unit)
    end)
end

function Classcolor:OnDisable()
    mUI:Unhook("UnitFrameHealthBar_Update")
end
