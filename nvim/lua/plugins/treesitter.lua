-- Syntax highlighting and indentation via tree-sitter.
-- Uses the `main` branch API (required for Neovim 0.12).
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local langs = require("config.tools").parsers
    require("nvim-treesitter").install(langs)

    -- Start highlighting/indent for any buffer whose language has a parser.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and pcall(vim.treesitter.start, ev.buf, lang) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
