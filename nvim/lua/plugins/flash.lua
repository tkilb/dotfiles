-- Name: Flash
--
-- Docs: https://github.com/folke/flash.nvim
--
-- Description:
--   flash.nvim lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.

return {
  {
    "folke/flash.nvim",
    -- Disable the <C-Space> keymap that LazyVim sets by default
    keys = {
      -- Override LazyVim's default <C-Space> mapping by disabling it
      { "<c-space>", mode = { "n", "o", "x" }, false },
      -- Disable LazyVim's default `s`/`S` mappings (freed for vim-sandwich).
      -- These must be disabled here, not just del()'d in keymaps.lua: lazy.nvim
      -- (re)applies a plugin's declared `keys` mappings after user config runs,
      -- which would otherwise clobber our sandwich keymap/del() every time.
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
    },
    opts = {
      modes = {
        char = {
          enabled = true,
        },
        search = {
          enabled = false,
        },
      },
    },
  },
}
