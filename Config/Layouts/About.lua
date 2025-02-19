local About = mUI:NewModule("mUI.Config.Layouts.About")

function About:OnEnable()
    local layout = {
        type = "group",
        args = {
            header = {
                name = "About",
                type = "header",
                order = 1
            },
            description = {
                name =
                "Thank you for using muleyoUI!\n\nIf you have any questions, suggestions, or issues, please visit the GitHub page or join the Discord Server.",
                type = "description",
                fontSize = "medium",
                order = 2
            },
            twitchbutton = {
                name = "Twitch",
                type = "execute",
                order = 3,
                func = function()
                    mUI:Link("https://www.twitch.tv/muleyo")
                end
            },
            discordbutton = {
                name = "Discord",
                type = "execute",
                order = 4,
                func = function()
                    mUI:Link("https://discord.gg/ddY4kjhPwq")
                end
            },
            githubbutton = {
                name = "GitHub",
                type = "execute",
                order = 5,
                func = function()
                    mUI:Link("https://github.com/muleyo/muleyoUI")
                end
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
