-- Name: Snacks - Picker
--
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
--
-- Description:
--   A collection of small quality-of-life improvements for Neovim.
--   This configuration specifically enables the picker module of the Snacks plugin.

return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      hidden = true,
      ignored = false,
      exclude = { "package-lock.json", ".github" },
      sources = {
        explorer = {
          layout = { preview = "main" },
        },
        marks = {
          -- Filter to show only manual marks (a-z, A-Z)
          transform = function(item)
            return item.label:match("%a") ~= nil
          end,
        },
      },
    },
  },
}
