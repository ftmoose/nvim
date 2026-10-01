-- Editor options. `:help 'optionname'` explains any of these.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.o

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"      -- keep gutter stable so text doesn't shift
o.cursorline = true
o.scrolloff = 8           -- keep lines visible above/below cursor
o.termguicolors = true
o.showmode = false        -- statusline shows mode; hide the "-- INSERT --" text
o.wrap = false
o.splitright = true
o.splitbelow = true

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true        -- case-sensitive only if the pattern has uppercase
o.inccommand = "split"    -- live preview for :s

-- Files
o.undofile = true         -- persistent undo across sessions
o.swapfile = false
o.updatetime = 250
o.timeoutlen = 300        -- faster which-key popup

-- System clipboard
vim.schedule(function()
  o.clipboard = "unnamedplus"
end)

-- Project-local config: run a trusted .nvim.lua found in cwd or any parent.
-- Neovim prompts on first load; `:trust` manages the allow list.
o.exrc = true
