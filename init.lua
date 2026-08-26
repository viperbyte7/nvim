-- Entry point for the document-first Neovim configuration.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
