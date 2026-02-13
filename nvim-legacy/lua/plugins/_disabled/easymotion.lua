-- Switch to leap
-- https://github.com/ggandor/leap.nvim/blob/main/doc/leap.txt

return {
	"Lokaltog/vim-easymotion",
	lazy = false,
	init = function()
		vim.g.EasyMotion_do_mapping = false
		vim.g.EasyMotion_inc_highlight = false
		vim.g.EasyMotion_keys = "abcdefghijklmnopqrstuvwxyz"
		vim.g.EasyMotion_smartcase = true
	end,
}
