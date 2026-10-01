-- Popup showing available keymaps after you press a prefix.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>c", group = "code" },
      { "<leader>t", group = "terminal" },
      { "<leader>a", group = "ai" },
    },
  },
}
