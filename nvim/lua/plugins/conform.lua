-- Name: Conform
--
-- Docs: https://github.com/stevearc/conform.nvim
--
-- Description:
--   Conform is a Neovim plugin that provides a unified interface for code formatting,
--   allowing you to easily configure and manage multiple formatters for different file types.
--   It supports format-on-save functionality and can be extended with additional formatters
--   through its dependencies.
local M = {}
return {
  "stevearc/conform.nvim",
  enabled = vim.env.NVIM_PLUGIN_DISABLED_CONFORM ~= "true",
  opts = function()
    local plugin = require("lazy.core.config").plugins["conform.nvim"]
    if plugin.config ~= M.setup then
      LazyVim.error({
        "Don't set `plugin.config` for `conform.nvim`.\n",
        "This will break **LazyVim** formatting.\n",
        "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
      }, { title = "LazyVim" })
    end
    ---@type conform.setupOpts
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        prettier = {
          -- require_cwd = true: Only run this formatter if a config file is found
          -- in the current working directory or its ancestors.
          require_cwd = true,
          -- cwd: Defines the root files to look for to set the project root.
          cwd = require("conform.util").root_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            "prettier.config.js",
            "package.json", -- Prettier config can also be in package.json
          }),
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        tsx = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
    }
    return opts
  end,
}
