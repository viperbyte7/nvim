-- Set keymaps
-- vim.g.mapleader = " "  -- this is set in a parent lua script.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer" })
vim.keymap.set("n", "<leader>v", vim.cmd.ListcharsToggle, { desc = "Toggle visible characters"})
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy, { desc = "Lazy Plugin Manager" })

-- Toggle relative line numbers keymaps
vim.opt.number = true
vim.keymap.set("n", "<leader>n", function()
  -- Flip the current value of `relativenumber`
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
  -- Opional: echo the new state to the command line
  if vim.opt.relativenumber:get() then
    print("Relative numbers: ON")
  else
    print("Relative numbers: OFF")
  end
end, { desc = "Toggle relative line numbers" })

-- Telescope Keymaps
local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Fuzzy Find Files" })
vim.keymap.set("n", "<leader>pg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- Codium Keymaps
vim.keymap.set("n", "<leader>c", function()
  vim.cmd("Codeium Chat")
end, { desc = "Open Codeium Chat", silent = true })


