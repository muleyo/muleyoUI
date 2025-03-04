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
            fontpath = [[Interface\AddOns\mUI\Media\Fonts\Prototype.ttf]],
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
            fontsize = 12,
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
                bagbuttons = "Default",
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
                darkmode = false,
                health = false,
                healthcolor = false,
                names = false,
                roleicons = false,
                solo = false
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
                -- Colors
                -- Purple: { r = 0.65, g = 0, b = 1 }
                -- Blue: { r = 0, g = 0.55, b = 1 }
                -- Orange: { r = 1, g = 0.55, b = 0 }
                -- Cyan: { r = 0, g = 1, b = 0.8 }

                -- Priory of the Sacred Flame
                [206705] = { name = "Arathi Footman", color = { r = 0, g = 1, b = 0.8 } },
                [206696] = { name = "Arathi Footman", color = { r = 0, g = 1, b = 0.8 } },
                [212835] = { name = "Risen Footman", color = { r = 0, g = 1, b = 0.8 } },
                [212826] = { name = "Guard Captain Suleyman", color = { r = 1, g = 0.55, b = 0 } },
                [206697] = { name = "Devout Priest", color = { r = 0.65, g = 0, b = 1 } },
                [206698] = { name = "Fanatical Conjuror", color = { r = 0, g = 0.55, b = 1 } },
                [206710] = { name = "Lightspawn", color = { r = 0, g = 1, b = 0.8 } },
                [239834] = { name = "Taener Duelmal", color = { r = 0, g = 0.55, b = 1 } },
                [207946] = { name = "Captain Dailcry", color = { r = 1, g = 0.55, b = 0 } },
                [207939] = { name = "Baron Braunpyke", color = { r = 1, g = 0.55, b = 0 } },
                [221760] = { name = "Risen Mage", color = { r = 0, g = 0.55, b = 1 } },
                [217658] = { name = "Sir Braunpyke", color = { r = 1, g = 0.55, b = 0 } },
                [207940] = { name = "Prioress Murrpray", color = { r = 1, g = 0.55, b = 0 } },

                -- Cinderbrew Meadery
                [218671] = { name = "Venture Co. Pyromaniac", color = { r = 0, g = 0.55, b = 1 } },
                [214697] = { name = "Chef Chewie", color = { r = 1, g = 0.55, b = 0 } },
                [210264] = { name = "Bee Wrangler", color = { r = 0, g = 0.55, b = 1 } },
                [220141] = { name = "Royal Jelly Purveyor", color = { r = 0, g = 0.55, b = 1 } },
                [214673] = { name = "Flavor Scientist", color = { r = 0, g = 0.55, b = 1 } },
                [222964] = { name = "Flavor Scientist", color = { r = 0, g = 0.55, b = 1 } },
                [220060] = { name = "Taste Tester", color = { r = 0, g = 0.55, b = 1 } },
                [218002] = { name = "Benk Buzzbee", color = { r = 1, g = 0.55, b = 0 } },
                [210267] = { name = "I'pa", color = { r = 1, g = 0.55, b = 0 } },
                [214661] = { name = "Goldie Baronbottom", color = { r = 1, g = 0.55, b = 0 } },

                -- Darkflame Cleft
                [210818] = { name = "Lowly Moleherd", color = { r = 0, g = 0.55, b = 1 } },
                [210812] = { name = "Royal Wicklighter", color = { r = 0, g = 0.55, b = 1 } },
                [210153] = { name = "Ol' Waxbeard", color = { r = 1, g = 0.55, b = 0 } },
                [220815] = { name = "Blazing Fiend", color = { r = 0, g = 0.55, b = 1 } },
                [208743] = { name = "Blazikon", color = { r = 1, g = 0.55, b = 0 } },
                [213913] = { name = "Kobold Flametender", color = { r = 0, g = 0.55, b = 1 } },
                [208745] = { name = "The Candle King", color = { r = 1, g = 0.55, b = 0 } },
                [208456] = { name = "Shuffling Horror", color = { r = 0, g = 0.55, b = 1 } },
                [208747] = { name = "The Darkness", color = { r = 1, g = 0.55, b = 0 } },
                [213008] = { name = "Wriggling Darkspawn", color = { r = 0, g = 0.55, b = 1 } },

                -- The Rookery
                [207198] = { name = "Cursed Thunderer", color = { r = 0, g = 0.55, b = 1 } },
                [207199] = { name = "Cursed Rooktender", color = { r = 0, g = 0.55, b = 1 } },
                [209230] = { name = "Kyrioss", color = { r = 1, g = 0.55, b = 0 } },
                [212793] = { name = "Void Ascendant", color = { r = 0, g = 0.55, b = 1 } },
                [207205] = { name = "Stormguard Gorren", color = { r = 1, g = 0.55, b = 0 } },
                [214439] = { name = "Corrupted Oracle", color = { r = 0, g = 0.55, b = 1 } },

                -- Operation: Floodgate
                [231380] = { name = "Undercrawler", color = { r = 0, g = 0.55, b = 1 } },
                [229069] = { name = "Mechadrone Sniper", color = { r = 0, g = 0.55, b = 1 } },
                [229252] = { name = "Darkfuse Hyena", color = { r = 0, g = 0.55, b = 1 } },
                [229686] = { name = "Venture Co. Surveyor", color = { r = 0, g = 0.55, b = 1 } },
                [231496] = { name = "Venture Co. Diver", color = { r = 0, g = 0.55, b = 1 } },
                [230748] = { name = "Darkfuse Bloodwarper", color = { r = 0, g = 0.55, b = 1 } },
                [226398] = { name = "Big M.O.M.M.A.", color = { r = 1, g = 0.55, b = 0 } },
                [228424] = { name = "Darkfuse Mechadrone", color = { r = 0, g = 0.55, b = 1 } },
                [231223] = { name = "Disturbed Kelp", color = { r = 0, g = 0.55, b = 1 } },
                [226402] = { name = "Bront", color = { r = 1, g = 0.55, b = 0 } },
                [226403] = { name = "Keeza Quickfuse", color = { r = 1, g = 0.55, b = 0 } },
                [231312] = { name = "Venture Co. Electrician", color = { r = 0, g = 0.55, b = 1 } },
                [231197] = { name = "Bubbles", color = { r = 1, g = 0.55, b = 0 } },
                [226404] = { name = "Geezle Gigazap", color = { r = 1, g = 0.55, b = 0 } },

                -- The Motherlode
                [136470] = { name = "Refreshment Vendor", color = { r = 0, g = 0.55, b = 1 } },
                [130488] = { name = "Mech Jockey", color = { r = 0.65, g = 0, b = 1 } },
                [134232] = { name = "Hired Assassin", color = { r = 0, g = 0.55, b = 1 } },
                [129214] = { name = "Coin-Operated Crowd Pummeler", color = { r = 1, g = 0.55, b = 0 } },
                [130661] = { name = "Venture Co. Earthshaper", color = { r = 0, g = 0.55, b = 1 } },
                [134005] = { name = "Shalebiter", color = { r = 0, g = 0.55, b = 1 } },
                [130635] = { name = "Stonefury", color = { r = 0, g = 0.55, b = 1 } },
                [134012] = { name = "Taskmaster Askari", color = { r = 1, g = 0.55, b = 0 } },
                [129227] = { name = "Azerokk", color = { r = 1, g = 0.55, b = 0 } },
                [129802] = { name = "Earthrager", color = { r = 0.65, g = 0, b = 1 } },
                [133432] = { name = "Venture Co. Alchemist", color = { r = 0, g = 0.55, b = 1 } },
                [129231] = { name = "Rixxa Fluxflame", color = { r = 1, g = 0.55, b = 0 } },
                [129232] = { name = "Mogul Razdunk", color = { r = 1, g = 0.55, b = 0 } },
                [141303] = { name = "B.O.O.M.B.A.", color = { r = 1, g = 0.55, b = 0 } },
                [132056] = { name = "Venture Co. Skyscorcher", color = { r = 0.65, g = 0, b = 1 } },

                -- Theater of Pain
                [174197] = { name = "Battlefield Ritualist", color = { r = 0, g = 0.55, b = 1 } },
                [164461] = { name = "Sathel the Accursed", color = { r = 0, g = 0.55, b = 1 } },
                [164463] = { name = "Paceran the Virulent", color = { r = 0.65, g = 0, b = 1 } },
                [164451] = { name = "Dessia the Decapitator", color = { r = 1, g = 0.55, b = 0 } },
                [165946] = { name = "Mordretha, the Endless Empress", color = { r = 1, g = 0.55, b = 0 } },
                [162744] = { name = "Nekthara the Mangler", color = { r = 1, g = 0.55, b = 0 } },
                [167538] = { name = "Dokigg the Brutalizer", color = { r = 1, g = 0.55, b = 0 } },
                [167536] = { name = "Harugia the Bloodthirsty", color = { r = 1, g = 0.55, b = 0 } },
                [167532] = { name = "Heavin the Breaker", color = { r = 1, g = 0.55, b = 0 } },
                [164506] = { name = "Ancient Captain", color = { r = 0, g = 1, b = 0.8 } },
                [167534] = { name = "Rek the Hardened", color = { r = 1, g = 0.55, b = 0 } },
                [167533] = { name = "Advent Nevermore", color = { r = 1, g = 0.55, b = 0 } },
                [162329] = { name = "Xav the Unfallen", color = { r = 1, g = 0.55, b = 0 } },
                [170234] = { name = "Oppressive Banner", color = { r = 0.65, g = 0, b = 1 } },
                [174210] = { name = "Blighted Sludge-Spewer", color = { r = 0, g = 0.55, b = 1 } },
                [169927] = { name = "Putrid Butcher", color = { r = 0.65, g = 0, b = 1 } },
                [163086] = { name = "Rancid Gasbag", color = { r = 1, g = 0.55, b = 0 } },
                [162317] = { name = "Gorechop", color = { r = 1, g = 0.55, b = 0 } },
                [169875] = { name = "Shackled Soul", color = { r = 0, g = 0.55, b = 1 } },
                [167998] = { name = "Portal Guardian", color = { r = 1, g = 0.55, b = 0 } },
                [160495] = { name = "Maniacal Soulbinder", color = { r = 0, g = 1, b = 0.8 } },
                [170882] = { name = "Bone Magus", color = { r = 0, g = 0.55, b = 1 } },
                [169893] = { name = "Nefarious Darkspeaker", color = { r = 0, g = 0.55, b = 1 } },
                [162309] = { name = "Kul'tharok", color = { r = 1, g = 0.55, b = 0 } },

                -- Mechagon: Workshop
                [144244] = { name = "The Platinum Pummeler", color = { r = 1, g = 0.55, b = 0 } },
                [145185] = { name = "Gnomercy 4.U.", color = { r = 1, g = 0.55, b = 0 } },
                [144246] = { name = "K.U.-J.0.", color = { r = 1, g = 0.55, b = 0 } },
                [144295] = { name = "Mechagon Mechanic", color = { r = 0.65, g = 0, b = 1 } },
                [144294] = { name = "Mechagon Tinkerer", color = { r = 0, g = 1, b = 0.8 } },
                [144248] = { name = "Head Machinist Sparkflux", color = { r = 1, g = 0.55, b = 0 } },
                [150396] = { name = "Aerial Unit R-21/X", color = { r = 1, g = 0.55, b = 0 } },
                [144249] = { name = "Omega Buster", color = { r = 1, g = 0.55, b = 0 } },
                [151657] = { name = "Bomb Tonk", color = { r = 0, g = 0.55, b = 1 } },
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
            achievements = false,
            fastloot = false
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
