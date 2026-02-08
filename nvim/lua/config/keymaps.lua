local opts = { noremap = true, silent = true }
local recursive = { remap = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local keymapset = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- OS style copy / paste
keymap("", "<leader>c", "y", opts)
keymap("", "<C-c>", "y", opts)
keymap("", "<C-v>", "p", opts)

--------------------------------------------------
-- Normal --
--------------------------------------------------
keymapset("n", "<leader>fp", ':let @+ = expand("%:p")<cr>', { desc = "Copy filepath" })
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<leader>/", "viwo<Esc>yw/<C-r><C-w><cr>N", opts)
keymap("n", "<leader><Space>", "<C-w><C-w>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<cr>", opts)
keymap("n", "<C-Down>", ":resize +2<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<cr>", opts)

-- Navigate buffers
keymap("n", "<C-l>", ":bnext<cr>", opts)
keymap("n", "<C-h>", ":bprevious<cr>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<cr>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<cr>==gi", opts)

-- Toggle relative lines
keymap("n", "<leader>r", "<cmd>set nonumber! norelativenumber!<cr>", opts)

--------------------------------------------------
-- Visual --
--------------------------------------------------

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<cr>==", opts)
keymap("v", "<A-k>", ":m .-2<cr>==", opts)
keymap("v", "p", '"_dP', opts)

--------------------------------------------------
-- Visual Block --
--------------------------------------------------

-- Move text up and down
keymap("x", "J", ":move '>+1<cr>gv-gv", opts)
keymap("x", "K", ":move '<-2<cr>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<cr>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<cr>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>

--------------------------------------------------
-- Plugins
--------------------------------------------------
-- Multi Plugin Dismisser
keymap(
  "n",
  "<leader><esc>",
  ""                                                      --
  .. "<cmd>Trouble close<cr>"                             --
  .. "<cmd>lua require'goto-preview'.close_all_win()<cr>" --
  .. "<cmd>DiffviewClose<cr>"                             --
  .. "<cmd>NoiceDismiss<cr>"                              --
  .. "<cmd>noh<cr>"                                       --
  .. "",
  opts
)

-- BarBar
keymap("n", "<leader><cr>", "<cmd>BufferPick<cr>", opts)
keymap("n", "<leader>d", "<cmd>BufferPickDelete<cr>", opts)
keymap("n", "<leader>dd", "<cmd>BufferPickDelete!<cr>", opts)
keymap("n", "<leader>do", "<cmd>BufferCloseAllButCurrent<cr>", opts)
keymap("n", "<leader>]", "<cmd>BufferNext<cr>", opts)
keymap("n", "<leader>[", "<cmd>BufferPrev<cr>", opts)
keymap("n", "<leader>q", "<cmd>bd<cr>", opts)

-- Code Companion
keymap("n", "<leader>ac", "<cmd>CopilotToggle<cr>", opts)

-- FZF
keymap("n", "<leader>gs", "<cmd>lua require('fzf-lua').git_status()<cr>", { noremap = true, silent = true })
keymap("n", "<leader>gh", "<cmd>lua require('fzf-lua').git_bcommits()<cr>", { noremap = true, silent = true })

-- Git Signs
keymap("n", "gh", "<cmd>Gitsigns preview_hunk<cr>", opts)

-- Goto
keymap("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opts)

-- Harpoon
keymap("n", "<F12>", "<cmd>lua require'harpoon.mark'.add_file()<cr>", opts)
keymap("n", "<F10>", "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<cr>", opts)

keymap("n", "<F4>", "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>", opts)
keymap("n", "<F5>", "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>", opts)
keymap("n", "<F6>", "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>", opts)
keymap("n", "<F7>", "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>", opts)
keymap("n", "<F8>", "<cmd>lua require'harpoon.ui'.nav_file(5)<cr>", opts)
keymap("n", "<F9>", "<cmd>lua require'harpoon.ui'.nav_file(6)<cr>", opts)

-- Hop
keymap("n", "<leader>w", "<cmd>HopCamelCase<cr>", opts)

-- LSP
keymap("i", "<C-Space>", "<C-x><C-o>", opts)
keymap("n", "<C-Space>", "", opts)

-- Neogit
keymap("n", "<leader>g", "<cmd>Neogit<cr>", opts)
keymap("n", "<leader>gg", "<cmd>Neogit<cr>", opts)

-- Obsidian
keymap("n", "<leader>bb", "<cmd>silent! Obsidian workspace ebrain-nvim<cr><cmd>Obsidian quick_switch<cr>", opts)
keymap("n", "<leader>bp", "<cmd>silent! Obsidian workspace ebrain-personal<cr><cmd>Obsidian quick_switch<cr>", opts)
keymap("n", "<leader>bt", "<cmd>silent! Obsidian workspace ebrain-tech<cr><cmd>Obsidian quick_switch<cr>", opts)
keymap("n", "<leader>bw", "<cmd>Oil ~/ebrain/work/<cr>", opts)
keymap("n", "<leader>bs", "<cmd>e ~/ebrain/work/_/Scrap.md<cr>", opts)
keymap("n", "<leader>bk", "<cmd>e ~/ebrain/work/Kanban.md<cr>", opts)

-- Oil
keymap("n", "-", "<cmd>Oil<cr>", opts)

-- Origami
keymap("n", "<leader>^", "^<cmd>lua require'origami'.h()<cr>", opts)

-- Neotree
keymap("n", "<leader>+", "<cmd>Neotree float<cr>", opts)
keymap("n", "<M-C-S-e>", "<cmd>Neotree float git_status<cr>", opts)

-- Sidekick keymaps
keymap("i", "<C-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("n", "<C-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("t", "<C-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("x", "<C-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("i", "<A-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("n", "<A-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("t", "<A-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("x", "<A-.>", "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>", opts)
keymap("n", "<leader>ad", "<cmd>lua require('sidekick.cli').close()<cr>", opts)
keymap("n", "<leader>af", "<cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{file}' })<cr>", opts)
keymap("n", "<leader>an", "<cmd>SidekickNesToggle<cr>", opts)
keymap("n", "<leader>al", "<cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{line}' })<cr>", opts)
keymap("x", "<leader>al", "<cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{line}' })<cr>", opts)
keymap("n", "<leader>ap", "<cmd>lua require('sidekick.cli').prompt()<cr>", opts)
keymap("x", "<leader>ap", "<cmd>lua require('sidekick.cli').prompt()<cr>", opts)
keymap("n", "<leader>as", "<cmd>lua require('sidekick.cli').select()<cr>", opts)
keymap("n", "<leader>at", "<cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{this}' })<cr>", opts)
keymap("x", "<leader>at", "<cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{this}' })<cr>", opts)
keymap("x", "<leader>av", "<cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{selection}' })<cr>", opts)

-- Snacks - Dashboard
keymap("n", "<leader>$", "<cmd>Dashboard<cr>", opts)

-- Snacks - Explorer
keymap("n", "<leader>?", "<cmd>Keymaps<cr>", opts)

-- Snacks - Picker
keymap("n", "<leader>f", "<cmd>lua require'snacks.picker'.files()<cr>", opts)
keymap("n", "<leader>ff", "<cmd>lua require'snacks.picker'.files()<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require'snacks.picker'.grep()<cr>", opts)
keymap("n", "<leader>fr", "<cmd>lua require'snacks.picker'.recent()<cr>", opts)

-- Test Vim
keymap("n", "<leader>s", ":TestNearest<cr>", opts)
keymap("n", "<leader>S", ":TestFile<cr>", opts)
keymap("n", "<leader>Sa", ":TestSuite<cr>", opts)

-- Trouble
keymap("n", "gt", "<cmd>Trouble toggle<cr>", opts)
keymap("n", "<leader>.", "<cmd>Trouble diagnostics focus=true<cr>", opts)
keymap("n", "gi", "<cmd>Trouble lsp_implementations focus=true<cr>", opts)
keymap("n", "gd", "<cmd>Trouble lsp_declarations focus=true<cr>", opts)
keymap("n", "gdd", "<cmd>Trouble lsp_definitions focus=true<cr>", opts)
keymap("n", "gs", "<cmd>Trouble lsp_document_symbols focus=true<cr>", opts)
keymap("n", "gr", "<cmd>Trouble lsp_references focus=true<cr>", opts)
keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
keymap("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

-- Toggle Terminal
keymap("n", "<C-j>", "<cmd>ToggleTerm<cr>", opts)
keymap("i", "<C-j>", "<cmd>ToggleTerm<cr>", opts)

-- UndoTree
keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

-- Which Key
-- keymap("n", "<leader>?", "<cmd>WhichKey<cr>", opts)
