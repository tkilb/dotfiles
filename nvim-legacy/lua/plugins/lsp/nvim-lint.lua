-- Name: Nvim-lint 
--
-- Docs: https://github.com/mfussenegger/nvim-lint
--
-- Description:
--   Nvim-lint is a Neovim plugin that provides linting capabilities for various programming languages.
--   It allows you to configure linters for different file types and integrates with Neovim's built-in
--   LSP client to display linting diagnostics directly in the editor.

return {
  "mfussenegger/nvim-lint",
  enabled = vim.env.NVIM_PLUGIN_DISABLED_NVM_LINT ~= "true",
  config = function()
    require("lint").linters_by_ft = {
      sh = { "shellcheck" },
      terraform = { "tflint" },
      python = { "ruff" },
    }
  end,
}
