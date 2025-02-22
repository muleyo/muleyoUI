local Classcolor = mUI:NewModule("mUI.Modules.Unitframes.Color")

function Classcolor:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.unitframes

    -- Create Frame
    self.classcolor = CreateFrame("Frame")

    -- Variables
    self.playerFrame = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
    self.originalTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health"

    -- Create Tables
    self.frames = {
        player = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain,
        target = TargetFrame.TargetFrameContent.TargetFrameContentMain,
        focus = FocusFrame.TargetFrameContent.TargetFrameContentMain,
        boss1 = Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain,
        boss2 = Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain,
        boss3 = Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain,
        boss4 = Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain,
        boss5 = Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain
    }

    self.unitframes = {
        player = PlayerFrame,
        pet = PetFrame,
        target = TargetFrame,
        focus = FocusFrame,
        targettarget = TargetFrameToT,
        focustarget = FocusFrameToT,
        boss1 = Boss1TargetFrame,
        boss2 = Boss2TargetFrame,
        boss3 = Boss3TargetFrame,
        boss4 = Boss4TargetFrame,
        boss5 = Boss5TargetFrame,
        party1 = PartyFrame.MemberFrame1,
        party2 = PartyFrame.MemberFrame2,
        party3 = PartyFrame.MemberFrame3,
        party4 = PartyFrame.MemberFrame4
    }

    function self:SetColor(frame, unit)
        local unitframe = self.frames[unit]
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
            local _, class = UnitClass(unit)
            local color = RAID_CLASS_COLORS[class]
            frame:SetStatusBarDesaturated(true)
            frame:SetStatusBarColor(color.r, color.g, color.b)
            if unitframe and unitframe.ReputationColor then
                unitframe.ReputationColor:SetVertexColor(color.r, color.g, color.b)
            end
        elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
            frame:SetStatusBarDesaturated(true)
            frame:SetStatusBarColor(0.5, 0.5, 0.5)
            if unitframe and unitframe.ReputationColor then
                unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
            end
        else
            if UnitExists(unit) then
                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                    frame:SetStatusBarDesaturated(true)
                    frame:SetStatusBarColor(0.5, 0.5, 0.5)
                    if unitframe and unitframe.ReputationColor then
                        unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
                    end
                elseif (not UnitIsTapDenied(unit)) then
                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                    if reaction then
                        frame:SetStatusBarDesaturated(true)
                        frame:SetStatusBarColor(reaction.r, reaction.g, reaction.b)

                        if unitframe and unitframe.ReputationColor then
                            unitframe.ReputationColor:SetVertexColor(reaction.r, reaction.g, reaction.b)
                        end
                    end
                end
            end
        end
    end

    function self:Update()
        for _, frame in pairs(self.unitframes) do
            self:SetColor(frame.healthbar, frame.unit)
        end
    end
end

function Classcolor:OnEnable()
    -- Hook Frame
    mUI:HookScript(self.classcolor, "OnUpdate", function(_, _, _)
        self:Update()
    end)

    -- Update PlayerFrame HealthColor
    local _, playerClass = UnitClass("player")
    local color = RAID_CLASS_COLORS[playerClass]
    self.playerFrame.ReputationColor:SetVertexColor(color.r, color.g, color.b)
    self.playerFrame.HealthBarsContainer.HealthBar:SetStatusBarDesaturated(true)
    self.playerFrame.HealthBarsContainer.HealthBar:SetStatusBarColor(color.r, color.g, color.b)
end

function Classcolor:OnDisable()
    -- Unhook
    mUI:Unhook(self.classcolor, "OnUpdate")

    -- Reset Colors
    self.playerFrame.ReputationColor:SetVertexColor(0, 0, 1)
    if self.db.textures.unitframes == "None" then
        for _, frame in pairs(self.frames) do
            frame.HealthBarsContainer.HealthBar:SetStatusBarDesaturated(false)
            frame.HealthBarsContainer.HealthBar:SetStatusBarColor(1, 1, 1)
        end
    else
        for _, frame in pairs(self.frames) do
            frame.HealthBarsContainer.HealthBar.unitFrame.healthbar:SetStatusBarColor(0, 1, 0)
        end
    end
end
