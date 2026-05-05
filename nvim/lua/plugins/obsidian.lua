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
    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        date = os.date("%Y-%m-%d"),
        tags = note.tags,
        people = {},
      }
      -- Preserve any fields the user has already set
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    callbacks = {
      enter_note = function(_)
        local function toggle_with_date()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
          local had_checkbox = line and line:match("^%s*[-*+] %[")

          require("obsidian.actions").toggle_checkbox()

          if not had_checkbox then
            local new_line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
            if new_line and new_line:match("^%s*[-*+] %[") then
              local date = os.date("%Y-%m-%d")
              vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
                new_line .. " (added: " .. date .. ")",
              })
            end
          end
        end

        vim.keymap.set("n", "<leader>ch", toggle_with_date, { buffer = true, desc = "Toggle checkbox (stamps added date on new todos)" })
        vim.keymap.set("n", "<leader>dd", toggle_with_date, { buffer = true, desc = "Toggle checkbox (stamps added date on new todos)" })
      end,
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
