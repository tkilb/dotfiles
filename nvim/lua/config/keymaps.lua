local del = vim.keymap.del
local map = LazyVim.safe_keymap_set
local wkey = require("which-key").add

--------------------------------------------------
-- Unregistered
--------------------------------------------------
del("n", "<leader>`")
del("n", "<leader>K")

--------------------------------------------------
-- General
--------------------------------------------------
-- OS style copy / paste
map("", "<C-c>", "y")
map("", "<C-v>", "p")

-- Buffers
wkey({
  { "<leader>]", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer", mode = "n", hidden = true },
  { "<leader>[", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer", mode = "n", hidden = true },
  { "<leader>)", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Right", mode = "n", hidden = true },
  { "<leader>(", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Left", mode = "n", hidden = true },
})

-- Search (Override LazyVim defaults, uses classic Vim)
wkey({ "n", "n", desc = "Next Search Result", mode = "n", hidden = true })
wkey({ "N", "N", desc = "Prev Search Result", mode = "n", hidden = true })

-- Multi Dismiss
map(
  "n",
  "<leader><esc>",
  ""                                                      --
  .. "<cmd>Trouble close<cr>"                             --
  .. "<cmd>DiffviewClose<cr>"                             --
  .. "<cmd>NoiceDismiss<cr>"                              --
  .. "<cmd>noh<cr>"                                       --
  .. "<cmd>lua require'goto-preview'.close_all_win()<cr>" --
  .. "<Right><Left>" --
  .. "",
  { desc = "Dismiss All", hidden = true }
)

-- Find / Files
wkey({ "<leader>fp", ":let @+ = expand('%:p')<cr>", icon=" ", desc = "Copy Filepath" })
wkey({ "<leader>fP", function() Snacks.picker.projects() end, icon=" ", desc = "Projects" })

-- Lazy
del("n", "<leader>l")
del("n", "<leader>L")
wkey({
  { "<leader>l", icon = "󰒲 ", group = "lazy" },
  { "<leader>lc", function() LazyVim.news.changelog() end, icon = "󰒲 ", desc = "Changelog", mode = "n" },
  { "<leader>ll", "<cmd>Lazy<cr>", icon = "󰒲 ", desc = "Lazy", mode = "n" },
  { "<leader>ls", "<cmd>Lazy sync<cr>", icon = "󰒲 ", desc = "Sync", mode = "n" },
  { "<leader>lu", "<cmd>Lazy update<cr>", icon = "󰒲 ", desc = "Update", mode = "n" },
})

-- Notes
del("n", "<leader>n")
wkey({
  { "<leader>n", icon = "󰠮 ", group = "notes" },
  { "<leader>nk", "<cmd>e ~/Notes/work/_Kanban.md<cr>", icon = "󰠮 ", desc = "Kanban", mode = "n" },
  { "<leader>no", "<cmd>e ~/Notes/work/_One On One.md<cr>", icon = "󰠮 ", desc = "One on One", mode = "n" },
  { "<leader>nh", "<cmd>e ~/Notes/work/_History.md<cr>", icon = "󰠮 ", desc = "History", mode = "n" },
  { "<leader>np", "<cmd>Oil ~/Notes/personal/<cr>", icon = "󰠮 ", desc = "Personal", mode = "n" },
  { "<leader>nr", "<cmd>e ~/Notes/work/_Receipts.md<cr>", icon = "󰠮 ", desc = "Receipts", mode = "n" },
  { "<leader>ns", "<cmd>e ~/Notes/work/_Scrap.md<cr>", icon = "󰠮 ", desc = "Scrap", mode = "n" },
  { "<leader>nt", "<cmd>Oil ~/Notes/tech/<cr>", icon = "󰠮 ", desc = "Tech", mode = "n" },
  { "<leader>nv", "<cmd>Oil ~/Notes/nvim/<cr>", icon = "󰠮 ", desc = "Vim", mode = "n" },
  { "<leader>nw", "<cmd>Oil ~/Notes/work/<cr>", icon = "󰠮 ", desc = "Work", mode = "n" },
})

-- Notifications
wkey({
  { "<leader>N", function() Snacks.picker.notifications() end, desc = "Notifications", mode = "n" },
})

-- Relative Line Numbers
wkey({"<leader>r", "<cmd>set nonumber! norelativenumber!<cr>", desc = "Toggle Relative Line Numbers", mode = "n", hidden = true})

-- Windows
del("n", "<leader>-")
wkey({ "<leader>=", "<cmd>sp<cr>", icon = "", desc = "Split Window Down", mode = "n"})
wkey({ "<leader><space>", "<C-w><C-w>", icon = "󰮗 ", desc = "Toggle Last Window", mode = "n" })

--------------------------------------------------
-- Plugins
--------------------------------------------------
-- Code Companion
wkey({ "<leader>ac", "<cmd>CopilotToggle<cr>", icon = "󰨙 ", desc = "Toggle Predictions", mode = "n" })

-- Flash
del("n", "s")
del("n", "S")
wkey({
  { "f", "<cmd>lua require('flash').jump()<cr>", desc = "Flash Jump", mode = "n" },
  { "F", "<cmd>lua require('flash').treesitter()<cr>", desc = "Flash Treesitter", mode = "n" },
})

-- Git Signs
wkey({ "<leader>ub", "<cmd>Gitsigns toggle_current_line_blame<cr>", icon = "󰊢 ", desc = "Toggle Blame", mode = "n" })

-- Goto
wkey({ "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", icon = " ", desc = "Preview Definition", mode = "n" })

-- NeoGit
map("n", "<leader>gg", "<cmd>Neogit<cr>")

-- Oil
map("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })

-- Sidekick
wkey({
  { "<C-.>", "<cmd>lua require('sidekick.cli').toggle({ focus = true })<cr>", desc = "Toggle Sidekick", mode = { "i", "n", "t", "x" }, hidden = true },
  { "<A-.>", "<cmd>lua require('sidekick.cli').toggle({ focus = true })<cr>", desc = "Toggle Sidekick", mode = { "i", "n", "t", "x" }, hidden = true },
  { "<leader>a", icon = "󰚩 ", group = "ai" },
  { "<leader>ad", "<cmd>lua require('sidekick.cli').close()<cr>", icon = "󰚩 ", desc = "Close", mode = "n" },
  { "<leader>af", "<cmd>lua require('sidekick.cli').send({ msg = '{file}' })<cr>", icon = "󰚩 ", desc = "Send File", mode = "n" },
  { "<leader>an", "<cmd>SidekickNesToggle<cr>", icon = "󰚩 ", desc = "Toggle Nes", mode = "n" },
  { "<leader>al", "<cmd>lua require('sidekick.cli').send({ msg = '{line}' })<cr>", icon = "󰚩 ", desc = "Send Line", mode = { "n", "x" } },
  { "<leader>ap", "<cmd>lua require('sidekick.cli').prompt()<cr>", icon = "󰚩 ", desc = "Prompts", mode = { "n", "x" } },
  { "<leader>as", "<cmd>lua require('sidekick.cli').select()<cr>", icon = "󰚩 ", desc = "Select", mode = "n" },
  { "<leader>at", "<cmd>lua require('sidekick.cli').send({ msg = '{this}' })<cr>", icon = "󰚩 ", desc = "Send This", mode = { "n", "x" } },
  { "<leader>av", "<cmd>lua require('sidekick.cli').send({ msg = '{selection}' })<cr>", icon = "󰚩 ", desc = "Send Selection", mode = "x" },
})

-- Snacks Dashboard
wkey({
  { "<leader>$", "<cmd>Dashboard<cr>", icon="", desc = "Dashboard", mode = "n" },
})

-- UndoTree
wkey({
  { "U", "<cmd>UndotreeToggle<cr>", icon="", desc = "UndoTree", mode = "n" },
})

-- Misc
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>/", "viwo<Esc>yw/<C-r><C-w><cr>N")
