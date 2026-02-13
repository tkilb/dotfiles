-- Name: Snacks - Dashboard
--
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
--
-- Description:
--   A collection of small quality-of-life improvements for Neovim.
--   This configuration specifically enables the dashboard module of the Snacks plugin.

math.randomseed(os.time())

return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        pick = nil,
        header = [[
                                                                                   
               ████ ██████           █████      ██                           
              ███████████             █████                                   
              █████████ ███████████████████ ███   ███████████         
             █████████  ███    █████████████ █████ ██████████████         
            █████████ ██████████ █████████ █████ █████ ████ █████         
          ███████████ ███    ███ █████████ █████ █████ ████ █████        
         ██████  █████████████████████ ████ █████ █████ ████ ██████       
        ]],
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          { separator = true },
          { header = "Configs", separator = true, align = "left" },
          { icon = " ", key = "v", desc = "NeoVim Configs", action = ":Oil ~/.dotfiles/nvim/" },
          { icon = " ", key = "k", desc = "NeoVim Keymaps", action = ":e ~/.dotfiles/nvim/lua/config/keymaps.lua" },
          {
            icon = " ",
            key = "K",
            desc = "Legacy Keymaps",
            action = ":e ~/.dotfiles/nvim-legacy/lua/config/keymaps.lua",
          },
          { icon = " ", key = "z", desc = "Zsh", action = ":Oil ~/.dotfiles/zsh/" },
          { icon = "", key = ".", desc = "Dotfiles", action = ":Oil ~/.dotfiles/" },
          {
            icon = "",
            key = "$",
            desc = "Dashboard",
            action = ":e ~/.dotfiles/nvim/lua/plugins/snacks-dashboard.lua",
          },
        },
      },
      sections = {
        { section = "header" },
        {
          icon = "󰌪 ",
          title = "Vimprove",
          section = "terminal",
          cmd = (function()
            local tips = {
              "Use 'ciw' to change the word under cursor",
              "Press 'zz' to center the current line on screen",
              "Use ':%s/old/new/g' to replace all occurrences in file",
              "Press 'gf' on a filepath to open it in a new buffer",
              "Use 'Ctrl-o' and 'Ctrl-i' to jump back and forward",
              "Press '.' to repeat the last change",
              "Use 'diw' to delete the word under cursor",
              "Press '*' to search for the word under cursor",
              "Use 'gg=G' to auto-indent the entire file",
              "Press 'Ctrl-a' to increment a number, 'Ctrl-x' to decrement",
              "Use 'viw' to select the word under cursor",
              "Press 'ea' to append at the end of the current word",
              "Use ':earlier 5m' to undo to 5 minutes ago",
              "Press 'g;' to jump to last change position",
              "Use 'vip' to select the current paragraph",
              "Press 'Ctrl-v' for visual block mode",
              "Press 'gv' to reselect the last visual selection",
              "Press 'Ctrl-r' in insert mode to paste from register",
              "Use 'gi' to go back to the last insert position and enter insert mode",
              "Press 'g&' to repeat the last substitute command on all lines",
              "Use 'gn' to select the next search match in visual mode",
              "Press 'gU' or 'gu' with motion to change case (e.g., 'gUiw' uppercases word)",
              "Use ':g/pattern/d' to delete all lines matching a pattern",
              "Press 'Ctrl-w _' to maximize current window height",
              "Use 'qa' to start recording macro in register 'a', 'q' to stop, '@a' to replay",
              "Press 'g~' with motion to toggle case (e.g., 'g~iw' toggles word case)",
              "Use ':ab abbr expansion' to create abbreviations (type 'abbr' → 'expansion')",
              "Press 'gJ' to join lines without adding a space",
              "Use 'Ctrl-w T' to move current window to a new tab",
              "Press 'Ctrl-]' on a tag/function to jump to definition",
              "Use ':sort u' to sort lines and remove duplicates",
              "Press 'Ctrl-w ==' to resize all windows to equal dimensions",
              "Use ':v/pattern/d' to delete all lines NOT matching a pattern",
              "Press 'g Ctrl-g' to show word count and file statistics",
              "Use ':read !command' to insert command output into buffer",
              "Press 'Ctrl-w o' to close all windows except the current one",
              "Use ':earlier 1h' or ':later 30m' to travel through undo history by time",
              "Press 'gq' with motion to format/wrap text (e.g., 'gqip' formats paragraph)",
              "Use ':%!column -t' to align columns in a table",
              "Press 'Ctrl-w r' to rotate windows, 'Ctrl-w x' to exchange with next",
              "Use ':args **/*.js' to populate argument list with all JS files recursively",
              "Press 'Ctrl-w s' for horizontal split, 'Ctrl-w v' for vertical split",
              "Use ':bufdo %s/old/new/ge | update' to replace in all buffers",
              "Press 'g Ctrl-a' on visual block of numbers to create an incrementing sequence",
              "Use ':set spell' to enable spell check, 'z=' for suggestions, ']s' next error",
              "Press 'g;' and 'g,' to navigate through the change list",
              "Use 'Ctrl-x Ctrl-f' in insert mode for filename completion",
              "Press '``' (double backtick) to jump to position before the last jump",
              "Use ':normal @a' to execute macro 'a' on a range of lines",
              "Press 'Ctrl-w H/J/K/L' to move current window to far left/bottom/top/right",
              "Use ':cdo s/old/new/g | update' to replace in all quickfix files",
            }
            return "echo '" .. tips[math.random(#tips)] .. "'"
          end)(),
          height = 1,
          padding = 1,
          indent = 0,
          align = "center",
        },
        { section = "keys", indent = 1, padding = 1 },
        { section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 2 },
        { section = "startup" },
      },
    },
  },
}
