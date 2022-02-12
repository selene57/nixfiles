 require('neorg').setup {
        -- Tell Neorg what modules to load
        load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.gtd.base"] = {
                        config = {
                        -- workspace =   "example_gtd" , -- assign the workspace,
                                workspace = "home",
                                exclude = { "notes/" }, -- Optional: all excluded files from the workspace are not part of the gtd workflow
                                projects = {
                                        show_completed_projects = false,
                                        show_projects_without_tasks = false,
                                },
                        custom_tag_completion = true,
                        },
                },
                ["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
                ["core.norg.concealer"] = { -- Allows for use of icons
                        config = {
                                icon_preset = "diamond",
                                markup_preset = "dimmed",
                        },
                },
                ["core.norg.qol.toc"] = {}, -- Generate automatic table of contents
                ["core.keybinds"] = { -- Allows configuring of keybinds
                        config = {
                                default_keybinds = true, -- generate default keybinds
                                neorg_leader = "<LocalLeader>"
                        },
                },
                ["core.norg.dirman"] = { -- Manage your directories with Neorg
                        config = {
                                workspaces = {
                                        home = "~/neorg",
                                        notes = "~/neorg/notes"
                                },
                                index = "index.norg"
                        }
                }
        },
}

local neorg_callbacks = require("neorg.callbacks")

local neorg = require('neorg')
local function load_completion()
neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp" -- Choose your completion engine here
})
end

-- If Neorg is loaded already then don't hesitate and load the completion
if neorg.is_loaded() then
        load_completion()
else -- Otherwise wait until Neorg gets started and load the completion module then
        neorg.callbacks.on_event("core.started", load_completion)
end
