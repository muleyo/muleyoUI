local Database = mUI:NewModule("mUI.Config.Database")

local defaults = {
    profile = {
        install = false,
        new_version = false,
        changelogVersion = false,
        gui = {
            scale = 1
        },
        general = {
            enabled = true,
            theme = "Dark",
            color = {0, 0, 0, 1},
            font = "Prototype",
            fontpath = [[Interface\AddOns\mUI\Media\Fonts\Prototype.ttf]],
            borderStyle = "Style1",
            automation = {
                repair = "Personal",
                sell = true,
                delete = true,
                duel = true,
                release = false,
                resurrect = false,
                invite = false,
                cinematic = true,
                talkinghead = true,
                rolecheck = false,
                quests = false,
                gossip = false
            },
            display = {
                iteminfo = true,
                stats = true,
                movementspeed = false,
                errormessages = true,
                friendlist = true,
                mousecursor = false
            }
        },
        actionbars = {
            enabled = true,
            style = "mUI",
            hotkey = false,
            macro = false,
            flash = true,
            range = true,
            fontsize = 12,
            cooldown = false,
            layout = {
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
            },
            mouseover = {
                enabled = false,
                bar1 = false,
                bar2 = false,
                bar3 = false,
                bar4 = false,
                bar5 = false,
                bar6 = false,
                bar7 = false,
                bar8 = false,
                petbar = false,
                stancebar = false,
                micromenu = "Default",
                bagbuttons = "Default"
            }
        },
        unitframes = {
            enabled = true,
            textures = {
                unitframes = "D1",
                raidframes = "D1"
            },
            color = true,
            playerrepcolor = true,
            reputationcolor = false,
            pvpbadge = false,
            hitindicator = false,
            combatindicator = false,
            totemicons = false,
            classbar = false,
            cornericon = true,
            restingtextures = true,
            name = false,
            level = false,
            elitecolor = false,
            overshields = true,
            smooth = false,
            buffsdebuffs = {
                enabled = true,
                buffsize = 24,
                debuffsize = 24,
                debuffcolors = false
            },
            raidframes = {
                enabled = true,
                size = {
                    enabled = false,
                    width = 100,
                    height = 75
                },
                darkmode = false,
                health = false,
                healthcolor = false,
                names = false,
                partyNameCentered = false,
                partyStatusColorMode = "default",
                partyStatusCustomColor = {1, 0.82, 0, 1},
                hidenames = false,
                roleicons = false,
                solo = false,
                partyScale = 100,
                skinicons = true,
                buffsize = 28,
                debuffsize = 35,
                privateaurasize = 35,
                centerDefensiveSize = 60,
                centerDefensivePoint = "CENTER",
                centerDefensiveX = 0,
                centerDefensiveY = 0,
                defensive = {
                    position = "TOP",
                    size = 25
                },
                dispelGlow = true,
                auraDisplay = false,
                auraTooltips = true,
                dispelScale = 1.3,
                ccScale = 1.15
            }
        },
        castbars = {
            enabled = true,
            style = "mUI",
            icon = true,
            casttime = true,
            targetscale = 100,
            focusscale = 100,
            targetpos = false,
            focuspos = false,
            texture = "D1"
        },
        nameplates = {
            enabled = true,
            texture = "D1",
            decimals = 0,
            height = 2.5,
            width = 1,
            smartstacking = false,
            healthtext = true,
            classcolor = true,
            servername = true,
            arena = true,
            casttime = true,
            focus = false,
            debuffs = false,
            colors = false,
            clickthrough = false,
            size = {
                healthwidth = 150,
                healthheight = 12,
                castwidth = 150,
                castheight = 10
            },
            castbar = {
                y = 8
            },
            border = {
                size = 1
            },
            name = {
                size = 12
            },
            health = {
                percent = false,
                anchor = "RIGHT",
                x = 2,
                y = 0
            },
            names = {
                arena = false,
                spec = false
            },
            scale = {
                target = 1.2,
                other = 1
            },
            friendly = {
                hidehealthbar = false,
                hidenames = false,
                classcolor = false,
                small = false,
                width = 90
            },
            classicons = {
                enabled = false,
                friendly = true,
                enemy = true,
                spec = true,
                size = 22,
                anchor = "LEFT",
                x = 4,
                y = 0
            },
            healer = {
                enabled = false,
                friendly = true,
                enemy = true,
                size = 18,
                anchor = "RIGHT",
                x = 4,
                y = 0
            },
            target = {
                enabled = false,
                arrows = true,
                glow = false,
                classcolor = false,
                color = {1, 1, 1, 1},
                size = 16,
                offset = 4
            },
            raidmarker = {
                enabled = false,
                hide = false,
                alpha = 1,
                size = 22,
                anchor = "TOP",
                x = 0,
                y = 4
            },
            auras = {
                enabled = false,
                cc = {
                    size = 20,
                    x = 4,
                    anchor = "RIGHT"
                },
                top = {
                    size = 20,
                    y = 4
                },
                left = {
                    size = 20,
                    x = 4,
                    anchor = "LEFT"
                }
            },
            -- Personal resource bar: shows only the native class resource
            -- bar (combo points, runes, etc.), anchored to your target's Health Bar.
            personalresource = {
                enabled = false,
                anchor = "TOP",
                x = 0,
                y = 6
            },
            -- Totem indicator, ported from BetterBlizzPlates with permission.
            totem = {
                enabled = false,
                enemyOnly = false,
                colorHealthBar = false,
                noAnimation = false,
                size = 24,
                anchor = "TOP",
                x = 0,
                y = 4,
                color = {1, 0.82, 0, 1}
            }
        },
        tooltips = {
            enabled = true,
            style = "mUI",
            combat = false,
            mouseanchor = false,
            mythicplus = true,
            pvprating = true,
            lfgtooltips = true
        },
        map = {
            enabled = true,
            coordinates = true,
            minimap = false,
            clock = false,
            date = false,
            tracking = false,
            buttons = true
        },
        chat = {
            enabled = true,
            style = "mUI",
            input = true,
            link = true,
            copy = true,
            whisperalert = false,
            settings = {
                color = {0.88, 0.74, 0.36},
                tooltips = true,
                smooth = true,
                fade = {
                    enabled = true,
                    click = false,
                    out_delay = 60
                },
                buttons = {
                    up_and_down = false
                },
                chat = {
                    alpha = 0.4,
                    x_padding = 8,
                    y_padding = 0,
                    font = {
                        size = 12,
                        shadow = true,
                        outline = true
                    }
                },
                dock = {
                    alpha = 0.8,
                    fade = {
                        enabled = true
                    }
                },
                edit = {
                    alpha = 0.8,
                    position = "top",
                    offset = 32,
                    font = {
                        size = 12,
                        shadow = true,
                        outline = true
                    }
                }
            }
        },
        misc = {
            enabled = true,
            interrupt = false,
            menubutton = true,
            skinmenu = true,
            statusbar = false,
            tabbinder = false,
            dampening = true,
            surrender = true,
            safequeue = true,
            losecontrol = true,
            achievements = false,
            fastloot = false,
            playerlinks = true,
            lfgdeclined = true,
            gryphons = false
        },
        edit = {
            grid = {
                enabled = false,
                size = 16,
                alpha = 0.3,
                color = {1, 1, 1}
            }
        }
    }
}

function Database:OnInitialize()
    mUI.db = LibStub("AceDB-3.0"):New("mUIDB", defaults, true)
    mUI.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    mUI.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    mUI.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

function Database:RefreshConfig()
    mUI:Disable()
    mUI:Enable()
end
