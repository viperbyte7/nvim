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
        -- Top-level menu order.
        { "<leader>a", order = 1, group = "Annotations" },
        { "<leader>c", order = 2, group = "Colorschemes" },
        { "<leader>d", order = 3, group = "Display" },
        { "<leader>g", order = 4, group = "Codex / AI" },
        { "<leader>m", order = 5, group = "Markdown" },
        { "<leader>o", order = 6, group = "Open elsewhere" },
        { "<leader>p", order = 7, group = "Project / search" },
        { "<leader>w", order = 8, group = "Writing" },
        { "<leader>y", order = 9, group = "Copy paths" },

        -- Annotations: start/resume first, then create and manage notes.
        { "<leader>as", order = 1, desc = "Start annotation session" },
        { "<leader>ar", order = 2, desc = "Resume annotation session" },
        { "<leader>ac", order = 3, desc = "Concise annotation", mode = "v" },
        { "<leader>am", order = 4, desc = "Multiline annotation", mode = "v" },
        { "<leader>aq", order = 5, desc = "Stop annotation session" },
        { "<leader>aw", order = 6, desc = "Toggle annotation panel" },

        -- Colorschemes: common choices first, chooser last.
        { "<leader>ct", order = 1, desc = "Use Tokyonight" },
        { "<leader>cc", order = 2, desc = "Use Catppuccin" },
        { "<leader>cg", order = 3, desc = "Use Gruvbox" },
        { "<leader>ck", order = 4, desc = "Use Kanagawa" },
        { "<leader>co", order = 5, desc = "Use Onedark" },
        { "<leader>cr", order = 6, desc = "Use Rose Pine" },
        { "<leader>ce", order = 7, desc = "Use Everforest" },
        { "<leader>cn", order = 8, desc = "Use Nightfox" },
        { "<leader>cs", order = 9, desc = "Choose colorscheme" },

        -- Display: broad visibility controls first.
        { "<leader>dz", order = 1, desc = "Toggle all line numbers" },
        { "<leader>dn", order = 2, desc = "Toggle relative numbers" },
        { "<leader>dv", order = 3, desc = "Toggle visible characters" },

        -- Codex: open, provide context, review, then manage the session.
        { "<leader>gg", order = 1, desc = "Toggle Codex" },
        { "<leader>gf", order = 2, desc = "Add current file to Codex" },
        { "<leader>gs", order = 3, desc = "Send selection to Codex", mode = "v" },
        { "<leader>gr", order = 4, desc = "Review file and annotations with Codex" },
        { "<leader>gc", order = 5, desc = "Continue Codex session" },
        { "<leader>gx", order = 6, desc = "Stop Codex" },

        -- Markdown: structural navigation before presentation tools.
        { "<leader>mo", order = 1, desc = "Toggle Markdown outline" },
        { "<leader>mt", order = 2, desc = "Toggle Markdown table of contents" },
        { "<leader>mm", order = 3, desc = "Toggle inline rendering" },

        -- External applications: default application before named editors.
        { "<leader>of", order = 1, desc = "Open in default application" },
        { "<leader>ov", order = 2, desc = "Open in VS Code" },
        { "<leader>oc", order = 3, desc = "Open in Cursor" },
        { "<leader>on", order = 4, desc = "Open in Neovide" },

        -- Project/search: find files, search text, then utilities.
        { "<leader>pf", order = 1, desc = "Find files" },
        { "<leader>pg", order = 2, desc = "Search project text" },
        { "<leader>ps", order = 3, desc = "Search selected string" },
        { "<leader>pv", order = 4, desc = "Open file browser (netrw)" },
        { "<leader>pl", order = 5, desc = "Open Lazy" },

        -- Writing: focus, spelling, then wrapping.
        { "<leader>wz", order = 1, desc = "Toggle distraction-free mode" },
        { "<leader>ws", order = 2, desc = "Toggle spell check" },
        { "<leader>ww", order = 3, desc = "Toggle word wrap" },

        -- Paths: full path, project-relative path, then directory.
        { "<leader>yp", order = 1, desc = "Copy full path" },
        { "<leader>yr", order = 2, desc = "Copy relative path" },
        { "<leader>yd", order = 3, desc = "Copy containing folder" },
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
