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
