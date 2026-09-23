return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight-night") end,
  },
  { "navarasu/onedark.nvim", lazy = false, priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000, opts = { flavour = "mocha" } },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
}
