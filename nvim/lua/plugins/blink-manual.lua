-- Name: blink.cmp manual trigger
--
-- Description:
--   Stops the completion menu from opening automatically while typing, so
--   suggestions (including snippets) cannot be inserted by mistake. Press
--   <C-Space> in insert mode to open the menu. Inline ghost text previews are
--   also disabled. All keymaps are unchanged.

return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { auto_show = false },
        ghost_text = { enabled = false },
      },
    },
  },
}
