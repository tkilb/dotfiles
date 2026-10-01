-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable autoformat for keymaps.lua
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*/config/keymaps.lua",
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Auto-cd terminals (sidekick + snacks) to the last file buffer's directory,
-- but only when the directory has actually changed since the last cd.
local terminal_last_dir = {}
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local ft = vim.bo.filetype
    -- Track the last normal file buffer's directory
    if vim.bo.filetype == "oil" then
      local oil_dir = vim.fn.expand("%:p"):gsub("^oil://", "")
      vim.g.last_file_dir = oil_dir
      -- Follow oil navigation with nvim's actual cwd, so leaving nvim (see
      -- the `vim()` shell wrapper) drops you into the last dir you browsed.
      if oil_dir ~= "" and oil_dir ~= vim.fn.getcwd() then
        vim.cmd.cd(vim.fn.fnameescape(oil_dir))
      end
    elseif vim.bo.buftype == "" and vim.fn.expand("%:p") ~= "" then
      vim.g.last_file_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
    end
    -- cd terminals only when the target directory has changed
    if ft == "snacks_terminal" then
      local cwd = vim.g.last_file_dir or vim.fn.getcwd()
      local buf = vim.api.nvim_get_current_buf()
      if terminal_last_dir[buf] ~= cwd then
        terminal_last_dir[buf] = cwd
        if ft == "snacks_terminal" then
          local job_id = vim.b.terminal_job_id
          if job_id then
            vim.fn.chansend(job_id, " cd " .. vim.fn.shellescape(cwd) .. "\n")
          end
        end
      end
    end
  end,
})

-- Write the final cwd to $NVIM_CWD_FILE on exit, so the shell wrapper (see
-- `vim()` in zsh/.feature.administation.sh) can cd into it after nvim quits.
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local cwd_file = vim.env.NVIM_CWD_FILE
    if not cwd_file then return end
    local f = io.open(cwd_file, "w")
    if not f then return end
    f:write(vim.fn.getcwd())
    f:close()
  end,
})

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

