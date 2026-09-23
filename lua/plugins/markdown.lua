local function toggle_markdown_conceal()
  local enabled = vim.wo.conceallevel > 0
  vim.wo.conceallevel = enabled and 0 or 2
  vim.wo.concealcursor = ""
  vim.notify("Markdown conceal: " .. (enabled and "off" or "on"))
end

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
    opts = {
      enabled = false,
      file_types = { "markdown" },
      anti_conceal = { enabled = false },
    },
    keys = {
      { "<leader>mm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle inline rendering" },
      { "<leader>mc", toggle_markdown_conceal, desc = "Toggle Markdown conceal" },
    },
  },
}
