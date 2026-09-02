-- Toggle Last Window: `wincmd p` relies on Neovim's built-in previous-window
-- history, which gets polluted once focus has bounced between a snacks
-- picker's input/list/preview sub-windows (e.g. after typing in the search
-- box). Track the last "real" (non-picker) window explicitly instead, so the
-- toggle target doesn't drift after interacting with the picker's search.

local M = {}

local last_real_win = nil

local function is_picker_win(win)
  local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
  if not ok then return false end
  local ft = vim.bo[buf].filetype
  return ft == "snacks_picker_input" or ft == "snacks_picker_list" or ft == "snacks_picker_preview"
end

function M.setup()
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if not is_picker_win(win) then
        last_real_win = win
      end
    end,
  })
end

function M.toggle()
  local cur = vim.api.nvim_get_current_win()
  if is_picker_win(cur) then
    -- In the picker: go back to the last real editor window.
    if last_real_win and vim.api.nvim_win_is_valid(last_real_win) then
      vim.api.nvim_set_current_win(last_real_win)
    else
      vim.cmd("wincmd p")
    end
  else
    -- In a real window: prefer jumping into an open picker's list, else
    -- fall back to normal previous-window toggling.
    local pickers = Snacks.picker.get()
    if pickers[1] and pickers[1].list and pickers[1].list.win then
      pickers[1].list.win:focus()
    else
      vim.cmd("wincmd p")
    end
  end
end

return M
