local _, ns = ...
local EditMode = mUI:NewModule("mUI.EditMode", "AceHook-3.0")

function EditMode:OnInitialize()
    -- Load Database
    EditMode.db = mUI.db.profile.edit

    if mUI:GameVersion()["Vanilla"] then
        -- Initialize grid database settings if they don't exist
        if not EditMode.db.grid then
            EditMode.db.grid = {
                enabled = false,
                size = 32,
                alpha = 0.3,
                color = {1, 1, 1} -- White color
            }
        end

        -- Initialize snapping database settings if they don't exist
        if not EditMode.db.snapping then
            EditMode.db.snapping = {
                enabled = true,
                snapToFrames = true,
                snapToCenter = true,
                snapToGrid = false,
                snapDistance = 15,
                showSnapLines = true
            }
        end

        -- Initialize frame positions and scales database
        if not EditMode.db.frames then
            EditMode.db.frames = {}
        end

        -- Initialize action bar layout database if it doesn't exist
        if not mUI.db.profile.actionbars.layout then
            mUI.db.profile.actionbars.layout = {
                bar1 = {
                    buttonsPerRow = 12,
                    visibleButtons = 12
                },
                bar2 = {
                    buttonsPerRow = 12,
                    visibleButtons = 12
                },
                bar3 = {
                    buttonsPerRow = 12,
                    visibleButtons = 12
                },
                bar4 = {
                    buttonsPerRow = 1,
                    visibleButtons = 12
                },
                bar5 = {
                    buttonsPerRow = 1,
                    visibleButtons = 12
                }
            }
        end

        EditMode.defaults = {
            ["mUIStatsFrame"] = {
                point = "BOTTOMLEFT",
                relativeTo = "UIParent",
                relativePoint = "BOTTOMLEFT",
                xOffset = 0,
                yOffset = 0,
                scale = 1
            },
            ["mUIBuffFrame"] = {
                point = "TOPRIGHT",
                relativeTo = "UIParent",
                relativePoint = "TOPRIGHT",
                xOffset = -350,
                yOffset = -30,
                scale = 1
            },
            ["mUIDebuffFrame"] = {
                point = "TOPRIGHT",
                relativeTo = "UIParent",
                relativePoint = "TOPRIGHT",
                xOffset = -350,
                yOffset = -175,
                scale = 1
            },
            ["mUIActionBar1"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 0,
                yOffset = 100,
                scale = 1
            },
            ["mUIActionBar2"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 0,
                yOffset = 140,
                scale = 1
            },
            ["mUIActionBar3"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 0,
                yOffset = 180,
                scale = 1
            },
            ["mUIActionBar4"] = {
                point = "RIGHT",
                relativeTo = "UIParent",
                relativePoint = "RIGHT",
                xOffset = 0,
                yOffset = 0,
                scale = 1
            },
            ["mUIActionBar5"] = {
                point = "RIGHT",
                relativeTo = "UIParent",
                relativePoint = "RIGHT",
                xOffset = -40,
                yOffset = 0,
                scale = 1
            },
            ["mUIMicroMenu"] = {
                point = "BOTTOMRIGHT",
                relativeTo = "UIParent",
                relativePoint = "BOTTOMRIGHT",
                xOffset = 0,
                yOffset = 0,
                scale = 1
            },
            ["mUIBagBar"] = {
                point = "BOTTOMRIGHT",
                relativeTo = "UIParent",
                relativePoint = "BOTTOMRIGHT",
                xOffset = -5,
                yOffset = 40,
                scale = 1
            },
            ["mUIPetActionBar"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 61,
                yOffset = 221,
                scale = 1
            },
            ["mUIStanceBar"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = -128.5,
                yOffset = 221,
                scale = 1
            },
            ["mUIExpBar"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 0,
                yOffset = 85,
                scale = 1
            },
            ["mUITooltipFrame"] = {
                point = "BOTTOMRIGHT",
                relativeTo = "UIParent",
                relativePoint = "BOTTOMRIGHT",
                xOffset = -50,
                yOffset = 120,
                scale = 1
            },
            ["MainMenuBarVehicleLeaveButton"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 260,
                yOffset = 100,
                scale = 1
            },
            ["PlayerPowerBarAlt"] = {
                point = "TOP",
                relativeTo = "UIParent",
                relativePoint = "TOP",
                xOffset = 0,
                yOffset = -50,
                scale = 1
            },
            ["CastingBarFrame"] = {
                point = "CENTER",
                relativeTo = "UIParent",
                relativePoint = "CENTER",
                xOffset = 0,
                yOffset = -150,
                scale = 1
            }
        }

        if mUI:GameVersion()["Mists"] then
            EditMode.defaults["ExtraActionBarFrame"] = {
                point = "BOTTOM",
                relativeTo = "UIParent",
                relativePoint = "BOTTOM",
                xOffset = 250,
                yOffset = 150,
                scale = 1
            }
        end

        -- Common draggable frames for Classic
        if mUI.db.profile.actionbars.style == "mUI" then
            EditMode.availableFrames = { -- Unit Frames
            {
                frame = "PlayerFrame",
                name = "Player Frame"
            }, {
                frame = "TargetFrame",
                name = "Target Frame"
            }, {
                frame = "FocusFrame",
                name = "Focus Frame"
            }, -- Cast Bars
            {
                frame = "CastingBarFrame",
                name = "Player CastBar"
            }, -- Custom Buff/Debuff Anchors
            {
                frame = "mUIBuffFrame",
                name = "Buffs"
            }, {
                frame = "mUIDebuffFrame",
                name = "Debuffs"
            }, -- Custom mUI frames
            {
                frame = "mUIActionBar1",
                name = "ActionBar 1"
            }, {
                frame = "mUIActionBar2",
                name = "ActionBar 2"
            }, {
                frame = "mUIActionBar3",
                name = "ActionBar 3"
            }, {
                frame = "mUIActionBar4",
                name = "ActionBar 4"
            }, {
                frame = "mUIActionBar5",
                name = "ActionBar 5"
            }, {
                frame = "mUIMicroMenu",
                name = "Micro Menu"
            }, {
                frame = "mUIBagBar",
                name = "Bags Bar"
            }, {
                frame = "mUIPetActionBar",
                name = "Pet ActionBar"
            }, {
                frame = "mUIStanceBar",
                name = "Stance Bar"
            }, {
                frame = "mUIExpBar",
                name = "Experience Bar"
            }, {
                frame = "mUIStatsFrame",
                name = "Stats Frame"
            }, {
                frame = "mUITooltipFrame",
                name = "Tooltip"
            }, {
                frame = "MainMenuBarVehicleLeaveButton",
                name = "Vehicle Leave Button"
            }, {
                frame = "ExtraActionBarFrame",
                name = "Extra Action Button"
            }}

            if mUI:GameVersion()["Mists"] then
                -- ExtraActionButton Frame
                UIPARENT_MANAGED_FRAME_POSITIONS["ExtraActionBarFrame"] = nil
                UIPARENT_MANAGED_FRAME_POSITIONS["PlayerPowerBarAlt"] = nil
                ExtraActionBarFrame:SetParent(UIParent)
                ExtraActionBarFrame:SetMovable(true)
            end
        else
            EditMode.availableFrames = { -- Unit Frames
            {
                frame = "PlayerFrame",
                name = "Player Frame"
            }, {
                frame = "TargetFrame",
                name = "Target Frame"
            }, {
                frame = "FocusFrame",
                name = "Focus Frame"
            }, -- Cast Bars
            {
                frame = "CastingBarFrame",
                name = "Player CastBar"
            }, -- Custom Buff/Debuff Anchors
            {
                frame = "mUIBuffFrame",
                name = "Buffs"
            }, {
                frame = "mUIDebuffFrame",
                name = "Debuffs"
            }, -- Custom mUI frames
            {
                frame = "mUIStatsFrame",
                name = "Stats Frame"
            }, -- Tooltip
            {
                frame = "mUITooltipFrame",
                name = "Tooltip"
            }}
        end

        -- Tooltip Frame
        EditMode.tooltip = CreateFrame("Frame", "mUITooltipFrame", UIParent)
        EditMode.tooltip:SetSize(150, 25)
        EditMode.tooltip:SetMovable(true)
        EditMode:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("BOTTOMRIGHT", EditMode.tooltip, "BOTTOMRIGHT")
        end)

        -- Create Buff & Debuff Anchors
        EditMode.buffFrame = CreateFrame("Frame", "mUIBuffFrame", UIParent, "SecureHandlerStateTemplate")
        EditMode.debuffFrame = CreateFrame("Frame", "mUIDebuffFrame", UIParent)

        EditMode.buffFrame:SetSize(32, 32)
        EditMode.debuffFrame:SetSize(32, 32)

        EditMode.buffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -350, -30)
        EditMode.debuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -350, -175)

        EditMode.buffFrame:SetMovable(true)
        EditMode.debuffFrame:SetMovable(true)

        -- Only set UserPlaced if frames are movable
        if EditMode.buffFrame:IsMovable() then
            EditMode.buffFrame:SetUserPlaced(true)
        end
        if EditMode.debuffFrame:IsMovable() then
            EditMode.debuffFrame:SetUserPlaced(true)
        end

        -- Create main grid frame
        EditMode.grid = CreateFrame("Frame", "mUIEditMode", UIParent)
        EditMode.grid:SetAllPoints(UIParent)
        EditMode.grid:SetFrameLevel(0)
        EditMode.grid:Hide()

        -- Table to store grid line textures
        EditMode.gridLines = {}

        -- Function to create grid lines
        function EditMode:CreateGridLines()
            self:ClearGridLines()

            local screenWidth = GetScreenWidth()
            local screenHeight = GetScreenHeight()
            local gridSize = self.db.grid.size
            local alpha = self.db.grid.alpha
            local color = self.db.grid.color

            -- Calculate center positions
            local centerX = screenWidth / 2
            local centerY = screenHeight / 2

            -- Calculate number of lines needed
            local numVerticalLines = math.ceil(screenWidth / gridSize) + 1
            local numHorizontalLines = math.ceil(screenHeight / gridSize) + 1

            -- Create vertical lines
            for i = 0, numVerticalLines do
                local x = i * gridSize
                if x <= screenWidth then
                    local line = self.grid:CreateTexture(nil, "BACKGROUND")

                    -- Check if this is close to the center vertical line
                    local isCenterLine = math.abs(x - centerX) < (gridSize / 2)

                    if isCenterLine then
                        -- Center line: brighter, slightly thicker, different color
                        line:SetColorTexture(1, 0.8, 0, alpha * 2) -- Golden color
                        line:SetSize(2, screenHeight) -- 2 pixels thick
                    else
                        -- Regular grid line
                        line:SetColorTexture(color[1], color[2], color[3], alpha)
                        line:SetSize(1, screenHeight)
                    end

                    line:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, 0)
                    table.insert(self.gridLines, line)
                end
            end

            -- Create horizontal lines
            for i = 0, numHorizontalLines do
                local y = i * gridSize
                if y <= screenHeight then
                    local line = self.grid:CreateTexture(nil, "BACKGROUND")

                    -- Check if this is close to the center horizontal line
                    local isCenterLine = math.abs(y - centerY) < (gridSize / 2)

                    if isCenterLine then
                        -- Center line: brighter, slightly thicker, different color
                        line:SetColorTexture(1, 0.8, 0, alpha * 2) -- Golden color
                        line:SetSize(screenWidth, 2) -- 2 pixels thick
                    else
                        -- Regular grid line
                        line:SetColorTexture(color[1], color[2], color[3], alpha)
                        line:SetSize(screenWidth, 1)
                    end

                    line:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, y)
                    table.insert(self.gridLines, line)
                end
            end

            -- Add exact center lines for perfect centering (only if not already created)
            local hasExactCenterV = false
            local hasExactCenterH = false

            -- Check if we already have lines close to exact center (same logic as golden lines)
            for i = 0, numVerticalLines do
                local x = i * gridSize
                if math.abs(x - centerX) < (gridSize / 2) then
                    hasExactCenterV = true
                    break
                end
            end

            for i = 0, numHorizontalLines do
                local y = i * gridSize
                if math.abs(y - centerY) < (gridSize / 2) then
                    hasExactCenterH = true
                    break
                end
            end

            -- Only add exact center lines if they don't already exist
            if not hasExactCenterV then
                local exactCenterV = self.grid:CreateTexture(nil, "ARTWORK")
                exactCenterV:SetColorTexture(1, 1, 0, alpha * 1.5) -- Bright yellow
                exactCenterV:SetSize(2, screenHeight)

                -- Calculate the center between ActionButtons 6 and 7
                -- ActionBar1 is centered on screen, so we calculate from screen center
                local actionBarCenter = screenWidth / 2
                local buttonSize = 36
                local buttonSpacing = 2.5

                -- The ActionBar has 12 buttons centered on screen
                -- Total bar width: (12 * buttonSize) + (11 * buttonSpacing) = 432 + 27.5 = 459.5
                local totalBarWidth = (12 * buttonSize) + (11 * buttonSpacing)
                local barStartX = actionBarCenter - (totalBarWidth / 2)

                -- Calculate position between button 6 and 7 from bar start
                -- Button 6 ends at: barStartX + (6 * buttonSize) + (5 * buttonSpacing)
                -- Button 7 starts at: barStartX + (6 * buttonSize) + (6 * buttonSpacing)
                local button6End = barStartX + (6 * buttonSize) + (5 * buttonSpacing)
                local button7Start = barStartX + (6 * buttonSize) + (6 * buttonSpacing)
                local centerBetweenButtons = (button6End + button7Start) / 2

                exactCenterV:SetPoint("LEFT", UIParent, "BOTTOMLEFT", centerBetweenButtons, screenHeight / 2)
                table.insert(self.gridLines, exactCenterV)
            end

            if not hasExactCenterH then
                local exactCenterH = self.grid:CreateTexture(nil, "ARTWORK")
                exactCenterH:SetColorTexture(1, 1, 0, alpha * 1.5) -- Bright yellow
                exactCenterH:SetSize(screenWidth, 2)
                exactCenterH:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
                table.insert(self.gridLines, exactCenterH)
            end
        end

        -- Function to clear existing grid lines
        function EditMode:ClearGridLines()
            for _, line in pairs(self.gridLines) do
                line:SetTexture(nil)
            end
            wipe(self.gridLines)
        end

        -- Function to update grid appearance
        function EditMode:UpdateGrid()
            if self.db.grid.enabled then
                self:CreateGridLines()
                self.grid:Show()
            else
                self.grid:Hide()
            end
        end

        -- Function to toggle grid
        function EditMode:ToggleGrid()
            self.db.grid.enabled = not self.db.grid.enabled
            self:UpdateGrid()

            if self.db.grid.enabled then
                -- Auto-enable drag mode when grid is enabled
                if not self.isDragModeEnabled and not InCombatLockdown() then
                    EditMode:EnableDragMode()
                end

                -- Show snapping panel when edit mode is enabled
                if not self.snappingPanel then
                    self:CreateSnappingPanel()
                end
                self.snappingPanel:Show()
            else
                -- Auto-disable drag mode when grid is disabled
                if self.isDragModeEnabled and not InCombatLockdown() then
                    EditMode:DisableDragMode()
                end

                -- Hide snapping panel when edit mode is disabled
                if self.snappingPanel then
                    self.snappingPanel:Hide()
                end
            end
        end

        -- Handle UI scale changes and edit mode state
        EditMode.grid:RegisterEvent("UI_SCALE_CHANGED")
        EditMode.grid:RegisterEvent("PLAYER_REGEN_DISABLED")
        EditMode.grid:RegisterEvent("PLAYER_REGEN_ENABLED")
        EditMode.grid:SetScript("OnEvent", function(self, event, ...)
            if event == "UI_SCALE_CHANGED" then
                if EditMode.db.grid.enabled then
                    C_Timer.After(0.1, function()
                        EditMode:UpdateGrid()
                    end)
                end
            elseif event == "PLAYER_REGEN_DISABLED" then
                -- Disable drag mode when entering combat
                if EditMode.isDragModeEnabled then
                    mUI:Debug("Combat started - temporarily disabling EditMode")
                    EditMode.wasDragModeActive = true
                    EditMode:DisableDragMode()
                end
            elseif event == "PLAYER_REGEN_ENABLED" then
                -- Re-enable drag mode when leaving combat if it was active or if grid is enabled
                if EditMode.wasDragModeActive or EditMode.db.grid.enabled then
                    mUI:Debug("Combat ended - re-enabling drag mode")
                    EditMode.wasDragModeActive = false
                    EditMode:EnableDragMode()
                end
            end
        end)

        -- Draggable frames system
        EditMode.draggableFrames = {}
        EditMode.isDragModeEnabled = false
        EditMode.wasDragModeActive = false

        -- Snapping system
        EditMode.snapLines = {}
        EditMode.currentSnapLines = {}

        -- Function to save frame position and scale
        function EditMode:SaveFramePosition(frameName, frame)
            if not EditMode.db or not EditMode.db.frames then
                return -- Exit safely if database is not available
            end

            if not EditMode.db.frames[frameName] then
                EditMode.db.frames[frameName] = {}
            end

            local point, relativeTo, relativePoint, x, y = frame:GetPoint()
            EditMode.db.frames[frameName].position = {
                point = point,
                relativeTo = UIParent,
                relativePoint = relativePoint,
                x = x,
                y = y
            }
            EditMode.db.frames[frameName].scale = frame:GetScale()
        end

        -- Function to restore a single frame to its default position and scale
        function EditMode:RestoreFrameToDefault(frameName, frame)
            if not frame then
                frame = _G[frameName]
                if not frame then
                    return
                end
            end

            -- Clear saved position data from database
            if EditMode.db and EditMode.db.frames and EditMode.db.frames[frameName] then
                EditMode.db.frames[frameName] = nil
            end

            -- Use defaults table if available, otherwise use original position
            local defaultData = EditMode.defaults[frameName]
            if defaultData then
                local relativeTo = _G[defaultData.relativeTo] or UIParent
                frame:ClearAllPoints()
                frame:SetPoint(defaultData.point, relativeTo, defaultData.relativePoint, defaultData.xOffset, defaultData.yOffset)
                frame:SetScale(defaultData.scale or 1.0)
            else
                -- Fallback to original position if no defaults defined
                if frame.originalPosition then
                    frame:ClearAllPoints()
                    frame:SetPoint(unpack(frame.originalPosition))
                end
                frame:SetScale(1.0)
            end

            -- Clear UserPlaced to allow the default UI to control positioning
            if frame:IsMovable() then
                frame:SetUserPlaced(false)
            end
        end

        -- Function to restore all frames to their default positions and scales
        function EditMode:RestoreAllFramesToDefault()
            -- Clear all saved frame data
            if EditMode.db and EditMode.db.frames then
                wipe(EditMode.db.frames)
            end

            -- Restore each draggable frame to default
            for _, frameData in ipairs(EditMode.availableFrames) do
                local frame = _G[frameData.frame]
                if frame then
                    -- Use defaults table if available, otherwise use original position
                    local defaultData = EditMode.defaults[frameData.frame]
                    if defaultData then
                        local relativeTo = _G[defaultData.relativeTo] or UIParent
                        frame:ClearAllPoints()
                        frame:SetPoint(defaultData.point, relativeTo, defaultData.relativePoint, defaultData.xOffset, defaultData.yOffset)
                        frame:SetScale(defaultData.scale or 1.0)
                    else
                        -- Fallback to original position if no defaults defined
                        if frame.originalPosition then
                            frame:ClearAllPoints()
                            frame:SetPoint(unpack(frame.originalPosition))
                        end
                        frame:SetScale(1.0)
                    end

                    -- Clear UserPlaced to allow the default UI to control positioning
                    if frame:IsMovable() then
                        frame:SetUserPlaced(false)
                    end
                end
            end
        end

        -- Function to restore all frames to their saved positions
        function EditMode:RestoreAllSavedPositions()
            if not EditMode.db or not EditMode.db.frames then
                return
            end

            local restoredCount = 0

            -- Create a lookup table for available frames for faster validation
            local availableFrames = {}
            for _, frameData in ipairs(EditMode.availableFrames) do
                availableFrames[frameData.frame] = true
            end

            -- Restore each frame that has saved data
            for frameName, frameData in pairs(EditMode.db.frames) do
                -- Check if frame exists in available frames list
                if availableFrames[frameName] then
                    local frame = _G[frameName]
                    if frame and frameData.position then
                        local pos = frameData.position
                        local relativeTo = UIParent

                        frame:ClearAllPoints()
                        frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.x, pos.y)

                        if frameData.scale then
                            frame:SetScale(frameData.scale)
                        end

                        -- Ensure UserPlaced is true to protect the position, but only if frame is movable
                        if frame:IsMovable() then
                            frame:SetUserPlaced(true)
                        end

                        restoredCount = restoredCount + 1
                    end
                end
            end
        end

        -- Function to apply defaults to frames that don't have saved positions
        function EditMode:ApplyDefaultPositions()
            if not EditMode.defaults then
                return
            end

            local appliedCount = 0

            local availableFrames = {}
            for _, frameData in ipairs(EditMode.availableFrames) do
                availableFrames[frameData.frame] = true
            end

            -- Apply defaults to frames that don't have saved positions
            for frameName, defaultData in pairs(EditMode.defaults) do
                if availableFrames[frameName] then
                    local frame = _G[frameName]
                    if frame then
                        -- Only apply defaults if frame doesn't have saved position
                        if not EditMode.db.frames[frameName] or not EditMode.db.frames[frameName].position then
                            local relativeTo = UIParent
                            frame:ClearAllPoints()
                            frame:SetPoint(defaultData.point, relativeTo, defaultData.relativePoint, defaultData.xOffset, defaultData.yOffset)
                            frame:SetScale(defaultData.scale or 1.0)
                            -- Only set UserPlaced if frame is movable
                            if frame:IsMovable() then
                                frame:SetUserPlaced(true) -- Protect the default position
                            end
                            appliedCount = appliedCount + 1
                        end
                    end
                end
            end
        end

        -- Create frame scaling window
        function EditMode:CreateScalingWindow()
            if EditMode.scalingWindow then
                return -- Already created
            end

            -- Main window frame
            EditMode.scalingWindow = CreateFrame("Frame", "mUIFrameScalingWindow", UIParent, "BasicFrameTemplateWithInset")
            EditMode.scalingWindow:SetSize(350, 350)
            EditMode.scalingWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            EditMode.scalingWindow:Hide()
            EditMode.scalingWindow:SetFrameLevel(1000) -- High level to be on top

            -- Title
            EditMode.scalingWindow.title = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            EditMode.scalingWindow.title:SetPoint("TOP", EditMode.scalingWindow, "TOP", 0, -5)
            EditMode.scalingWindow.title:SetText("Frame Scaling")

            -- Frame name label
            EditMode.scalingWindow.frameLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.frameLabel:SetPoint("TOP", EditMode.scalingWindow.title, "BOTTOM", 0, -10)
            EditMode.scalingWindow.frameLabel:SetText("Frame: None")

            -- Scale label
            EditMode.scalingWindow.scaleLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.scaleLabel:SetPoint("TOP", EditMode.scalingWindow.frameLabel, "BOTTOM", 0, -25)
            EditMode.scalingWindow.scaleLabel:SetText("Scale: 1.00")

            -- Scale slider
            EditMode.scalingWindow.scaleSlider = CreateFrame("Slider", "mUIScaleSlider", EditMode.scalingWindow, "OptionsSliderTemplate")
            EditMode.scalingWindow.scaleSlider:SetPoint("TOP", EditMode.scalingWindow.scaleLabel, "BOTTOM", 0, -20)
            EditMode.scalingWindow.scaleSlider:SetMinMaxValues(0.5, 2.0)
            EditMode.scalingWindow.scaleSlider:SetValue(1.0)
            EditMode.scalingWindow.scaleSlider:SetValueStep(0.05)
            EditMode.scalingWindow.scaleSlider:SetObeyStepOnDrag(true)
            EditMode.scalingWindow.scaleSlider:SetWidth(200)

            -- Slider text labels
            EditMode.scalingWindow.scaleSlider.Low:SetText("0.5")
            EditMode.scalingWindow.scaleSlider.High:SetText("2.0")
            EditMode.scalingWindow.scaleSlider.Text:SetText("Scale")

            -- Action Bar Layout Controls (hidden by default)
            -- Buttons per row
            EditMode.scalingWindow.buttonsPerRowLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.buttonsPerRowLabel:SetPoint("TOP", EditMode.scalingWindow.scaleSlider, "BOTTOM", 0, -25)
            EditMode.scalingWindow.buttonsPerRowLabel:SetText("Buttons per Row: 12")
            EditMode.scalingWindow.buttonsPerRowLabel:Hide()

            EditMode.scalingWindow.buttonsPerRowSlider = CreateFrame("Slider", "mUIButtonsPerRowSlider", EditMode.scalingWindow,
                "OptionsSliderTemplate")
            EditMode.scalingWindow.buttonsPerRowSlider:SetPoint("TOP", EditMode.scalingWindow.buttonsPerRowLabel, "BOTTOM", 0, -15)
            EditMode.scalingWindow.buttonsPerRowSlider:SetMinMaxValues(1, 12)
            EditMode.scalingWindow.buttonsPerRowSlider:SetValue(12)
            EditMode.scalingWindow.buttonsPerRowSlider:SetValueStep(1)
            EditMode.scalingWindow.buttonsPerRowSlider:SetObeyStepOnDrag(true)
            EditMode.scalingWindow.buttonsPerRowSlider:SetWidth(200)
            EditMode.scalingWindow.buttonsPerRowSlider.Low:SetText("1")
            EditMode.scalingWindow.buttonsPerRowSlider.High:SetText("12")
            EditMode.scalingWindow.buttonsPerRowSlider.Text:SetText("Buttons per Row")
            EditMode.scalingWindow.buttonsPerRowSlider:Hide()

            -- Visible buttons
            EditMode.scalingWindow.visibleButtonsLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.visibleButtonsLabel:SetPoint("TOP", EditMode.scalingWindow.buttonsPerRowSlider, "BOTTOM", 0, -25)
            EditMode.scalingWindow.visibleButtonsLabel:SetText("Visible Buttons: 12")
            EditMode.scalingWindow.visibleButtonsLabel:Hide()

            EditMode.scalingWindow.visibleButtonsSlider = CreateFrame("Slider", "mUIVisibleButtonsSlider", EditMode.scalingWindow,
                "OptionsSliderTemplate")
            EditMode.scalingWindow.visibleButtonsSlider:SetPoint("TOP", EditMode.scalingWindow.visibleButtonsLabel, "BOTTOM", 0, -15)
            EditMode.scalingWindow.visibleButtonsSlider:SetMinMaxValues(1, 12)
            EditMode.scalingWindow.visibleButtonsSlider:SetValue(12)
            EditMode.scalingWindow.visibleButtonsSlider:SetValueStep(1)
            EditMode.scalingWindow.visibleButtonsSlider:SetObeyStepOnDrag(true)
            EditMode.scalingWindow.visibleButtonsSlider:SetWidth(200)
            EditMode.scalingWindow.visibleButtonsSlider.Low:SetText("1")
            EditMode.scalingWindow.visibleButtonsSlider.High:SetText("12")
            EditMode.scalingWindow.visibleButtonsSlider.Text:SetText("Visible Buttons")
            EditMode.scalingWindow.visibleButtonsSlider:Hide()

            -- Action bar slider events
            EditMode.scalingWindow.buttonsPerRowSlider:SetScript("OnValueChanged", function(self, value)
                local intValue = math.floor(value + 0.5)
                EditMode.scalingWindow.buttonsPerRowLabel:SetText("Buttons per Row: " .. intValue)

                -- Apply changes immediately for preview
                if EditMode.scalingWindow.currentFrameName and EditMode.scalingWindow.currentFrameName:match("^mUIActionBar[1-5]$") then
                    EditMode:ApplyActionBarLayout(EditMode.scalingWindow.currentFrameName, intValue,
                        EditMode.scalingWindow.visibleButtonsSlider:GetValue())
                end
            end)

            EditMode.scalingWindow.visibleButtonsSlider:SetScript("OnValueChanged", function(self, value)
                local intValue = math.floor(value + 0.5)
                EditMode.scalingWindow.visibleButtonsLabel:SetText("Visible Buttons: " .. intValue)

                -- Apply changes immediately for preview
                if EditMode.scalingWindow.currentFrameName and EditMode.scalingWindow.currentFrameName:match("^mUIActionBar[1-5]$") then
                    EditMode:ApplyActionBarLayout(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.buttonsPerRowSlider:GetValue(),
                        intValue)
                end
            end)

            -- Apply button
            EditMode.scalingWindow.applyButton = CreateFrame("Button", "mUIApplyScaleButton", EditMode.scalingWindow, "GameMenuButtonTemplate")
            EditMode.scalingWindow.applyButton:SetSize(70, 22)
            EditMode.scalingWindow.applyButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", -100, 40)
            EditMode.scalingWindow.applyButton:SetText("Apply")

            -- Reset button
            EditMode.scalingWindow.resetButton = CreateFrame("Button", "mUIResetScaleButton", EditMode.scalingWindow, "GameMenuButtonTemplate")
            EditMode.scalingWindow.resetButton:SetSize(90, 22)
            EditMode.scalingWindow.resetButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", -15, 40)
            EditMode.scalingWindow.resetButton:SetText("Reset Scale")

            -- Restore Default button
            EditMode.scalingWindow.restoreDefaultButton = CreateFrame("Button", "mUIRestoreDefaultButton", EditMode.scalingWindow,
                "GameMenuButtonTemplate")
            EditMode.scalingWindow.restoreDefaultButton:SetSize(100, 22)
            EditMode.scalingWindow.restoreDefaultButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", 85, 40)
            EditMode.scalingWindow.restoreDefaultButton:SetText("Reset Position")

            -- Reset All button (for all frames)
            EditMode.scalingWindow.resetAllButton = CreateFrame("Button", "mUIResetAllButton", EditMode.scalingWindow, "GameMenuButtonTemplate")
            EditMode.scalingWindow.resetAllButton:SetSize(140, 22)
            EditMode.scalingWindow.resetAllButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", 0, 15)
            EditMode.scalingWindow.resetAllButton:SetText("Reset All Frames")

            -- Current frame being scaled
            EditMode.scalingWindow.currentFrame = nil
            EditMode.scalingWindow.currentFrameName = nil

            -- Slider events
            EditMode.scalingWindow.scaleSlider:SetScript("OnValueChanged", function(self, value)
                EditMode.scalingWindow.scaleLabel:SetText(string.format("Scale: %.2f", value))
                if EditMode.scalingWindow.currentFrame then
                    EditMode.scalingWindow.currentFrame:SetScale(value)
                end
            end)

            -- Apply button events
            EditMode.scalingWindow.applyButton:SetScript("OnClick", function()
                if EditMode.scalingWindow.currentFrame then
                    local scale = EditMode.scalingWindow.scaleSlider:GetValue()
                    EditMode.scalingWindow.currentFrame:SetScale(scale)

                    -- Save the new scale
                    EditMode:SaveFramePosition(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.currentFrame)

                    -- Handle action bar layout if this is an action bar frame
                    if EditMode.scalingWindow.currentFrameName:match("^mUIActionBar[1-5]$") then
                        local buttonsPerRow = math.floor(EditMode.scalingWindow.buttonsPerRowSlider:GetValue() + 0.5)
                        local visibleButtons = math.floor(EditMode.scalingWindow.visibleButtonsSlider:GetValue() + 0.5)

                        -- Save action bar layout
                        EditMode:SaveActionBarLayout(EditMode.scalingWindow.currentFrameName, buttonsPerRow, visibleButtons)

                        -- Apply action bar layout
                        EditMode:ApplyActionBarLayout(EditMode.scalingWindow.currentFrameName, buttonsPerRow, visibleButtons)

                        mUI:Debug("Applied layout to " .. EditMode.scalingWindow.currentFrameName .. ": " .. buttonsPerRow .. " per row, " ..
                                      visibleButtons .. " visible")
                    end
                end
                EditMode.scalingWindow:Hide()
            end)

            -- Reset button events
            EditMode.scalingWindow.resetButton:SetScript("OnClick", function()
                if EditMode.scalingWindow.currentFrame then
                    EditMode.scalingWindow.currentFrame:SetScale(1.0)
                    EditMode.scalingWindow.scaleSlider:SetValue(1.0)

                    -- Handle action bar layout reset if this is an action bar frame
                    if EditMode.scalingWindow.currentFrameName:match("^mUIActionBar[1-5]$") then
                        -- Reset to defaults (12 buttons per row, 12 visible)
                        EditMode.scalingWindow.buttonsPerRowSlider:SetValue(12)
                        EditMode.scalingWindow.visibleButtonsSlider:SetValue(12)

                        -- Save to database
                        EditMode:SaveActionBarLayout(EditMode.scalingWindow.currentFrameName, 12, 12)

                        -- Apply layout
                        EditMode:ApplyActionBarLayout(EditMode.scalingWindow.currentFrameName, 12, 12)

                        mUI:Debug("Reset layout for " .. EditMode.scalingWindow.currentFrameName .. " to default")
                    end

                    -- Save the reset scale
                    EditMode:SaveFramePosition(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.currentFrame)
                end
                EditMode.scalingWindow:Hide()
            end)

            -- Restore Default button events
            EditMode.scalingWindow.restoreDefaultButton:SetScript("OnClick", function()
                if EditMode.scalingWindow.currentFrame then
                    EditMode:RestoreFrameToDefault(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.currentFrame)

                    -- Get proper frame name for message
                    local properName = EditMode.scalingWindow.currentFrameName
                    for _, frameData in ipairs(EditMode.availableFrames) do
                        if frameData.frame == EditMode.scalingWindow.currentFrameName then
                            properName = frameData.name
                            break
                        end
                    end
                    mUI:Debug(properName .. " restored to default position and scale.")
                end
                EditMode.scalingWindow:Hide()
            end)

            -- Reset All button events
            EditMode.scalingWindow.resetAllButton:SetScript("OnClick", function()
                EditMode:RestoreAllFramesToDefault()
                mUI:Debug("All frames restored to default positions and scales.")
                EditMode.scalingWindow:Hide()
            end)

            -- Make window movable
            EditMode.scalingWindow:SetMovable(true)
            EditMode.scalingWindow:EnableMouse(true)
            EditMode.scalingWindow:RegisterForDrag("LeftButton")
            EditMode.scalingWindow:SetScript("OnDragStart", function(self)
                self:StartMoving()
            end)
            EditMode.scalingWindow:SetScript("OnDragStop", function(self)
                self:StopMovingOrSizing()
            end)

            -- Close on Escape
            EditMode.scalingWindow:SetScript("OnKeyDown", function(self, key)
                if key == "ESCAPE" then
                    self:Hide()
                end
            end)
        end

        -- Action Bar Layout Controls (hidden by default) - Add to scaling window
        -- These controls are added to the scaling window and shown/hidden as needed
        if EditMode.scalingWindow then
            -- Buttons per row
            EditMode.scalingWindow.buttonsPerRowLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.buttonsPerRowLabel:SetPoint("TOP", EditMode.scalingWindow.scaleSlider, "BOTTOM", 0, -25)
            EditMode.scalingWindow.buttonsPerRowLabel:SetText("Buttons per Row: 12")
            EditMode.scalingWindow.buttonsPerRowLabel:Hide()

            EditMode.scalingWindow.buttonsPerRowSlider = CreateFrame("Slider", "mUIButtonsPerRowSlider", EditMode.scalingWindow,
                "OptionsSliderTemplate")
            EditMode.scalingWindow.buttonsPerRowSlider:SetPoint("TOP", EditMode.scalingWindow.buttonsPerRowLabel, "BOTTOM", 0, -15)
            EditMode.scalingWindow.buttonsPerRowSlider:SetMinMaxValues(1, 12)
            EditMode.scalingWindow.buttonsPerRowSlider:SetValue(12)
            EditMode.scalingWindow.buttonsPerRowSlider:SetValueStep(1)
            EditMode.scalingWindow.buttonsPerRowSlider:SetObeyStepOnDrag(true)
            EditMode.scalingWindow.buttonsPerRowSlider:SetWidth(200)
            EditMode.scalingWindow.buttonsPerRowSlider.Low:SetText("1")
            EditMode.scalingWindow.buttonsPerRowSlider.High:SetText("12")
            EditMode.scalingWindow.buttonsPerRowSlider.Text:SetText("Buttons per Row")
            EditMode.scalingWindow.buttonsPerRowSlider:Hide()

            -- Visible buttons
            EditMode.scalingWindow.visibleButtonsLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.visibleButtonsLabel:SetPoint("TOP", EditMode.scalingWindow.buttonsPerRowSlider, "BOTTOM", 0, -25)
            EditMode.scalingWindow.visibleButtonsLabel:SetText("Visible Buttons: 12")
            EditMode.scalingWindow.visibleButtonsLabel:Hide()

            EditMode.scalingWindow.visibleButtonsSlider = CreateFrame("Slider", "mUIVisibleButtonsSlider", EditMode.scalingWindow,
                "OptionsSliderTemplate")
            EditMode.scalingWindow.visibleButtonsSlider:SetPoint("TOP", EditMode.scalingWindow.visibleButtonsLabel, "BOTTOM", 0, -15)
            EditMode.scalingWindow.visibleButtonsSlider:SetMinMaxValues(1, 12)
            EditMode.scalingWindow.visibleButtonsSlider:SetValue(12)
            EditMode.scalingWindow.visibleButtonsSlider:SetValueStep(1)
            EditMode.scalingWindow.visibleButtonsSlider:SetObeyStepOnDrag(true)
            EditMode.scalingWindow.visibleButtonsSlider:SetWidth(200)
            EditMode.scalingWindow.visibleButtonsSlider.Low:SetText("1")
            EditMode.scalingWindow.visibleButtonsSlider.High:SetText("12")
            EditMode.scalingWindow.visibleButtonsSlider.Text:SetText("Visible Buttons")
            EditMode.scalingWindow.visibleButtonsSlider:Hide()

            -- Action bar slider events
            EditMode.scalingWindow.buttonsPerRowSlider:SetScript("OnValueChanged", function(self, value)
                local intValue = math.floor(value + 0.5)
                EditMode.scalingWindow.buttonsPerRowLabel:SetText("Buttons per Row: " .. intValue)

                -- Apply changes immediately for preview
                if EditMode.scalingWindow.currentFrameName and EditMode.scalingWindow.currentFrameName:match("^mUIActionBar[1-5]$") then
                    EditMode:ApplyActionBarLayout(EditMode.scalingWindow.currentFrameName, intValue,
                        EditMode.scalingWindow.visibleButtonsSlider:GetValue())
                end
            end)

            EditMode.scalingWindow.visibleButtonsSlider:SetScript("OnValueChanged", function(self, value)
                local intValue = math.floor(value + 0.5)
                EditMode.scalingWindow.visibleButtonsLabel:SetText("Visible Buttons: " .. intValue)

                -- Apply changes immediately for preview
                if EditMode.scalingWindow.currentFrameName and EditMode.scalingWindow.currentFrameName:match("^mUIActionBar[1-5]$") then
                    EditMode:ApplyActionBarLayout(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.buttonsPerRowSlider:GetValue(),
                        intValue)
                end
            end)
        end

        -- Create action bar layout configuration window
        function EditMode:CreateActionBarLayoutWindow()
            if EditMode.actionBarLayoutWindow then
                return -- Already created
            end

            -- Main window frame
            EditMode.actionBarLayoutWindow = CreateFrame("Frame", "mUIActionBarLayoutWindow", UIParent, "BasicFrameTemplateWithInset")
            EditMode.actionBarLayoutWindow:SetSize(400, 350)
            EditMode.actionBarLayoutWindow:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
            EditMode.actionBarLayoutWindow:Hide()
            EditMode.actionBarLayoutWindow:SetFrameLevel(1000)

            -- Title
            EditMode.actionBarLayoutWindow.title = EditMode.actionBarLayoutWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            EditMode.actionBarLayoutWindow.title:SetPoint("TOP", EditMode.actionBarLayoutWindow, "TOP", 0, -5)
            EditMode.actionBarLayoutWindow.title:SetText("Action Bar Layout")

            -- Current action bar label
            EditMode.actionBarLayoutWindow.barLabel = EditMode.actionBarLayoutWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.actionBarLayoutWindow.barLabel:SetPoint("TOP", EditMode.actionBarLayoutWindow.title, "BOTTOM", 0, -15)
            EditMode.actionBarLayoutWindow.barLabel:SetText("Action Bar: None")

            -- Buttons per row
            EditMode.actionBarLayoutWindow.buttonsPerRowLabel = EditMode.actionBarLayoutWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.actionBarLayoutWindow.buttonsPerRowLabel:SetPoint("TOP", EditMode.actionBarLayoutWindow.barLabel, "BOTTOM", 0, -25)
            EditMode.actionBarLayoutWindow.buttonsPerRowLabel:SetText("Buttons per Row: 12")

            EditMode.actionBarLayoutWindow.buttonsPerRowSlider = CreateFrame("Slider", "mUIButtonsPerRowSlider", EditMode.actionBarLayoutWindow,
                "OptionsSliderTemplate")
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetPoint("TOP", EditMode.actionBarLayoutWindow.buttonsPerRowLabel, "BOTTOM", 0, -15)
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetMinMaxValues(1, 12)
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetValue(12)
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetValueStep(1)
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetObeyStepOnDrag(true)
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetWidth(250)
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider.Low:SetText("1")
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider.High:SetText("12")
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider.Text:SetText("Buttons per Row")

            -- Visible buttons
            EditMode.actionBarLayoutWindow.visibleButtonsLabel = EditMode.actionBarLayoutWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.actionBarLayoutWindow.visibleButtonsLabel:SetPoint("TOP", EditMode.actionBarLayoutWindow.buttonsPerRowSlider, "BOTTOM", 0, -25)
            EditMode.actionBarLayoutWindow.visibleButtonsLabel:SetText("Visible Buttons: 12")

            EditMode.actionBarLayoutWindow.visibleButtonsSlider = CreateFrame("Slider", "mUIVisibleButtonsSlider", EditMode.actionBarLayoutWindow,
                "OptionsSliderTemplate")
            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetPoint("TOP", EditMode.actionBarLayoutWindow.visibleButtonsLabel, "BOTTOM", 0, -15)
            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetMinMaxValues(1, 12)
            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetValue(12)
            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetValueStep(1)
            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetObeyStepOnDrag(true)
            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetWidth(250)
            EditMode.actionBarLayoutWindow.visibleButtonsSlider.Low:SetText("1")
            EditMode.actionBarLayoutWindow.visibleButtonsSlider.High:SetText("12")
            EditMode.actionBarLayoutWindow.visibleButtonsSlider.Text:SetText("Visible Buttons")

            -- Current frame being configured
            EditMode.actionBarLayoutWindow.currentBarName = nil

            -- Slider events
            EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetScript("OnValueChanged", function(self, value)
                local intValue = math.floor(value + 0.5)
                EditMode.actionBarLayoutWindow.buttonsPerRowLabel:SetText("Buttons per Row: " .. intValue)

                -- Apply changes immediately for preview
                if EditMode.actionBarLayoutWindow.currentBarName then
                    EditMode:ApplyActionBarLayout(EditMode.actionBarLayoutWindow.currentBarName, intValue,
                        EditMode.actionBarLayoutWindow.visibleButtonsSlider:GetValue())
                end
            end)

            EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetScript("OnValueChanged", function(self, value)
                local intValue = math.floor(value + 0.5)
                EditMode.actionBarLayoutWindow.visibleButtonsLabel:SetText("Visible Buttons: " .. intValue)

                -- Apply changes immediately for preview
                if EditMode.actionBarLayoutWindow.currentBarName then
                    EditMode:ApplyActionBarLayout(EditMode.actionBarLayoutWindow.currentBarName,
                        EditMode.actionBarLayoutWindow.buttonsPerRowSlider:GetValue(), intValue)
                end
            end)

            -- Apply button
            EditMode.actionBarLayoutWindow.applyButton = CreateFrame("Button", "mUIApplyLayoutButton", EditMode.actionBarLayoutWindow,
                "GameMenuButtonTemplate")
            EditMode.actionBarLayoutWindow.applyButton:SetSize(70, 22)
            EditMode.actionBarLayoutWindow.applyButton:SetPoint("BOTTOM", EditMode.actionBarLayoutWindow, "BOTTOM", -100, 40)
            EditMode.actionBarLayoutWindow.applyButton:SetText("Apply")

            -- Reset button
            EditMode.actionBarLayoutWindow.resetButton = CreateFrame("Button", "mUIResetLayoutButton", EditMode.actionBarLayoutWindow,
                "GameMenuButtonTemplate")
            EditMode.actionBarLayoutWindow.resetButton:SetSize(70, 22)
            EditMode.actionBarLayoutWindow.resetButton:SetPoint("BOTTOM", EditMode.actionBarLayoutWindow, "BOTTOM", -25, 40)
            EditMode.actionBarLayoutWindow.resetButton:SetText("Reset")

            -- Close button
            EditMode.actionBarLayoutWindow.closeButton = CreateFrame("Button", "mUICloseLayoutButton", EditMode.actionBarLayoutWindow,
                "GameMenuButtonTemplate")
            EditMode.actionBarLayoutWindow.closeButton:SetSize(70, 22)
            EditMode.actionBarLayoutWindow.closeButton:SetPoint("BOTTOM", EditMode.actionBarLayoutWindow, "BOTTOM", 50, 40)
            EditMode.actionBarLayoutWindow.closeButton:SetText("Close")

            -- Apply button events
            EditMode.actionBarLayoutWindow.applyButton:SetScript("OnClick", function()
                if EditMode.actionBarLayoutWindow.currentBarName then
                    local buttonsPerRow = math.floor(EditMode.actionBarLayoutWindow.buttonsPerRowSlider:GetValue() + 0.5)
                    local visibleButtons = math.floor(EditMode.actionBarLayoutWindow.visibleButtonsSlider:GetValue() + 0.5)

                    -- Save to database
                    EditMode:SaveActionBarLayout(EditMode.actionBarLayoutWindow.currentBarName, buttonsPerRow, visibleButtons)

                    -- Apply layout
                    EditMode:ApplyActionBarLayout(EditMode.actionBarLayoutWindow.currentBarName, buttonsPerRow, visibleButtons)

                    mUI:Debug("Applied layout to " .. EditMode.actionBarLayoutWindow.currentBarName .. ": " .. buttonsPerRow .. " per row, " ..
                                  visibleButtons .. " visible")
                end
                EditMode.actionBarLayoutWindow:Hide()
            end)

            -- Reset button events
            EditMode.actionBarLayoutWindow.resetButton:SetScript("OnClick", function()
                if EditMode.actionBarLayoutWindow.currentBarName then
                    -- Reset to defaults (12 buttons per row, 12 visible)
                    EditMode.actionBarLayoutWindow.buttonsPerRowSlider:SetValue(12)
                    EditMode.actionBarLayoutWindow.visibleButtonsSlider:SetValue(12)

                    -- Save to database
                    EditMode:SaveActionBarLayout(EditMode.actionBarLayoutWindow.currentBarName, 12, 12)

                    -- Apply layout
                    EditMode:ApplyActionBarLayout(EditMode.actionBarLayoutWindow.currentBarName, 12, 12)

                    mUI:Debug("Reset layout for " .. EditMode.actionBarLayoutWindow.currentBarName .. " to default")
                end
            end)

            -- Close button events
            EditMode.actionBarLayoutWindow.closeButton:SetScript("OnClick", function()
                EditMode.actionBarLayoutWindow:Hide()
            end)

            -- Make window movable
            EditMode.actionBarLayoutWindow:SetMovable(true)
            EditMode.actionBarLayoutWindow:EnableMouse(true)
            EditMode.actionBarLayoutWindow:RegisterForDrag("LeftButton")
            EditMode.actionBarLayoutWindow:SetScript("OnDragStart", function(self)
                self:StartMoving()
            end)
            EditMode.actionBarLayoutWindow:SetScript("OnDragStop", function(self)
                self:StopMovingOrSizing()
            end)

            -- Close on Escape
            EditMode.actionBarLayoutWindow:SetScript("OnKeyDown", function(self, key)
                if key == "ESCAPE" then
                    self:Hide()
                end
            end)

            EditMode.scalingWindow.frameLabel:SetPoint("TOP", EditMode.scalingWindow.title, "BOTTOM", 0, -10)
            EditMode.scalingWindow.frameLabel:SetText("Frame: None")

            -- Scale label
            EditMode.scalingWindow.scaleLabel = EditMode.scalingWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.scalingWindow.scaleLabel:SetPoint("TOP", EditMode.scalingWindow.frameLabel, "BOTTOM", 0, -25)
            EditMode.scalingWindow.scaleLabel:SetText("Scale: 1.00")

            -- Scale slider
            EditMode.scalingWindow.scaleSlider = CreateFrame("Slider", "mUIScaleSlider", EditMode.scalingWindow, "OptionsSliderTemplate")
            EditMode.scalingWindow.scaleSlider:SetPoint("TOP", EditMode.scalingWindow.scaleLabel, "BOTTOM", 0, -20)
            EditMode.scalingWindow.scaleSlider:SetMinMaxValues(0.5, 2.0)
            EditMode.scalingWindow.scaleSlider:SetValue(1.0)
            EditMode.scalingWindow.scaleSlider:SetValueStep(0.05)
            EditMode.scalingWindow.scaleSlider:SetObeyStepOnDrag(true)
            EditMode.scalingWindow.scaleSlider:SetWidth(200)

            -- Slider text labels
            EditMode.scalingWindow.scaleSlider.Low:SetText("0.5")
            EditMode.scalingWindow.scaleSlider.High:SetText("2.0")
            EditMode.scalingWindow.scaleSlider.Text:SetText("Scale")

            -- Apply button
            EditMode.scalingWindow.applyButton = CreateFrame("Button", "mUIApplyScaleButton", EditMode.scalingWindow, "GameMenuButtonTemplate")
            EditMode.scalingWindow.applyButton:SetSize(70, 22)
            EditMode.scalingWindow.applyButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", -100, 40)
            EditMode.scalingWindow.applyButton:SetText("Apply")

            -- Reset button
            EditMode.scalingWindow.resetButton = CreateFrame("Button", "mUIResetScaleButton", EditMode.scalingWindow, "GameMenuButtonTemplate")
            EditMode.scalingWindow.resetButton:SetSize(90, 22)
            EditMode.scalingWindow.resetButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", -15, 40)
            EditMode.scalingWindow.resetButton:SetText("Reset Scale")

            -- Restore Default button
            EditMode.scalingWindow.restoreDefaultButton = CreateFrame("Button", "mUIRestoreDefaultButton", EditMode.scalingWindow,
                "GameMenuButtonTemplate")
            EditMode.scalingWindow.restoreDefaultButton:SetSize(100, 22)
            EditMode.scalingWindow.restoreDefaultButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", 85, 40)
            EditMode.scalingWindow.restoreDefaultButton:SetText("Reset Position")

            -- Reset All button (for all frames)
            EditMode.scalingWindow.resetAllButton = CreateFrame("Button", "mUIResetAllButton", EditMode.scalingWindow, "GameMenuButtonTemplate")
            EditMode.scalingWindow.resetAllButton:SetSize(140, 22)
            EditMode.scalingWindow.resetAllButton:SetPoint("BOTTOM", EditMode.scalingWindow, "BOTTOM", 0, 15)
            EditMode.scalingWindow.resetAllButton:SetText("Reset All Frames")

            -- Current frame being scaled
            EditMode.scalingWindow.currentFrame = nil
            EditMode.scalingWindow.currentFrameName = nil

            -- Slider events
            EditMode.scalingWindow.scaleSlider:SetScript("OnValueChanged", function(self, value)
                EditMode.scalingWindow.scaleLabel:SetText(string.format("Scale: %.2f", value))
                if EditMode.scalingWindow.currentFrame then
                    EditMode.scalingWindow.currentFrame:SetScale(value)
                end
            end)

            -- Apply button events
            EditMode.scalingWindow.applyButton:SetScript("OnClick", function()
                if EditMode.scalingWindow.currentFrame then
                    local scale = EditMode.scalingWindow.scaleSlider:GetValue()
                    EditMode.scalingWindow.currentFrame:SetScale(scale)

                    -- Save the new scale
                    EditMode:SaveFramePosition(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.currentFrame)
                end
                EditMode.scalingWindow:Hide()
            end)

            -- Reset button events
            EditMode.scalingWindow.resetButton:SetScript("OnClick", function()
                if EditMode.scalingWindow.currentFrame then
                    EditMode.scalingWindow.currentFrame:SetScale(1.0)
                    EditMode.scalingWindow.scaleSlider:SetValue(1.0)

                    -- Save the reset scale
                    EditMode:SaveFramePosition(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.currentFrame)
                end
                EditMode.scalingWindow:Hide()
            end)

            -- Restore Default button events
            EditMode.scalingWindow.restoreDefaultButton:SetScript("OnClick", function()
                if EditMode.scalingWindow.currentFrame then
                    EditMode:RestoreFrameToDefault(EditMode.scalingWindow.currentFrameName, EditMode.scalingWindow.currentFrame)

                    -- Get proper frame name for message
                    local properName = EditMode.scalingWindow.currentFrameName
                    for _, frameData in ipairs(EditMode.availableFrames) do
                        if frameData.frame == EditMode.scalingWindow.currentFrameName then
                            properName = frameData.name
                            break
                        end
                    end
                    mUI:Debug(properName .. " restored to default position and scale.")
                end
                EditMode.scalingWindow:Hide()
            end)

            -- Reset All button events
            EditMode.scalingWindow.resetAllButton:SetScript("OnClick", function()
                EditMode:RestoreAllFramesToDefault()
                mUI:Debug("All frames restored to default positions and scales.")
                EditMode.scalingWindow:Hide()
            end)

            -- Make window movable
            EditMode.scalingWindow:SetMovable(true)
            EditMode.scalingWindow:EnableMouse(true)
            EditMode.scalingWindow:RegisterForDrag("LeftButton")
            EditMode.scalingWindow:SetScript("OnDragStart", function(self)
                self:StartMoving()
            end)
            EditMode.scalingWindow:SetScript("OnDragStop", function(self)
                self:StopMovingOrSizing()
            end)

            -- Close on Escape
            EditMode.scalingWindow:SetScript("OnKeyDown", function(self, key)
                if key == "ESCAPE" then
                    self:Hide()
                end
            end)
        end

        -- Show scaling window for a specific frame
        function EditMode:ShowScalingWindow(frame, frameName)
            if not EditMode.scalingWindow then
                EditMode:CreateScalingWindow()
            end

            EditMode.scalingWindow.currentFrame = frame
            EditMode.scalingWindow.currentFrameName = frameName

            -- Get proper frame name
            local properName = frameName
            for _, frameData in ipairs(EditMode.availableFrames) do
                if frameData.frame == frameName then
                    properName = frameData.name
                    break
                end
            end

            EditMode.scalingWindow.frameLabel:SetText("Frame: " .. properName)

            -- Set current scale
            local currentScale = frame:GetScale()
            EditMode.scalingWindow.scaleSlider:SetValue(currentScale)
            EditMode.scalingWindow.scaleLabel:SetText(string.format("Scale: %.2f", currentScale))

            -- Check if this is an action bar frame and show/hide action bar controls
            local isActionBar = frameName:match("^mUIActionBar[1-5]$")
            if isActionBar then
                -- Show action bar controls
                EditMode.scalingWindow.buttonsPerRowLabel:Show()
                EditMode.scalingWindow.buttonsPerRowSlider:Show()
                EditMode.scalingWindow.visibleButtonsLabel:Show()
                EditMode.scalingWindow.visibleButtonsSlider:Show()

                -- Get current layout settings
                local barNumber = frameName:match("mUIActionBar([1-5])")
                local barKey = "bar" .. barNumber
                local layout = mUI.db.profile.actionbars.layout[barKey] or {
                    buttonsPerRow = 12,
                    visibleButtons = 12
                }

                -- Set slider values
                EditMode.scalingWindow.buttonsPerRowSlider:SetValue(layout.buttonsPerRow)
                EditMode.scalingWindow.visibleButtonsSlider:SetValue(layout.visibleButtons)

                -- Update labels
                EditMode.scalingWindow.buttonsPerRowLabel:SetText("Buttons per Row: " .. layout.buttonsPerRow)
                EditMode.scalingWindow.visibleButtonsLabel:SetText("Visible Buttons: " .. layout.visibleButtons)

                -- Increase window size for action bar controls
                EditMode.scalingWindow:SetSize(350, 450)
            else
                -- Hide action bar controls
                EditMode.scalingWindow.buttonsPerRowLabel:Hide()
                EditMode.scalingWindow.buttonsPerRowSlider:Hide()
                EditMode.scalingWindow.visibleButtonsLabel:Hide()
                EditMode.scalingWindow.visibleButtonsSlider:Hide()

                -- Reset window size for regular frames
                EditMode.scalingWindow:SetSize(350, 350)
            end

            EditMode.scalingWindow:Show()
        end

        -- Function to store original button visibility states
        function EditMode:StoreActionButtonVisibility()
            if not EditMode.originalButtonStates then
                EditMode.originalButtonStates = {}
            end

            local buttonPrefixes = {"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton",
                                    "MultiBarRightButton"}

            for _, prefix in ipairs(buttonPrefixes) do
                if not EditMode.originalButtonStates[prefix] then
                    EditMode.originalButtonStates[prefix] = {}
                end

                for i = 1, 12 do
                    local button = _G[prefix .. i]
                    if button then
                        EditMode.originalButtonStates[prefix][i] = button:IsShown()
                    end
                end
            end
        end

        -- Function to restore button visibility based on original state and settings
        function EditMode:RestoreActionButtonVisibility()
            if not EditMode.originalButtonStates then
                return
            end

            local buttonPrefixes = {"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton",
                                    "MultiBarRightButton"}

            for _, prefix in ipairs(buttonPrefixes) do
                if EditMode.originalButtonStates[prefix] then
                    for i = 1, 12 do
                        local button = _G[prefix .. i]
                        if button and EditMode.originalButtonStates[prefix][i] ~= nil then
                            -- Only hide buttons that were originally hidden
                            if not EditMode.originalButtonStates[prefix][i] then
                                button:Hide()
                            end
                        end
                    end
                end
            end
        end

        -- Show action bar layout window for specific action bar
        -- Save action bar layout to database
        function EditMode:SaveActionBarLayout(frameName, buttonsPerRow, visibleButtons)
            local barNumber = frameName:match("mUIActionBar([1-5])")
            if not barNumber then
                return
            end

            local barKey = "bar" .. barNumber
            if not mUI.db.profile.actionbars.layout[barKey] then
                mUI.db.profile.actionbars.layout[barKey] = {}
            end

            mUI.db.profile.actionbars.layout[barKey].buttonsPerRow = buttonsPerRow
            mUI.db.profile.actionbars.layout[barKey].visibleButtons = visibleButtons
        end

        -- Apply action bar layout
        function EditMode:ApplyActionBarLayout(frameName, buttonsPerRow, visibleButtons)
            local barNumber = frameName:match("mUIActionBar([1-5])")
            if not barNumber then
                return
            end

            local barFrame = _G[frameName]
            if not barFrame then
                return
            end

            -- Get the appropriate button prefix based on bar number
            local buttonPrefix
            if barNumber == "1" then
                buttonPrefix = "ActionButton"
            elseif barNumber == "2" then
                buttonPrefix = "MultiBarBottomLeftButton"
            elseif barNumber == "3" then
                buttonPrefix = "MultiBarBottomRightButton"
            elseif barNumber == "4" then
                buttonPrefix = "MultiBarRightButton"
            elseif barNumber == "5" then
                buttonPrefix = "MultiBarLeftButton"
            else
                return
            end

            -- Calculate new bar size based on layout
            local buttonSize = 36 -- Standard button size
            local buttonSpacing = 2.5

            local newWidth, newHeight
            if barNumber == "4" or barNumber == "5" then
                -- Vertical bars (bar 4 and 5)
                local rows = math.ceil(visibleButtons / buttonsPerRow)
                newWidth = buttonsPerRow * buttonSize + (buttonsPerRow - 1) * buttonSpacing
                newHeight = rows * buttonSize + (rows - 1) * buttonSpacing
            else
                -- Horizontal bars (bar 1, 2, 3)
                local rows = math.ceil(visibleButtons / buttonsPerRow)
                newWidth = buttonsPerRow * buttonSize + (buttonsPerRow - 1) * buttonSpacing
                newHeight = rows * buttonSize + (rows - 1) * buttonSpacing
            end

            -- Resize the bar frame
            barFrame:SetSize(newWidth, newHeight)

            -- Reposition buttons
            for i = 1, 12 do
                local button = _G[buttonPrefix .. i]
                if button then
                    button:ClearAllPoints()

                    if i <= visibleButtons then
                        -- Only show if it was originally visible or if it's within visible range
                        local wasOriginallyVisible = true
                        if EditMode.originalButtonStates and EditMode.originalButtonStates[buttonPrefix] then
                            wasOriginallyVisible = EditMode.originalButtonStates[buttonPrefix][i] or false
                        end

                        if wasOriginallyVisible then
                            button:Show()
                        end

                        -- Calculate row and column
                        local row = math.ceil(i / buttonsPerRow) - 1
                        local col = ((i - 1) % buttonsPerRow)

                        if barNumber == "4" or barNumber == "5" then
                            -- Vertical layout
                            if i == 1 then
                                button:SetPoint("TOPLEFT", barFrame, "TOPLEFT", 0, 0)
                            else
                                if col == 0 then
                                    -- New row
                                    button:SetPoint("TOP", _G[buttonPrefix .. (i - buttonsPerRow)], "BOTTOM", 0, -buttonSpacing)
                                else
                                    -- Same row
                                    button:SetPoint("LEFT", _G[buttonPrefix .. (i - 1)], "RIGHT", buttonSpacing, 0)
                                end
                            end
                        else
                            -- Horizontal layout
                            if i == 1 then
                                button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", 0, 0)
                            else
                                if col == 0 then
                                    -- New row
                                    button:SetPoint("BOTTOM", _G[buttonPrefix .. (i - buttonsPerRow)], "TOP", 0, buttonSpacing)
                                else
                                    -- Same row
                                    button:SetPoint("LEFT", _G[buttonPrefix .. (i - 1)], "RIGHT", buttonSpacing, 0)
                                end
                            end
                        end
                    else
                        button:Hide()
                    end
                end
            end
        end

        -- Apply all action bar layouts from database
        function EditMode:ApplyAllActionBarLayouts()
            for barKey, layout in pairs(mUI.db.profile.actionbars.layout) do
                local barNumber = barKey:match("bar([1-5])")
                if barNumber then
                    local frameName = "mUIActionBar" .. barNumber
                    EditMode:ApplyActionBarLayout(frameName, layout.buttonsPerRow or 12, layout.visibleButtons or 12)
                end
            end
        end

        -- Snapping system functions
        function EditMode:CreateSnapLines()
            -- Create snap line textures for showing snap guides
            if not self.snapLines.vertical then
                self.snapLines.vertical = UIParent:CreateTexture(nil, "OVERLAY")
                self.snapLines.vertical:SetColorTexture(1, 0.5, 0, 0.8) -- Orange color
                self.snapLines.vertical:SetSize(2, GetScreenHeight())
                self.snapLines.vertical:Hide()
            end

            if not self.snapLines.horizontal then
                self.snapLines.horizontal = UIParent:CreateTexture(nil, "OVERLAY")
                self.snapLines.horizontal:SetColorTexture(1, 0.5, 0, 0.8) -- Orange color
                self.snapLines.horizontal:SetSize(GetScreenWidth(), 2)
                self.snapLines.horizontal:Hide()
            end
        end

        function EditMode:HideSnapLines()
            if self.snapLines.vertical then
                self.snapLines.vertical:Hide()
            end
            if self.snapLines.horizontal then
                self.snapLines.horizontal:Hide()
            end
        end

        function EditMode:ShowSnapLine(orientation, position)
            if not self.db.snapping.showSnapLines then
                return
            end

            self:CreateSnapLines()

            if orientation == "vertical" then
                self.snapLines.vertical:SetPoint("CENTER", UIParent, "BOTTOMLEFT", position, GetScreenHeight() / 2)
                self.snapLines.vertical:Show()
            elseif orientation == "horizontal" then
                self.snapLines.horizontal:SetPoint("CENTER", UIParent, "BOTTOMLEFT", GetScreenWidth() / 2, position)
                self.snapLines.horizontal:Show()
            end
        end

        function EditMode:GetSnapPosition(frame, currentX, currentY)
            if not self.db.snapping.enabled then
                return currentX, currentY
            end

            local snapX, snapY = currentX, currentY
            local snappedX, snappedY = false, false
            local snapDistance = self.db.snapping.snapDistance

            local frameWidth = frame:GetWidth()
            local frameHeight = frame:GetHeight()

            -- Center coordinates
            local screenCenterX = GetScreenWidth() / 2
            local screenCenterY = GetScreenHeight() / 2

            -- Frame edges for snapping calculations
            local frameLeft = currentX
            local frameRight = currentX + frameWidth
            local frameCenterX = currentX + frameWidth / 2
            local frameBottom = currentY
            local frameTop = currentY + frameHeight
            local frameCenterY = currentY + frameHeight / 2

            -- Snap to screen center
            if self.db.snapping.snapToCenter then
                -- Snap frame center to screen center
                if math.abs(frameCenterX - screenCenterX) <= snapDistance then
                    snapX = screenCenterX - frameWidth / 2
                    snappedX = true
                    self:ShowSnapLine("vertical", screenCenterX)
                end

                if math.abs(frameCenterY - screenCenterY) <= snapDistance then
                    snapY = screenCenterY - frameHeight / 2
                    snappedY = true
                    self:ShowSnapLine("horizontal", screenCenterY)
                end
            end

            -- Snap to other frames
            if self.db.snapping.snapToFrames and not (snappedX and snappedY) then
                for _, frameData in ipairs(self.availableFrames) do
                    local targetFrame = _G[frameData.frame]
                    if targetFrame and targetFrame ~= frame and targetFrame:IsVisible() then
                        local targetLeft = targetFrame:GetLeft() or 0
                        local targetRight = targetFrame:GetRight() or 0
                        local targetBottom = targetFrame:GetBottom() or 0
                        local targetTop = targetFrame:GetTop() or 0
                        local targetCenterX = (targetLeft + targetRight) / 2
                        local targetCenterY = (targetBottom + targetTop) / 2
                        local targetWidth = targetFrame:GetWidth()
                        local targetHeight = targetFrame:GetHeight()

                        -- Horizontal snapping (align vertically)
                        if not snappedX then
                            -- Left edge to left edge
                            if math.abs(frameLeft - targetLeft) <= snapDistance then
                                snapX = targetLeft
                                snappedX = true
                                self:ShowSnapLine("vertical", targetLeft)
                                -- Right edge to right edge
                            elseif math.abs(frameRight - targetRight) <= snapDistance then
                                snapX = targetRight - frameWidth
                                snappedX = true
                                self:ShowSnapLine("vertical", targetRight)
                                -- Left edge to right edge (snap next to)
                            elseif math.abs(frameLeft - targetRight) <= snapDistance then
                                snapX = targetRight
                                snappedX = true
                                self:ShowSnapLine("vertical", targetRight)
                                -- Right edge to left edge (snap next to)
                            elseif math.abs(frameRight - targetLeft) <= snapDistance then
                                snapX = targetLeft - frameWidth
                                snappedX = true
                                self:ShowSnapLine("vertical", targetLeft)
                                -- Center to center
                            elseif math.abs(frameCenterX - targetCenterX) <= snapDistance then
                                snapX = targetCenterX - frameWidth / 2
                                snappedX = true
                                self:ShowSnapLine("vertical", targetCenterX)
                            end
                        end

                        -- Vertical snapping (align horizontally)
                        if not snappedY then
                            -- Bottom edge to bottom edge
                            if math.abs(frameBottom - targetBottom) <= snapDistance then
                                snapY = targetBottom
                                snappedY = true
                                self:ShowSnapLine("horizontal", targetBottom)
                                -- Top edge to top edge
                            elseif math.abs(frameTop - targetTop) <= snapDistance then
                                snapY = targetTop - frameHeight
                                snappedY = true
                                self:ShowSnapLine("horizontal", targetTop)
                                -- Bottom edge to top edge (snap next to)
                            elseif math.abs(frameBottom - targetTop) <= snapDistance then
                                snapY = targetTop
                                snappedY = true
                                self:ShowSnapLine("horizontal", targetTop)
                                -- Top edge to bottom edge (snap next to)
                            elseif math.abs(frameTop - targetBottom) <= snapDistance then
                                snapY = targetBottom - frameHeight
                                snappedY = true
                                self:ShowSnapLine("horizontal", targetBottom)
                                -- Center to center
                            elseif math.abs(frameCenterY - targetCenterY) <= snapDistance then
                                snapY = targetCenterY - frameHeight / 2
                                snappedY = true
                                self:ShowSnapLine("horizontal", targetCenterY)
                            end
                        end
                    end
                end
            end

            -- Snap to grid
            if self.db.snapping.snapToGrid and self.db.grid.enabled then
                local gridSize = self.db.grid.size

                if not snappedX then
                    local gridSnapX = math.floor((frameCenterX + gridSize / 2) / gridSize) * gridSize - frameWidth / 2
                    if math.abs(frameCenterX - (gridSnapX + frameWidth / 2)) <= snapDistance then
                        snapX = gridSnapX
                        snappedX = true
                    end
                end

                if not snappedY then
                    local gridSnapY = math.floor((frameCenterY + gridSize / 2) / gridSize) * gridSize - frameHeight / 2
                    if math.abs(frameCenterY - (gridSnapY + frameHeight / 2)) <= snapDistance then
                        snapY = gridSnapY
                        snappedY = true
                    end
                end
            end

            return snapX, snapY
        end

        -- Function to make a frame draggable
        function EditMode:MakeFrameDraggable(frameName)
            local frame = _G[frameName]
            if not frame then
                return false
            end

            -- Skip if frame is restricted during combat, but allow protected frames when not in combat
            if InCombatLockdown() and frame:IsProtected() then
                return false
            end

            -- Store original position
            local point, _, relativePoint, x, y = frame:GetPoint()
            frame.originalPosition = {point, UIParent, relativePoint, x, y}

            -- Store original settings
            frame.originalMovable = frame:IsMovable()
            frame.originalMouseEnabled = frame:IsMouseEnabled()
            frame.originalShown = frame:IsShown()

            -- Make frame movable - SetMovable must be called before SetUserPlaced
            frame:SetMovable(true)
            frame:EnableMouse(true)
            frame:RegisterForDrag("LeftButton")

            -- Only set UserPlaced if the frame is actually movable
            if frame:IsMovable() then
                frame:SetUserPlaced(true)
            end

            -- Store original user placed state
            frame.originalUserPlaced = frame:IsUserPlaced()

            -- Create draggable border first (needed for hidden frame overlays)
            if not frame.draggableBorder then
                frame.draggableBorder = CreateFrame("Frame", nil, UIParent) -- Parent to UIParent instead of frame
                frame.draggableBorder:SetAllPoints(frame)
                -- Ensure border is always visible and on top with very high frame level
                local targetFrameLevel = math.max(frame:GetFrameLevel(), 2)
                frame.draggableBorder:SetFrameLevel(targetFrameLevel + 200) -- Much higher to ensure visibility above all child frames
                frame.draggableBorder:Show() -- Explicitly show the border frame

                -- Create border textures
                local borderSize = 2
                frame.draggableBorder.top = frame.draggableBorder:CreateTexture(nil, "OVERLAY")
                frame.draggableBorder.top:SetPoint("TOPLEFT", frame.draggableBorder, "TOPLEFT", 0, 0)
                frame.draggableBorder.top:SetPoint("TOPRIGHT", frame.draggableBorder, "TOPRIGHT", 0, 0)
                frame.draggableBorder.top:SetHeight(borderSize)
                frame.draggableBorder.top:SetDrawLayer("OVERLAY", 7) -- Very high draw layer

                frame.draggableBorder.bottom = frame.draggableBorder:CreateTexture(nil, "OVERLAY")
                frame.draggableBorder.bottom:SetPoint("BOTTOMLEFT", frame.draggableBorder, "BOTTOMLEFT", 0, 0)
                frame.draggableBorder.bottom:SetPoint("BOTTOMRIGHT", frame.draggableBorder, "BOTTOMRIGHT", 0, 0)
                frame.draggableBorder.bottom:SetHeight(borderSize)
                frame.draggableBorder.bottom:SetDrawLayer("OVERLAY", 7) -- Very high draw layer

                frame.draggableBorder.left = frame.draggableBorder:CreateTexture(nil, "OVERLAY")
                frame.draggableBorder.left:SetPoint("TOPLEFT", frame.draggableBorder, "TOPLEFT", 0, 0)
                frame.draggableBorder.left:SetPoint("BOTTOMLEFT", frame.draggableBorder, "BOTTOMLEFT", 0, 0)
                frame.draggableBorder.left:SetWidth(borderSize)
                frame.draggableBorder.left:SetDrawLayer("OVERLAY", 7) -- Very high draw layer

                frame.draggableBorder.right = frame.draggableBorder:CreateTexture(nil, "OVERLAY")
                frame.draggableBorder.right:SetPoint("TOPRIGHT", frame.draggableBorder, "TOPRIGHT", 0, 0)
                frame.draggableBorder.right:SetPoint("BOTTOMRIGHT", frame.draggableBorder, "BOTTOMRIGHT", 0, 0)
                frame.draggableBorder.right:SetWidth(borderSize)
                frame.draggableBorder.right:SetDrawLayer("OVERLAY", 7) -- Very high draw layer

                frame.draggableBorder:EnableMouse(true)
                frame.draggableBorder:SetMovable(true)
                frame.draggableBorder:RegisterForDrag("LeftButton")
            end

            -- Border frame handles all mouse interactions
            -- Always ensure mouse interaction is properly set up (even on re-enable)
            frame.draggableBorder:EnableMouse(true)
            frame.draggableBorder:SetMovable(true)
            frame.draggableBorder:RegisterForDrag("LeftButton")

            -- Set up drag handlers for border frame (for all frames)
            frame.draggableBorder:SetScript("OnDragStart", function(self)
                if EditMode.isDragModeEnabled and not InCombatLockdown() then
                    -- Store initial drag position
                    local cursorX, cursorY = GetCursorPosition()
                    local uiScale = UIParent:GetEffectiveScale()
                    cursorX = cursorX / uiScale
                    cursorY = cursorY / uiScale

                    local frameLeft = frame:GetLeft() or 0
                    local frameBottom = frame:GetBottom() or 0

                    frame.dragOffsetX = cursorX - frameLeft
                    frame.dragOffsetY = cursorY - frameBottom
                    frame.isDragging = true

                    frame.dragActiveOverlay:Show()
                    self.top:SetColorTexture(0, 0.5, 1, 1) -- Change border to blue while dragging
                    self.bottom:SetColorTexture(0, 0.5, 1, 1)
                    self.left:SetColorTexture(0, 0.5, 1, 1)
                    self.right:SetColorTexture(0, 0.5, 1, 1)

                    -- Start update loop for smooth dragging with snapping
                    if not frame.dragUpdateFrame then
                        frame.dragUpdateFrame = CreateFrame("Frame")
                    end

                    frame.dragUpdateFrame:SetScript("OnUpdate", function()
                        if frame.isDragging then
                            local cursorX, cursorY = GetCursorPosition()
                            local uiScale = UIParent:GetEffectiveScale()
                            cursorX = cursorX / uiScale
                            cursorY = cursorY / uiScale

                            local newX = cursorX - frame.dragOffsetX
                            local newY = cursorY - frame.dragOffsetY

                            -- Apply snapping
                            local snappedX, snappedY = EditMode:GetSnapPosition(frame, newX, newY)

                            frame:ClearAllPoints()
                            frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", snappedX, snappedY)
                        end
                    end)
                end
            end)

            frame.draggableBorder:SetScript("OnDragStop", function(self)
                if EditMode.isDragModeEnabled and not (frame:IsProtected() and InCombatLockdown()) then
                    frame.isDragging = false
                    if frame.dragUpdateFrame then
                        frame.dragUpdateFrame:SetScript("OnUpdate", nil)
                    end

                    EditMode:HideSnapLines()
                    frame.dragActiveOverlay:Hide()

                    -- Save new position
                    EditMode:SaveFramePosition(frameName, frame)

                    -- Restore frame visibility based style
                    EditMode:UpdateFrameOverlayStyle(frame, frameName)
                end
            end)

            frame.draggableBorder:SetScript("OnEnter", function(self)
                if EditMode.isDragModeEnabled then
                    frame.draggableOverlay:SetAlpha(0.6) -- Brighten on hover
                end
            end)

            frame.draggableBorder:SetScript("OnLeave", function(self)
                if EditMode.isDragModeEnabled then
                    frame.draggableOverlay:SetAlpha(1) -- Return to normal
                end
            end)

            frame.draggableBorder:SetScript("OnMouseUp", function(self, button)
                if EditMode.isDragModeEnabled and button == "RightButton" and not InCombatLockdown() and
                    not (frame:IsProtected() and InCombatLockdown()) then
                    EditMode:ShowScalingWindow(frame, frameName)
                end
            end)

            -- Create draggable overlay (persistent visual indicator)
            if not frame.draggableOverlay then
                -- Always create overlay on border frame (UIParent child) so it's always visible above child frames
                frame.draggableOverlay = frame.draggableBorder:CreateTexture(nil, "OVERLAY")
                frame.draggableOverlay:SetAllPoints(frame.draggableBorder)
                frame.draggableOverlay:SetDrawLayer("OVERLAY", 7) -- High draw layer to ensure visibility
            end

            -- Create drag active overlay (shown only while dragging)
            if not frame.dragActiveOverlay then
                -- Always create drag overlay on border frame for consistency
                frame.dragActiveOverlay = frame.draggableBorder:CreateTexture(nil, "OVERLAY")
                frame.dragActiveOverlay:SetAllPoints(frame.draggableBorder)
                frame.dragActiveOverlay:SetColorTexture(0.2, 0.8, 1, 0.4) -- Blue overlay while dragging
                frame.dragActiveOverlay:SetDrawLayer("OVERLAY", 6) -- Very high draw layer for visibility
                frame.dragActiveOverlay:Hide()
            end

            -- Create text label for the frame
            if not frame.draggableLabel then
                frame.draggableLabel = frame.draggableBorder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                frame.draggableLabel:SetPoint("CENTER", frame.draggableBorder, "CENTER", 0, 0)
                frame.draggableLabel:SetTextColor(1, 1, 1, 1) -- White text
                frame.draggableLabel:SetShadowColor(0, 0, 0, 1)
                frame.draggableLabel:SetShadowOffset(2, -2)

                -- Make font size scale with frame size
                local frameWidth = frame:GetWidth() or 100
                local frameHeight = frame:GetHeight() or 50
                local minDimension = math.min(frameWidth, frameHeight)
                local fontSize = math.max(10, math.min(18, minDimension * 0.15)) -- Scale font between 10-18 based on frame size
                frame.draggableLabel:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")

                -- Find the proper name for this frame
                local properName = frameName -- Default fallback
                for _, frameData in ipairs(EditMode.availableFrames) do
                    if frameData.frame == frameName then
                        properName = frameData.name
                        break
                    end
                end
                frame.draggableLabel:SetText(properName)
            end

            -- Set overlay colors based on frame visibility
            EditMode:UpdateFrameOverlayStyle(frame, frameName)

            -- Show draggable indicators (always visible, regardless of frame state)
            frame.draggableOverlay:Show()
            frame.draggableBorder:Show()
            frame.draggableLabel:Show()

            -- For hidden frames, ensure overlays are visible by forcing the frame visible temporarily
            -- and keeping overlays independent
            if not frame.originalShown then
                frame:Show()

                -- Force overlay visibility for hidden frames - make sure overlay is explicitly shown
                frame.draggableOverlay:Show()
                frame.draggableOverlay:SetAlpha(1)
                frame.draggableBorder:SetAlpha(1)
                frame.draggableLabel:SetAlpha(1)
            end

            -- Ensure overlay elements are always on top and visible
            frame.draggableBorder:SetFrameLevel(math.max(UIParent:GetFrameLevel() + 200, 500)) -- Very high frame level
            frame.draggableLabel:SetDrawLayer("OVERLAY", 8) -- Highest draw layer for text

            -- Update border position to track the frame
            frame.draggableBorder:SetScript("OnUpdate", function(self)
                if frame:IsVisible() then
                    self:SetAllPoints(frame)
                    -- For hidden frames, also update the overlay position since it's parented to border
                    if not frame.originalShown and frame.draggableOverlay then
                        frame.draggableOverlay:SetAllPoints(self)
                    end
                end
            end)

            -- For hidden frames, make the border frame handle dragging
            if not frame.originalShown then
                -- Make border frame draggable for hidden frames
                frame.draggableBorder:SetMovable(true)
                frame.draggableBorder:EnableMouse(true)
                frame.draggableBorder:RegisterForDrag("LeftButton")

                -- Border drag handlers for hidden frames
                frame.draggableBorder:SetScript("OnDragStart", function(self)
                    if EditMode.isDragModeEnabled and not InCombatLockdown() then
                        frame:StartMoving() -- Move the actual frame
                        frame.dragActiveOverlay:Show()
                        self.top:SetColorTexture(0, 0.5, 1, 1) -- Change border to blue while dragging
                        self.bottom:SetColorTexture(0, 0.5, 1, 1)
                        self.left:SetColorTexture(0, 0.5, 1, 1)
                        self.right:SetColorTexture(0, 0.5, 1, 1)
                    end
                end)

                frame.draggableBorder:SetScript("OnDragStop", function(self)
                    if EditMode.isDragModeEnabled and not (frame:IsProtected() and InCombatLockdown()) then
                        frame:StopMovingOrSizing() -- Stop moving the actual frame
                        frame.dragActiveOverlay:Hide()

                        -- Save new position
                        EditMode:SaveFramePosition(frameName, frame)

                        -- Restore frame visibility based style
                        EditMode:UpdateFrameOverlayStyle(frame, frameName)
                    end
                end)

                -- Mouse enter/leave effects for border frame
                frame.draggableBorder:SetScript("OnEnter", function(self)
                    if EditMode.isDragModeEnabled then
                        frame.draggableOverlay:SetAlpha(0.6) -- Brighten on hover
                    end
                end)

                frame.draggableBorder:SetScript("OnLeave", function(self)
                    if EditMode.isDragModeEnabled then
                        frame.draggableOverlay:SetAlpha(1) -- Return to normal
                    end
                end)

                -- Right-click to open scaling window for border frame
                frame.draggableBorder:SetScript("OnMouseUp", function(self, button)
                    if EditMode.isDragModeEnabled and button == "RightButton" and not InCombatLockdown() and
                        not (frame:IsProtected() and InCombatLockdown()) then
                        EditMode:ShowScalingWindow(frame, frameName)
                    end
                end)
            end

            -- Mouse enter/leave effects
            frame:SetScript("OnEnter", function(self)
                if EditMode.isDragModeEnabled then
                    self.draggableOverlay:SetAlpha(0.6) -- Brighten on hover
                end
            end)

            frame:SetScript("OnLeave", function(self)
                if EditMode.isDragModeEnabled then
                    self.draggableOverlay:SetAlpha(1) -- Return to normal
                end
            end)

            -- Right-click to open scaling window
            frame:SetScript("OnMouseUp", function(self, button)
                if EditMode.isDragModeEnabled and button == "RightButton" and not InCombatLockdown() and
                    not (self:IsProtected() and InCombatLockdown()) then
                    EditMode:ShowScalingWindow(self, frameName)
                end
            end)

            -- Drag start
            frame:SetScript("OnDragStart", function(self)
                if EditMode.isDragModeEnabled and not InCombatLockdown() and not (self:IsProtected() and InCombatLockdown()) then
                    self:StartMoving()
                    self.dragActiveOverlay:Show()
                    self.draggableBorder.top:SetColorTexture(0, 0.5, 1, 1) -- Change border to blue while dragging
                    self.draggableBorder.bottom:SetColorTexture(0, 0.5, 1, 1)
                    self.draggableBorder.left:SetColorTexture(0, 0.5, 1, 1)
                    self.draggableBorder.right:SetColorTexture(0, 0.5, 1, 1)
                end
            end)

            -- Drag stop
            frame:SetScript("OnDragStop", function(self)
                if EditMode.isDragModeEnabled and not (self:IsProtected() and InCombatLockdown()) then
                    self:StopMovingOrSizing()
                    self.dragActiveOverlay:Hide()

                    -- Save new position
                    EditMode:SaveFramePosition(frameName, self)

                    -- Restore frame visibility based style
                    EditMode:UpdateFrameOverlayStyle(self, frameName)
                end
            end)

            -- Add to draggable frames list
            EditMode.draggableFrames[frameName] = frame

            return true
        end

        -- Function to update frame overlay style based on visibility
        function EditMode:UpdateFrameOverlayStyle(frame, frameName)
            if not frame or not frame.draggableOverlay or not frame.draggableBorder then
                return
            end

            local isVisible = frame.originalShown

            -- Visible frames: Green tint and border
            frame.draggableOverlay:SetColorTexture(0.1, 0.9, 0.1, 0.6) -- Green tint (increased from 0.4 to 0.6)
            frame.draggableBorder.top:SetColorTexture(0, 1, 0, 1.0) -- Green border (increased from 0.9 to 1.0)
            frame.draggableBorder.bottom:SetColorTexture(0, 1, 0, 1.0)
            frame.draggableBorder.left:SetColorTexture(0, 1, 0, 1.0)
            frame.draggableBorder.right:SetColorTexture(0, 1, 0, 1.0)
        end

        -- Function to remove draggable functionality
        function EditMode:RemoveFrameDraggable(frameName)
            local frame = _G[frameName]
            if not frame then
                return false
            end

            -- Restore original settings
            if frame.originalMovable then
                frame:SetMovable(frame.originalMovable)
            else
                frame:SetMovable(false)
            end

            if frame.originalMouseEnabled then
                frame:EnableMouse(frame.originalMouseEnabled)
            else
                frame:EnableMouse(false)
            end

            -- Handle UserPlaced state - keep it true if we have a saved position
            if EditMode.db and EditMode.db.frames and EditMode.db.frames[frameName] and EditMode.db.frames[frameName].position then
                -- Only set UserPlaced if frame is movable
                if frame:IsMovable() then
                    frame:SetUserPlaced(true) -- Keep UserPlaced true to prevent repositioning
                end
            elseif frame.originalUserPlaced then
                -- Only set UserPlaced if frame is movable
                if frame:IsMovable() then
                    frame:SetUserPlaced(frame.originalUserPlaced)
                end
            else
                -- Only set UserPlaced if frame is movable
                if frame:IsMovable() then
                    frame:SetUserPlaced(false)
                end
            end

            -- Restore original visibility
            if frame.originalShown ~= nil then
                if frame.originalShown then
                    frame:Show()
                else
                    frame:Hide()
                end
            end

            frame:RegisterForDrag()
            frame:SetScript("OnDragStart", nil)
            frame:SetScript("OnDragStop", nil)
            frame:SetScript("OnEnter", nil)
            frame:SetScript("OnLeave", nil)

            -- Hide and clean up all overlay elements
            if frame.draggableOverlay then
                frame.draggableOverlay:Hide()
            end

            if frame.dragActiveOverlay then
                frame.dragActiveOverlay:Hide()
            end

            if frame.draggableBorder then
                frame.draggableBorder:SetScript("OnUpdate", nil) -- Remove update script
                frame.draggableBorder:SetScript("OnDragStart", nil) -- Remove border drag handlers
                frame.draggableBorder:SetScript("OnDragStop", nil)
                frame.draggableBorder:SetScript("OnEnter", nil)
                frame.draggableBorder:SetScript("OnLeave", nil)
                frame.draggableBorder:EnableMouse(false)
                frame.draggableBorder:SetMovable(false)
                frame.draggableBorder:RegisterForDrag()
                frame.draggableBorder:Hide()
            end

            if frame.draggableLabel then
                frame.draggableLabel:Hide()
            end

            -- Restore original position only if we don't have a saved position
            if frame.originalPosition and (not EditMode.db or not EditMode.db.frames or not EditMode.db.frames[frameName]) then
                frame:ClearAllPoints()
                frame:SetPoint(unpack(frame.originalPosition))
            end

            -- Clean up stored values
            frame.originalPosition = nil
            frame.originalMovable = nil
            frame.originalMouseEnabled = nil
            frame.originalShown = nil
            frame.originalAnchor = nil
            frame.originalUserPlaced = nil

            EditMode.draggableFrames[frameName] = nil
            return true
        end

        -- Function to enable drag mode
        function EditMode:EnableDragMode()
            if InCombatLockdown() then
                return
            end

            EditMode.isDragModeEnabled = true
            local count = 0
            local failed = 0

            for _, frameData in ipairs(EditMode.availableFrames) do
                if EditMode:MakeFrameDraggable(frameData.frame) then
                    count = count + 1
                else
                    failed = failed + 1
                end
            end
        end

        -- Function to disable drag mode
        function EditMode:DisableDragMode()
            if InCombatLockdown() then
                return
            end

            EditMode.isDragModeEnabled = false

            for frameName, _ in pairs(EditMode.draggableFrames) do
                EditMode:RemoveFrameDraggable(frameName)
            end
        end

        -- Function to toggle overlay visibility
        function EditMode:ToggleOverlayVisibility(show)
            for frameName, frame in pairs(EditMode.draggableFrames) do
                if frame.draggableOverlay then
                    if show then
                        frame.draggableOverlay:Show()
                    else
                        frame.draggableOverlay:Hide()
                    end
                end

                if frame.draggableBorder then
                    if show then
                        frame.draggableBorder:Show()
                    else
                        frame.draggableBorder:Hide()
                    end
                end

                if frame.draggableLabel then
                    if show then
                        frame.draggableLabel:Show()
                    else
                        frame.draggableLabel:Hide()
                    end
                end
            end
        end

        -- Function to reset frame positions
        function EditMode:ResetFramePositions()
            for frameName, frame in pairs(EditMode.draggableFrames) do
                if frame.originalPosition then
                    frame:ClearAllPoints()
                    frame:SetPoint(unpack(frame.originalPosition))
                end
            end
        end

        -- Initialize grid on startup
        EditMode:UpdateGrid()

        -- Check if grid is enabled on startup and enable drag mode if so
        -- Also restore all saved frame positions on addon load
        C_Timer.After(0, function()
            -- Store original button visibility before any changes
            EditMode:StoreActionButtonVisibility()

            if EditMode.db.grid.enabled and not InCombatLockdown() then
                EditMode:EnableDragMode()
            end

            -- Apply default positions to frames without saved positions first
            EditMode:ApplyDefaultPositions()

            -- Then restore all saved frame positions on addon load (this will override defaults for saved frames)
            EditMode:RestoreAllSavedPositions()

            -- Apply action bar layouts if mUI action bars are enabled
            if mUI.db.profile.actionbars.style == "mUI" then
                EditMode:ApplyAllActionBarLayouts()
                -- Restore original visibility after layouts are applied
                EditMode:RestoreActionButtonVisibility()
            end
        end)

        -- Create Snapping Settings Panel
        function EditMode:CreateSnappingPanel()
            if EditMode.snappingPanel then
                return -- Already created
            end

            -- Main snapping panel frame
            EditMode.snappingPanel = CreateFrame("Frame", "mUISnappingPanel", UIParent, "BackdropTemplate")
            EditMode.snappingPanel:SetSize(200, 180)
            EditMode.snappingPanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
            EditMode.snappingPanel:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                tile = true,
                tileSize = 16,
                edgeSize = 16,
                insets = {
                    left = 4,
                    right = 4,
                    top = 4,
                    bottom = 4
                }
            })
            EditMode.snappingPanel:SetBackdropColor(0, 0, 0, 0.8)
            EditMode.snappingPanel:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
            EditMode.snappingPanel:SetFrameLevel(1000)
            EditMode.snappingPanel:Hide() -- Hidden by default

            -- Title
            EditMode.snappingPanel.title = EditMode.snappingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            EditMode.snappingPanel.title:SetPoint("TOP", EditMode.snappingPanel, "TOP", 0, -10)
            EditMode.snappingPanel.title:SetText("Snapping")
            EditMode.snappingPanel.title:SetTextColor(1, 1, 1, 1)

            -- Enable Snapping checkbox
            EditMode.snappingPanel.enableCheckbox = CreateFrame("CheckButton", "mUISnappingEnable", EditMode.snappingPanel, "UICheckButtonTemplate")
            EditMode.snappingPanel.enableCheckbox:SetPoint("TOPLEFT", EditMode.snappingPanel, "TOPLEFT", 15, -35)
            EditMode.snappingPanel.enableCheckbox:SetSize(20, 20)
            EditMode.snappingPanel.enableCheckbox:SetChecked(EditMode.db.snapping.enabled)

            EditMode.snappingPanel.enableLabel = EditMode.snappingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.snappingPanel.enableLabel:SetPoint("LEFT", EditMode.snappingPanel.enableCheckbox, "RIGHT", 5, 0)
            EditMode.snappingPanel.enableLabel:SetText("Enable Snapping")
            EditMode.snappingPanel.enableLabel:SetTextColor(1, 1, 1, 1)

            -- Snap to Center checkbox
            EditMode.snappingPanel.centerCheckbox = CreateFrame("CheckButton", "mUISnapToCenter", EditMode.snappingPanel, "UICheckButtonTemplate")
            EditMode.snappingPanel.centerCheckbox:SetPoint("TOPLEFT", EditMode.snappingPanel.enableCheckbox, "BOTTOMLEFT", 0, -10)
            EditMode.snappingPanel.centerCheckbox:SetSize(20, 20)
            EditMode.snappingPanel.centerCheckbox:SetChecked(EditMode.db.snapping.snapToCenter)

            EditMode.snappingPanel.centerLabel = EditMode.snappingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.snappingPanel.centerLabel:SetPoint("LEFT", EditMode.snappingPanel.centerCheckbox, "RIGHT", 5, 0)
            EditMode.snappingPanel.centerLabel:SetText("Snap to Center")
            EditMode.snappingPanel.centerLabel:SetTextColor(1, 1, 1, 1)

            -- Snap to Frames checkbox
            EditMode.snappingPanel.framesCheckbox = CreateFrame("CheckButton", "mUISnapToFrames", EditMode.snappingPanel, "UICheckButtonTemplate")
            EditMode.snappingPanel.framesCheckbox:SetPoint("TOPLEFT", EditMode.snappingPanel.centerCheckbox, "BOTTOMLEFT", 0, -10)
            EditMode.snappingPanel.framesCheckbox:SetSize(20, 20)
            EditMode.snappingPanel.framesCheckbox:SetChecked(EditMode.db.snapping.snapToFrames)

            EditMode.snappingPanel.framesLabel = EditMode.snappingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.snappingPanel.framesLabel:SetPoint("LEFT", EditMode.snappingPanel.framesCheckbox, "RIGHT", 5, 0)
            EditMode.snappingPanel.framesLabel:SetText("Snap to Frames")
            EditMode.snappingPanel.framesLabel:SetTextColor(1, 1, 1, 1)

            -- Snap to Grid checkbox
            EditMode.snappingPanel.gridCheckbox = CreateFrame("CheckButton", "mUISnapToGrid", EditMode.snappingPanel, "UICheckButtonTemplate")
            EditMode.snappingPanel.gridCheckbox:SetPoint("TOPLEFT", EditMode.snappingPanel.framesCheckbox, "BOTTOMLEFT", 0, -10)
            EditMode.snappingPanel.gridCheckbox:SetSize(20, 20)
            EditMode.snappingPanel.gridCheckbox:SetChecked(EditMode.db.snapping.snapToGrid)

            EditMode.snappingPanel.gridLabel = EditMode.snappingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.snappingPanel.gridLabel:SetPoint("LEFT", EditMode.snappingPanel.gridCheckbox, "RIGHT", 5, 0)
            EditMode.snappingPanel.gridLabel:SetText("Snap to Grid")
            EditMode.snappingPanel.gridLabel:SetTextColor(1, 1, 1, 1)

            -- Show Snap Lines checkbox
            EditMode.snappingPanel.linesCheckbox = CreateFrame("CheckButton", "mUIShowSnapLines", EditMode.snappingPanel, "UICheckButtonTemplate")
            EditMode.snappingPanel.linesCheckbox:SetPoint("TOPLEFT", EditMode.snappingPanel.gridCheckbox, "BOTTOMLEFT", 0, -10)
            EditMode.snappingPanel.linesCheckbox:SetSize(20, 20)
            EditMode.snappingPanel.linesCheckbox:SetChecked(EditMode.db.snapping.showSnapLines)

            EditMode.snappingPanel.linesLabel = EditMode.snappingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            EditMode.snappingPanel.linesLabel:SetPoint("LEFT", EditMode.snappingPanel.linesCheckbox, "RIGHT", 5, 0)
            EditMode.snappingPanel.linesLabel:SetText("Show Snap Lines")
            EditMode.snappingPanel.linesLabel:SetTextColor(1, 1, 1, 1)

            -- Close button
            EditMode.snappingPanel.closeButton = CreateFrame("Button", "mUISnappingPanelClose", EditMode.snappingPanel, "UIPanelCloseButton")
            EditMode.snappingPanel.closeButton:SetPoint("TOPRIGHT", EditMode.snappingPanel, "TOPRIGHT", -5, -5)
            EditMode.snappingPanel.closeButton:SetSize(20, 20)
            EditMode.snappingPanel.closeButton:SetScript("OnClick", function()
                EditMode.snappingPanel:Hide()
            end)

            -- Checkbox event handlers
            EditMode.snappingPanel.enableCheckbox:SetScript("OnClick", function(self)
                EditMode.db.snapping.enabled = self:GetChecked()
            end)

            EditMode.snappingPanel.centerCheckbox:SetScript("OnClick", function(self)
                EditMode.db.snapping.snapToCenter = self:GetChecked()
            end)

            EditMode.snappingPanel.framesCheckbox:SetScript("OnClick", function(self)
                EditMode.db.snapping.snapToFrames = self:GetChecked()
            end)

            EditMode.snappingPanel.gridCheckbox:SetScript("OnClick", function(self)
                EditMode.db.snapping.snapToGrid = self:GetChecked()
            end)

            EditMode.snappingPanel.linesCheckbox:SetScript("OnClick", function(self)
                EditMode.db.snapping.showSnapLines = self:GetChecked()
            end)

            -- Make panel movable
            EditMode.snappingPanel:SetMovable(true)
            EditMode.snappingPanel:EnableMouse(true)
            EditMode.snappingPanel:RegisterForDrag("LeftButton")
            EditMode.snappingPanel:SetScript("OnDragStart", function(self)
                self:StartMoving()
            end)
            EditMode.snappingPanel:SetScript("OnDragStop", function(self)
                self:StopMovingOrSizing()
            end)

            -- Close on Escape key
            EditMode.snappingPanel:SetScript("OnKeyDown", function(self, key)
                if key == "ESCAPE" then
                    self:Hide()
                end
            end)
        end

        -- Create Menu Button
        EditMode.menuButton = CreateFrame("Button", "mUI_EditModeButton", GameMenuFrame, "UIPanelButtonTemplate")
        EditMode.menuButton:SetHeight(20)
        EditMode.menuButton:SetWidth(145)
        EditMode.menuButton:SetText("Edit Mode")
        EditMode.menuButton:SetPoint("CENTER", GameMenuButtonContinue, "CENTER", 0, -30)
        EditMode:SecureHookScript(EditMode.menuButton, "OnClick", function()
            EditMode:ToggleGrid()
            ToggleGameMenu()
        end)

        -- Add keybinding for snapping panel toggle (Ctrl+S while in edit mode)
        local snappingKeybind = CreateFrame("Frame")
        snappingKeybind:RegisterEvent("ADDON_LOADED")
        snappingKeybind:SetScript("OnEvent", function(self, event, addonName)
            if addonName == "mUI" then
                snappingKeybind:SetScript("OnKeyDown", function(self, key)
                    if EditMode.isDragModeEnabled and IsControlKeyDown() and key == "S" then
                        if not EditMode.snappingPanel then
                            EditMode:CreateSnappingPanel()
                        end

                        if EditMode.snappingPanel:IsShown() then
                            EditMode.snappingPanel:Hide()
                        else
                            EditMode.snappingPanel:Show()
                        end
                    end
                end)
                snappingKeybind:EnableKeyboard(true)
            end
        end)

        EditMode:SecureHookScript(GameMenuFrame, "OnShow", function()
            GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + 45)
        end)
    elseif mUI:GameVersion()["TBC"] then
        -- Load Libraries
        EditMode.LEM = ns.LibEditMode

        -- Stats Frame
        function EditMode:StatsFrame(layout, point, x, y)
            EditMode.db[layout].statsframe.point = point
            EditMode.db[layout].statsframe.x = x
            EditMode.db[layout].statsframe.y = y
        end

        -- GameTooltip
        local mUIGameTooltip = CreateFrame("Frame", "mUIGameTooltip", UIParent)
        mUIGameTooltip:SetSize(160, 90)
        mUIGameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

        EditMode:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("CENTER", mUIGameTooltip, "CENTER")
        end)

        function EditMode:GameTooltip(layout, point, x, y)
            EditMode.db[layout].gametooltip.point = point
            EditMode.db[layout].gametooltip.x = x
            EditMode.db[layout].gametooltip.y = y
        end

        EditMode.LEM:AddFrame(mUI.statsFrame, EditMode.StatsFrame)
        EditMode.LEM:AddFrame(mUIGameTooltip, EditMode.GameTooltip)

        EditMode.LEM:RegisterCallback('layout', function(layout)
            if not EditMode.db[layout] then
                EditMode.db[layout] = {
                    ["statsframe"] = {
                        ["point"] = "BOTTOMLEFT",
                        ["x"] = 0,
                        ["y"] = 0
                    },
                    ["gametooltip"] = {
                        ["point"] = "BOTTOMRIGHT",
                        ["x"] = 0,
                        ["y"] = 0
                    }
                }
            else
                if not EditMode.db[layout]["gametooltip"] then
                    EditMode.db[layout]["gametooltip"] = {
                        ["point"] = "BOTTOMRIGHT",
                        ["x"] = 0,
                        ["y"] = 0
                    }
                end
            end

            mUI.statsFrame:ClearAllPoints()
            mUI.statsFrame:SetPoint(EditMode.db[layout].statsframe.point, EditMode.db[layout].statsframe.x, EditMode.db[layout].statsframe.y)

            mUIGameTooltip:ClearAllPoints()
            mUIGameTooltip:SetPoint(EditMode.db[layout].gametooltip.point, EditMode.db[layout].gametooltip.x, EditMode.db[layout].gametooltip.y)
        end)
    elseif mUI:GameVersion()["Mainline"] then
        -- Load Libraries
        EditMode.LEM = ns.LibEditMode

        -- Create Holder Frame
        EditMode.QueueStatus = CreateFrame("Frame", "mUIQueueStatusButton", UIParent)
        EditMode.QueueStatus:SetSize(QueueStatusButton:GetWidth(), QueueStatusButton:GetHeight())
        EditMode.QueueStatus:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

        -- Set QueueStatusButton to Holder Frame
        QueueStatusButton:SetParent(EditMode.QueueStatus)
        QueueStatusButton:ClearAllPoints()
        QueueStatusButton:SetPoint("CENTER", EditMode.QueueStatus)
        -- Keep button centered when Blizzard tries to reposition it
        local ignoringPointHook = false
        EditMode:SecureHook(QueueStatusButton, "SetPoint", function()
            if ignoringPointHook then
                return
            end
            ignoringPointHook = true
            QueueStatusButton:ClearAllPoints()
            QueueStatusButton:SetPoint("CENTER", EditMode.QueueStatus)
            ignoringPointHook = false
        end)

        -- Desired scale for QueueStatusButton; updated by layout callback and slider.
        -- The SetScale hook below ensures Blizzard can never override this.
        local queueDesiredScale = 0.8
        EditMode:SecureHook(QueueStatusButton, "SetScale", function(self, scale)
            if scale ~= queueDesiredScale then
                self:SetScale(queueDesiredScale)
            end
        end)

        -- Stats Frame
        function EditMode:StatsFrame(layout, point, x, y)
            if not EditMode.db[layout].statsframe then
                EditMode.db[layout].statsframe = {}
            end
            EditMode.db[layout].statsframe.point = point
            EditMode.db[layout].statsframe.x = x
            EditMode.db[layout].statsframe.y = y
        end

        -- QueueStatusButton
        function EditMode:QueueIcon(layout, point, x, y)
            if not EditMode.db[layout].queueicon then
                EditMode.db[layout].queueicon = {}
            end
            EditMode.db[layout].queueicon.point = point
            EditMode.db[layout].queueicon.x = x
            EditMode.db[layout].queueicon.y = y
        end

        EditMode.LEM:AddFrame(mUI.statsFrame, EditMode.StatsFrame)
        EditMode.LEM:AddFrame(EditMode.QueueStatus, EditMode.QueueIcon)

        EditMode.LEM:RegisterCallback('layout', function(layout)
            if not EditMode.db[layout] then
                EditMode.db[layout] = {}
            end
            if not EditMode.db[layout].statsframe then
                EditMode.db[layout].statsframe = {
                    point = "BOTTOMLEFT",
                    x = 0,
                    y = 0
                }
            end
            if not EditMode.db[layout].queueicon then
                EditMode.db[layout].queueicon = {
                    point = "TOPRIGHT",
                    x = -166.668701171875,
                    y = -164.1666259765625
                }
            end

            mUI.statsFrame:ClearAllPoints()
            mUI.statsFrame:SetPoint(EditMode.db[layout].statsframe.point, EditMode.db[layout].statsframe.x, EditMode.db[layout].statsframe.y)

            -- Apply stats frame text size
            local textSize = EditMode.db[layout].statsframe.textsize or 13
            local Stats = mUI:GetModule("mUI.Modules.General.Stats")
            local fontPath = Stats and Stats.db and Stats.db.general.font ~= "None" and Stats.db.general.fontpath or STANDARD_TEXT_FONT
            mUI.statsFrame.text:SetFont(fontPath, textSize, "OUTLINE")

            EditMode.QueueStatus:ClearAllPoints()
            EditMode.QueueStatus:SetPoint(EditMode.db[layout].queueicon.point, EditMode.db[layout].queueicon.x, EditMode.db[layout].queueicon.y)

            -- Apply QueueStatusButton scale
            queueDesiredScale = EditMode.db[layout].queueicon.scale or 0.8
            QueueStatusButton:SetScale(queueDesiredScale)
        end)

        EditMode.LEM:AddFrameSettings(mUI.statsFrame, {{
            name = 'Text Size',
            kind = EditMode.LEM.SettingType.Slider,
            default = 13,
            get = function(layout)
                return EditMode.db[layout].statsframe and EditMode.db[layout].statsframe.textsize or 13
            end,
            set = function(layout, value)
                if not EditMode.db[layout].statsframe then
                    EditMode.db[layout].statsframe = {}
                end
                EditMode.db[layout].statsframe.textsize = value
                local Stats = mUI:GetModule("mUI.Modules.General.Stats")
                local fontPath = Stats and Stats.db and Stats.db.general.font ~= "None" and Stats.db.general.fontpath or STANDARD_TEXT_FONT
                mUI.statsFrame.text:SetFont(fontPath, value, "OUTLINE")
            end,
            minValue = 6,
            maxValue = 32,
            valueStep = 1,
            formatter = function(value)
                return tostring(value)
            end
        }})

        EditMode.LEM:AddFrameSettings(EditMode.QueueStatus, {{
            name = 'Button Size',
            kind = EditMode.LEM.SettingType.Slider,
            default = 0.8,
            get = function(layout)
                return EditMode.db[layout].queueicon and EditMode.db[layout].queueicon.scale or 0.8
            end,
            set = function(layout, value)
                if not EditMode.db[layout].queueicon then
                    EditMode.db[layout].queueicon = {}
                end
                EditMode.db[layout].queueicon.scale = value
                queueDesiredScale = value
                QueueStatusButton:SetScale(value)
            end,
            minValue = 0.1,
            maxValue = 5,
            valueStep = 0.1,
            formatter = function(value)
                return FormatPercentage(value, true)
            end
        }})
    end
end
