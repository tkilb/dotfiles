-- Name: Snacks - Main
--
-- Docs: https://github.com/folke/snacks.nvim
--
-- Description:
--   A collection of small quality-of-life improvements for Neovim.

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- indent = { enabled = true }, -- Disabled due to conflict with another plugin, needs investigation
    -- input = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    vim.api.nvim_create_user_command("Dashboard", function()
      require("snacks").dashboard.open()
    end, {})

    -- Command to open keymap picker
    vim.api.nvim_create_user_command("Keymaps", function()
      require("snacks").picker.keymaps()
    end, { desc = "Open keymap picker" })
  end,
}
