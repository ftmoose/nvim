-- LSP. Neovim 0.12 has the client built in; nvim-lspconfig just supplies
-- per-server defaults and mason installs the server binaries.
return {
  {
    "mason-org/mason.nvim",
    opts = {}, -- run :Mason to browse/install servers
    config = function(_, opts)
      require("mason").setup(opts)

      -- Install anything in config/tools.lua that's missing. Only touches the
      -- network when something is absent, so normal startups stay offline.
      if vim.env.NVIM_SKIP_MASON_ENSURE then return end -- `just tools` does this itself
      local registry = require("mason-registry")
      local want = require("config.tools").mason
      local function missing()
        local m = {}
        for _, name in ipairs(want) do
          local ok, pkg = pcall(registry.get_package, name)
          if not ok or not pkg:is_installed() then m[#m + 1] = name end
        end
        return m
      end
      if #missing() > 0 then
        registry.refresh(function()
          for _, name in ipairs(missing()) do
            local ok, pkg = pcall(registry.get_package, name)
            if ok then
              vim.notify("mason: installing " .. name)
              pkg:install()
            end
          end
        end)
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      -- Add servers here. Names match nvim-lspconfig's lsp/*.lua files.
      -- Install the binary with :MasonInstall <name> (e.g. lua-language-server).
      -- ts_ls handles .ts/.tsx/.js/.jsx. rust_analyzer comes from the mise
      -- toolchain on PATH (not Mason) so it matches the project's rustc.
      vim.lsp.enable({ "lua_ls", "ts_ls", "rust_analyzer", "pyright", "ruff" })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { features = {} },
            check = { command = "clippy" },
            -- Formatting is handled by conform.nvim (see conform.lua), which
            -- picks the toolchain pinned in the project's mise.toml.
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { library = { vim.env.VIMRUNTIME } },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.diagnostic.config({ virtual_text = true, severity_sort = true })

      -- Buffer-local keymaps once a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "Format")
        end,
      })
    end,
  },
}
