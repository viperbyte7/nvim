return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "modern", delay = 250 },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>a", group = "Annotations" }, { "<leader>c", group = "Colorschemes" },
        { "<leader>d", group = "Display" }, { "<leader>g", group = "Codex / AI" },
        { "<leader>m", group = "Markdown" }, { "<leader>o", group = "Open elsewhere" },
        { "<leader>p", group = "Project / search" }, { "<leader>w", group = "Writing" },
        { "<leader>y", group = "Copy paths" },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
