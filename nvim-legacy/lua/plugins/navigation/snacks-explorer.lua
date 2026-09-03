-- Name: Snacks - Explorer
--
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
--
-- Description:
--  A collection of small quality-of-life improvements for Neovim.
--  This configuration specifically enables the explorer module of the Snacks plugin.

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    explorer = { enabled = true },
  },
}
