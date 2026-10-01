-- Autocompletion. version = "1.*" pulls prebuilt binaries (no Rust needed).
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  opts = {
    keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> navigate, <C-space> open
    completion = { documentation = { auto_show = true } },
    sources = { default = { "lsp", "path", "buffer" } },
  },
}
