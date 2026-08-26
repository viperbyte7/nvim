-- Editor behavior. This configuration is intentionally document-first.
local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.list = false
opt.listchars = { trail = "-", eol = "↲", tab = "» ", space = "·" }
opt.conceallevel = 2
opt.mouse = "a"
opt.shortmess:append("c")

vim.g.have_nerd_font = true
