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
	config = function()
		require("conform").setup({
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
		})
	end,
}
