return {
  {
    "zion-off/mole.nvim",
    cmd = { "MoleStart", "MoleStop", "MoleResume", "MoleToggle", "MoleStartHere", "MoleResumeHere" },
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>ac", mode = "v", desc = "Concise annotation" },
      { "<leader>am", mode = "v", desc = "Multiline annotation" },
      { "<leader>as", mode = "n", desc = "Start annotation session" },
      { "<leader>aq", mode = "n", desc = "Stop annotation session" },
      { "<leader>ar", mode = "n", desc = "Resume annotation session" },
      { "<leader>aw", mode = "n", desc = "Toggle annotation panel" },
    },
    opts = {
      session_dir = vim.fn.getcwd(), capture_mode = "snippet", auto_open_panel = true, virtual_text = false,
      keys = {
        annotate = "<leader>ac", start_session = "<leader>as", stop_session = "<leader>aq",
        resume_session = "<leader>ar", toggle_window = "<leader>aw",
        jump_to_location = { "<CR>", "gd" }, next_annotation = "]a", prev_annotation = "[a",
      },
    },
    config = function(_, opts)
      local mole = require("mole")
      mole.setup(opts)
      local function configure()
        local path, name = vim.fn.expand("%:p"), vim.fn.expand("%:t")
        if path == "" or name == "" then
          vim.notify("Open a file before starting annotations", vim.log.levels.WARN)
          return false
        end
        mole.config.session_dir = vim.fn.expand("%:p:h")
        mole.config.session_name = name .. ".review"
        return true
      end
      local function start() if configure() then mole.start_session() end end
      local function resume() if configure() then mole.resume_session() end end
      vim.keymap.set("n", "<leader>as", start, { desc = "Start annotation session beside file" })
      vim.keymap.set("n", "<leader>ar", resume, { desc = "Resume annotation session beside file" })
      local function ensure_session()
        local session = require("mole.session")
        if session.state.active then return true end

        local source_win = vim.api.nvim_get_current_win()
        if not configure() then return false end
        mole.start_session()

        -- Mole opens the side panel in the current window; return to the
        -- selected Markdown buffer before capturing its Visual selection.
        if vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
        end
        return session.state.active
      end
      vim.keymap.set("v", "<leader>ac", function()
        if ensure_session() then mole.annotate() end
      end, { desc = "Add concise annotation" })
      vim.keymap.set("v", "<leader>am", function()
        if not ensure_session() then return end
        mole.annotate()
        vim.schedule(function()
          vim.api.nvim_feedkeys(vim.keycode("<C-e>"), "t", false)
        end)
      end, { desc = "Add multiline annotation" })
      vim.api.nvim_create_user_command("MoleStartHere", start, { desc = "Start Mole beside current file" })
      vim.api.nvim_create_user_command("MoleResumeHere", resume, { desc = "Resume Mole beside current file" })
    end,
  },
}
