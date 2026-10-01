-- Entry point. Order matters: leader must be set before plugins load.
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
