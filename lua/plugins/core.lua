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
      sort = { "manual" },
      -- Visual selections can use the context and annotation actions below;
      -- keep the popup available for discovery in both modes.
      triggers = { { "<auto>", mode = "n" }, { "<leader>", mode = "v" } },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        -- Top-level menu order.
        { "<leader>a", group = "Annotations" },
        { "<leader>c", group = "Colorschemes" },
        { "<leader>d", group = "Display" },
        { "<leader>m", group = "Markdown" },
        { "<leader>o", group = "Open elsewhere" },
        { "<leader>p", group = "Project / search" },
        { "<leader>v", group = "Windows" },
        { "<leader>w", group = "Writing" },
        { "<leader>y", group = "Copy / share" },

        -- Annotations: start/resume first, then create and manage notes.
        { "<leader>as", desc = "Start annotation session" },
        { "<leader>ar", desc = "Resume annotation session" },
        -- Visual annotation actions automatically start or resume Mole if needed.
        { "<leader>ac", desc = "Concise annotation (starts session if needed)", mode = "v" },
        { "<leader>am", desc = "Multiline annotation (starts session if needed)", mode = "v" },
        { "<leader>aq", desc = "Stop annotation session" },
        { "<leader>aw", desc = "Toggle annotation panel" },

        -- Colorschemes: common choices first, chooser last.
        { "<leader>ct", desc = "Use Tokyonight" }, { "<leader>cc", desc = "Use Catppuccin" },
        { "<leader>cg", desc = "Use Gruvbox" }, { "<leader>ck", desc = "Use Kanagawa" },
        { "<leader>co", desc = "Use Onedark" }, { "<leader>cr", desc = "Use Rose Pine" },
        { "<leader>ce", desc = "Use Everforest" }, { "<leader>cn", desc = "Use Nightfox" },
        { "<leader>cs", desc = "Choose colorscheme" },

        -- Display: broad visibility controls first.
        { "<leader>dz", desc = "Toggle all line numbers" },
        { "<leader>dn", desc = "Toggle relative numbers" },
        { "<leader>dv", desc = "Toggle visible characters" },

        -- Markdown: structural navigation before presentation tools.
        { "<leader>mo", desc = "Toggle Markdown outline" },
        { "<leader>mt", desc = "Toggle Markdown table of contents" },
        { "<leader>mm", desc = "Toggle inline rendering" },

        -- External applications: default application before named editors.
        { "<leader>of", desc = "Open in default application" }, { "<leader>ov", desc = "Open in VS Code" },
        { "<leader>oc", desc = "Open in Cursor" }, { "<leader>on", desc = "Open in Neovide" },

        -- Project/search: find files, search text, then utilities.
        { "<leader>pf", desc = "Find files" }, { "<leader>pg", desc = "Search project text" },
        { "<leader>ps", desc = "Search with prompt" }, { "<leader>pv", desc = "Open file browser (netrw)" },
        { "<leader>pl", desc = "Open Lazy" },

        -- Windows: directional focus, then layout controls.
        { "<leader>vh", desc = "Focus left window" }, { "<leader>vj", desc = "Focus down window" },
        { "<leader>vk", desc = "Focus up window" }, { "<leader>vl", desc = "Focus right window" },
        { "<leader>vH", desc = "Decrease window width" }, { "<leader>vL", desc = "Increase window width" },
        { "<leader>vJ", desc = "Decrease window height" }, { "<leader>vK", desc = "Increase window height" },
        { "<leader>v=", desc = "Equalize window sizes" }, { "<leader>vx", desc = "Maximize/restore current window" },

        -- Writing: focus, spelling, then wrapping.
        { "<leader>wz", desc = "Toggle distraction-free mode" },
        { "<leader>ws", desc = "Toggle spell check" }, { "<leader>ww", desc = "Toggle word wrap" },

        -- Paths: full path, project-relative path, then directory.
        { "<leader>yp", desc = "Copy full path" }, { "<leader>yr", desc = "Copy relative path" },
        { "<leader>yd", desc = "Copy containing folder" },
        { "<leader>yc", desc = "Copy selection with request", mode = "v" },
        { "<leader>ym", desc = "Copy selection with multiline request", mode = "v" },
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
