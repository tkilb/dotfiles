-- Name: Obsidian
--
-- Docs: https://github.com/obsidian-nvim/obsidian.nvim
--
-- Description:
--   Obsidian integration for Neovim with note management and fuzzy finding.

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  lazy = false,
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = { enable = false },
    legacy_commands = false, -- this will be removed in the next major release

    -- Only cycle between unchecked and checked
    checkbox = {
      order = { " ", "x" },
    },
    picker = {
      name = "snacks.pick",
    },

    -- Location for new notes (one of: "notes_subdir", "current_dir")
    new_notes_location = "notes_subdir",

    -- Attachment/image folder configuration
    attachments = {
      img_folder = "z-attachments", -- where pasted images are saved
    },

    templates = {
      folder = "z-templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },

    daily_notes = {
      alias_format = nil,
      date_format = "YYYY-MM-DD",
      default_tags = { "daily" },
      enabled = true,
      folder = "1.daily",
      template = "daily-note.md",
      workdays_only = true,
    },
    workspaces = {
      {
        name = "notes-work",
        path = "~/Notes/work",
      },
      {
        name = "notes-nvim",
        path = "~/Notes/nvim",
      },
      {
        name = "notes-personal",
        path = "~/Notes/personal",
      },
      {
        name = "notes-tech",
        path = "~/Notes/tech",
      },
      {
        name = "notes-workshop",
        path = "~/Notes/workshop",
      },
    },
  },
}
