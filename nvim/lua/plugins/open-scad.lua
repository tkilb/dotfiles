-- Name: Openscad
--
-- Docs: https://github.com/salkin-mada/openscad.nvim
--
-- Description:
--   Syntax highlighting, cheatsheet, snippets, offline manual and fuzzy help plugin for the OpenSCAD language.

return {
  {
    "salkin-mada/openscad.nvim",
    config = function()
      vim.g.openscad_load_snippets = true
      vim.g.openscad_pdf_cmd = "zathura"
      require("openscad")
    end,
    dependencies = {
      "ibhagwan/fzf-lua",
      "L3MON4D3/LuaSnip", -- optional
    },
  },

  -- OpenSCAD language server (installed via Mason as "openscad-lsp")
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        openscad_lsp = {},
      },
    },
  },
}
