-- Name: Herdr Neovim Nav
--
-- Docs: https://github.com/aimdevlee/herdr-nvim-nav
--
-- Description:
--   Seamless navigation between Neovim splits and Herdr panes using Ctrl+Arrow keys.

return {
  "aimdevlee/herdr-nvim-nav",
  lazy = false,
  opts = {
    with_tmux = false,
    keymaps = {
      left = { "<C-Left>", "<C-h>" },
      down = { "<C-Down>", "<C-j>" },
      up = { "<C-Up>", "<C-k>" },
      right = { "<C-Right>", "<C-l>" },
    },
  },
  config = function(_, opts)
    require("herdr-nvim-nav").setup(opts)
  end,
}
