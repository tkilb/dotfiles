-- Name: Which-Key
--
-- Docs: https://github.com/folke/which-key.nvim
--
-- Description:
--   A Neovim plugin that displays available keybindings in a popup.
--   It helps users discover and remember keybindings by showing them in a structured and organized way.
--   Which-Key can be configured to show different types of keybindings, such as normal mode, insert mode,
--   visual mode, etc., and it can also display descriptions for each keybinding to provide context and improve usability.

return {
  "folke/which-key.nvim",
  opts = {
    --- @type vim._watch.watch.Opts
    -- which-key's auto-trigger logic deliberately skips single lowercase
    -- letters other than `g`/`z` (see is_safe() in which-key/buf.lua) to
    -- avoid hijacking common single-key commands. That means `s`, mapped in
    -- config/keymaps.lua as the vim-sandwich group prefix, never gets an
    -- auto trigger and its popup never appears. Add it as a manual trigger
    -- alongside the default auto-trigger entry to opt it back in.
    triggers = {
      { "<auto>", mode = "nxso" },
      { "s", mode = { "n", "x" } },
    },
  },
}
