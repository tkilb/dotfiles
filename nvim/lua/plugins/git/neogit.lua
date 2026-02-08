-- Name: Neogit
--
-- Docs: https://github.com/NeogitOrg/neogit
--
-- Description:
--   A Magit-inspired Git plugin for Neovim

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "folke/snacks.nvim",    -- optional
  },
}
