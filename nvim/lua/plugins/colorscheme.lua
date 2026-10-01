-- Colorschemes. The one named in `colorscheme` below loads at startup; the
-- others are installed so `:colorscheme <name>` can switch live for comparison.
return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = false, -- true for ayu-mirage
        terminal = true,
      })
      vim.cmd.colorscheme("ayu-dark")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    config = function()
      -- Louder git gutter colours; tokyonight's are muted on purpose.
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "tokyonight*",
        callback = function()
          local set = vim.api.nvim_set_hl
          set(0, "GitSignsAdd", { fg = "#4fd6be", bold = true })
          set(0, "GitSignsChange", { fg = "#ffc777", bold = true })
          set(0, "GitSignsDelete", { fg = "#ff757f", bold = true })
          set(0, "GitSignsAddNr", { fg = "#4fd6be" })
          set(0, "GitSignsChangeNr", { fg = "#ffc777" })
          set(0, "GitSignsDeleteNr", { fg = "#ff757f" })
        end,
      })
    end,
  },
}
