local Raidframes = mUI:NewModule("mUI.Config.Layouts.Raidframes")

-- On 12.1.0+ the container-based raid auras are always on (no opt-out) and the
-- default raid auras are hidden, so the aura sub-options are always available and
-- the enable toggle is locked on.
local RAID_AURAS_FORCED = select(4, GetBuildInfo()) >= 120100

function Raidframes:OnInitialize()
    -- Get LSM
    Raidframes.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules (Raidframes are part of the same Unitframes module/DB)
    Raidframes.Module = mUI:GetModule("mUI.Modules.Unitframes")
    Raidframes.Theme = mUI:GetModule("mUI.Modules.General.Theme")

    -- Initialize Layout
    Raidframes.layout = {
        type = "group",
        args = {
            preview = {
                name = "Preview",
                desc = "Preview your Raidframes changes in a side panel",
                type = "execute",
                func = function()
                    mUI.mGUI.Preview:Toggle()
                end,
                order = 1.5
            },
            enable = {
                name = function()
                    if mUI.db.profile.unitframes.raidframes.enabled then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable the Party / Raidframes.\n\n|cffffff00Info:|r Requires Reload\n\n|cffffff00Note:|r Independent from the Unitframes tab.",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.enabled = val
                    mUI:Reload(val and 'Enable Raidframes' or 'Disable Raidframes')
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.enabled
                end,
                order = 1
            },
            header1 = {
                name = "Textures",
                type = "header",
                order = 2
            },
            textures_raidframes = {
                name = "Healthbar / Powerbar",
                desc = "Select a Texture for the Party / Raidframes",
                type = "select",
                values = Raidframes.LSM:HashTable("statusbar"),
                dialogControl = 'mUI_LSM30_Status',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.raidframes = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val == "None" then
                        Raidframes.Module.RF_Textures:Disable()
                        Raidframes.Module.RF_Textures:Update()
                    else
                        Raidframes.Module.RF_Textures:Enable()
                        Raidframes.Module.RF_Textures:Update()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.textures.raidframes
                end,
                order = 3
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 4
            },
            partyStatusColorMode = {
                name = "Party StatusText Color",
                desc = "Color of the StatusText on Party Frames",
                type = "select",
                values = {
                    default = "Default",
                    class = "Class Color",
                    custom = "Custom"
                },
                sorting = {"default", "class", "custom"},
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.partyStatusColorMode = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    local needs = val ~= "default" or mUI.db.profile.unitframes.raidframes.health
                    if needs then
                        if Raidframes.Module.RF_Health:IsEnabled() then
                            Raidframes.Module.RF_Health:Update()
                        else
                            Raidframes.Module.RF_Health:Enable()
                        end
                    else
                        Raidframes.Module.RF_Health:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.partyStatusColorMode or "default"
                end,
                order = 5
            },
            partyStatusCustomColor = {
                name = "",
                desc = "Custom color for the Party StatusText",
                type = "color",
                hasAlpha = false,
                hidden = function()
                    return (mUI.db.profile.unitframes.raidframes.partyStatusColorMode or "default") ~= "custom"
                end,
                set = function(_, r, g, b)
                    mUI.db.profile.unitframes.raidframes.partyStatusCustomColor = {r, g, b, 1}

                    if Raidframes.Module:IsEnabled() and Raidframes.Module.RF_Health:IsEnabled() then
                        Raidframes.Module.RF_Health:Update()
                    end
                end,
                get = function()
                    local c = mUI.db.profile.unitframes.raidframes.partyStatusCustomColor or {1, 0.82, 0, 1}
                    return c[1], c[2], c[3], c[4] or 1
                end,
                order = 6
            },
            partyScale = {
                name = "Party Frame Scale",
                desc = "Scale of the CompactPartyFrame (party container).",
                type = "range",
                min = 50,
                max = 200,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.partyScale = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val == 100 then
                        Raidframes.Module.RF_Scale:Disable()
                    else
                        if Raidframes.Module.RF_Scale:IsEnabled() then
                            Raidframes.Module.RF_Scale:Update()
                        else
                            Raidframes.Module.RF_Scale:Enable()
                        end
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.partyScale
                end,
                order = 7
            },
            roleicons = {
                name = "Hide Role Icons",
                desc = "Hide Role Icons on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.roleicons = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Raidframes.Module.RF_RoleIcons:Enable()
                    else
                        Raidframes.Module.RF_RoleIcons:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.roleicons
                end,
                order = 8
            },
            names = {
                name = "Classcolor Names",
                desc = "Show Names in Classcolor on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.names = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Raidframes.Module.RF_Name:Enable()
                    else
                        Raidframes.Module.RF_Name:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.names
                end,
                order = 9
            },
            partyNameCentered = {
                name = "Center Party Names",
                desc = "Anchor party member names centered at the top of the frame",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.partyNameCentered = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        if Raidframes.Module.RF_Name:IsEnabled() then
                            Raidframes.Module.RF_Name:Update()
                        else
                            Raidframes.Module.RF_Name:Enable()
                        end
                    else
                        if (not mUI.db.profile.unitframes.raidframes.names) and (not mUI.db.profile.unitframes.raidframes.hidenames) then
                            Raidframes.Module.RF_Name:Disable()
                        else
                            Raidframes.Module.RF_Name:Update()
                        end
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.partyNameCentered
                end,
                order = 10
            },
            hidenames = {
                name = "Hide Names",
                desc = "Hide Names on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.hidenames = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Raidframes.Module.RF_HideNames:Enable()
                    else
                        Raidframes.Module.RF_HideNames:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.hidenames
                end,
                order = 11
            },
            solo = {
                name = "Solo Partyframes",
                desc = "Show Partyframes even when not in a group",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.solo = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Raidframes.Module.RF_Solo:Enable()
                    else
                        Raidframes.Module.RF_Solo:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.solo
                end,
                order = 12
            },
            smooth = {
                name = "Smooth Healthbars",
                desc = "Enable Smooth Healthbar Animation\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.smooth = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Raidframes.Module.Smooth:Enable()
                    else
                        Raidframes.Module.Smooth:Disable()
                        mUI:Reload("Disable Smooth Healthbars")
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.smooth
                end,
                order = 13
            },
            dispelGlow = {
                name = "Dispel Glow",
                desc = "Pulse a pixel glow around the raid/party frame when the unit has a dispellable debuff (color-coded by dispel type)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.dispelGlow = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end
                    if val then
                        Raidframes.Module.RF_Auras:Enable()
                    else
                        Raidframes.Module.RF_Auras:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.dispelGlow
                end,
                order = 14
            },
            header3 = {
                name = "Auras",
                type = "header",
                order = 15
            },
            auraDisplay = {

                name = function()
                    if mUI.db.profile.unitframes.raidframes.auraDisplay then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "Replace Blizzard's raid/party-frame buff and debuff icons with mUI-styled icons (custom borders, native countdown, dispellable debuffs scaled larger and shown first).\n\n|cffffff00Info:|r Requires UI reload to take effect.",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.auraDisplay = val

                    if not Raidframes.Module:IsEnabled() then
                        return
                    end
                    if val then
                        Raidframes.Module.RF_AuraDisplay:Enable()
                    else
                        Raidframes.Module.RF_AuraDisplay:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.auraDisplay
                end,
                order = 16
            },
            auraTooltips = {
                name = "Aura Tooltips",
                desc = "Show the aura tooltip when hovering over a custom aura icon. Disabling lets clicks pass through to the unit frame.",
                type = "toggle",
                hidden = function()
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.auraTooltips = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.auraTooltips
                end,
                order = 17
            },
            centerDefensivePoint = {
                name = "Defensive Anchor",
                desc = "Where on the raid frame the defensive icon(s) attach.",
                type = "select",
                values = {
                    CENTER = "Center",
                    LEFT = "Left",
                    RIGHT = "Right"
                },
                sorting = {"LEFT", "CENTER", "RIGHT"},
                hidden = function()
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.centerDefensivePoint = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.centerDefensivePoint
                end,
                order = 18
            },
            centerDefensiveSize = {
                name = "Center Defensive Size",
                desc = "Size of the centered defensive cooldown icon (BigDefensive / ExternalDefensive) as a percent of the raid frame's height.",
                type = "range",
                min = 20,
                max = 150,
                step = 1,
                isPercent = false,
                hidden = function()
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.centerDefensiveSize = val
                    Raidframes.Theme:UpdateAllRaidAuras()
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.centerDefensiveSize
                end,
                order = 19
            },
            centerDefensiveX = {
                name = "Defensive X Offset",
                desc = "Horizontal offset of the defensive icon(s) from the chosen anchor.",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                isPercent = false,
                hidden = function()
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.centerDefensiveX = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.centerDefensiveX
                end,
                order = 20
            },
            centerDefensiveY = {
                name = "Defensive Y Offset",
                desc = "Vertical offset of the defensive icon(s) from the chosen anchor.",
                type = "range",
                min = -100,
                max = 100,
                step = 1,
                isPercent = false,
                hidden = function()
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.centerDefensiveY = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.centerDefensiveY
                end,
                order = 21
            },
            buffSize = {
                name = "Buff Size",
                desc = "Set the size of Buffs on Raidframes (percentage of frame height)\n\n|cffffff00Info:|r Requires Skin Aura Icons or Custom Aura Icons",
                type = "range",
                min = 10,
                max = 50,
                step = 1,
                hidden = function()
                    if select(4, GetBuildInfo()) < 120005 then
                        return false
                    end
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.buffsize = val
                    Raidframes.Theme:UpdateAllRaidAuras()
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.buffsize
                end,
                order = 22
            },
            debuffSize = {
                name = "Debuff Size",
                desc = "Set the size of Debuffs on Raidframes (percentage of frame height)\n\n|cffffff00Info:|r Requires Skin Aura Icons or Custom Aura Icons",
                type = "range",
                min = 10,
                max = 100,
                step = 1,
                hidden = function()
                    if select(4, GetBuildInfo()) < 120005 then
                        return false
                    end
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.debuffsize = val
                    Raidframes.Theme:UpdateAllRaidAuras()
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.debuffsize
                end,
                order = 23
            },
            dispelScale = {
                name = "Big Debuff Size",
                desc = "How much larger important debuffs (boss & role auras) are shown compared to normal debuffs.\n\n|cffffff00Info:|r Requires UI reload to take effect.",
                type = "range",
                min = 1,
                max = 2,
                step = 0.05,
                isPercent = false,
                hidden = function()
                    return not (RAID_AURAS_FORCED or mUI.db.profile.unitframes.raidframes.auraDisplay)
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.dispelScale = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.dispelScale
                end,
                order = 24
            }
        }
    }

    function Raidframes:GetOptions()
        return Raidframes.layout
    end
end
