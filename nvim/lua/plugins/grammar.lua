-- Name: grammar.nvim (local)
--
-- Source: nvim/plugins/grammar.nvim
--
-- Description:
--   Corrects spelling and grammar of the visual selection in place via
--   `claude -p`. Keymap lives in config/keymaps.lua (<leader>ag).

return {
  dir = vim.fn.stdpath("config") .. "/plugins/grammar.nvim",
  name = "grammar.nvim",
  opts = {
    timeout_ms = 10000,
  },
}
