local NPCColors = mUI:NewModule("mUI.Config.Layouts.NPCColors")

-- Enable Module
NPCColors:Enable()

function NPCColors:OnInitialize()
    -- Load Database
    NPCColors.db = mUI.db.profile.nameplates

    -- Get Modules
    NPCColors.Health = mUI:GetModule("mUI.Modules.Nameplates.Health")

    -- Load Libraries
    local ACD = LibStub("AceConfigDialog-3.0")
    local npcInfo = LibStub('LibNPCInfo')

    -- Initialize Layout
    NPCColors.layout = {
        type = "group",
        name = "NPC Colors",
        args = {
            header = {
                type = "header",
                name = "NPC Colors",
                order = 0
            },
            back = {
                type = "execute",
                name = "Nameplate Options",
                desc = "Go back to Nameplates Options",
                func = function()
                    mUIOptions.container:ReleaseChildren()
                    ACD:Open("mUIOptions_Nameplates_Tab", mUIOptions.container)
                end,
                width = 1,
                order = 1
            },
            loadpreset = {
                type = "execute",
                name = "Load Preset",
                desc = "Load a preset of NPCs",
                func = function()
                    for npcID, npcData in pairs(NPCColors.db.preset_npccolors) do
                        if not NPCColors.db.npccolors[npcID] then
                            NPCColors.db.npccolors[npcID] = { name = npcData.name, color = { r = npcData.color.r, g = npcData.color.g, b = npcData.color.b } }
                        end
                    end
                    NPCColors:UpdateNPCList()
                end,
                width = 1,
                order = 2
            },
            spacer1 = {
                type = "description",
                name = "",
                width = 0.05,
                order = 3,
            },
            addnpc = {
                type = "input",
                name = "Add NPC by ID",
                desc = "Add a new NPC to the list",
                set = function(_, value)
                    NPCColors:AddNPC(value)
                end,
                width = 0.75,
                order = 4
            },
            spacer2 = {
                type = "description",
                name = "",
                width = 0.7,
                order = 5,
            },
            search = {
                type = "input",
                name = "Search",
                desc = "Search for an NPC by name or ID",
                get = function() return NPCColors.searchQuery or "" end,
                set = function(_, value)
                    NPCColors.searchQuery = value
                    NPCColors:UpdateNPCList()
                end,
                width = 0.75,
                order = 6
            },
            spacer3 = {
                type = "description",
                name = "",
                width = "full",
                order = 7
            },
            spacer4 = {
                type = "description",
                name = "",
                width = 0.75,
                order = 8
            },
            nameHeader = {
                type = "description",
                name = "NPC Name",
                fontSize = "large",
                width = 1.5,
                order = 9
            },
            npcID = {
                type = "description",
                name = "NPC ID",
                fontSize = "large",
                width = "quarter",
                order = 10
            },
            colorHeader = {
                type = "description",
                name = "Color",
                fontSize = "large",
                width = "quarter",
                order = 11
            },
        },
    }

    function NPCColors:UpdateNPCList()
        for npcID, npcData in pairs(NPCColors.db.npccolors) do
            local show = true
            if NPCColors.searchQuery and NPCColors.searchQuery ~= "" then
                show = string.find(npcData.name:lower(), NPCColors.searchQuery:lower()) or
                    string.find(tostring(npcID), NPCColors.searchQuery)
            end

            if show then
                NPCColors.layout.args["npc" .. npcID] = {
                    type = "group",
                    inline = true,
                    name = "",
                    order = npcID * 3 + 3,
                    args = {
                        spacer = {
                            type = "description",
                            name = "",
                            width = 0.75,
                            order = 0
                        },
                        name = {
                            type = "description",
                            name = function() return "|cffffd100" .. npcData.name .. "|r" end,
                            fontSize = "medium",
                            width = 1.5,
                            order = 1
                        },
                        npcid = {
                            type = "description",
                            name = "|cffffd100" .. tostring(npcID) .. "|r",
                            fontSize = "medium",
                            width = 1,
                            order = 2
                        },
                        color = {
                            type = "color",
                            name = "",
                            hasAlpha = false,
                            get = function()
                                return npcData.color.r, npcData.color.g, npcData.color.b, 1
                            end,
                            set = function(_, r, g, b)
                                npcData.color.r = r
                                npcData.color.g = g
                                npcData.color.b = b
                            end,
                            width = 0.5,
                            order = 3
                        },
                        delete = {
                            type = "execute",
                            name = "Delete",
                            func = function()
                                NPCColors.db.npccolors[npcID] = nil
                                NPCColors.layout.args["npc" .. npcID] = nil
                                mUI:Debug("'" .. npcData.name .. "' (ID: " .. npcID .. ") has been removed.")
                            end,
                            width = 0.5,
                            order = 4
                        }
                    }
                }
            else
                NPCColors.layout.args["npc" .. npcID] = nil
            end
        end
    end

    function NPCColors:AddNPC(value)
        local npcID = tonumber(value) -- convert to number as it's necessary

        npcInfo.GetNPCInfoByID(npcID, function(npc)
                if npc.name then
                    -- Check if an entry already exists
                    if NPCColors.db.npccolors[npc.id] then
                        mUI:Debug("NPC with ID '" .. npc.id .. "' (" .. npc.name .. ") already exists.")
                        return
                    end

                    -- Insert into table and print feedback to the user
                    NPCColors.db.npccolors[npc.id] = { name = npc.name, color = { r = 0, g = 0.55, b = 1 } }
                    mUI:Debug("'" .. npc.name .. "' (ID: " .. npc.id .. ") has been added.")

                    NPCColors:UpdateNPCList()
                end
            end,
            function()
                mUI:Debug("NPC with ID '" .. npcID .. "' does not exist.")
            end)
    end

    NPCColors:UpdateNPCList()
end

function NPCColors:OnEnable()
    function NPCColors:GetOptions()
        return NPCColors.layout
    end
end
