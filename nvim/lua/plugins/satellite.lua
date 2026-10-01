-- Scrollbar in the right column with markers for git hunks (from gitsigns),
-- diagnostics, search matches, and marks.
return {
  "lewis6991/satellite.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    current_only = true, -- only in the active window; set false for all
    winblend = 30,
    handlers = {
      cursor = { enable = false },
      search = { enable = true },
      diagnostic = { enable = true },
      gitsigns = { enable = true },
      marks = { enable = true },
    },
    excluded_filetypes = { "fzf", "minifiles", "fugitive", "help" },
  },
}
