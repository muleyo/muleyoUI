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
                aurasizeParty = 22,
                aurasizeRaid = 15,
                debuffsizeParty = 22,
                debuffsizeRaid = 15,
                darkmode = false,
                health = false,
                healthcolor = false,
                names = false,
                roleicons = false,
                solo = false,
                skinicons = true
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
            texture = "Dragonflight"
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
                -- Colors
                -- Purple: { r = 0.65, g = 0, b = 1 }
                -- Blue: { r = 0, g = 0.55, b = 1 }
                -- Orange: { r = 1, g = 0.55, b = 0 }
                -- Cyan: { r = 0, g = 1, b = 0.8 }

                -- Halls of Atonement
                [164562] = {
                    name = "Depraved Houndmaster",
                    color = {
                        r = 0.65,
                        g = 0,
                        b = 1
                    }
                },
                [165414] = {
                    name = "Depraved Obliterator",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [164557] = {
                    name = "Shard of Halkias",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [165408] = {
                    name = "Halkias",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [165529] = {
                    name = "Depraved Collector",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [164185] = {
                    name = "Echelon",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [165410] = {
                    name = "High Adjudicator Aleez",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [167876] = {
                    name = "Inquisitor Sigar",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [164218] = {
                    name = "Lord Chamberlain",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Tazavesh: Streets
                [178392] = {
                    name = "Gatewarden Zo'mazz",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [177817] = {
                    name = "Support Officer",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [175616] = {
                    name = "Zo'phex",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [179837] = {
                    name = "Tracker Zo'korss",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [179821] = {
                    name = "Commander Zo'far",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [180091] = {
                    name = "Ancient Core Hound",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [179841] = {
                    name = "Veteran Sparkcaster",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [176395] = {
                    name = "Overloaded Mailemental",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [175646] = {
                    name = "P.O.S.T. Master",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [176556] = {
                    name = "Alcruux",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [176705] = {
                    name = "Venza Goldfuse",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [176555] = {
                    name = "Achillite",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [175806] = {
                    name = "So'azmi",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Tazavesh: Gambit
                [178139] = {
                    name = "Murkbrine Shellcrusher",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [178142] = {
                    name = "Murkbrine Fishmancer",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [180431] = {
                    name = "Focused Ritualist",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [179388] = {
                    name = "Hourglass Tidesage",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [179733] = {
                    name = "Invigorating Fish Stick",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [178165] = {
                    name = "Coastwalker Goliath",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [175663] = {
                    name = "Hylbrande",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [175546] = {
                    name = "Timecap'n Hooktail",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [180429] = {
                    name = "Adorned Starseer",
                    color = {
                        r = 0.65,
                        g = 0,
                        b = 1
                    }
                },
                [180433] = {
                    name = "Wandering Pulsar",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [177269] = {
                    name = "So'leah",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Ara-Kara
                [216293] = {
                    name = "Trilling Attendant",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [223253] = {
                    name = "Bloodstained Webmage",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [216364] = {
                    name = "Blood Overseer",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [216340] = {
                    name = "Sentry Stagshell",
                    color = {
                        r = 0.65,
                        g = 0,
                        b = 1
                    }
                },
                [217531] = {
                    name = "Ixin",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [218324] = {
                    name = "Nakt",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [217533] = {
                    name = "Atik",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [213179] = {
                    name = "Avanoxx",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [216338] = {
                    name = "Hulking Bloodguard",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [228015] = {
                    name = "Hulking Bloodguard",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [215405] = {
                    name = "Anubzekt",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [215407] = {
                    name = "Kikatal The Harvester",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Dawnbreaker
                [214761] = {
                    name = "Nightfall Ritualist",
                    color = {
                        r = 0.65,
                        g = 0,
                        b = 1
                    }
                },
                [214762] = {
                    name = "Nightfall Commander",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [213892] = {
                    name = "Nightfall Shadowmage",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [210966] = {
                    name = "Sureki Webmage",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [213893] = {
                    name = "Nightfall Darkcaster",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [211087] = {
                    name = "Speaker Shadowcrown",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [211089] = {
                    name = "Anubikkaj",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [213937] = {
                    name = "Rashanan",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [213885] = {
                    name = "Nightfall Dark Architect",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [211263] = {
                    name = "Deathscreamer Ikentak",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [211262] = {
                    name = "Ixkreten The Unbreakable",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [211261] = {
                    name = "Ascendant Viscoxria",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [211341] = {
                    name = "Manifested Shadow",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Eco-Dome
                [234957] = {
                    name = "Wastelander Ritualist",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [234962] = {
                    name = "Wastelander Farstalker",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [234955] = {
                    name = "Wastelander Pactspeaker",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [236995] = {
                    name = "Ravenous Destroyer",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [234893] = {
                    name = "Azhiccar",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [242631] = {
                    name = "Overcharged Sentinel",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [237514] = {
                    name = "A'wazj",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [234933] = {
                    name = "Taah'bat",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [245092] = {
                    name = "Burrowing Creeper",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [234935] = {
                    name = "Soul-Scribe",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Priory of the Sacred Flame
                [212827] = {
                    name = "High Priest Aemya",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [212831] = {
                    name = "Forge Master Damian",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [239833] = {
                    name = "Elaena Emberlanz",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [239836] = {
                    name = "Sergeant Shaynemail",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [206696] = {
                    name = "Arathi Knight",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [212826] = {
                    name = "Guard Captain Suleyman",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [206697] = {
                    name = "Devout Priest",
                    color = {
                        r = 0.65,
                        g = 0,
                        b = 1
                    }
                },
                [206698] = {
                    name = "Fanatical Conjuror",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [206710] = {
                    name = "Lightspawn",
                    color = {
                        r = 0,
                        g = 1,
                        b = 0.8
                    }
                },
                [239834] = {
                    name = "Taener Duelmal",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [207946] = {
                    name = "Captain Dailcry",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [207939] = {
                    name = "Baron Braunpyke",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [221760] = {
                    name = "Risen Mage",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [217658] = {
                    name = "Sir Braunpyke",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [207940] = {
                    name = "Prioress Murrpray",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },

                -- Operation: Floodgate
                [231380] = {
                    name = "Undercrawler",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [229069] = {
                    name = "Mechadrone Sniper",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [229252] = {
                    name = "Darkfuse Hyena",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [229686] = {
                    name = "Venture Co. Surveyor",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [231496] = {
                    name = "Venture Co. Diver",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [230748] = {
                    name = "Darkfuse Bloodwarper",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [226398] = {
                    name = "Big M.O.M.M.A.",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [228424] = {
                    name = "Darkfuse Mechadrone",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [231223] = {
                    name = "Disturbed Kelp",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [226402] = {
                    name = "Bront",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [226403] = {
                    name = "Keeza Quickfuse",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [231312] = {
                    name = "Venture Co. Electrician",
                    color = {
                        r = 0,
                        g = 0.55,
                        b = 1
                    }
                },
                [231197] = {
                    name = "Bubbles",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [226404] = {
                    name = "Geezle Gigazap",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [209801] = {
                    name = "Quartermaster Koratite",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [212786] = {
                    name = "Voidrider",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [214421] = {
                    name = "Coalescing Void Diffuser",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [212739] = {
                    name = "Radiating Voidstone",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [230740] = {
                    name = "Shreddinator 3000",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [231325] = {
                    name = "Darkfuse Jumpstarter",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                },
                [226396] = {
                    name = "Swampface",
                    color = {
                        r = 1,
                        g = 0.55,
                        b = 0
                    }
                }
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
            dragonflying = true,
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
