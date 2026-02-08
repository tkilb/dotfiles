-- Name: Catppuccin
--
-- Docs: https://github.com/nvim-lualine/lualine.nvim
--
-- Description:
--   Enhanced Neovim statusline.

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			component_separators = "",
			section_separators = { left = "", right = "" },
			theme = "codedark",
		},
	},
}
