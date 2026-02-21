local Database = mUI:NewModule("mUI.Config.Database")

local defaults = {
    profile = {
        install = false,
        new_version = false,
        gui = {
            scale = 1
        },
        general = {
            enabled = true,
            theme = "Dark",
            color = {0, 0, 0, 1},
            font = "Prototype",
            fontpath = [[Interface\AddOns\mUI\Media\Fonts\Prototype.ttf]],
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
                quests = false
            },
            display = {
                iteminfo = true,
                stats = true,
                movementspeed = false,
                errormessages = true,
                friendlist = true
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
                size = {
                    enabled = false,
                    width = 100,
                    height = 75
                },
                darkmode = false,
                health = false,
                healthcolor = false,
                names = false,
                roleicons = false,
                solo = false,
                skinicons = true,
                defensive = {
                    position = "TOP",
                    size = 25
                }
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
            totem = false,
            casttime = true,
            focus = false,
            debuffs = false,
            colors = false,
            smallerfriends = false,
            npccolors = {}
        },
        tooltips = {
            enabled = true,
            style = "mUI",
            combat = false,
            mouseanchor = false
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
            friendlist = true,
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
