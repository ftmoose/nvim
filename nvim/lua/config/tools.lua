-- Single source of truth for external tools the config installs itself.
-- Read by lsp.lua and treesitter.lua at startup, and by `just tools` / `just plugins`.
return {
  -- Mason package names (:Mason lists them). Installed on startup if missing.
  mason = {
    "lua-language-server",
    "typescript-language-server",
    "pyright",
    "ruff",
    "stylua",
  },
  -- Tree-sitter parsers, compiled on startup if missing.
  parsers = {
    "lua", "vim", "vimdoc", "query", "bash", "json", "markdown", "markdown_inline",
    "typescript", "tsx", "javascript", "rust", "python", "toml", "yaml",
  },
}
