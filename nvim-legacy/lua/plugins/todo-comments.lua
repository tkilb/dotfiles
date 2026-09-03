-- Name: Todo Comments
--
-- Docs: https://github.com/folke/todo-comments.nvim
--
-- Description:
--   Highlights and searches for todo comments like
--   TODO, HACK, BUG in your code base.

return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = false },
}
