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
