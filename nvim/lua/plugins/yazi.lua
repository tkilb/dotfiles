-- Name: Yazi
--
-- Docs: https://github.com/mikavilpas/yazi.nvim
--
-- Description:
--   A Neovim plugin that provides a file explorer and file management capabilities.
--   Yazi allows users to navigate their file system, open files, and perform various file operations directly from within Neovim.
--   It offers a user-friendly interface for browsing directories, previewing files, and managing files efficiently without leaving the editor.
--   Yazi can be customized with keybindings and supports features like opening files in splits, toggling hidden files, and more.

return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own key mappings!
    {
      "+",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>p+",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
    {
      -- Open in the current working directory
      "<leader>c+",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- mark netrw as loaded so it's not loaded at all.
    --
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    vim.g.loaded_netrwPlugin = 1
  end,
}
