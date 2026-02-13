-- https://github.com/akinsho/toggleterm.nvim
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			autochdir = true,
			direction = "float",
			insert_mappings = true,
			open_mapping = [[<C-j>]],
			terminal_mappings = true,
		},
	},
}
