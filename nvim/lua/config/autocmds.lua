-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable autoformat for keymaps.lua
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*/config/keymaps.lua",
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Make :term windows show plain CLI colors without colorscheme influence.
-- Background is made transparent so the terminal emulator's bg shows through.
-- ANSI colors are handled by gruvbox_material_disable_terminal_colors in the colorscheme config.
local function set_terminal_hl()
  vim.api.nvim_set_hl(0, "TerminalNormal", { bg = "NONE", fg = "NONE" })
end
set_terminal_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function() vim.schedule(set_terminal_hl) end,
})
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.wo.winhighlight = "Normal:TerminalNormal,NormalNC:TerminalNormal"
  end,
})
