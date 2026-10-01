-- Small mini.nvim modules, one spec each.
return {
  {
    -- Icons for fzf-lua and lualine. mock_nvim_web_devicons lets plugins that
    -- expect nvim-web-devicons use these instead.
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {},
    config = function(_, opts)
      require("mini.icons").setup(opts)
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    -- Auto-close brackets and quotes as you type.
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    -- File explorer as Finder-style columns. Edit the listing, then `=` to apply.
    "nvim-mini/mini.files",
    lazy = false,
    keys = {
      {
        "-",
        function()
          local buf = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.filereadable(buf) == 1 and buf or vim.uv.cwd()
          require("mini.files").open(path, true)
        end,
        desc = "Open file explorer",
      },
    },
    opts = {
      windows = { preview = true, width_focus = 30, width_preview = 50 },
      options = { use_as_default_explorer = true }, -- disables netrw
    },
    init = function()
      -- Inside the explorer: Esc closes; the find keys close it first so the
      -- picked file opens in the real window, not the explorer's float.
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.data.buf_id, desc = desc })
          end
          map("<Esc>", function() require("mini.files").close() end, "Close explorer")
          map("<leader>ff", function() require("mini.files").close(); vim.cmd("FzfLua files") end, "Files")
          map("<leader>fg", function() require("mini.files").close(); vim.cmd("FzfLua live_grep") end, "Grep")
          map("<leader>fr", function() require("mini.files").close(); vim.cmd("FzfLua oldfiles") end, "Recent")
        end,
      })

      -- `nvim .` : go straight to the file picker instead of an empty
      -- directory buffer. `-` opens the explorer when you want to browse.
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(ev)
          local name = vim.api.nvim_buf_get_name(ev.buf)
          -- Once per directory buffer: closing the picker re-enters this
          -- buffer for a moment, which would otherwise open a second picker.
          if vim.fn.isdirectory(name) == 1 and not vim.b[ev.buf].dir_picker_shown then
            vim.b[ev.buf].dir_picker_shown = true
            vim.schedule(function() require("fzf-lua").files({ cwd = name }) end)
          end
        end,
      })
    end,
  },
}
