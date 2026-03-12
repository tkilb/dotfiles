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
          -- Point directly at TerminalNormal (bg=NONE, set in autocmds.lua) to get the same
          -- plain CLI appearance as a regular :term without any colorscheme influence.
          winhighlight = "Normal:TerminalNormal,NormalNC:TerminalNormal,EndOfBuffer:TerminalNormal,SignColumn:TerminalNormal",
        },
      },
      tools = {
        copilot = { cmd = { vim.fn.expand("~/.local/bin/copilot"), "--no-auto-update" } },
      },
      prompts = {
        -- Default prompts from sidekick.nvim
        changes = "Can you review my changes?",
        diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
        diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
        document = "Add documentation to {function|line}",
        explain = "Explain {this}",
        fix = "Can you fix {this}?",
        optimize = "How can {this} be optimized?",
        review = "Can you review {file} for any issues or improvements?",
        tests = "Can you write tests for {this}?",
        -- Simple context prompts
        buffers = "{buffers}",
        file = "{file}",
        line = "{line}",
        position = "{position}",
        quickfix = "{quickfix}",
        selection = "{selection}",
        ["function"] = "{function}",
        class = "{class}",
        -- Custom prompt: Repository analysis
        repo_summary = function(ctx)
          local prompt_file = vim.fn.expand("~/.dotfiles/ai/AI_REPO_SUMMARY.md")
          local f = io.open(prompt_file, "r")
          if not f then
            return "Error: Could not read " .. prompt_file
          end
          local content = f:read("*all")
          f:close()

          -- Get the git repository root for the current buffer
          local git_root = vim.fn.systemlist(
            "git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel 2>/dev/null"
          )[1]
          if not git_root or git_root == "" then
            git_root = vim.fn.getcwd()
          end

          return string.format(
            "%s\n\n---\n\nTARGET REPOSITORY: %s\n\nPlease verify this is the correct repository before proceeding with the analysis.",
            content,
            git_root
          )
        end,
      },
    },
    nes = {
      enabled = false,
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)

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
