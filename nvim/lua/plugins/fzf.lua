-- Fuzzy finder for files, text, buffers, help, etc.
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-mini/mini.icons" },
  cmd = "FzfLua",
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>FzfLua helptags<CR>", desc = "Help" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent" },
    { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
    { "<leader>/", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "Grep buffer" },
    -- Git, repo-wide (gitsigns handles per-buffer hunks)
    { "<leader>gg", "<cmd>FzfLua git_status<CR>", desc = "Changed files" },
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits (repo)" },
    { "<leader>gC", "<cmd>FzfLua git_bcommits<CR>", desc = "Commits (this file)" },
    { "<leader>go", "<cmd>FzfLua git_branches<CR>", desc = "Branches (checkout)" },
  },
  opts = {},
}
