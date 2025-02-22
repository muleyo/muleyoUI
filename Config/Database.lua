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
            theme = 'Dark',
            color = { 0, 0, 0, 1 },
            font = 'Prototype',
            automation = {
                repair = 'Disabled',
                sell = true,
                delete = true,
                duel = true,
                release = true,
                resurrect = true,
                invite = false,
                cinematic = true,
                talkinghead = true
            },
            display = {
                iteminfo = true,
                stats = false,
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
                micromenu = 'Default',
                bagbuttons = 'Default'
            }
        },
        unitframes = {
            enabled = true,
            textures = {
                unitframes = 'Dragonflight',
                raidframes = 'Dragonflight'
            },
            color = true,
            playerrepcolor = true,
            reputationcolor = false,
            pvpbadge = true,
            hitindicator = false,
            combatindicator = false,
            totemicons = false,
            classbar = false,
            cornericon = true,
            restingtextures = true,
            name = false,
            level = false,
            buffsdebuffs = {
                enabled = true,
                buffsize = 24,
                debuffsize = 24
            }
        },
        castbars = {
            enabled = true,
            style = 'mUI',
            icon = true,
            casttime = true,
            targetscale = 100,
            focusscale = 100,
            targetpos = false,
            focuspos = false
        },
        nameplates = {
            enabled = true,
            style = 'mUI',
            texture = 'Dragonflight',
            decimals = 0,
            height = 2.5,
            width = 1,
            healthtext = true,
            classcolor = true,
            servername = true,
            arena = true,
            totem = true,
            casttime = true,
            focus = false,
            debuffs = 2,
            colors = 1,
            npccolors = {
                -- Mists of Tirna Scithe
                { id = 164921, name = 'Drust Harvester',         color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 166275, name = 'Mistveil Shaper',         color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 166299, name = 'Mistveil Tender',         color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 167111, name = 'Spinemaw Staghorn',       color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- The Necrotic Wake
                { id = 166302, name = 'Corpse Harvester',        color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 165137, name = 'Zolramus Gatekeeper',     color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 163128, name = 'Zolramus Sorcerer',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 163618, name = 'Zolramus Necromancer',    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 163126, name = 'Brittlebone Mage',        color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 165919, name = 'Skeletal Marauder',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 165824, name = 'Nar\'zudah',              color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 173016, name = 'Corpse Collector',        color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- Siege of Boralus
                { id = 129370, name = 'Irontide Waveshaper',     color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 128969, name = 'Ashvane Commander',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 135241, name = 'Bilge Rat Pillager',      color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 129367, name = 'Bilge Rat Tempest',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 144071, name = 'Irontide Waveshaper',     color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- The Stonevault
                { id = 212389, name = 'Cursedheart Invader',     color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 212453, name = 'Ghastly Voidsoul',        color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 213338, name = 'Forgebound Mender',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 221979, name = 'Void Bound Howler',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 214350, name = 'Turned Speaker',          color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 214066, name = 'Cursedforge Stoneshaper', color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 224962, name = 'Cursedforge Mender',      color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- The Dawnbreaker
                { id = 213892, name = 'Nightfall Shadowmage',    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 214762, name = 'Nightfall Commander',     color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 210966, name = 'Sureki Webmage',          color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 213893, name = 'Nightfall Darkcaster',    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 213932, name = 'Sureki Militant',         color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- Grim Batol
                { id = 224219, name = 'Twilight Earthcaller',    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 40167,  name = 'Twilight Beguiler',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 224271, name = 'Twilight Warlock',        color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- Ara-Kara
                { id = 216293, name = 'Trilling Attendant',      color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 217531, name = 'Ixin',                    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 218324, name = 'Nakt',                    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 217533, name = 'Atik',                    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 223253, name = 'Bloodstained Webmage',    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 216340, name = 'Sentry Stagshell',        color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 220599, name = 'Bloodstained Webmage',    color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 216364, name = 'Blood Overseer',          color = { r = 0, g = 0.55, b = 1, a = 1 } },

                -- City of Threads
                { id = 220195, name = 'Sureki Silkbinder',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 220196, name = 'Herald Of Ansurek',       color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 219984, name = 'Xephitik',                color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 223844, name = 'Covert Webmancer',        color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 224732, name = 'Covert Webmancer',        color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 216339, name = 'Sureki Unnaturaler',      color = { r = 0, g = 0.55, b = 1, a = 1 } },
                { id = 221102, name = 'Elder Shadeweaver',       color = { r = 0, g = 0.55, b = 1, a = 1 } }
            }
        },
        tooltips = {
            enabled = true,
            style = 'mUI',
            combat = true,
            lifeontop = true,
            mouseanchor = false
        },
        map = {
            enabled = true,
            coordinates = true,
            minimap = true,
            clock = true,
            date = true,
            tracking = true,
            buttons = true
        },
        chat = {
            enabled = true,
            style = 'mUI',
            input = true,
            link = true,
            copy = true,
            friendlist = true
        },
        misc = {
            enabled = true,
            interrupt = true,
            menubutton = true,
            statusbar = true,
            dragonflying = true,
            tabbinder = true,
            dampening = true,
            surrender = true,
            safequeue = true,
            losecontrol = true
        },
        edit = {
            statsframe = {
                point = 'BOTTOMLEFT',
                x = 5,
                y = 3
            },
            queueicon = {
                point = 'CENTER',
                x = 0,
                y = 0
            }
        },
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
