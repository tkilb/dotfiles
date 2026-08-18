-- Name: Grug Far
--
-- Docs: https://github.com/MagicDuck/grug-far.nvim
--
-- Description:
--   Search and replace across files. Overrides LazyVim's default
--   <leader>sr trigger, moving it to <leader>sR so <leader>sr is free
--   for Snacks picker resume (see plugins/snacks.lua).

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    -- Disable LazyVim's default trigger key
    { "<leader>sr", false },
    {
      "<leader>sR",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Search and Replace",
    },
  },
}
