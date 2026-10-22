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
    vim.g.gruvbox_material_background = "hard"
    -- Darker backgrounds for more contrast. Hard-palette defaults: bg0 #1d2021,
    -- bg1/bg2/bg_statusline1 #282828.
    vim.g.gruvbox_material_colors_override = {
      bg0 = { "#111111", "233" },
      bg1 = { "#111111", "233" },
      bg2 = { "#111111", "233" },
      bg_statusline1 = { "#111111", "233" },
    }
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

    -- Floating windows (including the Snacks terminal) default to bg3 (#3c3836);
    -- use gruvbox hard's #1d2021, slightly lighter than the #111111 main background.
    local function darken_floats()
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#ddc7a1", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#928374", bg = "#1d2021" })
    end
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("darken-float-backgrounds", { clear = true }),
      callback = darken_floats,
    })
    darken_floats()

    vim.opt.guicursor = "n:block-CursorNormalMode,v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr:hor20-Cursor,o:hor50-Cursor,a:blinkon0"
  end,
}
