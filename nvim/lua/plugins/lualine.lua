-- Statusline: mode, git branch, diff counts, diagnostics, filename, position.
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    options = { theme = "auto", section_separators = "", component_separators = "|" },
  },
}
