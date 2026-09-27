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
  keys = {
    -- <leader>sr freed up by disabling grug-far's default trigger
    -- (see plugins/grug-far.lua)
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
  },
  ---@type snacks.Config
  opts = {
    terminal = {
      win = {
        keys = {
          hide_slash = false, -- Handled globally in config/keymaps.lua to support fullscreen Zen escape
          hide_underscore = false,
        },
      },
    },
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
