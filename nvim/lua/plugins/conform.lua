-- Name: Conform
--
-- Docs: https://github.com/stevearc/conform.nvim
--
-- Description:
--   Conform is a Neovim plugin that provides a unified interface for code formatting,
--   allowing you to easily configure and manage multiple formatters for different file types.
--   It supports format-on-save functionality and can be extended with additional formatters
--   through its dependencies.

return {
  "stevearc/conform.nvim",
  enabled = vim.env.NVIM_PLUGIN_DISABLED_CONFORM ~= "true",
  opts = {
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
  },
}
