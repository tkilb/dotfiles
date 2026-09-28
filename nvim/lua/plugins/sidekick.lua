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
        enabled = false,
      },
      scroll_on_output = false, -- Disable auto-scroll when copilot is thinking
      win = {
        keys = {
          hide_ctrl_dot = false, -- Handled globally in config/keymaps.lua to support fullscreen Zen escape
          -- sidekick.nvim's own defaults (sidekick/config.lua) bind these as
          -- buffer-local Terminal-mode keys (sidekick/cli/actions.lua's
          -- `nav()`): at a split edge (or when floating) they just return the
          -- raw `<c-h/j/k/l>` chord back to the expr-mapping, which re-sends
          -- it straight to the pty with no herdr awareness -- the same
          -- buffer-local-shadowing bug Phase 1 fixed for Snacks.terminal.
          -- Override by the same key names (sidekick's opts-merging replaces
          -- same-named table entries) with the herdr-aware version shared
          -- with config/keymaps.lua.
          nav_left = {
            "<c-h>",
            function(self)
              if self:is_float() then
                return "<c-h>"
              end
              require("util.herdr_nav").terminal_nav("h")
            end,
            desc = "navigate to the left window",
            expr = true,
          },
          nav_down = {
            "<c-j>",
            function(self)
              if self:is_float() then
                return "<c-j>"
              end
              require("util.herdr_nav").terminal_nav("j")
            end,
            desc = "navigate to the below window",
            expr = true,
          },
          nav_up = {
            "<c-k>",
            function(self)
              if self:is_float() then
                return "<c-k>"
              end
              require("util.herdr_nav").terminal_nav("k")
            end,
            desc = "navigate to the above window",
            expr = true,
          },
          nav_right = {
            "<c-l>",
            function(self)
              if self:is_float() then
                return "<c-l>"
              end
              require("util.herdr_nav").terminal_nav("l")
            end,
            desc = "navigate to the right window",
            expr = true,
          },
        },
        wo = {
          -- Point directly at TerminalNormal (bg=NONE, set in autocmds.lua) to get the same
          -- plain CLI appearance as a regular :term without any colorscheme influence.
          winhighlight = "Normal:TerminalNormal,NormalNC:TerminalNormal,EndOfBuffer:TerminalNormal,SignColumn:TerminalNormal",
        },
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
        -- Notes: Ingest old daily notes + inbox into PARA structure
        ingest_and_organize = function(_ctx)
          return require("agents").ingest_and_organize()
        end,
        kanban_update = function(_ctx)
          return require("agents").kanban_update()
        end,
        -- Notes: Team shareout / status update from daily notes + active projects
        shareout = function(_ctx)
          return require("agents").shareout()
        end,
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
      tools = {
        antigravity = {
          cmd = { "agy" },
        },
      },
    },
    nes = {
      enabled = false,
    },
  },
  config = function(_, opts)
    local util = require("sidekick.util")
    local notify = util.notify
    util.notify = function(msg, level)
      if type(msg) == "string" and msg:match("^%*%*Copilot:%*%* You are not signed into GitHub%.") then
        return
      end
      return notify(msg, level)
    end

    require("sidekick").setup(opts)

    -- Filter out disabled tools from the selection
    local config = require("sidekick.config")
    local original_tools = config.tools
    config.tools = function()
      local ret = original_tools()
      ret.aider = nil
      ret.amazon_q = nil
      ret.claude = nil
      ret.codex = nil
      ret.crush = nil
      ret.cursor = nil
      ret.gemini = nil
      ret.grok = nil
      ret.opencode = nil
      ret.pi = nil
      ret.qwen = nil
      return ret
    end

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
