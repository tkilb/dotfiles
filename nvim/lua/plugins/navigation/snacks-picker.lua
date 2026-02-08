-- Name: Snacks - Picker
--
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
--
-- Description:
--  A collection of small quality-of-life improvements for Neovim.
--  This configuration specifically enables the picker module of the Snacks plugin.

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = { enabled = true },
  },
}
