-- Build a temporary Markdown request for the system clipboard.
-- This is deliberately independent of Mole and any AI integration.
local M = {}

local function normalize(path)
  return vim.fn.fnamemodify(vim.fn.expand(path), ":p"):gsub("/$", "")
end

local function project_root(path)
  local marker = vim.fs.find({ ".git", "pyproject.toml", "package.json", "Makefile" }, {
    path = vim.fs.dirname(path),
    upward = true,
    limit = 1,
  })[1]
  return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

function M.visual_selection()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Visual marks are finalized when Visual mode exits. Do that before reading
  -- them so mappings invoked directly from a live selection are reliable.
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "x", false)
  end

  local start = vim.api.nvim_buf_get_mark(bufnr, "<")
  local finish = vim.api.nvim_buf_get_mark(bufnr, ">")
  if start[1] == 0 or finish[1] == 0 then return nil end

  local start_line, end_line = start[1], finish[1]
  local start_col, end_col = start[2], finish[2]
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  mode = vim.fn.visualmode()
  local text
  if mode == "V" then
    text = table.concat(vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false), "\n")
  else
    local selected = vim.api.nvim_buf_get_text(bufnr, start_line - 1, start_col, end_line - 1, end_col + 1, {})
    text = table.concat(selected, "\n")
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then return nil end

  local absolute_path = normalize(path)
  local root = normalize(project_root(absolute_path))
  local relative_path = absolute_path:sub(#root + 2)
  if relative_path == "" or relative_path == absolute_path then
    relative_path = vim.fn.fnamemodify(absolute_path, ":.")
  end

  return {
    bufnr = bufnr,
    path = absolute_path,
    relative_path = relative_path,
    working_directory = vim.fn.getcwd(),
    project_root = root,
    directory = normalize(vim.fn.fnamemodify(absolute_path, ":h")),
    filetype = vim.bo[bufnr].filetype,
    start_line = start_line,
    end_line = end_line,
    start_col = start_col + 1,
    end_col = end_col + 1,
    mode = mode,
    text = text,
    modified = vim.bo[bufnr].modified,
  }
end

local function fence_for(text)
  local longest = 0
  for run in text:gmatch("`+") do longest = math.max(longest, #run) end
  return string.rep("`", math.max(3, longest + 1))
end

local function payload(selection, instruction)
  local fence = fence_for(selection.text)
  local lines = {
    "# Neovim Context",
    "",
    "- File: " .. selection.path,
    "- Project-relative path: " .. selection.relative_path,
    "- Working directory: " .. selection.working_directory,
    "- Working-directory path: " .. vim.fn.fnamemodify(selection.path, ":."),
    "- Project root: " .. selection.project_root,
    "- Containing folder: " .. selection.directory,
    "- File type: " .. (selection.filetype ~= "" and selection.filetype or "plain text"),
    "- Lines: " .. selection.start_line .. "-" .. selection.end_line,
    "- Columns: "
      .. (selection.mode == "V" and "entire line(s)" or (selection.start_col .. "-" .. selection.end_col)),
    "- Selection mode: " .. selection.mode,
    "- Captured: " .. os.date("%Y-%m-%d %H:%M:%S %z"),
    "- Buffer modified: " .. (selection.modified and "yes" or "no"),
    "",
    "## Request",
    "",
    instruction,
    "",
    "## Selected text",
    "",
    fence .. (selection.filetype or ""),
    selection.text,
    fence,
  }
  return table.concat(lines, "\n")
end

function M.copy_selection(selection, opts)
  opts = opts or {}
  if not selection then
    vim.notify("Select text from a named file first", vim.log.levels.WARN)
    return false
  end
  vim.fn.setreg("+", payload(selection, opts.instruction or ""))
  vim.notify("Copied selection and request to the system clipboard")
  return true
end

function M.prompt_visual(opts)
  opts = opts or {}
  local selection = M.visual_selection()
  if not selection then
    vim.notify("Select text from a named file first", vim.log.levels.WARN)
    return false
  end

  vim.ui.input({ prompt = opts.prompt or "Request: " }, function(input)
    input = input and vim.trim(input) or ""
    if input == "" then
      vim.notify("Context copy cancelled", vim.log.levels.INFO)
      return
    end
    M.copy_selection(selection, { instruction = input })
  end)
  return true
end

function M.prompt_visual_multiline()
  local selection = M.visual_selection()
  if not selection then
    vim.notify("Select text from a named file first", vim.log.levels.WARN)
    return false
  end

  local source_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.min(90, math.max(50, (ui and ui.width or vim.o.columns) - 8))
  local height = math.min(14, math.max(6, (ui and ui.height or vim.o.lines) - 8))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor(((ui and ui.width or vim.o.columns) - width) / 2),
    row = math.floor(((ui and ui.height or vim.o.lines) - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Context request ",
    title_pos = "right",
    footer = " <C-Space>/<C-Enter> copy  <Esc>/q cancel ",
    footer_pos = "left",
  })
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.cmd("startinsert")

  local closed = false
  local function close()
    if closed then return end
    closed = true
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    if vim.api.nvim_win_is_valid(source_win) then vim.api.nvim_set_current_win(source_win) end
  end

  local function cancel()
    close()
    vim.notify("Context copy cancelled", vim.log.levels.INFO)
  end

  local function confirm()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    while #lines > 0 and vim.trim(lines[#lines]) == "" do table.remove(lines) end
    local instruction = vim.trim(table.concat(lines, "\n"))
    close()
    if instruction == "" then
      vim.notify("Context copy cancelled", vim.log.levels.INFO)
      return
    end
    M.copy_selection(selection, { instruction = instruction })
  end

  -- This is a normal scratch buffer, like Mole's expanded input. Keep the
  -- standard insert/normal-mode editing commands available; only the small
  -- set of request actions below is buffer-local.
  local map_opts = { buffer = buf, noremap = true, silent = true }
  vim.keymap.set({ "i", "n" }, "<C-CR>", confirm, map_opts)
  vim.keymap.set({ "i", "n" }, "<C-Space>", confirm, map_opts)
  -- In Insert mode <Esc> should enter Normal mode so motions and basic edits
  -- work normally. Press <Esc> again in Normal mode to cancel, as in Mole.
  vim.keymap.set("n", "<Esc>", cancel, map_opts)
  vim.keymap.set("n", "q", cancel, map_opts)
  return true
end

return M
