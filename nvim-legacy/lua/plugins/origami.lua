-- Name: Origami
--
-- Docs: https://github.com/chrisgrieser/nvim-origami
--
-- Description:
--   Provides code folding.  Uses the LSP to provide folds, with Treesitter as fallback if
--   the LSP does not provide folding information (and indent-based folding as fallback if neither is available).

return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		useLspFoldsWithTreesitterFallback = {
			enabled = true,
			foldmethodIfNeitherIsAvailable = "indent", ---@type string|fun(bufnr: number): string
		},
		pauseFoldsOnSearch = true,
		foldtext = {
			enabled = true,
			padding = 3,
			lineCount = {
				template = "%d lines", -- `%d` is replaced with the number of folded lines
				hlgroup = "Comment",
			},
			diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
			gitsignsCount = true, -- requires `gitsigns.nvim`
			disableOnFt = { "snacks_picker_input" }, ---@type string[]
		},
		autoFold = {
			enabled = false,
			kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
		},
		foldKeymaps = {
			setup = false, --default true, -- modifies `h`, `l`, `^`, and `$`
			closeOnlyOnFirstColumn = false, -- `h` and `^` only close in the 1st column
			scrollLeftOnCaret = false, -- `^` should scroll left (basically mapped to `0^`)
		},
	}, -- needed even when using default config

	-- recommended: disable vim's auto-folding
	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
}
