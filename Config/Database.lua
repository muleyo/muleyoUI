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
            color = { 0, 0, 0, 1 },
            font = "Prototype",
            automation = {
                repair = "Personal",
                sell = true,
                delete = true,
                duel = true,
                release = true,
                resurrect = false,
                invite = false,
                cinematic = true,
                talkinghead = true
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
            hotkey = false,
            macro = false,
            flash = true,
            range = true,
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
                unitframes = "Dragonflight",
                raidframes = "Dragonflight"
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
                    height = 75,
                },
                healthcolor = false,
                names = false,
                roleicons = false,
                health = false
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
            focuspos = false
        },
        nameplates = {
            enabled = true,
            texture = "Dragonflight",
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
            npccolors = {},
            preset_npccolors = {
                -- Mists of Tirna Scithe
                [164921] = { name = "Drust Harvester", color = { r = 0, g = 0.55, b = 1 } },
                [166275] = { name = "Mistveil Shaper", color = { r = 0, g = 0.55, b = 1 } },
                [166299] = { name = "Mistveil Tender", color = { r = 0, g = 0.55, b = 1 } },
                [167111] = { name = "Spinemaw Staghorn", color = { r = 0, g = 0.55, b = 1 } },

                -- The Necrotic Wake
                [166302] = { name = "Corpse Harvester", color = { r = 0, g = 0.55, b = 1 } },
                [165137] = { name = "Zolramus Gatekeeper", color = { r = 0, g = 0.55, b = 1 } },
                [163128] = { name = "Zolramus Sorcerer", color = { r = 0, g = 0.55, b = 1 } },
                [163618] = { name = "Zolramus Necromancer", color = { r = 0, g = 0.55, b = 1 } },
                [163126] = { name = "Brittlebone Mage", color = { r = 0, g = 0.55, b = 1 } },
                [165919] = { name = "Skeletal Marauder", color = { r = 0, g = 0.55, b = 1 } },
                [165824] = { name = "Nar'zudah", color = { r = 0, g = 0.55, b = 1 } },
                [173016] = { name = "Corpse Collector", color = { r = 0, g = 0.55, b = 1 } },

                -- Siege of Boralus
                [129370] = { name = "Irontide Waveshaper", color = { r = 0, g = 0.55, b = 1 } },
                [128969] = { name = "Ashvane Commander", color = { r = 0, g = 0.55, b = 1 } },
                [135241] = { name = "Bilge Rat Pillager", color = { r = 0, g = 0.55, b = 1 } },
                [129367] = { name = "Bilge Rat Tempest", color = { r = 0, g = 0.55, b = 1 } },
                [144071] = { name = "Irontide Waveshaper", color = { r = 0, g = 0.55, b = 1 } },

                -- The Stonevault
                [212389] = { name = "Cursedheart Invader", color = { r = 0, g = 0.55, b = 1 } },
                [212453] = { name = "Ghastly Voidsoul", color = { r = 0, g = 0.55, b = 1 } },
                [213338] = { name = "Forgebound Mender", color = { r = 0, g = 0.55, b = 1 } },
                [221979] = { name = "Void Bound Howler", color = { r = 0, g = 0.55, b = 1 } },
                [214350] = { name = "Turned Speaker", color = { r = 0, g = 0.55, b = 1 } },
                [214066] = { name = "Cursedforge Stoneshaper", color = { r = 0, g = 0.55, b = 1 } },
                [224962] = { name = "Cursedforge Mender", color = { r = 0, g = 0.55, b = 1 } },

                -- The Dawnbreaker
                [213892] = { name = "Nightfall Shadowmage", color = { r = 0, g = 0.55, b = 1 } },
                [214762] = { name = "Nightfall Commander", color = { r = 0, g = 0.55, b = 1 } },
                [210966] = { name = "Sureki Webmage", color = { r = 0, g = 0.55, b = 1 } },
                [213893] = { name = "Nightfall Darkcaster", color = { r = 0, g = 0.55, b = 1 } },
                [213932] = { name = "Sureki Militant", color = { r = 0, g = 0.55, b = 1 } },

                -- Grim Batol
                [224219] = { name = "Twilight Earthcaller", color = { r = 0, g = 0.55, b = 1 } },
                [40167] = { name = "Twilight Beguiler", color = { r = 0, g = 0.55, b = 1 } },
                [224271] = { name = "Twilight Warlock", color = { r = 0, g = 0.55, b = 1 } },

                -- Ara-Kara
                [216293] = { name = "Trilling Attendant", color = { r = 0, g = 0.55, b = 1 } },
                [217531] = { name = "Ixin", color = { r = 0, g = 0.55, b = 1 } },
                [218324] = { name = "Nakt", color = { r = 0, g = 0.55, b = 1 } },
                [217533] = { name = "Atik", color = { r = 0, g = 0.55, b = 1 } },
                [223253] = { name = "Bloodstained Webmage", color = { r = 0, g = 0.55, b = 1 } },
                [216340] = { name = "Sentry Stagshell", color = { r = 0, g = 0.55, b = 1 } },
                [220599] = { name = "Bloodstained Webmage", color = { r = 0, g = 0.55, b = 1 } },
                [216364] = { name = "Blood Overseer", color = { r = 0, g = 0.55, b = 1 } },

                -- City of Threads
                [220195] = { name = "Sureki Silkbinder", color = { r = 0, g = 0.55, b = 1 } },
                [220196] = { name = "Herald Of Ansurek", color = { r = 0, g = 0.55, b = 1 } },
                [219984] = { name = "Xephitik", color = { r = 0, g = 0.55, b = 1 } },
                [223844] = { name = "Covert Webmancer", color = { r = 0, g = 0.55, b = 1 } },
                [224732] = { name = "Covert Webmancer", color = { r = 0, g = 0.55, b = 1 } },
                [216339] = { name = "Sureki Unnaturaler", color = { r = 0, g = 0.55, b = 1 } },
                [221102] = { name = "Elder Shadeweaver", color = { r = 0, g = 0.55, b = 1 } }
            }
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
                color = { 0.88, 0.74, 0.36 },
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
            },
        },
        misc = {
            enabled = true,
            interrupt = true,
            menubutton = true,
            statusbar = false,
            dragonflying = true,
            tabbinder = false,
            dampening = true,
            surrender = true,
            safequeue = true,
            losecontrol = true,
            buffcollapse = false,
            achievements = false
        },
        edit = {},
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
