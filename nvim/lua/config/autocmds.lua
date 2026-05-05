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
    if vim.bo.buftype == "" and vim.fn.expand("%:p") ~= "" then
      local path = vim.fn.expand("%:p")
      -- Oil buffers use oil:// URIs — extract the real filesystem path
      if vim.bo.filetype == "oil" then
        path = path:gsub("^oil://", "")
        vim.g.last_file_dir = path
      else
        vim.g.last_file_dir = vim.fn.fnamemodify(path, ":h")
      end
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

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Kanban staleness check on startup
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, cfg = pcall(require, "notes-config")
    if not ok then return end
    local kanban = cfg.kanban
    local f = io.open(kanban, "r")
    if not f then return end
    local today = os.time()
    local nudge, stale = {}, {}
    for line in f:lines() do
      local name, date_str = line:match("- %[ %] (.-)%s*%(added: (%d%d%d%d%-%d%d%-%d%d)%)")
      if name and date_str then
        local y, m, d = date_str:match("(%d+)-(%d+)-(%d+)")
        local added = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
        local age = math.floor((today - added) / 86400)
        if age >= cfg.stale_days then
          table.insert(stale, name)
        elseif age >= cfg.nudge_days then
          table.insert(nudge, name)
        end
      end
    end
    f:close()
    if #stale > 0 then
      local names = table.concat(vim.list_slice(stale, 1, 3), ", ")
      if #stale > 3 then names = names .. " +" .. (#stale - 3) .. " more" end
      vim.notify("🔴 Stale Kanban (" .. #stale .. "): " .. names, vim.log.levels.WARN, { title = "Kanban" })
    end
    if #nudge > 0 then
      local names = table.concat(vim.list_slice(nudge, 1, 3), ", ")
      if #nudge > 3 then names = names .. " +" .. (#nudge - 3) .. " more" end
      vim.notify("🟡 Kanban nudge (" .. #nudge .. "): " .. names, vim.log.levels.INFO, { title = "Kanban" })
    end
  end,
})
