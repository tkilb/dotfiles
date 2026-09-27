local del = vim.keymap.del
local map = LazyVim.safe_keymap_set
local wkey = require("which-key").add

--------------------------------------------------
-- Unregistered
--------------------------------------------------
del("n", "<leader>`")
del("n", "<leader>K")

-- remove default substitute
map({ "n", "x" }, "s", "<Nop>")
map({ "n", "x" }, "S", "<Nop>")

--------------------------------------------------
-- General
--------------------------------------------------
-- OS style copy / paste
map("", "<C-c>", "y")
map("", "<C-v>", "p")

-- Treat :W as :w (typo-tolerant save)
vim.api.nvim_create_user_command("W", "w", { bang = true, desc = "Save (alias of :w)" })

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
  { "<leader>ni", "<cmd>Oil ~/Notes/work/0.Inbox/<cr>", icon = "󰠮 ", desc = "Inbox", mode = "n" },
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
  { "<leader>na", icon = "󰚩 ", group = "Note Agents" },
  { "<leader>nak", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").kanban_update()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Update Kanban", mode = "n" },
  { "<leader>nas", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").shareout()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Shareout", mode = "n" },
  { "<leader>nao", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").ingest_and_organize()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Organize Notes", mode = "n" },
  { "<leader>nat", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").meeting_ingest()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Transcript Ingest", mode = "n" },
  { "<leader>nan", function()
      local sidekick = require("sidekick.cli")
      sidekick.toggle({ name = "copilot", focus = true })
      local msg = require("agents").ingest_note()
      vim.defer_fn(function() sidekick.send({ msg = msg }) end, 500)
    end, icon = "󰚩 ", desc = "Ingest Note", mode = "n" },
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
-- Toggle Last Window (see config/window_toggle.lua for details on why this
-- doesn't just use `wincmd p`)
local window_toggle = require("config.window_toggle")
window_toggle.setup()
wkey({ "<leader><space>", window_toggle.toggle, icon = "󰏧 ", desc = "Toggle Last Window", mode = "n" })

--------------------------------------------------
-- Plugins
--------------------------------------------------
-- Code Companion
wkey({ "<leader>ac", "<cmd>CopilotToggle<cr>", icon = "󰨙 ", desc = "Toggle Predictions", mode = "n" })

--- Flash
wkey({
  { "f", "<cmd>lua require('flash').jump()<cr>", desc = "Flash Jump", mode = "n" },
  { "F", "<cmd>lua require('flash').treesitter()<cr>", desc = "Flash Treesitter", mode = "n" },
})

-- Word Motion
wkey({
  { "B", "<Plug>WordMotion_b", desc = "Camel Word Forward", mode = { "n", "x", "o" } },
  { "E", "<Plug>WordMotion_e", desc = "Camel Word Forward", mode = { "n", "x", "o" } },
  { "W", "<Plug>WordMotion_w", desc = "Camel Word Forward", mode = { "n", "x", "o" } },
})

-- Returns the last file buffer's directory (or cwd as fallback), oil-aware
local function file_cwd()
  if vim.bo.filetype == "oil" then
    return (vim.fn.expand("%:p"):gsub("^oil://", ""))
  end
  if vim.bo.buftype == "" and vim.fn.expand("%:p") ~= "" then
    return vim.fn.expand("%:p:h")
  end
  return vim.g.last_file_dir or vim.fn.getcwd()
end

-- Git Signs
wkey({ "<leader>ub", "<cmd>Gitsigns toggle_current_line_blame<cr>", icon = "󰊢 ", desc = "Toggle Blame", mode = "n" })

-- LazyGit (flipped behavior)
wkey({
  { "<leader>gg", function() Snacks.lazygit.open({ cwd = file_cwd() }) end, icon = " ", desc = "Lazygit (Root Dir)", mode = "n" },
  { "<leader>gG", function() Snacks.lazygit.open() end, icon = " ", desc = "Lazygit (cwd)", mode = "n" },
})

-- Goto
wkey({ "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", icon = " ", desc = "Preview Definition", mode = "n" })

-- Oil
map("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })

-- Helper to safely close Snacks.zen/zoom overlay before layout changes
local function close_zen()
  if Snacks.zen and Snacks.zen.win then
    pcall(function()
      if Snacks.zen.win:valid() then
        Snacks.zen.win:close()
      end
    end)
    Snacks.zen.win = nil
  end
end

-- Helper to check if any window currently displays Sidekick
local function is_sidekick_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "sidekick_terminal" then
        return true
      end
    end
  end
  return false
end

-- Sidekick
local function toggle_sidekick()
  local was_sidekick = is_sidekick_visible()
  close_zen()

  if was_sidekick then
    require("sidekick.cli").hide({ all = true })
  else
    vim.cmd("lcd " .. vim.fn.fnameescape(file_cwd()))
    local t = Snacks.terminal.get(nil, { create = false })
    if t then t:hide() end
    require("sidekick.cli").toggle({ focus = true })
  end
end

map({ "i", "n", "t", "x" }, "<C-.>", toggle_sidekick, { desc = "Toggle Sidekick" })
map({ "i", "n", "t", "x" }, "<A-.>", toggle_sidekick, { desc = "Toggle Sidekick" })

wkey({
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
local function toggle_terminal()
  -- If currently zoomed in Zen mode, unzoom and dismiss terminal cleanly
  if Snacks.zen and Snacks.zen.win and Snacks.zen.win:valid() then
    Snacks.zen.zoom()
    vim.schedule(function()
      for _, t in ipairs(Snacks.terminal.list()) do
        if t:valid() then
          t:hide()
        end
      end
      local t = Snacks.terminal.get(nil, { create = false })
      if t and t:valid() then
        t:hide()
      end
    end)
    return
  end

  require("sidekick.cli").hide({ all = true })
  Snacks.terminal.toggle()
end

-- Override LazyVim's default <C-/> behavior to properly toggle terminal
del({ "n", "t" }, "<C-/>")
del({ "n", "t" }, "<C-_>") -- In terminal emulators, Ctrl+/ often sends Ctrl+_
map({ "n", "t", "i" }, "<C-/>", toggle_terminal, { desc = "Toggle Terminal" })
map({ "n", "t" }, "<C-,>", function()
  Snacks.zen.zoom()
end, { desc = "Toggle Terminal Zoom" })

-- Misc
map("n", "<leader>/", "viwo<Esc>yw/<C-r><C-w><cr>N")

-- Herdr Navigation (override LazyVim default Ctrl+Arrow resize and Ctrl+hjkl window navigation)
pcall(function()
  require("herdr-nvim-nav").setup({
    with_tmux = false,
    keymaps = {
      left = { "<C-Left>", "<C-h>" },
      down = { "<C-Down>", "<C-j>" },
      up = { "<C-Up>", "<C-k>" },
      right = { "<C-Right>", "<C-l>" },
    },
  })
end)

-- Obsidian checkbox toggle (Kitty full keyboard protocol required)
map("n", "<S-Space>", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Checkbox Toggle" })
