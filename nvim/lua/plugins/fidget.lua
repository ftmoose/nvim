-- LSP progress (indexing, cargo check) in the bottom-right corner, plus
-- vim.notify messages routed through the same panel.
return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    notification = {
      override_vim_notify = true,
      window = { winblend = 0 }, -- opaque, so it reads on any background
    },
    progress = {
      display = { done_ttl = 2 }, -- seconds a finished task stays visible
    },
  },
}
