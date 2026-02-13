-- Name: LSP Signature
--
-- Docs: https://github.com/ray-x/lsp_signature.nvim
--
-- Description:
--  LSP Signature is a Neovim plugin that provides real-time function signature help as you type.

return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	opts = {
		bind = true,
		handler_opts = {
			border = "rounded",
		},
	},
}
