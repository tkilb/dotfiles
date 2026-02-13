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
      -- Set default model to GPT 4.1
      vim.g.copilot_model_version = "gpt-4.1"

      -- Toggle Copilot predictions on and off
      vim.api.nvim_create_user_command("CopilotToggle", function()
        vim.g.copilot_enabled = 1 - (vim.g.copilot_enabled or 1)
        print("Copilot predictions " .. (vim.g.copilot_enabled == 1 and "enabled" or "disabled"))
      end, {})
    end,
  },
}
