-- Name: Wordmotion
--
-- Docs: https://github.com/chaoren/vim-wordmotion
--
-- Description:
--   Extends w, e, b and friends to understand CamelCase, snake_case, and
--   other sub-word boundaries for more precise word motions.

return {
  "chaoren/vim-wordmotion",
  event = "VeryLazy",
  init = function()
    vim.g.wordmotion_nomap = 1
  end,
}
