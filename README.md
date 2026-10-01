# nvim

A hand-built Neovim config on lazy.nvim. Everything lives in `nvim/`; the rest of
this repo installs it.

## Prerequisites

Installed by you, not by this repo:

- [Homebrew](https://brew.sh)
- `just` (`brew install just`)
- git and the Xcode Command Line Tools (`xcode-select --install`)
- node 20 or newer (the TypeScript and Python language servers run on it)

## Setup

```sh
git clone <this repo> ~/code/nvim
cd ~/code/nvim
just setup
```

Then set your terminal font to **Hack Nerd Font Mono** and run `nvim`. The first
launch finishes any remaining plugin and parser work.

`just setup` is idempotent. It runs, in order:

| recipe    | does                                                                  |
|-----------|-----------------------------------------------------------------------|
| `brew`    | installs the Brewfile: neovim, tree-sitter-cli, fzf, ripgrep, fd, font |
| `link`    | symlinks `~/.config/nvim` here, backing up anything already there      |
| `plugins` | installs plugins at the commits in `lazy-lock.json`, compiles parsers  |
| `tools`   | installs language servers and formatters via Mason                     |
| `claude`  | installs the Claude Code CLI if missing                                |

`just doctor` reports what's present and what isn't. `just update` upgrades
plugins; commit the new `lazy-lock.json` afterwards.

## Layout

```
nvim/
├── init.lua                 requires the three config modules, in order
├── lazy-lock.json           pinned plugin commits (committed on purpose)
└── lua/
    ├── config/
    │   ├── options.lua      editor options, leader = Space
    │   ├── keymaps.lua      plugin-free keymaps
    │   ├── autocmds.lua     terminal auto-insert, yank highlight, fzf fixes
    │   ├── lazy.lua         bootstraps lazy.nvim, imports plugins/
    │   └── tools.lua        Mason packages and tree-sitter parsers to ensure
    └── plugins/             one file per plugin, each returns a lazy spec
```

Add a plugin by adding a file to `lua/plugins/`. Add a language server by adding
its Mason package to `tools.lua` and its name to `vim.lsp.enable` in
`plugins/lsp.lua`. Add a parser to `tools.lua`.

## Per-project config

`exrc` is on, so a trusted `.nvim.lua` at a project root is loaded. Used for
things like routing a formatter through the project's own `just` recipe.
