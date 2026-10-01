-- Git commands inside Neovim: status buffer, commit, push, blame, conflicts.
return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  keys = {
    { "<leader>gG", "<cmd>G<CR>", desc = "Fugitive status" },
    { "<leader>gP", "<cmd>G push<CR>", desc = "Git push" },
    { "<leader>gL", "<cmd>G log --oneline -30<CR>", desc = "Git log" },
  },
}
