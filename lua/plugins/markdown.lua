return {
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "<leader>mo", "<cmd>Outline<cr>", desc = "Toggle Markdown outline" } },
    opts = {
      outline_window = {
        position = "right",
        width = 40,
        relative_width = false,
        auto_close = false,
        auto_jump = true,
        focus_on_open = true,
        show_numbers = false,
        show_relative_numbers = false,
      },
      providers = { priority = { "markdown" } },
      guides = { enabled = true },
      symbol_folding = { autofold_depth = 1 },
      preview_window = { auto_preview = true },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = { file_types = { "markdown" } },
    keys = { { "<leader>mm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle inline rendering" } },
  },
}
