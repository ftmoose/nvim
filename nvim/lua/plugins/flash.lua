-- Jump anywhere on screen (across windows) by typing a few characters and
-- then the label that appears next to the match. Also upgrades f/t/F/T.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash select node" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote (operator)" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash treesitter search" },
    { "<C-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle flash in / search" },
  },
}
