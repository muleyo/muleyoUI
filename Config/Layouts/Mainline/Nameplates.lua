local Nameplates = mUI:NewModule("mUI.Config.Layouts.Nameplates")

function Nameplates:OnInitialize()
    -- Load Libraries
    Nameplates.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    Nameplates.Module = mUI:GetModule("mUI.Modules.Nameplates")

    local function db()
        return mUI.db.profile.nameplates
    end

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
            preview = {
                name = "Preview",
                desc = "Preview your Nameplate size and Aura placement in a side panel",
                type = "execute",
                func = function()
                    mUI.mGUI.Preview:Toggle()
                end,
                order = 1.5
            },
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
                order = 4
            },
            header2 = {
                name = "Sizes",
                type = "header",
                order = 5
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
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().size.healthwidth
                end,
                order = 6
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
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().size.healthheight
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
            nameSize = {
                name = "Name Text Size",
                desc = "Set the Font Size of the Unit Name",
                type = "range",
                min = 6,
                max = 32,
                step = 1,
                set = function(_, val)
                    db().name.size = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().name.size
                end,
                order = 9
            },
            nameAnchor = {
                name = "Name Position",
                desc = "Select whether the Unit Name sits above or below the Health Bar",
                type = "select",
                values = {
                    ABOVE = "Top",
                    BELOW = "Bottom"
                },
                sorting = {"ABOVE", "BELOW"},
                set = function(_, val)
                    db().name.anchor = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().name.anchor
                end,
                order = 9.1
            },
            nameAlign = {
                name = "Name Align",
                desc = "Select how the Unit Name aligns relative to the Health Bar",
                type = "select",
                values = {
                    LEFT = "Left",
                    CENTER = "Center",
                    RIGHT = "Right"
                },
                sorting = {"LEFT", "CENTER", "RIGHT"},
                set = function(_, val)
                    db().name.align = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().name.align
                end,
                order = 9.15
            },
            nameOffsetX = {
                name = "Name Offset X",
                desc = "Move the Unit Name horizontally",
                type = "range",
                min = -50,
                max = 50,
                step = 1,
                set = function(_, val)
                    db().name.x = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().name.x
                end,
                order = 9.2
            },
            nameOffsetY = {
                name = "Name Offset Y",
                desc = "Move the Unit Name away from the Health Bar",
                type = "range",
                min = -50,
                max = 50,
                step = 1,
                set = function(_, val)
                    db().name.y = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().name.y
                end,
                order = 9.3
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
                order = 10
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
                order = 11
            },
            header3 = {
                name = "Options",
                type = "header",
                order = 12
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
                order = 13
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
                order = 14
            },
            showClassColor = {
                name = "Class Colors",
                desc = "Color Enemy Player Health Bars by Class\n\n|cffffff00Info:|r Also sets Blizzard's nameplateShowClassColor CVar",
                type = "toggle",
                set = function(_, val)
                    db().classcolor = val
                    db().showClassColor = val

                    Refresh(Nameplates.Module.Health)

                    if Nameplates.Module:IsEnabled() and Nameplates.Module.Style:IsEnabled() then
                        Nameplates.Module.Style:ApplyScale()
                    end
                end,
                get = function()
                    return db().classcolor
                end,
                order = 14.1
            },
            healthDisplay = {
                name = "Health Text",
                desc = "Show the Unit's Health as a Percentage and/or a Value on the Health Bar\n\n|cffffff00Info:|r Disables Blizzard's own Health Percentage/Value text\n\n|cffffff00Info:|r With both enabled, Value sits on the Left and Percentage on the Right",
                type = "multiselect",
                values = {
                    percent = "Percentage",
                    value = "Value"
                },
                set = function(_, key, val)
                    db().health[key] = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function(_, key)
                    return db().health[key]
                end,
                order = 15
            },
            healthOffsetX = {
                name = "Health Text Offset X",
                desc = "Nudge the Health Text horizontally away from its anchor",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not (db().health.percent or db().health.value)
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
            healthOffsetY = {
                name = "Health Text Offset Y",
                desc = "Move the Health Text vertically",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not (db().health.percent or db().health.value)
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
            hitbox = {
                name = "Clickable Area",
                desc = "Grow or shrink the area of the Nameplate that responds to the mouse\n\n|cffffff00Info:|r Always covers the Health Bar; positive values extend further past their edges, negative values shrink inside them",
                type = "range",
                min = -20,
                max = 40,
                step = 1,
                set = function(_, val)
                    db().hitbox = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    Nameplates.Module.Core:RefreshHitTest()
                end,
                get = function()
                    return db().hitbox
                end,
                order = 17.1
            },
            header35 = {
                name = "NPC Type",
                type = "header",
                order = 19
            },
            classificationEnabled = {
                name = "Color by NPC Type",
                desc = "Color the Health Bar by the Unit's Type instead of its Reaction\n\n|cffffff00Info:|r Players keep their Class Color. Rares keep their Reaction Color",
                type = "toggle",
                set = function(_, val)
                    db().classification.enabled = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().classification.enabled
                end,
                order = 20
            },
            classificationInstancesOnly = {
                name = "Instance Only",
                desc = "Only use the Boss, Miniboss and Caster colors inside a Dungeon or Raid\n\n|cffffff00Info:|r These tiers are worked out from Dungeon Level scaling, so they are only meaningful inside an Instance. Quest coloring always applies, indoors or out.",
                type = "toggle",
                disabled = function()
                    return not db().classification.enabled
                end,
                set = function(_, val)
                    db().classification.instancesonly = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().classification.instancesonly
                end,
                order = 21
            },
            classificationBoss = {
                name = "Boss",
                desc = "Choose a Color for Bosses",
                type = "color",
                hasAlpha = true,
                disabled = function()
                    return not db().classification.enabled
                end,
                set = function(_, r, g, b, a)
                    db().classification.boss = {r, g, b, a}
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return unpack(db().classification.boss)
                end,
                order = 23
            },
            classificationMiniboss = {
                name = "Miniboss",
                desc = "Choose a Color for Minibosses (Lieutenants)",
                type = "color",
                hasAlpha = true,
                disabled = function()
                    return not db().classification.enabled
                end,
                set = function(_, r, g, b, a)
                    db().classification.miniboss = {r, g, b, a}
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return unpack(db().classification.miniboss)
                end,
                order = 24
            },
            classificationCaster = {
                name = "Caster",
                desc = "Choose a Color for NPCs with Mana",
                type = "color",
                hasAlpha = true,
                disabled = function()
                    return not db().classification.enabled
                end,
                set = function(_, r, g, b, a)
                    db().classification.caster = {r, g, b, a}
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return unpack(db().classification.caster)
                end,
                order = 25
            },
            classificationQuest = {
                name = "Quest",
                desc = "Choose a Color for Quest Mobs",
                type = "color",
                hasAlpha = true,
                disabled = function()
                    return not db().classification.enabled
                end,
                set = function(_, r, g, b, a)
                    db().classification.quest = {r, g, b, a}
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return unpack(db().classification.quest)
                end,
                order = 26
            },
            header4 = {
                name = "Friendly",
                type = "header",
                order = 28
            },
            cvarOnlyShowNames = {
                name = "Only Show Names",
                desc = "Hide the Health Bar for Friendly Player Nameplates and only show their Name\n\n|cffffff00CVar:|r nameplateShowOnlyNameForFriendlyPlayerUnits",
                type = "toggle",
                set = function(_, val)
                    db().cvars.onlyShowNames = val
                    Refresh(Nameplates.Module.Cvars)
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().cvars.onlyShowNames
                end,
                order = 28.1
            },
            friendlyClasscolor = {
                name = "Class Color",
                desc = "Color Friendly Player Health Bars and Names by Class\n\n|cffffff00CVar:|r nameplateUseClassColorForFriendlyPlayerUnitNames",
                type = "toggle",
                set = function(_, val)
                    db().friendly.classcolor = val
                    Refresh(Nameplates.Module.Health)
                    Refresh(Nameplates.Module.Cvars)
                end,
                get = function()
                    return db().friendly.classcolor
                end,
                order = 28.2
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
                disabled = function()
                    return db().cvars.onlyShowNames
                end,
                order = 29
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
                disabled = function()
                    return db().cvars.onlyShowNames
                end,
                order = 30
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
                order = 31
            },
            friendlySmall = {
                name = "Small Friendly Plates",
                desc = "Narrow the Health Bar and Cast Bar on Friendly Nameplates\n\n|cffffff00Info:|r Bar Height stays on the shared sliders",
                type = "toggle",
                set = function(_, val)
                    db().friendly.small = val
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().friendly.small
                end,
                disabled = function()
                    return db().cvars.onlyShowNames
                end,
                order = 33
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
                    Refresh(Nameplates.Module.Health)
                end,
                get = function()
                    return db().friendly.width
                end,
                order = 34
            },
            header5 = {
                name = "Class Icon",
                type = "header",
                order = 35
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
                order = 36
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
                order = 37
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
                order = 38
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
                order = 39
            },
            classiconsArenaOnly = {
                name = "Arena Only",
                desc = "Only show the Icon inside an Arena",
                type = "toggle",
                disabled = function()
                    return not db().classicons.enabled
                end,
                set = function(_, val)
                    db().classicons.arenaonly = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.arenaonly
                end,
                order = 40
            },
            classiconsHideHealers = {
                name = "Hide on Friendly Healers",
                desc = "Hide the Class Icon on Friendly Healers, so only the Healer Indicator marks them",
                type = "toggle",
                disabled = function()
                    return not db().classicons.enabled or not db().classicons.friendly
                end,
                set = function(_, val)
                    db().classicons.hidehealers = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.hidehealers
                end,
                order = 41
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
                order = 42
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
                order = 43
            },
            classiconsFriendlyX = {
                name = "Friendly Offset X",
                desc = "Move the Icon horizontally on Friendly Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled or not db().classicons.friendly
                end,
                set = function(_, val)
                    db().classicons.friendlyx = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.friendlyx
                end,
                order = 44
            },
            classiconsFriendlyY = {
                name = "Friendly Offset Y",
                desc = "Move the Icon vertically on Friendly Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled or not db().classicons.friendly
                end,
                set = function(_, val)
                    db().classicons.friendlyy = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.friendlyy
                end,
                order = 45
            },
            classiconsEnemyX = {
                name = "Enemy Offset X",
                desc = "Move the Icon horizontally on Enemy Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled or not db().classicons.enemy
                end,
                set = function(_, val)
                    db().classicons.enemyx = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.enemyx
                end,
                order = 46
            },
            classiconsEnemyY = {
                name = "Enemy Offset Y",
                desc = "Move the Icon vertically on Enemy Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().classicons.enabled or not db().classicons.enemy
                end,
                set = function(_, val)
                    db().classicons.enemyy = val
                    Refresh(Nameplates.Module.ClassIcon)
                end,
                get = function()
                    return db().classicons.enemyy
                end,
                order = 47
            },
            header6 = {
                name = "Healer",
                type = "header",
                order = 48
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
                order = 49
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
                order = 50
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
                order = 51
            },
            healerArenaOnly = {
                name = "Arena Only",
                desc = "Only show the Indicator inside an Arena",
                type = "toggle",
                disabled = function()
                    return not db().healer.enabled
                end,
                set = function(_, val)
                    db().healer.arenaonly = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.arenaonly
                end,
                order = 52
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
                order = 53
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
                order = 54
            },
            healerFriendlyX = {
                name = "Friendly Offset X",
                desc = "Move the Indicator horizontally on Friendly Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().healer.enabled or not db().healer.friendly
                end,
                set = function(_, val)
                    db().healer.friendlyx = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.friendlyx
                end,
                order = 55
            },
            healerFriendlyY = {
                name = "Friendly Offset Y",
                desc = "Move the Indicator vertically on Friendly Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().healer.enabled or not db().healer.friendly
                end,
                set = function(_, val)
                    db().healer.friendlyy = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.friendlyy
                end,
                order = 56
            },
            healerEnemyX = {
                name = "Enemy Offset X",
                desc = "Move the Indicator horizontally on Enemy Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().healer.enabled or not db().healer.enemy
                end,
                set = function(_, val)
                    db().healer.enemyx = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.enemyx
                end,
                order = 57
            },
            healerEnemyY = {
                name = "Enemy Offset Y",
                desc = "Move the Indicator vertically on Enemy Nameplates",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().healer.enabled or not db().healer.enemy
                end,
                set = function(_, val)
                    db().healer.enemyy = val
                    Refresh(Nameplates.Module.Healer)
                end,
                get = function()
                    return db().healer.enemyy
                end,
                order = 58
            },
            header7 = {
                name = "Target",
                type = "header",
                order = 59
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
                order = 60
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
                order = 61
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
                order = 62
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
                order = 63
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
                order = 64
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
                order = 65
            },
            header8 = {
                name = "Raid Marker",
                type = "header",
                order = 66
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
                order = 67
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
                order = 68
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
                order = 69
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
                order = 70
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
                order = 71
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
                order = 72
            },
            header9 = {
                name = "Auras",
                type = "header",
                order = 73
            },
            aurasEnabled = {
                name = "Nameplate Auras",
                desc = "Show three Aura groups on Nameplates\n\n|cffffff00Crowd Control|r: right of the Health Bar\n|cffffff00Your Debuffs|r: above the Nameplate\n|cffffff00Important Buffs|r: left of the Health Bar",
                type = "toggle",
                set = function(_, val)
                    db().auras.enabled = val
                    SetFeature(Nameplates.Module.Auras, val)
                end,
                get = function()
                    return db().auras.enabled
                end,
                order = 74
            },
            aurasCCAnchor = {
                name = "CC Anchor",
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
                order = 75
            },
            aurasLeftAnchor = {
                name = "Important Anchor",
                desc = "Which side of the Health Bar the Important Buff Aura group sits on",
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
                order = 76
            },
            aurasTopAnchor = {
                name = "Debuffs Anchor",
                desc = "Which side of the Health Bar the Debuff Aura group sits on",
                type = "select",
                values = ANCHOR_VALUES,
                sorting = ANCHOR_SORTING,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.top.anchor = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.top.anchor
                end,
                order = 77
            },
            aurasCCOffset = {
                name = "CC Offset",
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
                order = 78
            },
            aurasLeftOffset = {
                name = "Important Offset",
                desc = "Move the Important Aura group away from the Health Bar",
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
                order = 79
            },
            aurasTopOffsetX = {
                name = "Debuffs Offset X",
                desc = "Move the Debuff Aura group horizontally away from the Health Bar",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                disabled = function()
                    return not db().auras.enabled
                end,
                set = function(_, val)
                    db().auras.top.x = val
                    Refresh(Nameplates.Module.Auras)
                end,
                get = function()
                    return db().auras.top.x
                end,
                order = 80
            },
            aurasTopOffset = {
                name = "Debuffs Offset Y",
                desc = "Move the Debuff Aura group vertically away from the Health Bar",
                type = "range",
                min = -100,
                max = 100,
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
                order = 81
            },
            aurasCCSize = {
                name = "CC Size",
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
                order = 82
            },
            aurasLeftSize = {
                name = "Important Size",
                desc = "Set the Icon Size of the Important Buff Aura group",
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
                order = 82.1
            },
            aurasTopSize = {
                name = "Debuffs Size",
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
                order = 82.2
            },
            header10 = {
                name = "Totems",
                type = "header",
                order = 83
            },
            totemEnabled = {
                name = "Totem Indicator",
                desc = "Flag a totem's nameplate with an icon when it's casting/channeling an interruptible effect, or carrying a notable buff",
                type = "toggle",
                set = function(_, val)
                    db().totem.enabled = val
                    SetFeature(Nameplates.Module.Totem, val)
                end,
                get = function()
                    return db().totem.enabled
                end,
                order = 84
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
                order = 85
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
                order = 86
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
                order = 87
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
                order = 88
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
                order = 89
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
                order = 90
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
                order = 91
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
                order = 92
            },
            header11 = {
                name = "Personal Bar",
                type = "header",
                order = 93
            },
            personalresourceEnabled = {
                name = "Personal Resource Bar",
                desc = "Show your Class Resources (Combo Points, Runes, Holy Power, etc.) above your own Character\n\n|cffffff00Info:|r Wraps Blizzard's native Personal Resource Display, Health / Power Bars hidden\n\n|cffffff00Note:|r Works independently of the \"Enable Module\" toggle above.",
                type = "toggle",
                set = function(_, val)
                    db().personalresource.enabled = val

                    local Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
                    local PersonalResourceBar = mUI:GetModule("mUI.Modules.Nameplates.PersonalResourceBar")
                    if val then
                        if not Core:IsEnabled() then
                            Core:Enable()
                        end
                        if not PersonalResourceBar:IsEnabled() then
                            PersonalResourceBar:Enable()
                        else
                            PersonalResourceBar:Update()
                        end
                    elseif PersonalResourceBar:IsEnabled() then
                        PersonalResourceBar:Update()

                        if not Nameplates.Module:IsEnabled() then
                            PersonalResourceBar:Disable()
                            Core:Disable()
                        end
                    end
                end,
                get = function()
                    return db().personalresource.enabled
                end,
                order = 94
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
                    local PersonalResourceBar = mUI:GetModule("mUI.Modules.Nameplates.PersonalResourceBar")
                    if PersonalResourceBar:IsEnabled() then
                        PersonalResourceBar:Update()
                    end
                end,
                get = function()
                    return db().personalresource.anchor
                end,
                order = 95
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
                    local PersonalResourceBar = mUI:GetModule("mUI.Modules.Nameplates.PersonalResourceBar")
                    if PersonalResourceBar:IsEnabled() then
                        PersonalResourceBar:Update()
                    end
                end,
                get = function()
                    return db().personalresource.x
                end,
                order = 96
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
                    local PersonalResourceBar = mUI:GetModule("mUI.Modules.Nameplates.PersonalResourceBar")
                    if PersonalResourceBar:IsEnabled() then
                        PersonalResourceBar:Update()
                    end
                end,
                get = function()
                    return db().personalresource.y
                end,
                order = 97
            },
            header12 = {
                name = "Cast Bar",
                type = "header",
                order = 98
            },
            castbarShowTarget = {
                name = "Show Cast Target",
                desc = "Show who a Spell is being cast on below the Cast Bar",
                type = "toggle",
                set = function(_, val)
                    db().castbar.showTarget = val
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return db().castbar.showTarget
                end,
                order = 98.1
            },
            castbarColors = {
                name = "Interrupt on Cooldown",
                desc = "Recolor the Cast Bar of Interruptible Spells while your own Interrupt is on Cooldown\n\n|cffffff00Info:|r Does nothing if your Class has no Interrupt",
                type = "toggle",
                set = function(_, val)
                    db().castbar.colors = val
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return db().castbar.colors
                end,
                order = 99
            },
            castbarCooldownColor = {
                name = "Cannot Interrupt",
                desc = "Choose a Color for Spells you cannot Interrupt right now",
                type = "color",
                disabled = function()
                    return not db().castbar.colors
                end,
                set = function(_, r, g, b)
                    db().castbar.cooldowncolor = {r, g, b}
                    Refresh(Nameplates.Module.Castbar)
                end,
                get = function()
                    return unpack(db().castbar.cooldowncolor)
                end,
                order = 100
            },
            header13 = {
                name = "CVars",
                type = "header",
                order = 101
            },
            cvarStack = {
                name = "Stack Nameplates",
                desc = "Stack overlapping Nameplates instead of pushing them apart\n\n|cffffff00CVar:|r nameplateStackingTypes",
                type = "multiselect",
                values = {
                    enemy = "Enemy Units",
                    friendly = "Friendly Units"
                },
                sorting = {"enemy", "friendly"},
                set = function(_, key, val)
                    db().cvars.stacking[key] = val
                    Refresh(Nameplates.Module.Cvars)
                end,
                get = function(_, key)
                    return db().cvars.stacking[key]
                end,
                order = 102
            },
            cvarSimplify = {
                name = "Simplify Nameplates",
                desc = "Show a simplified Nameplate for the selected unit types\n\n|cffffff00CVar:|r nameplateSimplifiedTypes",
                type = "multiselect",
                values = {
                    minions = "Minions",
                    minor = "Minor",
                    friendlyPlayers = "Friendly Players",
                    friendlyNpcs = "Friendly NPCs"
                },
                sorting = {"minions", "minor", "friendlyPlayers", "friendlyNpcs"},
                set = function(_, key, val)
                    db().cvars.simplify[key] = val
                    Refresh(Nameplates.Module.Cvars)
                end,
                get = function(_, key)
                    return db().cvars.simplify[key]
                end,
                order = 103
            },
            cvarRealmName = {
                name = "Realm Name",
                desc = "Show the Realm Name on Friendly Player Nameplates\n\n|cffffff00CVar:|r nameplateShowFriendlyRealmName",
                type = "toggle",
                set = function(_, val)
                    db().cvars.realmName = val
                    Refresh(Nameplates.Module.Cvars)
                end,
                get = function()
                    return db().cvars.realmName
                end,
                order = 106
            },
            cvarFriendlyNpcs = {
                name = "Friendly NPC Nameplates",
                desc = "Show Nameplates for Friendly NPCs\n\n|cffffff00CVar:|r nameplateShowFriendlyNpcs",
                type = "toggle",
                set = function(_, val)
                    db().cvars.friendlyNpcs = val
                    Refresh(Nameplates.Module.Cvars)
                end,
                get = function()
                    return db().cvars.friendlyNpcs
                end,
                order = 107
            },
            cvarOffscreen = {
                name = "Show Offscreen Nameplates",
                desc = "Show indicators for Nameplates that are currently offscreen\n\n|cffffff00CVar:|r nameplateShowOffscreen",
                type = "toggle",
                set = function(_, val)
                    db().cvars.offscreen = val
                    Refresh(Nameplates.Module.Cvars)
                end,
                get = function()
                    return db().cvars.offscreen
                end,
                order = 108
            }
        }
    }

    function Nameplates:GetOptions()
        return Nameplates.layout
    end
end
