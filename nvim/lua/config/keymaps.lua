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
  { "<leader>n", icon = "󰠮", group = "notes" },
  { "<leader>n/", "<cmd>Obsidian search<cr>", icon = "󰠮", desc = "Grep", mode = "n" },
  { "<leader>n?", "<cmd>Obsidian helpgrep<cr>", icon = "󰠮", desc = "Help Grep", mode = "n" },
  { "<leader>nD", "<cmd>Obsidian tomorrow<cr>", icon = "󰠮", desc = "Tomorrow's Daily", mode = "n" },
  { "<leader>nH", "<cmd>Obsidian help<cr>", icon = "󰠮", desc = "Help", mode = "n" },
  { "<leader>nT", "<cmd>Obsidian tags<cr>", icon = "󰠮", desc = "Tags", mode = "n" },
  { "<leader>nd", "<cmd>Obsidian today<cr>", icon = "󰠮", desc = "Today's Daily", mode = "n" },
  { "<leader>nf", "<cmd>Obsidian quick_switch<cr>", icon = "󰠮", desc = "File Quick Switch", mode = "n" },
  { "<leader>nk", "<cmd>e ~/Notes/work/0.Kanban.md<cr>", icon = "󰠮", desc = "Kanban", mode = "n" },
  { "<leader>nl", "<cmd>Obsidian follow_link<cr>", icon = "󰠮", desc = "Link Follow", mode = "n" },
  { "<leader>nt", "<cmd>Obsidian template<cr>", icon = "󰠮", desc = "Template", mode = "n" },
  { "<leader>nw", "<cmd>Obsidian workspace<cr>", icon = "󰠮", desc = "Workspace Switch", mode = "n" },
  { "<leader>ny", "<cmd>Obsidian yesterday<cr>", icon = "󰠮", desc = "Yesterday's Daily", mode = "n" },
  {
    { "<leader>nn", icon = "󰠮", group = "note vaults" },
    { "<leader>nnt", "<cmd>Oil ~/Notes/tech/<cr>", icon = "󰠮 ", desc = "Tech", mode = "n" },
    { "<leader>nnv", "<cmd>Oil ~/Notes/nvim/<cr>", icon = "󰠮 ", desc = "Vim", mode = "n" },
    { "<leader>nnw", "<cmd>Oil ~/Notes/work/<cr>", icon = "󰠮 ", desc = "Work", mode = "n" },
  },
  -- Notes AI agents (via sidekick.nvim + Copilot CLI)
  { "<leader>nK", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").kanban_update()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Update Kanban", mode = "n" },
  { "<leader>ns", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").shareout()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Shareout", mode = "n" },
  { "<leader>no", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").ingest_and_organize()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Organize Notes", mode = "n" },
})

-- Notes (non-group)
wkey({
  { "<leader>dd", "<cmd>Obsidian toggle_checkbox<cr>", icon = "", desc = "Todo Toggle", mode = "n" },
})



-- Notifications
wkey({
  { "<leader>N", function() Snacks.picker.notifications() end, desc = "Notifications", mode = "n" },
})

-- Relative Line Numbers
wkey({"<leader>r", "<cmd>set nonumber! norelativenumber!<cr>", desc = "Toggle Relative Line Numbers", mode = "n", hidden = true})

-- Restore Last Session
wkey({"<leader>qr", "<cmd>lua require('persistence').load({ last = true })<cr>", desc = "Restore Last Session", mode = "n" })

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

-- LazyGit (flipped behavior)
-- wkey({
--   { "<leader>gg", function() Snacks.lazygit.open({ cwd = vim.fn.getcwd() }) end, icon = " ", desc = "Lazygit (cwd)", mode = "n" },
--   { "<leader>gG", function() Snacks.lazygit.open() end, icon = " ", desc = "Lazygit (Root Dir)", mode = "n" },
-- })

-- Goto
wkey({ "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", icon = " ", desc = "Preview Definition", mode = "n" })

-- Oil
map("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })

-- Sidekick
wkey({
  { "<C-.>", "<cmd>lua require('sidekick.cli').toggle({ focus = true })<cr>", desc = "Toggle Sidekick", mode = { "i", "n", "t", "x" }, hidden = true },
  { "<A-.>", "<cmd>lua require('sidekick.cli').toggle({ focus = true })<cr>", desc = "Toggle Sidekick", mode = { "i", "n", "t", "x" }, hidden = true },
  { "<leader>a", icon = "󰚩 ", group = "ai" },
  { "<leader>ad", "<cmd>lua require('sidekick.cli').close()<cr>", icon = "󰚩 ", desc = "Detatch", mode = "n" },
  { "<leader>af", "<cmd>lua require('sidekick.cli').send({ msg = '{file}' })<cr>", icon = "󰚩 ", desc = "Send File", mode = "n" },
  { "<leader>al", "<cmd>lua require('sidekick.cli').send({ msg = '{line}' })<cr>", icon = "󰚩 ", desc = "Send Line", mode = { "n", "x" } },
  { "<leader>an", "<cmd>SidekickNesToggle<cr>", icon = "󰨙 ", desc = "Toggle NES", mode = "n" },
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

-- Terminal
-- Override LazyVim's default <C-/> behavior to properly toggle terminal
del({ "n", "t" }, "<C-/>")
del({ "n", "t" }, "<C-_>") -- In terminal emulators, Ctrl+/ often sends Ctrl+_
map({ "n", "t" }, "<C-/>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
map({ "n", "t" }, "<C-_>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })

-- Misc
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>/", "viwo<Esc>yw/<C-r><C-w><cr>N")

-- Obsidian checkbox toggle (Kitty full keyboard protocol required)
map("n", "<S-Space>", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Checkbox Toggle" })
