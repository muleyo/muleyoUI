mUI.PortraitAuraSpells = {
    CrowdControl = {
        -- Stuns
        [853] = true,    -- Hammer of Justice
        [408] = true,    -- Kidney Shot
        [1833] = true,   -- Cheap Shot
        [5211] = true,   -- Mighty Bash
        [22570] = true,  -- Maim
        [203123] = true, -- Maim
        [163505] = true, -- Rake
        [119381] = true, -- Leg Sweep
        [132168] = true, -- Shockwave
        [46968] = true,  -- Shockwave
        [107570] = true, -- Storm Bolt
        [12809] = true,  -- Concussion Blow
        [179057] = true, -- Chaos Nova
        [200166] = true, -- Metamorphosis
        [211881] = true, -- Fel Eruption
        [108194] = true, -- Asphyxiate
        [221562] = true, -- Asphyxiate
        [47481] = true,  -- Gnaw
        [91800] = true,  -- Gnaw
        [89766] = true,  -- Axe Toss
        [30283] = true,  -- Shadowfury
        [200200] = true, -- Holy Word: Chastise
        [24394] = true,  -- Intimidation
        [117526] = true, -- Binding Shot
        [118905] = true, -- Static Charge
        [305485] = true, -- Lightning Lasso
        [64044] = true,  -- Psychic Horror
        [1122] = true,   -- Inferno
        -- Fears, horrors, disorients
        [5782] = true,   -- Fear
        [118699] = true, -- Fear
        [5246] = true,   -- Intimidating Shout
        [8122] = true,   -- Psychic Scream
        [5484] = true,   -- Howl of Terror
        [6789] = true,   -- Mortal Coil
        [207167] = true, -- Blinding Sleet
        [31661] = true,  -- Dragon's Breath
        [2094] = true,   -- Blind
        [105421] = true, -- Blinding Light
        [10326] = true,  -- Turn Evil
        [605] = true,    -- Mind Control
        [33786] = true,  -- Cyclone
        [710] = true,    -- Banish
        -- Incapacitates
        [118] = true,    -- Polymorph
        [28272] = true,  -- Polymorph (Pig)
        [28271] = true,  -- Polymorph (Turtle)
        [61305] = true,  -- Polymorph (Black Cat)
        [61721] = true,  -- Polymorph (Rabbit)
        [61780] = true,  -- Polymorph (Turkey)
        [126819] = true, -- Polymorph (Porcupine)
        [161353] = true, -- Polymorph (Polar Bear Cub)
        [161354] = true, -- Polymorph (Monkey)
        [161355] = true, -- Polymorph (Penguin)
        [161372] = true, -- Polymorph (Peacock)
        [277787] = true, -- Polymorph (Direhorn)
        [277792] = true, -- Polymorph (Bumblebee)
        [321395] = true, -- Polymorph (Mawrat)
        [391622] = true, -- Polymorph (Duck)
        [51514] = true,  -- Hex
        [210873] = true, -- Hex (Compy)
        [211004] = true, -- Hex (Spider)
        [211010] = true, -- Hex (Snake)
        [211015] = true, -- Hex (Cockroach)
        [269352] = true, -- Hex (Skeletal Hatchling)
        [277778] = true, -- Hex (Zandalari Tendonripper)
        [277784] = true, -- Hex (Wicker Mongrel)
        [309328] = true, -- Hex (Living Honey)
        [20066] = true,  -- Repentance
        [1776] = true,   -- Gouge
        [6770] = true,   -- Sap
        [99] = true,     -- Incapacitating Roar
        [115078] = true, -- Paralysis
        [107079] = true, -- Quaking Palm
        [198909] = true, -- Song of Chi-Ji
        [82691] = true,  -- Ring of Frost
        [3355] = true,   -- Freezing Trap
        [187650] = true, -- Freezing Trap
        [19386] = true,  -- Wyvern Sting
        [213691] = true, -- Scatter Shot
        [9484] = true,   -- Shackle Undead
    },

    -- Holds you in place but does not take the control away. Lower than the rest of the crowd control.
    SoftCrowdControl = {
        [122] = true,    -- Frost Nova
        [33395] = true,  -- Freeze
        [228600] = true, -- Glacial Spike
        [339] = true,    -- Entangling Roots
        [102359] = true, -- Mass Entanglement
        [64695] = true,  -- Earthgrab
        [45334] = true   -- Immobilized (Wild Charge)
    },

    Defensive = {
        -- Death Knight
        [48707] = true,   -- Anti-Magic Shell
        [48792] = true,   -- Icebound Fortitude
        [55233] = true,   -- Vampiric Blood
        [49039] = true,   -- Lichborne
        [81256] = true,   -- Dancing Rune Weapon
        [194679] = true,  -- Rune Tap
        [219809] = true,  -- Tombstone
        [145629] = true,  -- Anti-Magic Zone
        [410358] = true,  -- Spellwarden (Anti-Magic Zone)
        -- Demon Hunter
        [212800] = true,  -- Blur
        [209426] = true,  -- Darkness
        [196555] = true,  -- Netherwalk
        [187827] = true,  -- Metamorphosis
        [203819] = true,  -- Demon Spikes
        -- Druid
        [22812] = true,   -- Barkskin
        [102342] = true,  -- Iron Bark
        [61336] = true,   -- Survival Instincts
        [22842] = true,   -- Frenzied Regeneration
        [192081] = true,  -- Ironfur
        [50334] = true,   -- Berserk
        [102558] = true,  -- Incarnation: Guardian of Ursoc
        [1261872] = true, -- Heart of the Wild (Bear)
        -- Evoker
        [363916] = true,  -- Obsidian Scales
        [374348] = true,  -- Renewing Blaze
        [357170] = true,  -- Time Dilation
        [363534] = true,  -- Rewind
        [378441] = true,  -- Time Stop
        [374227] = true,  -- Zephyr
        [370960] = true,  -- Emerald Communion
        [409293] = true,  -- Burrow
        [360827] = true,  -- Blistering Scales
        -- Hunter
        [186265] = true,  -- Aspect of the Turtle
        [264735] = true,  -- Survival of the Fittest
        [281195] = true,  -- Survival of the Fittest
        [53480] = true,   -- Roar of Sacrifice
        -- Mage
        [45438] = true,   -- Ice Block
        [27619] = true,   -- Ice Block
        [414658] = true,  -- Ice Cold
        [11426] = true,   -- Ice Barrier
        [235313] = true,  -- Blazing Barrier
        [235450] = true,  -- Prismatic Barrier
        [110909] = true,  -- Alter Time
        [113862] = true,  -- Greater Invisibility
        -- Monk
        [115203] = true,  -- Fortifying Brew
        [120954] = true,  -- Fortifying Brew
        [122783] = true,  -- Diffuse Magic
        [122278] = true,  -- Dampen Harm
        [115176] = true,  -- Zen Meditation
        [125174] = true,  -- Touch of Karma
        [116849] = true,  -- Life Cocoon
        [322507] = true,  -- Celestial Brew
        [353319] = true,  -- Revival
        -- Paladin
        [642] = true,     -- Divine Shield
        [1020] = true,    -- Divine Shield
        [498] = true,     -- Divine Protection
        [5573] = true,    -- Divine Protection
        [403876] = true,  -- Divine Protection
        [1022] = true,    -- Blessing of Protection
        [5599] = true,    -- Blessing of Protection
        [10278] = true,   -- Blessing of Protection
        [6940] = true,    -- Blessing of Sacrifice
        [20729] = true,   -- Blessing of Sacrifice
        [204018] = true,  -- Blessing of Spellwarding
        [31850] = true,   -- Ardent Defender
        [86659] = true,   -- Guardian of Ancient Kings
        [228050] = true,  -- Guardian of the Forgotten Queen
        [31821] = true,   -- Aura Mastery
        [132403] = true,  -- Shield of the Righteous
        [184662] = true,  -- Shield of Vengeance
        [216331] = true,  -- Avenging Crusader
        [389539] = true,  -- Sentinel
        -- Priest
        [33206] = true,   -- Pain Suppression
        [47788] = true,   -- Guardian Spirit
        [47585] = true,   -- Dispersion
        [19236] = true,   -- Desperate Prayer
        [81782] = true,   -- Power Word: Barrier
        [271466] = true,  -- Luminous Barrier
        [27827] = true,   -- Spirit of Redemption
        [215769] = true,  -- Spirit of the Redeemer
        [15286] = true,   -- Vampiric Embrace
        [586] = true,     -- Fade
        [200183] = true,  -- Apotheosis
        [421453] = true,  -- Ultimate Penitence
        -- Rogue
        [5277] = true,    -- Evasion
        [26669] = true,   -- Evasion
        [31224] = true,   -- Cloak of Shadows
        [1966] = true,    -- Feint
        [11327] = true,   -- Vanish
        [45182] = true,   -- Cheating Death
        -- Shaman
        [108271] = true,  -- Astral Shift
        [98007] = true,   -- Spirit Link Totem
        [325174] = true,  -- Spirit Link Totem
        [207498] = true,  -- Ancestral Protection
        [30823] = true,   -- Shamanistic Rage
        -- Warlock
        [104773] = true,  -- Unending Resolve
        [108416] = true,  -- Dark Pact
        [212295] = true,  -- Nether Ward
        -- Warrior
        [871] = true,     -- Shield Wall
        [12975] = true,   -- Last Stand
        [118038] = true,  -- Die by the Sword
        [23920] = true,   -- Spell Reflection
        [184364] = true,  -- Enraged Regeneration
        [97463] = true,   -- Rallying Cry
        [190456] = true,  -- Ignore Pain
        [132404] = true,  -- Shield Block
        -- Racials
        [20594] = true,   -- Stoneform
        [58984] = true    -- Shadowmeld
    },

    Important = {
        -- Bloodlust and the like
        [2825] = true,    -- Bloodlust
        [32182] = true,   -- Heroism
        [80353] = true,   -- Time Warp
        [264667] = true,  -- Primal Rage
        [390386] = true,  -- Fury of the Aspects
        [160452] = true,  -- Netherwinds
        [90355] = true,   -- Ancient Hysteria
        -- Death Knight
        [51271] = true,   -- Pillar of Frost
        [207289] = true,  -- Unholy Assault
        [47568] = true,   -- Empower Rune Weapon
        [63560] = true,   -- Dark Transformation
        -- Demon Hunter
        [162264] = true,  -- Metamorphosis
        -- Druid
        [29166] = true,   -- Innervate
        [106951] = true,  -- Berserk
        [102543] = true,  -- Incarnation: Avatar of Ashamane
        [194223] = true,  -- Celestial Alignment
        [102560] = true,  -- Incarnation: Chosen of Elune
        [5217] = true,    -- Tiger's Fury
        [106898] = true,  -- Stampeding Roar (No Form)
        [77764] = true,   -- Stampeding Roar (Cat)
        [77761] = true,   -- Stampeding Roar (Bear)
        -- Evoker
        [375087] = true,  -- Dragonrage
        [395296] = true,  -- Ebon Might
        [410089] = true,  -- Prescience
        -- Hunter
        [19574] = true,   -- Bestial Wrath
        [193530] = true,  -- Aspect of the Wild
        [288613] = true,  -- Trueshot
        [266779] = true,  -- Coordinated Assault
        [359844] = true,  -- Call of the Wild
        [3045] = true,    -- Rapid Fire
        -- Mage
        [190319] = true,  -- Combustion
        [12472] = true,   -- Icy Veins
        [365362] = true,  -- Arcane Surge
        [12042] = true,   -- Arcane Power
        -- Monk
        [137639] = true,  -- Storm, Earth, and Fire
        [152173] = true,  -- Serenity
        [116680] = true,  -- Thunder Focus Tea
        [116841] = true,  -- Tiger's Lust
        -- Paladin
        [31884] = true,   -- Avenging Wrath
        [231895] = true,  -- Crusade
        [105809] = true,  -- Holy Avenger
        [1044] = true,    -- Blessing of Freedom
        [210256] = true,  -- Blessing of Sanctuary
        -- Priest
        [10060] = true,   -- Power Infusion
        [194249] = true,  -- Voidform
        -- Rogue
        [13750] = true,   -- Adrenaline Rush
        [185313] = true,  -- Shadow Dance
        [121471] = true,  -- Shadow Blades
        [51690] = true,   -- Killing Spree
        [57934] = true,   -- Tricks of the Trade
        [59628] = true,   -- Tricks of the Trade
        [1224098] = true, -- Tricks of the Trade
        -- Shaman
        [114050] = true,  -- Ascendance (Elemental)
        [114051] = true,  -- Ascendance (Enhancement)
        [114052] = true,  -- Ascendance (Restoration)
        [191634] = true,  -- Stormkeeper
        -- Warlock
        [113858] = true,  -- Dark Soul: Instability
        [113860] = true,  -- Dark Soul: Misery
        -- Warrior
        [1719] = true,    -- Recklessness
        [107574] = true,  -- Avatar
        [227847] = true,  -- Bladestorm
        [46924] = true    -- Bladestorm
    }
}
