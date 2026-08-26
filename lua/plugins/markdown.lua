return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = { file_types = { "markdown" } },
    keys = { { "<leader>mm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle inline rendering" } },
  },
}
