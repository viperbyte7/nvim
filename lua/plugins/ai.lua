return {
  {
    "nwiizo/codex.nvim",
    cmd = {
      "Codex", "CodexOpen", "CodexFocus", "CodexResume", "CodexContinue", "CodexReview", "CodexPrompt",
      "CodexSend", "CodexSendVisual", "CodexAdd", "CodexAddVisual", "CodexDiff", "CodexInterrupt",
      "CodexStatus", "CodexStop", "CodexHealth",
    },
    keys = {
      { "<leader>gg", "<cmd>CodexFocus<cr>", desc = "Toggle Codex" },
      { "<leader>gf", "<cmd>CodexAdd<cr>", desc = "Add current file to Codex" },
      { "<leader>gr", desc = "Review file and annotations with Codex" },
      { "<leader>gs", ":<C-U>CodexSendVisual<CR>", mode = "v", desc = "Send selection to Codex" },
      { "<leader>ge", mode = "v", desc = "Edit selection with Codex" },
      { "<leader>gc", "<cmd>CodexContinue<cr>", desc = "Continue Codex session" },
      { "<leader>gx", "<cmd>CodexStop<cr>", desc = "Stop Codex" },
    },
    opts = {
      backend = "terminal", cwd = "root", focus_after_send = false,
      terminal = { layout = "split", split_side = "right", split_width_percentage = 0.35, auto_insert = true, auto_close = true },
    },
    config = function(_, opts)
      local codex = require("codex")
      codex.setup(opts)

      vim.keymap.set("v", "<leader>ge", function()
        local instruction = nil
        vim.ui.input({ prompt = "Codex edit: " }, function(input)
          instruction = input and vim.trim(input) or ""
          if instruction == "" then
            vim.notify("Codex edit cancelled", vim.log.levels.INFO)
            return
          end

          if vim.bo.modified then
            vim.cmd("silent write")
          end

          if not codex.add_visual(vim.api.nvim_get_current_buf()) then
            return
          end

          codex.prompt(table.concat({
            "Edit only the exact selected text in the current file.",
            "Preserve all text outside the selection and do not modify unrelated files.",
            "Apply this requested change:",
            instruction,
            "After making the edit, briefly summarize what changed.",
          }, "\n"))
        end)
      end, { desc = "Edit selection with Codex" })

      vim.keymap.set("n", "<leader>gr", function()
        local paths, file = require("utils.paths"), require("utils.paths").current_file()
        if not file then
          vim.notify("Open a file before requesting a Codex review", vim.log.levels.WARN)
          return
        end
        vim.cmd("CodexAdd " .. vim.fn.fnameescape(file))
        local review = paths.annotation_file(file)
        if vim.fn.filereadable(review) == 1 then vim.cmd("CodexAdd " .. vim.fn.fnameescape(review)) end
        vim.cmd("CodexPrompt Review the Markdown file and annotation sidecar. Summarize requested changes before editing.")
      end, { desc = "Review file and annotations with Codex" })
    end,
  },
}
