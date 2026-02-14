-- Name: Snacks - Scroll
--
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md
--
-- Description:
--   A collection of small quality-of-life improvements for Neovim.
--   This configuration specifically enables the scroll module of the
--   Snacks plugin, which provides smooth scrolling animations for various scroll actions in Neovim.

return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 10, total = 100 },
        easing = "linear",
      },
      -- faster animation when repeating scroll after delay
      animate_repeat = {
        delay = 50, -- delay in ms before using the repeat animation
        duration = { step = 3, total = 20 },
        easing = "linear",
      },
    },
  },
}
