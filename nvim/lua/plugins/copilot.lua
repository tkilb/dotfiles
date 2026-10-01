-- Name: Copilot
--
-- Docs: https://github.com/github/copilot.vim
--
-- Description:
--   GitHub Copilot is an AI-powered code completion tool that suggests code snippets and entire functions
--   directly within your Neovim editor, enhancing productivity and coding efficiency.

return {
  {
    "github/copilot.vim",
    enabled = vim.env.NVIM_PLUGIN_DISABLED_COPILOT ~= "true",
    config = function()
      vim.g.copilot_model_version = "gpt-4.1"

      -- Use the static embedded language server version (no auto-bump via npx)
      vim.g.copilot_version = false

      -- Don't attach Copilot's LSP client to oil.nvim buffers. LazyVim's
      -- default "gr" keymap (References) fires for *any* attached LSP
      -- client, and Copilot's presence there was hijacking oil's own
      -- buffer-local "gr" (refresh) mapping.
      vim.g.copilot_filetypes = {
        oil = false,
      }

      -- Disable Copilot by default
      vim.cmd("Copilot disable")

      -- Toggle Copilot predictions on and off
      vim.api.nvim_create_user_command("CopilotToggle", function()
        local enabled = vim.fn["copilot#Enabled"]() == 1
        vim.cmd(enabled and "Copilot disable" or "Copilot enable")
        print("Copilot predictions " .. (enabled and "disabled" or "enabled"))
      end, {})
    end,
  },
}
