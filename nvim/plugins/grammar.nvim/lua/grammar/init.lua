-- grammar.nvim: grammar / spelling corrector for visually selected text.
-- Sends the selection to `claude -p` (no tools, no session) and replaces the
-- selection in place with the corrected text. Async: the editor never blocks.
local M = {}

local NS = vim.api.nvim_create_namespace("grammar")

local defaults = {
  model = "haiku",
  timeout_ms = 30000,
  prompt = table.concat({
    "You are a proofreader. Fix spelling, grammar, and punctuation in the text the user sends.",
    "Keep the original meaning, tone, wording, line breaks, indentation, markdown, and code untouched",
    "unless a fix requires changing them.",
    "Reply with ONLY the corrected text: no preamble, no explanation, no code fences.",
    "If the text is already correct, return it unchanged.",
  }, " "),
}
local config = vim.deepcopy(defaults)

--- Override defaults: { model, timeout_ms, prompt }.
function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Grammar" })
end

-- Returns { text, row, col, end_row, end_col } (0-indexed, end exclusive) for the
-- active visual selection, or nil if nothing usable is selected.
local function visual_range()
  local mode = vim.fn.mode()
  local p1, p2 = vim.fn.getpos("v"), vim.fn.getpos(".")
  local opts = { type = mode }
  local lines = vim.fn.getregion(p1, p2, opts)
  local pos = vim.fn.getregionpos(p1, p2, opts)
  if #lines == 0 or #pos == 0 then
    return nil
  end

  local first, last = pos[1][1], pos[#pos][2]
  local last_line = vim.api.nvim_buf_get_lines(0, last[2] - 1, last[2], false)[1] or ""
  -- getregionpos end col is the first byte of the last selected char; extend to its end.
  local last_char = vim.fn.matchstr(last_line:sub(last[3]), "^.")
  return {
    text = table.concat(lines, "\n"),
    row = first[2] - 1,
    col = first[3] - 1,
    end_row = last[2] - 1,
    end_col = last[3] - 1 + #last_char,
  }
end

local function apply(buf, mark, corrected)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local m = vim.api.nvim_buf_get_extmark_by_id(buf, NS, mark, { details = true })
  vim.api.nvim_buf_del_extmark(buf, NS, mark)
  if #m == 0 then
    return notify("Selection was removed before the correction finished", vim.log.levels.WARN)
  end
  vim.api.nvim_buf_set_text(buf, m[1], m[2], m[3].end_row, m[3].end_col, vim.split(corrected, "\n", { plain = true }))
  notify("Corrected")
end

--- Correct the active visual selection in place.
function M.correct_selection()
  local range = visual_range()
  -- Leave visual mode so the user can keep working while the request runs.
  vim.api.nvim_feedkeys(vim.keycode("<esc>"), "nx", false)
  if not range or range.text:match("^%s*$") then
    return notify("Nothing selected", vim.log.levels.WARN)
  end

  local buf = vim.api.nvim_get_current_buf()
  local mark = vim.api.nvim_buf_set_extmark(buf, NS, range.row, range.col, {
    end_row = range.end_row,
    end_col = range.end_col,
    hl_group = "DiffChange",
    right_gravity = false,
    end_right_gravity = true,
  })

  notify("Correcting…")
  local cmd = { "claude", "-p", "--model", config.model, "--tools", "", "--no-session-persistence", "--system-prompt", config.prompt }
  local ok, err = pcall(vim.system, cmd, { stdin = range.text, text = true, timeout = config.timeout_ms }, function(res)
    vim.schedule(function()
      local out = vim.trim(res.stdout or "")
      if res.code ~= 0 or out == "" then
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_del_extmark(buf, NS, mark)
        end
        return notify("Correction failed: " .. vim.trim(res.stderr or "no output"), vim.log.levels.ERROR)
      end
      apply(buf, mark, out)
    end)
  end)
  if not ok then
    vim.api.nvim_buf_del_extmark(buf, NS, mark)
    notify("Could not run claude: " .. tostring(err), vim.log.levels.ERROR)
  end
end

return M
