-- Name: Arrow
--
-- Docs: https://github.com/otavioschwanck/arrow.nvim
--
-- Description:
--   A Lua plugin for Neovim that provides a quick navigation menu for buffers, files, and more.
--   It allows users to quickly jump to different locations in their codebase using a customizable interface.
--   Arrow.nvim is designed to enhance productivity by providing an efficient way to navigate through files and buffers in Neovim.

return {
  "otavioschwanck/arrow.nvim",
  dependencies = {
    -- { "nvim-tree/nvim-web-devicons" },
    -- or if using `mini.icons`
    { "nvim-mini/mini.icons" },
  },
  opts = {
    show_icons = true,
    leader_key = "<S-Tab>", -- Recommended to be a single key
    -- buffer_leader_key = "m", -- Per Buffer Mappings
  },
}
