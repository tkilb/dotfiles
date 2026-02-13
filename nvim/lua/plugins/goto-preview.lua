-- Name: Trouble
--
-- Docs: https://github.com/folke/trouble.nvimreferenreferen
--
-- Description:
--   A pretty list for showing diagnostics, references, telescope results, quickfix
--   and location lists to help you solve all the trouble your code is causing.

return {
	"rmagatti/goto-preview",
	dependencies = { "rmagatti/logger.nvim" },
	event = "BufEnter",
	config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
}
