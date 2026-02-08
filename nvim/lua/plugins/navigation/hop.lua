-- Name: Harpoon
--
-- Docs: https://github.com/ThePrimeagen/harpoon
--
-- Description:
--   A Lua plugin for Neovim that provides file bookmarks.

return {
  "smoka7/hop.nvim",
  version = "*",
  opts = {
    keys = "abcdefghijklmnopqrstuvwxyz",
    x_bias = 20,
  },
}
