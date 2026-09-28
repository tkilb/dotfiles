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
          -- LazyVim's own defaults (lazyvim/plugins/util.lua) bind these as
          -- buffer-local Terminal-mode keys doing a plain `wincmd`, with no
          -- awareness of herdr panes beyond Neovim's own splits. Buffer-local
          -- keymaps always beat the global Terminal-mode ones in
          -- config/keymaps.lua, so override them here (by the same key
          -- names, which LazyVim's opts-merging replaces) with the
          -- herdr-aware version shared with config/keymaps.lua.
          nav_h = {
            "<C-h>",
            function(self)
              if self:is_floating() then
                return "<c-h>"
              end
              require("util.herdr_nav").terminal_nav("h")
            end,
            desc = "Go to Left Window",
            expr = true,
            mode = "t",
          },
          nav_j = {
            "<C-j>",
            function(self)
              if self:is_floating() then
                return "<c-j>"
              end
              require("util.herdr_nav").terminal_nav("j")
            end,
            desc = "Go to Lower Window",
            expr = true,
            mode = "t",
          },
          nav_k = {
            "<C-k>",
            function(self)
              if self:is_floating() then
                return "<c-k>"
              end
              require("util.herdr_nav").terminal_nav("k")
            end,
            desc = "Go to Upper Window",
            expr = true,
            mode = "t",
          },
          nav_l = {
            "<C-l>",
            function(self)
              if self:is_floating() then
                return "<c-l>"
              end
              require("util.herdr_nav").terminal_nav("l")
            end,
            desc = "Go to Right Window",
            expr = true,
            mode = "t",
          },
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
