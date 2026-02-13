return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-left>",  "<cmd>TmuxNavigateLeft<cr>" },
    { "<c-down>",  "<cmd>TmuxNavigateDown<cr>" },
    { "<c-up>",    "<cmd>TmuxNavigateUp<cr>" },
    { "<c-right>", "<cmd>TmuxNavigateRight<cr>" },
    { "<c-\\>",    "<cmd>TmuxNavigatePrevious<cr>" },
  },
}
