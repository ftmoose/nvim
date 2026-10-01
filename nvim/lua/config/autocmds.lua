-- Autocommands not tied to a plugin.
local aug = vim.api.nvim_create_augroup("user", { clear = true })

-- Terminals: start typing immediately when a terminal opens or when you move
-- into one. Skips terminals whose process has already exited.
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
  group = aug,
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "terminal" then return end
    local job = vim.b[ev.buf].terminal_job_id
    if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
      vim.cmd.startinsert()
    end
  end,
})

-- Briefly highlight what was yanked.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function() vim.hl.on_yank() end,
})

-- fzf-lua runs in a floating terminal; let it keep Ctrl-h/j/k/l (list
-- navigation) instead of the global window-switch terminal maps.
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = "fzf",
  callback = function(ev)
    for _, k in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
      vim.keymap.set("t", k, k, { buffer = ev.buf })
    end
  end,
})
