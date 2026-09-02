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

    -- Make the cursor purple in Normal mode so the mode is obvious at a glance.
    -- Other modes keep the theme's default cursor color/highlight group.
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("normal-mode-cursor-color", { clear = true }),
      callback = function()
        vim.api.nvim_set_hl(0, "CursorNormalMode", { bg = "#a9a1e1", fg = "#1d2021" })
      end,
    })
    vim.api.nvim_set_hl(0, "CursorNormalMode", { bg = "#a9a1e1", fg = "#1d2021" })

    vim.opt.guicursor = "n:block-CursorNormalMode,v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr:hor20-Cursor,o:hor50-Cursor,a:blinkon0"
  end,
}
