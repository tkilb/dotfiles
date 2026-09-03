-- Name: GitSigns
--
-- Docs: https://github.com/lewis6991/gitsigns.nvim
--
-- Description:
--   Adds git related signs to the gutter, as well as utilities for managing change

return {
  "lewis6991/gitsigns.nvim",
  ---- @type Gitsigns.Config
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    preview_config = {
      -- Options passed to nvim_open_win
      border = "rounded",
    },
  },
  config = function()
    require("gitsigns").setup()
  end,
}
