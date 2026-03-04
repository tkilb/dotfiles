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

      -- Toggle Copilot predictions on and off
      vim.api.nvim_create_user_command("CopilotToggle", function()
        local enabled = vim.fn["copilot#Enabled"]() == 1
        vim.cmd(enabled and "Copilot disable" or "Copilot enable")
        print("Copilot predictions " .. (enabled and "disabled" or "enabled"))
      end, {})
    end,
  },
}
