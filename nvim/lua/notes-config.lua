-- Notes configuration — central place to tune thresholds and paths.
-- Referenced by agents.lua, autocmds, and the launchd reminder script.
return {
  vault = vim.fn.expand("~/Notes/work"),
  kanban = vim.fn.expand("~/Notes/work/0.Kanban.md"),

  -- Number of days before a Kanban item is considered "nudge" worthy.
  -- A notification/warning will fire after this many days with no update.
  nudge_days = 2,

  -- Number of days before a Kanban item is considered stale.
  -- Agents will flag these items prominently for review.
  stale_days = 4,
}
