-- Name: LazyDev
--
-- Docs: https://github.com/folke/lazydev.nvim
--
-- Description:
--   Configure Lua LSP for your Neovim config, runtime and plugins
--   used for completion, annotations and signatures of Neovim apis.

return {
	"folke/lazydev.nvim",
	ft = "lua",
	enable = false,
	opts = {
		library = {
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
