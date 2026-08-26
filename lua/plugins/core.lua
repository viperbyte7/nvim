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
    opts = {
      preset = "modern",
      delay = 250,
      -- Visual selections use direct actions such as <leader>a; keep the popup
      -- available for normal-mode discovery without interrupting annotation.
      triggers = { { "<auto>", mode = "n" }, { "<leader>a", mode = "v" } },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>a", group = "Annotations" }, { "<leader>c", group = "Colorschemes" },
        { "<leader>d", group = "Display" }, { "<leader>g", group = "Codex / AI" },
        { "<leader>m", group = "Markdown" }, { "<leader>o", group = "Open elsewhere" },
        { "<leader>p", group = "Project / search" }, { "<leader>w", group = "Writing" },
        { "<leader>y", group = "Copy paths" },
        { "<leader>as", order = 1, desc = "Start annotation session" },
        { "<leader>ar", order = 2, desc = "Resume annotation session" },
        { "<leader>ac", order = 3, desc = "Concise annotation", mode = "v" },
        { "<leader>am", order = 4, desc = "Multiline annotation", mode = "v" },
        { "<leader>aq", order = 5, desc = "Stop annotation session" },
        { "<leader>aw", order = 6, desc = "Toggle annotation panel" },
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
