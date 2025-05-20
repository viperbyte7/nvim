-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- THE FOLLOWING IS SET IN A PARENT LUA SCRIPT
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
      require("telescope").setup({})
      end,
    },
    {
      "fraso-dev/nvim-listchars",
      event = "BufEnter", -- Load plugin on buffer enter
      config = function()
        require("nvim-listchars").setup({
          save_state = false, -- Do not persist toggle state
          listchars = {
            trail = "-",
            eol = "↲",
            tab = "» ",
            space = "·",
        },
        notifications = true, -- Enable notifications on toggle
        exclude_filetypes = { "markdown" }, -- Disable in markdown files
        lighten_step = 10, -- Adjust color brightness step
        })
        end,
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        style = "night", -- Options: "storm", "moon", "night", "day"
        transparent = false,
        terminal_colors = true
      },
      config = function(_, opts)
        require("tokyonight").setup(opts)
	-- vim.cmd.colorscheme("tokyonight")
      end,
    },
    {
      "navarasu/onedark.nvim",
      priority = 1001, -- make sure to load this before all the other start plugins
      config = function()
        require('onedark').setup {
          style = 'warmer' -- options are dark, darker, cool, deep, warm, warmer
        }
        -- Enable theme
        -- require('onedark').load()
	      -- vim.cmd.colorscheme("onedark")
      end
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "pyright", "ts_ls" },
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        local servers = { "pyright", "ts_ls" }

        for _, server in ipairs(servers) do
          lspconfig[server].setup({})
        end
      end,
    },
    {
      "Exafunction/windsurf.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
      },
      config = function()
        require("codeium").setup({
        })
      end
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

