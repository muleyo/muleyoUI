local Classcolor = mUI:NewModule("mUI.Modules.Unitframes.Color", "AceHook-3.0")

function Classcolor:OnInitialize()
    -- Load Database
    Classcolor.db = mUI.db.profile.unitframes

    -- Create Frame
    Classcolor.classcolor = CreateFrame("Frame")
    Classcolor.classcolor:RegisterEvent("PLAYER_ENTERING_WORLD")
    Classcolor.classcolor:RegisterEvent("UNIT_HEALTH")
    Classcolor.classcolor:RegisterEvent("UNIT_TARGET")
    Classcolor.classcolor:RegisterEvent("PLAYER_TARGET_CHANGED")
    Classcolor.classcolor:RegisterEvent("PLAYER_FOCUS_CHANGED")

    -- Create Tables
    Classcolor.healthbars = {
        player = PlayerFrame.healthbar,
        pet = PetFrame.healthbar,
        target = TargetFrame.healthbar,
        focus = FocusFrame.healthbar,
        targettarget = TargetFrameToT.healthbar,
        focustarget = FocusFrameToT.healthbar,
        boss1 = Boss1TargetFrame.healthbar,
        boss2 = Boss2TargetFrame.healthbar,
        boss3 = Boss3TargetFrame.healthbar,
        boss4 = Boss4TargetFrame.healthbar,
        boss5 = Boss5TargetFrame.healthbar,
        party1 = PartyFrame.MemberFrame1.healthbar,
        party2 = PartyFrame.MemberFrame2.healthbar,
        party3 = PartyFrame.MemberFrame3.healthbar,
        party4 = PartyFrame.MemberFrame4.healthbar
    }

    function Classcolor:SetColor(healthbar, unit)
        healthbar.lockColor = true
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
            local _, class = UnitClass(unit)
            local color = RAID_CLASS_COLORS[class]
            healthbar:SetStatusBarColor(color.r, color.g, color.b)
        elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
            healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        else
            if UnitExists(unit) then
                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                    healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
                elseif (not UnitIsTapDenied(unit)) then
                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                    if reaction then
                        healthbar:SetStatusBarColor(reaction.r, reaction.g, reaction.b)
                    end
                end
            end
        end
    end

    function Classcolor:Update()
        for unit, healthbar in pairs(Classcolor.healthbars) do
            Classcolor:SetColor(healthbar, unit)
        end

        TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0.5)
        FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0.5)
    end
end

function Classcolor:OnEnable()
    -- Hook Frame
    Classcolor:SecureHookScript(Classcolor.classcolor, "OnEvent", Classcolor.Update)
end

function Classcolor:OnDisable()
    -- Unhook
    Classcolor:UnhookAll()

    -- Reset Colors
    for _, healthbar in pairs(Classcolor.healthbars) do
        healthbar:SetStatusBarColor(0, 1, 0)
    end
end
