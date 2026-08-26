-- Small, predictable editor automations.
local group = vim.api.nvim_create_augroup("WritingEnvironment", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function(args)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = false
    pcall(vim.treesitter.start, args.buf, "markdown")
  end,
})
