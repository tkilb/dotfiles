-- Name: GruvBox
--
-- Docs: https://github.com/sainnhe/gruvbox-material
--
-- Description:
--   GruvBox Material is a retro groove color scheme for Neovim and Vim.
--   It is a modern take on the classic GruvBox color scheme, featuring
--   a more vibrant color palette and improved contrast for better readability.

return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_disable_terminal_colors = 1 -- Use terminal emulator's native ANSI colors
    -- vim.g.gruvbox_material_background = "hard"
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
