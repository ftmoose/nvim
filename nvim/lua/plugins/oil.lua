-- File explorer as an editable buffer: edit names, delete lines, :w to apply.
-- Replaces netrw, so `nvim .` opens oil.
return {
  "stevearc/oil.nvim",
  enabled = false, -- trying mini.files; flip to true (and disable mini.files) to come back
  lazy = false,
  dependencies = { "nvim-mini/mini.icons" },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
  },
  opts = {
    default_file_explorer = true,
    view_options = { show_hidden = true },
    skip_confirm_for_simple_edits = true,
  },
}
