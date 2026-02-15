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
    legacy_commands = false, -- this will be removed in the next major release
    picker = {
      name = "snacks.pick",
    },
    workspaces = {
      {
        name = "notes-nvim",
        path = "~/notes/nvim",
      },
      {
        name = "notes-personal",
        path = "~/notes/personal",
      },
      {
        name = "notes-tech",
        path = "~/notes/tech",
      },
      {
        name = "notes-work",
        path = "~/notes/work",
      },
    },
  },
}
