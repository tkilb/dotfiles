-- Name: Vim Test
--
-- Docs: https://github.com/vim-test/vim-test
--
-- Description:
--   Test.vim consists of a core which provides an abstraction
--   over running any kind of tests from the command-line.

return {
	"vim-test/vim-test",
	dependencies = {
		"preservim/vimux",
	},
	-- vim.cmd("let test#strategy = 'vimux'"),
}
