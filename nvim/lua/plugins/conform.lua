-- Formatting. Runs external formatters on save, falling back to the LSP
-- server's formatter when no external one is listed or installed.
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      python = { "ruff_format" },
      -- prettier only runs if it's on PATH or in node_modules/.bin;
      -- otherwise ts_ls formats.
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
    },
    -- Per-project overrides (e.g. a pinned rustfmt toolchain) belong in that
    -- project's .nvim.lua, loaded via 'exrc'. See options.lua.
    format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
  },
}
