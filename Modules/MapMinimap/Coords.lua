local Coords = mUI:NewModule("mUI.MapMinimap.Coords", "AceHook-3.0")

function Coords:OnInitialize()
    -- Create Frame
    Coords.coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)

    -- Variables
    Coords.int = 0

    -- Set Framelevel
    Coords.coords:SetFrameLevel(WorldMapFrame.BorderFrame:GetFrameLevel() + 2)
    Coords.coords:SetFrameStrata(WorldMapFrame.BorderFrame:GetFrameStrata())

    -- Create Fontstrings
    Coords.coords.PlayerText = Coords.coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Coords.coords.MouseText = Coords.coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")

    -- Set Points
    Coords.coords.PlayerText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer, "BOTTOM", 5, 20)
    Coords.coords.PlayerText:SetJustifyH("LEFT")
    Coords.coords.PlayerText:SetText(UnitName("player") .. ": 0,0")
    Coords.coords.MouseText:SetJustifyH("LEFT")
    Coords.coords.MouseText:SetPoint("BOTTOMLEFT", Coords.coords.PlayerText, "TOPLEFT", 0, 5)
    Coords.coords.MouseText:SetText(": 0,0")

    Coords.coords:Hide()

    function Coords:Update()
        Coords.int = Coords.int + 1
        if Coords.int >= 3 then
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
                Coords.coords.PlayerText:SetText(UnitName("player") .. ": " .. x .. "," .. y)
            else
                Coords.coords.PlayerText:SetText(UnitName("player") .. ": " .. "|cffff0000" .. "|r")
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
                Coords.coords.MouseText:SetText("Mouse: " .. adjustedX .. "," .. adjustedY)
            else
                Coords.coords.MouseText:SetText("|cffff0000" .. "|r")
            end
            Coords.int = 0
        end
    end
end

function Coords:OnEnable()
    Coords.coords:Show()
    Coords:HookScript(WorldMapFrame, "OnUpdate", function()
        Coords:Update()
    end)
end

function Coords:OnDisable()
    Coords.coords:Hide()
    Coords:UnhookAll()
end
