-- Git change markers in the gutter, plus per-hunk actions and blame.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Thicker bars, and colour the line number as well as the sign.
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "▁" },
      topdelete = { text = "▔" },
      changedelete = { text = "┃" },
      untracked = { text = "┆" },
    },
    numhl = true,
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigate hunks (falls back to vim diff jumps inside :diffthis)
      map("n", "]h", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
      end, "Next hunk")
      map("n", "[h", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
      end, "Prev hunk")

      -- Act on hunks
      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk (toggle)")
      map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selection")
      map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

      -- Inspect
      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<leader>gB", gs.blame, "Blame buffer")
      -- Diff toggles: open a side-by-side diff, or close it if one is open.
      -- gitsigns puts the comparison in a scratch buffer named gitsigns://...
      local function close_diff()
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)):match("^gitsigns://") then
            vim.api.nvim_win_close(w, true)
          end
        end
        vim.cmd("diffoff!")
      end
      local function toggle_diff(base)
        return function()
          if vim.wo.diff then close_diff() else gs.diffthis(base) end
        end
      end
      map("n", "<leader>gd", toggle_diff(), "Diff vs index (toggle)")
      map("n", "<leader>gD", toggle_diff("~"), "Diff vs HEAD (toggle)")
      map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle line blame")

      -- Show every hunk inline at once: highlight changed lines, show deleted
      -- lines as virtual text, and mark changed words. Press again to hide.
      map("n", "<leader>gv", function()
        local on = not require("gitsigns.config").config.linehl
        gs.toggle_linehl(on); gs.toggle_deleted(on); gs.toggle_word_diff(on)
        -- gitsigns only (re)builds the deleted-line previews when hunks change,
        -- which a toggle doesn't do; force the next update to treat them as changed.
        for _, bc in pairs(require("gitsigns.cache").cache) do bc.force_next_update = true end
        gs.refresh()
      end, "Toggle all hunks inline")


      -- Text object: select a hunk with `ih` (e.g. `vih`, `dih`)
      map({ "o", "x" }, "ih", gs.select_hunk, "Hunk")
    end,
  },
}
