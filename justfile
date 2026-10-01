# Neovim config: clone, `just setup`, set your terminal font, done.
# Prerequisites (not installed here): Homebrew, just, git, Xcode CLT, node >= 20.

set shell := ["bash", "-euo", "pipefail", "-c"]

config_src := justfile_directory() / "nvim"
config_dst := home_directory() / ".config" / "nvim"

default:
    @just --list

# Everything a fresh machine needs, in order. Safe to re-run.
setup: brew link plugins tools claude
    @echo
    @echo "Done. Set your terminal font to 'Hack Nerd Font Mono', then run nvim."

# Install Homebrew packages from the Brewfile.
brew:
    brew bundle --file "{{ justfile_directory() }}/Brewfile"

# Symlink ~/.config/nvim -> ./nvim (backs up anything already there).
link:
    #!/usr/bin/env bash
    set -euo pipefail
    src="{{ config_src }}"; dst="{{ config_dst }}"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "link ok: $dst -> $src"; exit 0
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        bak="$dst.bak-$(date +%Y%m%d-%H%M%S)"
        mv "$dst" "$bak"; echo "moved existing config to $bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"; echo "linked $dst -> $src"

# Install plugins at the commits pinned in lazy-lock.json, then compile tree-sitter parsers.
plugins:
    nvim --headless "+Lazy! restore" +qall
    nvim --headless -c "lua require('nvim-treesitter').install(require('config.tools').parsers):wait(600000)" +qall

# Install language servers and formatters listed in nvim/lua/config/tools.lua via Mason (missing ones only).
tools:
    NVIM_SKIP_MASON_ENSURE=1 nvim --headless -u "{{ config_src }}/init.lua" -l "{{ justfile_directory() }}/scripts/mason-install.lua"

# Install the Claude Code CLI (used by claudecode.nvim) if it's missing.
claude:
    @command -v claude >/dev/null && echo "claude ok: $(claude --version)" \
        || curl -fsSL https://claude.ai/install.sh | bash

# Update plugins to latest, then commit lazy-lock.json to pin them.
update:
    nvim --headless "+Lazy! update" +qall
    @echo "Review and commit nvim/lazy-lock.json."

# Report what's installed and what's missing.
doctor:
    #!/usr/bin/env bash
    ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
    bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; }
    check(){ if command -v "$1" >/dev/null; then ok "$1 $(${2:-true} 2>/dev/null | head -1)"; else bad "$1 missing${3:+ ($3)}"; fi; }
    echo "prerequisites:"
    check brew "brew --version"
    check git "git --version"
    check node "node --version" "needed by ts_ls and pyright"
    xcode-select -p >/dev/null 2>&1 && ok "xcode command line tools" || bad "xcode command line tools (xcode-select --install)"
    echo "brewfile:"
    check nvim "nvim --version"
    check tree-sitter "tree-sitter --version"
    check fzf "fzf --version"
    check rg "rg --version"
    check fd "fd --version"
    ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -qi "nerd" && ok "a Nerd Font is installed" || bad "no Nerd Font found (brew install --cask font-hack-nerd-font)"
    echo "optional:"
    check claude "claude --version" "just claude"
    echo "config:"
    if [ -L "{{ config_dst }}" ] && [ "$(readlink "{{ config_dst }}")" = "{{ config_src }}" ]; then ok "~/.config/nvim -> {{ config_src }}"; else bad "~/.config/nvim is not linked here (just link)"; fi
    want=$(nvim --headless -c "lua print(table.concat(require('config.tools').mason, ' '))" +qall 2>&1 | tr -d '\r')
    for p in $want; do [ -e ~/.local/share/nvim/mason/bin/$p ] || [ -d ~/.local/share/nvim/mason/packages/$p ] && ok "mason: $p" || bad "mason: $p (just tools)"; done
