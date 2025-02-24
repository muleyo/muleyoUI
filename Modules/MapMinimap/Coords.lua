local Coords = mUI:NewModule("mUI.MapMinimap.Coords")

function Coords:OnInitialize()
    -- Create Frame
    self.coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)

    -- Variables
    self.int = 0

    -- Set Framelevel
    self.coords:SetFrameLevel(WorldMapFrame.BorderFrame:GetFrameLevel() + 2)
    self.coords:SetFrameStrata(WorldMapFrame.BorderFrame:GetFrameStrata())

    -- Create Fontstrings
    self.coords.PlayerText = self.coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    self.coords.MouseText = self.coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")

    -- Set Points
    self.coords.PlayerText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer, "BOTTOM", 5, 20)
    self.coords.PlayerText:SetJustifyH("LEFT")
    self.coords.PlayerText:SetText(UnitName("player") .. ": 0,0")
    self.coords.MouseText:SetJustifyH("LEFT")
    self.coords.MouseText:SetPoint("BOTTOMLEFT", self.coords.PlayerText, "TOPLEFT", 0, 5)
    self.coords.MouseText:SetText(": 0,0")

    self.coords:Hide()

    function self:Update()
        self.int = self.int + 1
        if self.int >= 3 then
            local UnitMap = C_Map.GetBestMapForUnit("player")
            local x, y = 0, 0

            if UnitMap then
                local GetPlayerMapPosition = C_Map.GetPlayerMapPosition(UnitMap, "player")
                if GetPlayerMapPosition then
                    x, y = GetPlayerMapPosition:GetXY()
                end
            end

            x = math.floor(100 * x)
            y = math.floor(100 * y)
            if x ~= 0 and y ~= 0 then
                self.coords.PlayerText:SetText(UnitName("player") .. ": " .. x .. "," .. y)
            else
                self.coords.PlayerText:SetText(UnitName("player") .. ": " .. "|cffff0000" .. "|r")
            end

            local scale = WorldMapFrame.ScrollContainer:GetEffectiveScale()
            local width = WorldMapFrame.ScrollContainer:GetWidth()
            local height = WorldMapFrame.ScrollContainer:GetHeight()
            local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter()
            local x, y = GetCursorPosition()
            local adjustedX = (x / scale - (centerX - (width / 2))) / width
            local adjustedY = (centerY + (height / 2) - y / scale) / height

            if adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
                adjustedX = math.floor(100 * adjustedX)
                adjustedY = math.floor(100 * adjustedY)
                self.coords.MouseText:SetText("Mouse: " .. adjustedX .. "," .. adjustedY)
            else
                self.coords.MouseText:SetText("|cffff0000" .. "|r")
            end
            self.int = 0
        end
    end
end

function Coords:OnEnable()
    self.coords:Show()
    mUI:HookScript(WorldMapFrame, "OnUpdate", function()
        self:Update()
    end)
end

function Coords:OnDisable()
    self.coords:Hide()
    mUI:Unhook(WorldMapFrame, "OnUpdate")
end
