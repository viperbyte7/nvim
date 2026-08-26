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
      vim.keymap.set("v", "<leader>am", function()
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
