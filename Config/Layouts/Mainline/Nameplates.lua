local Nameplates = mUI:NewModule("mUI.Config.Layouts.Nameplates")

function Nameplates:OnInitialize()
    -- Load Libraries
    Nameplates.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    Nameplates.Module = mUI:GetModule("mUI.Modules.Nameplates")

    local function db()
        return mUI.db.profile.nameplates
    end

    -- Toggles a feature submodule and refreshes it, without touching anything
    -- when the parent nameplate module is switched off entirely.
    local function SetFeature(submodule, enabled)
        if not Nameplates.Module:IsEnabled() then
            return
        end

        if enabled then
            submodule:Enable()
        else
            submodule:Disable()
        end
    end

    local function Refresh(submodule)
        if Nameplates.Module:IsEnabled() and submodule:IsEnabled() then
            submodule:Update()
        end
    end

    local ANCHOR_VALUES = {
        LEFT = "Left",
        RIGHT = "Right",
        TOP = "Top",
        BOTTOM = "Bottom"
    }
    local ANCHOR_SORTING = {"LEFT", "RIGHT", "TOP", "BOTTOM"}

    -- Initialize Layout
    Nameplates.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if db().enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    db().enabled = val

                    if val then
                        Nameplates.Module:Enable()
                        mUI:Reload('Enable Nameplates Module')
                    else
                        Nameplates.Module:Disable()
                        mUI:Reload('Disable Nameplates Module')
                    end
                end,
                get = function()
                    return db().enabled
                end,
                order = 1
            },

            -- General ---------------------------------------------------------

            header1 = {
                name = "Textures",
                type = "header",
                order = 2
            },
            texture = {
                name = "Health Texture",
                desc = "Select a Texture for the Nameplates",
                type = "select",
                values = Nameplates.LSM:HashTable("statusbar"),
                dialogControl = 'mUI_LSM30_Status',
                set = function(_, val)
                    db().texture = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().texture
                end,
                order = 3
            },
            focusTexture = {
                name = "Focus Texture",
                desc = "Use a distinct Texture on your Focus Target's Health Bar",
                type = "toggle",
                set = function(_, val)
                    db().focus = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().focus
                end,
                order = 3.5
            },

            -- Size ------------------------------------------------------------

            header2 = {
                name = "Sizes",
                type = "header",
                order = 4
            },
            sizeHealthWidth = {
                name = "Health Bar Width",
                desc = "Set the Width of the Health Bar",
                type = "range",
                min = 50,
                max = 400,
                step = 1,
                set = function(_, val)
                    db().size.healthwidth = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().size.healthwidth
                end,
                order = 5
            },
            sizeHealthHeight = {
                name = "Health Bar Height",
                desc = "Set the Height of the Health Bar",
                type = "range",
                min = 4,
                max = 60,
                step = 1,
                set = function(_, val)
                    db().size.healthheight = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().size.healthheight
                end,
                order = 6
            },
            sizeCastWidth = {
                name = "Cast Bar Width",
                desc = "Set the Width of the Cast Bar",
                type = "range",
                min = 50,
                max = 400,
                step = 1,
                set = function(_, val)
                    db().size.castwidth = val
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return db().size.castwidth
                end,
                order = 7
            },
            sizeCastHeight = {
                name = "Cast Bar Height",
                desc = "Set the Height of the Cast Bar",
                type = "range",
                min = 4,
                max = 60,
                step = 1,
                set = function(_, val)
                    db().size.castheight = val
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return db().size.castheight
                end,
                order = 8
            },
            castbarY = {
                name = "Cast Bar Vertical Offset",
                desc = "Move the Cast Bar closer to or further from the Health Bar\n\n|cffffff00Info:|r Positive values move it further away, negative values pull it closer",
                type = "range",
                min = -30,
                max = 50,
                step = 1,
                set = function(_, val)
                    db().castbar.y = val
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return db().castbar.y
                end,
                order = 9
            },
            nameSize = {
                name = "Name Text Size",
                desc = "Set the Font Size of the Unit Name",
                type = "range",
                min = 6,
                max = 32,
                step = 1,
                set = function(_, val)
                    db().name.size = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().name.size
                end,
                order = 10
            },
            scaleTarget = {
                name = "Target Scale",
                desc = "Set the Size of your Target's Nameplate",
                type = "range",
                min = 0.5,
                max = 2,
                step = 0.05,
                isPercent = true,
                set = function(_, val)
                    db().scale.target = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().scale.target
                end,
                order = 11
            },
            scaleOther = {
                name = "Normal Scale",
                desc = "Set the Size of Nameplates that are not your Target",
                type = "range",
                min = 0.5,
                max = 2,
                step = 0.05,
                isPercent = true,
                set = function(_, val)
                    db().scale.other = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().scale.other
                end,
                order = 12
            },

            -- Options ---------------------------------------------------------

            header3 = {
                name = "Options",
                type = "header",
                order = 13
            },
            healthPercent = {
                name = "Health Percent",
                desc = "Show the Unit's Health as a Percentage on the Health Bar",
                type = "toggle",
                set = function(_, val)
                    db().health.percent = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().health.percent
                end,
                order = 14
            },
            healthPercentAnchor = {
                name = "Percent Position",
                desc = "Select where the Percentage sits on the Health Bar",
                type = "select",
                values = {
                    LEFT = "Left",
                    CENTER = "Center",
                    RIGHT = "Right",
                    TOP = "Top",
                    BOTTOM = "Bottom"
                },
                sorting = {"LEFT", "CENTER", "RIGHT", "TOP", "BOTTOM"},
                disabled = function()
                    return not db().health.percent
                end,
                set = function(_, val)
                    db().health.anchor = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().health.anchor
                end,
                order = 15
            },
            healthPercentX = {
                name = "Percent Offset X",
                desc = "Move the Percentage horizontally",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().health.percent
                end,
                set = function(_, val)
                    db().health.x = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().health.x
                end,
                order = 16
            },
            healthPercentY = {
                name = "Percent Offset Y",
                desc = "Move the Percentage vertically",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().health.percent
                end,
                set = function(_, val)
                    db().health.y = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().health.y
                end,
                order = 17
            },
            namesArena = {
                name = "Arena Number",
                desc = "Show the Arena Number instead of the Name on Enemy Player Nameplates\n\n|cffffff00Info:|r Always Class Colored",
                type = "toggle",
                set = function(_, val)
                    db().names.arena = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().names.arena
                end,
                order = 18
            },
            namesSpec = {
                name = "Specialization Name",
                desc = "Show the Specialization instead of the Name on Enemy Player Nameplates\n\n|cffffff00Info:|r Combines with Arena Number, e.g. |cffffffffHoly 1|r",
                type = "toggle",
                set = function(_, val)
                    db().names.spec = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().names.spec
                end,
                order = 19
            },

            -- Friendly Players ------------------------------------------------

            header4 = {
                name = "Friendly",
                type = "header",
                order = 19.5
            },
            friendlyHideHealthBar = {
                name = "Hide Health Bar",
                desc = "Hide the Health Bar, Cast Bar, Name and Target Indicator on Friendly Player Nameplates",
                type = "toggle",
                set = function(_, val)
                    db().friendly.hidehealthbar = val
                    Refresh(Nameplates.Module.Health)
                    Refresh(Nameplates.Module.TargetIndicator)
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return db().friendly.hidehealthbar
                end,
                order = 20
            },
            friendlyHideNames = {
                name = "Hide Names",
                desc = "Hide the Name on Friendly Player Nameplates\n\n|cffffff00Info:|r NPC Names are always shown",
                type = "toggle",
                set = function(_, val)
                    db().friendly.hidenames = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().friendly.hidenames
                end,
                order = 21
            },
            clickthrough = {
                name = "Clickthrough",
                desc = "Stop Friendly Nameplates from responding to the mouse, so they cannot be clicked or targeted\n\n|cffffff00Info:|r Enemy Nameplates always stay clickable",
                type = "toggle",
                set = function(_, val)
                    db().clickthrough = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    Nameplates.Module.Core:RefreshHitTest()
                end,
                get = function()
                    return db().clickthrough
                end,
                order = 22
            },
            friendlyClasscolor = {
                name = "Class Color",
                desc = "Color Friendly Player Health Bars and Names by Class",
                type = "toggle",
                set = function(_, val)
                    db().friendly.classcolor = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().friendly.classcolor
                end,
                order = 23
            },
            friendlySmall = {
                name = "Small Friendly Plates",
                desc = "Narrow the Health Bar and Cast Bar on Friendly Nameplates\n\n|cffffff00Info:|r Bar Height stays on the shared sliders",
                type = "toggle",
                set = function(_, val)
                    db().friendly.small = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().friendly.small
                end,
                order = 24
            },
            friendlyWidth = {
                name = "Friendly Bar Width",
                desc = "Set the Health Bar Width used by Small Friendly Plates",
                type = "range",
                min = 30,
                max = 400,
                step = 1,
                disabled = function()
                    return not db().friendly.small
                end,
                set = function(_, val)
                    db().friendly.width = val
                    Refresh(Nameplates.Module.Style)
                end,
                get = function()
                    return db().friendly.width
                end,
                order = 25
            },

            -- Class Icons -----------------------------------------------------

            header5 = {
                name = "Class Icon",
                type = "header",
                order = 26
            },
            classiconsEnabled = {
                name = "Class Icons",
                desc = "Show a Class or Specialization Icon next to Player Nameplates",
                type = "toggle",
                set = function(_, val)
                    db().classicons.enabled = val
                    SetFeature(Nameplates.Module.ClassIcon, val)
                end,
                get = function()
                    return db().classicons.enabled
                end,
                order = 27
            },
            classiconsSpec = {
                name = "Specialization Icon",
                desc = "Show the Specialization Icon instead of the Class Icon when it is known\n\n|cffffff00Info:|r Falls back to the Class Icon until the Specialization is identified",
                type = "toggle",
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.spec = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.spec
                end,
                order = 28
            },
            classiconsFriendly = {
                name = "Friendly Players",
                desc = "Show the Icon on Friendly Player Nameplates",
                type = "toggle",
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.friendly = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.friendly
                end,
                order = 29
            },
            classiconsEnemy = {
                name = "Enemy Players",
                desc = "Show the Icon on Enemy Player Nameplates",
                type = "toggle",
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.enemy = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.enemy
                end,
                order = 30
            },
            classiconsAnchor = {
                name = "Position",
                desc = "Select where the Icon is anchored on the Nameplate",
                type = "select",
                values = ANCHOR_VALUES,
                sorting = ANCHOR_SORTING,
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.anchor = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.anchor
                end,
                order = 31
            },
            classiconsSize = {
                name = "Icon Size",
                desc = "Set the Size of the Icon",
                type = "range",
                min = 8,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.size = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.size
                end,
                order = 32
            },
            classiconsX = {
                name = "Offset X",
                desc = "Move the Icon horizontally away from the Nameplate",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.x = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.x
                end,
                order = 33
            },
            classiconsY = {
                name = "Offset Y",
                desc = "Move the Icon vertically away from the Nameplate",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.y = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.y
                end,
                order = 34
            },

            -- Healer ----------------------------------------------------------

            header6 = {
                name = "Healer",
                type = "header",
                order = 35
            },
            healerEnabled = {
                name = "Healer Indicator",
                desc = "Show an Icon on the Nameplates of Players who are healing\n\n|cffffff00Info:|r Arena opponents are identified immediately; elsewhere the Role has to be inspected first",
                type = "toggle",
                set = function(_, val)
                    db().healer.enabled = val
                    SetFeature(Nameplates.Module.Healer, val)
                end,
                get = function()
                    return db().healer.enabled
                end,
                order = 36
            },
            healerFriendly = {
                name = "Friendly Players",
                desc = "Show the Icon on Friendly Healers",
                type = "toggle",
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.friendly = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.friendly
                end,
                order = 37
            },
            healerEnemy = {
                name = "Enemy Players",
                desc = "Show the Icon on Enemy Healers",
                type = "toggle",
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.enemy = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.enemy
                end,
                order = 38
            },
            healerAnchor = {
                name = "Position",
                desc = "Select where the Icon is anchored on the Nameplate",
                type = "select",
                values = ANCHOR_VALUES,
                sorting = ANCHOR_SORTING,
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.anchor = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.anchor
                end,
                order = 39
            },
            healerSize = {
                name = "Icon Size",
                desc = "Set the Size of the Icon",
                type = "range",
                min = 8,
                max = 48,
                step = 1,
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.size = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.size
                end,
                order = 40
            },
            healerX = {
                name = "Offset X",
                desc = "Move the Icon horizontally away from the Nameplate",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.x = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.x
                end,
                order = 41
            },
            healerY = {
                name = "Offset Y",
                desc = "Move the Icon vertically away from the Nameplate",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.y = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.y
                end,
                order = 42
            },

            -- Target Indicator ------------------------------------------------

            header7 = {
                name = "Target",
                type = "header",
                order = 43
            },
            targetEnabled = {
                name = "Target Indicator",
                desc = "Mark the Nameplate of your current Target",
                type = "toggle",
                set = function(_, val)
                    db().target.enabled = val
                    SetFeature(Nameplates.Module.TargetIndicator, val)
                end,
                get = function()
                    return db().target.enabled
                end,
                order = 44
            },
            targetArrows = {
                name = "Arrows",
                desc = "Show Arrows on either side of the Target's Health Bar",
                type = "toggle",
                disabled = function()
                    return not db().target.enabled
                end,
                set = function(_, val)
                    db().target.arrows = val
                    Refresh(Nameplates.Module.TargetIndicator)
                end,
                get = function()
                    return db().target.arrows
                end,
                order = 45
            },
            targetGlow = {
                name = "Border Highlight",
                desc = "Draw a Border around the Target's Health Bar",
                type = "toggle",
                disabled = function()
                    return not db().target.enabled
                end,
                set = function(_, val)
                    db().target.glow = val
                    Refresh(Nameplates.Module.TargetIndicator)
                end,
                get = function()
                    return db().target.glow
                end,
                order = 46
            },
            targetClasscolor = {
                name = "Class Color",
                desc = "Color the Indicator by the Target's Class",
                type = "toggle",
                disabled = function()
                    return not db().target.enabled
                end,
                set = function(_, val)
                    db().target.classcolor = val
                    Refresh(Nameplates.Module.TargetIndicator)
                end,
                get = function()
                    return db().target.classcolor
                end,
                order = 47
            },
            targetColor = {
                name = "Color",
                desc = "Choose a Color for the Target Indicator",
                type = "color",
                hasAlpha = true,
                disabled = function()
                    return not db().target.enabled or db().target.classcolor
                end,
                set = function(_, r, g, b, a)
                    db().target.color = {r, g, b, a}
                    Refresh(Nameplates.Module.TargetIndicator)
                end,
                get = function()
                    return unpack(db().target.color)
                end,
                order = 48
            },
            targetSize = {
                name = "Arrow Size",
                desc = "Set the Size of the Target Arrows",
                type = "range",
                min = 8,
                max = 48,
                step = 1,
                disabled = function()
                    return not db().target.enabled
                end,
                set = function(_, val)
                    db().target.size = val
                    Refresh(Nameplates.Module.TargetIndicator)
                end,
                get = function()
                    return db().target.size
                end,
                order = 49
            },
            targetOffset = {
                name = "Arrow Offset",
                desc = "Move the Arrows away from the Health Bar",
                type = "range",
                min = -50,
                max = 50,
                step = 1,
                disabled = function()
                    return not db().target.enabled
                end,
                set = function(_, val)
                    db().target.offset = val
                    Refresh(Nameplates.Module.TargetIndicator)
                end,
                get = function()
                    return db().target.offset
                end,
                order = 50
            },

            -- Raid Marker -----------------------------------------------------

            header8 = {
                name = "Raid Marker",
                type = "header",
                order = 51
            },
            raidmarkerEnabled = {
                name = "Raid Marker",
                desc = "Let mUI position and size the Raid Target Icon",
                type = "toggle",
                set = function(_, val)
                    db().raidmarker.enabled = val
                    SetFeature(Nameplates.Module.RaidMarker, val)
                end,
                get = function()
                    return db().raidmarker.enabled
                end,
                order = 52
            },
            raidmarkerAnchor = {
                name = "Position",
                desc = "Select where the Raid Target Icon is anchored on the Nameplate",
                type = "select",
                values = ANCHOR_VALUES,
                sorting = ANCHOR_SORTING,
                disabled = function()
                    return not db().raidmarker.enabled or db().raidmarker.hide
                end,
                set = function(_, val)
                    db().raidmarker.anchor = val
                    Refresh(Nameplates.Module.RaidMarker)
                end,
                get = function()
                    return db().raidmarker.anchor
                end,
                order = 53
            },
            raidmarkerSize = {
                name = "Icon Size",
                desc = "Set the Size of the Raid Target Icon",
                type = "range",
                min = 8,
                max = 64,
                step = 1,
                disabled = function()
                    return not db().raidmarker.enabled or db().raidmarker.hide
                end,
                set = function(_, val)
                    db().raidmarker.size = val
                    Refresh(Nameplates.Module.RaidMarker)
                end,
                get = function()
                    return db().raidmarker.size
                end,
                order = 54
            },
            raidmarkerAlpha = {
                name = "Opacity",
                desc = "Set the Opacity of the Raid Target Icon",
                type = "range",
                min = 0,
                max = 1,
                step = 0.05,
                isPercent = true,
                disabled = function()
                    return not db().raidmarker.enabled or db().raidmarker.hide
                end,
                set = function(_, val)
                    db().raidmarker.alpha = val
                    Refresh(Nameplates.Module.RaidMarker)
                end,
                get = function()
                    return db().raidmarker.alpha
                end,
                order = 55
            },
            raidmarkerX = {
                name = "Offset X",
                desc = "Move the Raid Target Icon horizontally away from the Nameplate",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().raidmarker.enabled or db().raidmarker.hide
                end,
                set = function(_, val)
                    db().raidmarker.x = val
                    Refresh(Nameplates.Module.RaidMarker)
                end,
                get = function()
                    return db().raidmarker.x
                end,
                order = 56
            },
            raidmarkerY = {
                name = "Offset Y",
                desc = "Move the Raid Target Icon vertically away from the Nameplate",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().raidmarker.enabled or db().raidmarker.hide
                end,
                set = function(_, val)
                    db().raidmarker.y = val
                    Refresh(Nameplates.Module.RaidMarker)
                end,
                get = function()
                    return db().raidmarker.y
                end,
                order = 57
            },

            -- Auras -------------------------------------------------------------

            header9 = {
                name = "Auras",
                type = "header",
                order = 58
            },
            aurasEnabled = {
                name = "Nameplate Auras",
                desc = "Show three Aura groups on Nameplates\n\n|cffffff00Crowd Control|r: right of the Health Bar\n|cffffff00Your Debuffs|r: above the Nameplate\n|cffffff00Stealable / Important Buffs|r: left of the Health Bar",
                type = "toggle",
                set = function(_, val)
                    db().auras.enabled = val
                    SetFeature(Nameplates.Module.Auras, val)
                end,
                get = function()
                    return db().auras.enabled
                end,
                order = 59
            },
            aurasCCSize = {
                name = "Crowd Control Size",
                desc = "Set the Icon Size of the Crowd Control Aura group",
                type = "range",
                min = 8,
                max = 40,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.cc.size = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.cc.size
                end,
                order = 60
            },
            aurasCCOffset = {
                name = "Crowd Control Offset",
                desc = "Move the Crowd Control Aura group away from the Health Bar",
                type = "range",
                min = 0,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.cc.x = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.cc.x
                end,
                order = 61
            },
            aurasCCAnchor = {
                name = "Crowd Control Side",
                desc = "Which side of the Health Bar the Crowd Control Aura group sits on",
                type = "select",
                values = {
                    LEFT = "Left",
                    RIGHT = "Right"
                },
                sorting = {"LEFT", "RIGHT"},
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.cc.anchor = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.cc.anchor
                end,
                order = 62
            },
            aurasTopSize = {
                name = "Your Debuffs Size",
                desc = "Set the Icon Size of the Aura group above the Nameplate showing your own Debuffs",
                type = "range",
                min = 8,
                max = 40,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.top.size = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.top.size
                end,
                order = 63
            },
            aurasTopOffset = {
                name = "Your Debuffs Offset",
                desc = "Move the Debuff Aura group away from the top of the Nameplate",
                type = "range",
                min = 0,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.top.y = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.top.y
                end,
                order = 64
            },
            aurasLeftSize = {
                name = "Stealable / Important Size",
                desc = "Set the Icon Size of the Stealable and Important Buff Aura group",
                type = "range",
                min = 8,
                max = 40,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.left.size = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.left.size
                end,
                order = 65
            },
            aurasLeftOffset = {
                name = "Stealable / Important Offset",
                desc = "Move the Stealable / Important Aura group away from the Health Bar",
                type = "range",
                min = 0,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.left.x = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.left.x
                end,
                order = 66
            },
            aurasLeftAnchor = {
                name = "Stealable / Important Side",
                desc = "Which side of the Health Bar the Stealable / Important Buff Aura group sits on",
                type = "select",
                values = {
                    LEFT = "Left",
                    RIGHT = "Right"
                },
                sorting = {"LEFT", "RIGHT"},
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.left.anchor = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.left.anchor
                end,
                order = 67
            },

            -- Totem -------------------------------------------------------------

            header10 = {
                name = "Totems",
                type = "header",
                order = 68
            },
            totemEnabled = {
                name = "Totem Indicator",
                desc = "Flag a totem's nameplate with an icon when it's casting/channeling an interruptible effect, or carrying a notable buff\n\n|cffffff00Info:|r Ported from BetterBlizzPlates, with permission",
                type = "toggle",
                set = function(_, val)
                    db().totem.enabled = val
                    SetFeature(Nameplates.Module.Totem, val)
                end,
                get = function()
                    return db().totem.enabled
                end,
                order = 69
            },
            totemEnemyOnly = {
                name = "Enemy Totems Only",
                desc = "Only show the indicator on enemy totems",
                type = "toggle",
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.enemyOnly = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.enemyOnly
                end,
                order = 70
            },
            totemNoAnimation = {
                name = "Disable Pulse Animation",
                desc = "Disable the pulsing animation on the totem indicator",
                type = "toggle",
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.noAnimation = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.noAnimation
                end,
                order = 71
            },
            totemColorHealthBar = {
                name = "Color Health Bar",
                desc = "Tint the totem's Health Bar to match the indicator",
                type = "toggle",
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.colorHealthBar = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.colorHealthBar
                end,
                order = 72
            },
            totemColor = {
                name = "Color",
                desc = "Choose a Color for the generic Totem Indicator",
                type = "color",
                hasAlpha = true,
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, r, g, b, a)
                    db().totem.color = {r, g, b, a}
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return unpack(db().totem.color)
                end,
                order = 73
            },
            totemAnchor = {
                name = "Position",
                desc = "Select where the Totem Indicator sits relative to the Health Bar",
                type = "select",
                values = ANCHOR_VALUES,
                sorting = ANCHOR_SORTING,
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.anchor = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.anchor
                end,
                order = 74
            },
            totemSize = {
                name = "Size",
                desc = "Set the Icon Size of the Totem Indicator",
                type = "range",
                min = 8,
                max = 48,
                step = 1,
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.size = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.size
                end,
                order = 75
            },
            totemX = {
                name = "Offset X",
                desc = "Move the Totem Indicator horizontally",
                type = "range",
                min = -60,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.x = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.x
                end,
                order = 76
            },
            totemY = {
                name = "Offset Y",
                desc = "Move the Totem Indicator vertically",
                type = "range",
                min = -60,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().totem.enabled
                end,
                set = function(_, val)
                    db().totem.y = val
                    Refresh(Nameplates.Module.Totem)
                end,
                get = function()
                    return db().totem.y
                end,
                order = 77
            },

            -- Personal Resource Bar ----------------------------------------------

            header11 = {
                name = "Personal Bar",
                type = "header",
                order = 78
            },
            personalresourceEnabled = {
                name = "Personal Resource Bar",
                desc = "Show your Class Resources (Combo Points, Runes, Holy Power, etc.) above your own Character\n\n|cffffff00Info:|r Wraps Blizzard's native Personal Resource Display, Health / Power Bars hidden",
                type = "toggle",
                set = function(_, val)
                    db().personalresource.enabled = val
                    Refresh(Nameplates.Module.PersonalResourceBar)
                end,
                get = function()
                    return db().personalresource.enabled
                end,
                order = 79
            },
            personalresourceAnchor = {
                name = "Position",
                desc = "Select where the Resource Bar sits relative to your Target's Health Bar",
                type = "select",
                values = ANCHOR_VALUES,
                sorting = ANCHOR_SORTING,
                disabled = function()
                    return not db().personalresource.enabled
                end,
                set = function(_, val)
                    db().personalresource.anchor = val
                    Refresh(Nameplates.Module.PersonalResourceBar)
                end,
                get = function()
                    return db().personalresource.anchor
                end,
                order = 80
            },
            personalresourceX = {
                name = "Offset X",
                desc = "Move the Resource Bar horizontally",
                type = "range",
                min = -60,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().personalresource.enabled
                end,
                set = function(_, val)
                    db().personalresource.x = val
                    Refresh(Nameplates.Module.PersonalResourceBar)
                end,
                get = function()
                    return db().personalresource.x
                end,
                order = 81
            },
            personalresourceY = {
                name = "Offset Y",
                desc = "Move the Resource Bar vertically",
                type = "range",
                min = -60,
                max = 60,
                step = 1,
                disabled = function()
                    return not db().personalresource.enabled
                end,
                set = function(_, val)
                    db().personalresource.y = val
                    Refresh(Nameplates.Module.PersonalResourceBar)
                end,
                get = function()
                    return db().personalresource.y
                end,
                order = 82
            }
        }
    }

    function Nameplates:GetOptions()
        return Nameplates.layout
    end
end
