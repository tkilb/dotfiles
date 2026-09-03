-- Name: Typescript Tools
--
-- Docs: https://github.com/pmizio/typescript-tools.nvim
--
-- Description:
--   A Neovim plugin that provides enhanced TypeScript development features,
--   including automatic imports, code actions, and refactoring tools,
--   leveraging the TypeScript Language Server (tsserver) for improved productivity.

return {
	"pmizio/typescript-tools.nvim",
	enabled = vim.env.NVIM_PLUGIN_DISABLED_TYPESCRIPT_TOOLS ~= "true",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
}
