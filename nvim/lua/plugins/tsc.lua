-- Name: tsc.nvim
--
-- Docs: https://github.com/dmmulroy/tsc.nvim
--
-- Description:
--   Async, project-wide TypeScript type-checking (runs `tsc` across the whole
--   project, not just open buffers). Results are loaded into the quickfix
--   list, then surfaced via the Snacks picker (instead of tsc.nvim's own
--   quickfix window) so it matches the rest of the diagnostics workflow.
--   Use `:TSC` on demand after refactors/renames to catch errors in files
--   you haven't opened yet. `:TSCStop` cancels a running check.

return {
	"dmmulroy/tsc.nvim",
	ft = { "typescript", "typescriptreact" },
	cmd = { "TSC", "TSCOpen", "TSCClose", "TSCStop" },
	opts = {
		-- tsc.nvim always populates the quickfix list regardless of this
		-- setting; it only controls whether tsc.nvim's own `:copen` window
		-- shows up. We keep it on and instead intercept/redirect that
		-- window below, since tsc.nvim has no post-run callback to hook.
		auto_open_qflist = true,
		auto_close_qflist = false,
		auto_start_watch_mode = false,
	},
	config = function(_, opts)
		require("tsc").setup(opts)

		-- Redirect tsc.nvim's native quickfix window into the Snacks
		-- picker as soon as it opens, so results are always browsed there.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "qf",
			desc = "Open TSC quickfix results in the Snacks picker instead of the native qflist window",
			callback = function()
				local ok, qf = pcall(vim.fn.getqflist, { title = 0 })
				if not ok or qf.title ~= "TSC" then
					return
				end
				local qf_win = vim.api.nvim_get_current_win()
				vim.schedule(function()
					if vim.api.nvim_win_is_valid(qf_win) then
						vim.api.nvim_win_close(qf_win, true)
					end
					Snacks.picker.qflist()
				end)
			end,
		})
	end,
}
