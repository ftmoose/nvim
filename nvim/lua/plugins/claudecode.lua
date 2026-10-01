-- Claude Code in a split terminal, wired to Neovim: it sees your open buffers
-- and selection, and its edits arrive as diffs you accept or deny here.
return {
  "coder/claudecode.nvim",
  cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny" },
  opts = {
    terminal = {
      provider = "native", -- built-in :terminal, no extra plugin
      split_side = "right",
      split_width_percentage = 0.35,
    },
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<CR>", desc = "Resume session" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue last session" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>", desc = "Add current buffer as context" },
    { "<leader>as", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send selection to Claude" },
    -- In a diff Claude proposes:
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
  },
}
