-- Name: Trouble
--
-- Docs: https://github.com/folke/trouble.nvim
--
-- Description:
--   A pretty list for showing diagnostics, references, telescope results, quickfix
--   and location lists to help you solve all the trouble your code is causing.

return {
	"folke/trouble.nvim",
	--- @module 'trouble'
	--- @type trouble.Config
	opts = {
		auto_jump = false,
		follow = false,
		---@type trouble.Window.opts
		win = {
			type = "split", -- split window
			relative = "win", -- relative to current window
			position = "bottom", -- right side
			size = 0.3, -- 30% of the window
		},
	},
	cmd = "Trouble",
	keys = {},
}
