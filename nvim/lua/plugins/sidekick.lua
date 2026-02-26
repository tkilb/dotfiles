-- Name: Sidekick
--
-- Docs: https://github.com/folke/sidekick.nvim,
--
-- Description:
--   Sidekick.nvim is a Neovim plugin that integrates AI-powered code assistance directly into your editor.
--   It provides features like code suggestions, completions, and interactions with various AI models
--   through a command-line interface (CLI) within Neovim, enhancing your coding experience and productivity.

return {
  "folke/sidekick.nvim",
  enabled = vim.env.NVIM_PLUGIN_DISABLED_COPILOT ~= "true",
  lazy = false,
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      scroll_on_output = false, -- Disable auto-scroll when copilot is thinking
      win = {
        wo = {
          -- Override SidekickChat highlight to transparent so gruvebox colors don't bleed in.
          -- The default maps Normal → SidekickChat → NormalFloat (themed); empty string resets to Normal.
          winhighlight = "Normal:SidekickChat,NormalNC:SidekickChat,EndOfBuffer:SidekickChat,SignColumn:SidekickChat",
        },
      },
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)

    -- Override SidekickChat to transparent after setup() so the terminal window
    -- shows plain CLI colors instead of gruvebox's NormalFloat background.
    -- setup() calls set_hl() with `default = true` (only sets if unset), so we
    -- must override explicitly after. Use vim.schedule on ColorScheme to run
    -- after sidekick's own ColorScheme handler re-applies its defaults.
    local function override_hl()
      vim.api.nvim_set_hl(0, "SidekickChat", { bg = "NONE", fg = "NONE" })
    end
    override_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function() vim.schedule(override_hl) end,
    })

    -- Add Sidekick.nvim toggle command for NES
    vim.api.nvim_create_user_command("SidekickNesToggle", function()
      local nes = require("sidekick.nes")
      nes.enable(not nes.enabled)
      print("Copilot NES " .. (nes.enabled and "enabled" or "disabled"))
    end, {})

    -- Suppress Sidekick.nvim window errors caused by invalid window IDs in nvim_win_get_cursor
    -- This prevents noisy "Invalid 'window': Expected Lua number" errors from appearing in Neovim
    local ok, sidekick = pcall(require, "sidekick")
    if ok and sidekick and sidekick.cli and sidekick.cli.terminal then
      local orig = sidekick.cli.terminal
      sidekick.cli.terminal = function(...)
        local ok2, res = pcall(orig, ...)
        if not ok2 and type(res) == "string" and res:find("Invalid 'window': Expected Lua number") then
          return nil
        end
        return res
      end
    end
  end,
}
