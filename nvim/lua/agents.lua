-- Agents: thin Lua loader for nvim/agents/*.md prompt templates.
-- Resolves dynamic file paths and interpolates them into the markdown templates.
local M = {}

local cfg = require("notes-config")
local VAULT = cfg.vault
local AGENTS = vim.fn.stdpath("config") .. "/agents"

local function load_template(name)
  local path = AGENTS .. "/" .. name .. ".md"
  local f = io.open(path, "r")
  if not f then
    return nil, "could not read " .. path
  end
  local t = f:read("*all")
  f:close()
  return t
end

local function recent_daily_paths(n)
  local paths = {}
  local h = io.popen("ls -t " .. VAULT .. "/1.Daily/*.md 2>/dev/null | head -" .. n)
  if h then
    for p in h:lines() do table.insert(paths, "  - " .. p) end
    h:close()
  end
  return #paths > 0 and table.concat(paths, "\n") or "  (none found)"
end

local function project_paths()
  local paths = {}
  local h = io.popen("find " .. VAULT .. "/2.Projects -name '*.md' -maxdepth 2 2>/dev/null")
  if h then
    for p in h:lines() do table.insert(paths, "  - " .. p) end
    h:close()
  end
  return #paths > 0 and table.concat(paths, "\n") or "  (none found)"
end

function M.ingest_and_organize()
  local tmpl, err = load_template("daily-ingest")
  if not tmpl then return "Error: " .. err end

  -- Daily notes older than stale_days
  local old_daily = {}
  local cutoff = os.time() - (cfg.stale_days * 24 * 60 * 60)
  local dh = io.popen("ls -t " .. VAULT .. "/1.Daily/*.md 2>/dev/null")
  if dh then
    for file in dh:lines() do
      local date_str = vim.fn.fnamemodify(file, ":t:r") -- e.g. 2026-04-10
      local y, m, d = date_str:match("(%d%d%d%d)-(%d%d)-(%d%d)")
      if y then
        local t = os.time({ year = y, month = m, day = d })
        if t < cutoff then
          table.insert(old_daily, "  - " .. file)
        end
      end
    end
    dh:close()
  end

  -- Inbox files
  local inbox = {}
  local ih = io.popen("find " .. VAULT .. "/0.Inbox -maxdepth 1 -type f 2>/dev/null")
  if ih then
    for file in ih:lines() do
      table.insert(inbox, "  - " .. file)
    end
    ih:close()
  end

  return tmpl
    :gsub("{{kanban}}", VAULT .. "/0.Kanban.md")
    :gsub("{{old_daily_notes}}", #old_daily > 0 and table.concat(old_daily, "\n") or "  (none found — all daily notes are within " .. cfg.stale_days .. " days)")
    :gsub("{{stale_days}}", tostring(cfg.stale_days))
    :gsub("{{inbox_files}}", #inbox > 0 and table.concat(inbox, "\n") or "  (inbox is empty)")
end

function M.kanban_update()
  local tmpl, err = load_template("kanban-update")
  if not tmpl then return "Error: " .. err end
  return tmpl
    :gsub("{{kanban}}", VAULT .. "/0.Kanban.md")
    :gsub("{{daily_notes}}", recent_daily_paths(7))
    :gsub("{{nudge_days}}", tostring(cfg.nudge_days))
    :gsub("{{stale_days}}", tostring(cfg.stale_days))
end

function M.shareout()
  local tmpl, err = load_template("shareout")
  if not tmpl then return "Error: " .. err end
  return tmpl
    :gsub("{{daily_notes}}", recent_daily_paths(7))
    :gsub("{{project_notes}}", project_paths())
end

function M.meeting_ingest()
  local tmpl, err = load_template("meeting-ingest")
  if not tmpl then return "Error: " .. err end

  -- Use the most recently modified file in 0.Inbox as the transcript
  local transcript = "(no file found in 0.Inbox)"
  local h = io.popen("ls -t " .. VAULT .. "/0.Inbox/* 2>/dev/null | head -1")
  if h then
    local p = h:read("*l")
    h:close()
    if p and p ~= "" then transcript = p end
  end

  return tmpl:gsub("{{transcript}}", transcript)
end

return M
