-- Use spaces for indent rather than tabs
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.tabstop = 2           -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2        -- Number of spaces to use for each step of (auto)indent
vim.opt.softtabstop = 2       -- Number of spaces that a <Tab> counts for while performing editing operations

-- turn on highlight search
vim.opt.hlsearch = true

-- 24 bit color detection for terminals. Apply theme as appropriate.
if vim.env.COLORTERM == 'truecolor' or vim.env.COLORTERM == '24bit' then
  vim.opt.termguicolors = true
  vim.cmd('colorscheme onedark')  -- or any other true color scheme
else
  vim.opt.termguicolors = false
  vim.cmd('colorscheme slate')     -- fallback for limited color support
end

vim.opt.termguicolors = true

