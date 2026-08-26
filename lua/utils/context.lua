-- Build portable Markdown context blocks for the system clipboard.
-- This intentionally has no Codex or other AI dependency: paste the result
-- into any terminal, editor, chat, or review tool.
local M = {}

local paths = require("utils.paths")

local function normalize(path)
  return vim.fn.fnamemodify(vim.fn.expand(path), ":p"):gsub("/$", "")
end

local function read_lines(path)
  if vim.fn.filereadable(path) ~= 1 then return nil end
  return vim.fn.readfile(path)
end

local function project_root(path)
  local marker = vim.fs.find({ ".git", "pyproject.toml", "package.json", "Makefile" }, {
    path = vim.fs.dirname(path),
    upward = true,
    limit = 1,
  })[1]
  return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

local function annotation_location(line)
  local file, start_line, end_line = line:match("`([^`]+):(%d+)-(%d+)`")
  if file then return file, tonumber(start_line), tonumber(end_line) end
  file, start_line = line:match("`([^`]+):(%d+)`")
  if file then return file, tonumber(start_line), tonumber(start_line) end
  return nil
end

local function resolve_annotation_file(file, project_dir)
  local candidates = {}
  if project_dir and not file:match("^/") then
    table.insert(candidates, project_dir .. "/" .. file)
  end
  table.insert(candidates, file)

  for _, candidate in ipairs(candidates) do
    local absolute = normalize(candidate)
    if vim.fn.filereadable(absolute) == 1 then return absolute end
  end
  return nil
end

local function annotation_source(source_file)
  local sidecar = paths.annotation_file(source_file)
  local ok, session = pcall(require, "mole.session")
  if ok and session.state.active and normalize(session.state.file_path) == normalize(sidecar) then
    local bufnr = session.state.bufnr
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      return sidecar, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    end
  end
  return sidecar, read_lines(sidecar)
end

local function related_annotations(source_file, start_line, end_line)
  local sidecar, lines = annotation_source(source_file)
  if not lines then return sidecar, {} end

  local project_dir
  for _, line in ipairs(lines) do
    project_dir = line:match("^%*%*Project:%*%* (.+)$") or project_dir
  end

  local blocks = {}
  local current
  local function finish()
    if not current then return end
    local resolved = current.file and resolve_annotation_file(current.file, project_dir)
    if resolved == normalize(source_file)
      and current.start_line <= end_line
      and current.end_line >= start_line
    then
      table.insert(blocks, current.lines)
    end
    current = nil
  end

  for _, line in ipairs(lines) do
    local file, annotation_start, annotation_end = annotation_location(line)
    if file then
      finish()
      current = {
        file = file,
        start_line = annotation_start,
        end_line = annotation_end,
        lines = { line },
      }
    elseif current then
      table.insert(current.lines, line)
    end
  end
  finish()

  return sidecar, blocks
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

  local mode = vim.fn.visualmode()
  local text
  if mode == "V" then
    text = table.concat(vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false), "\n")
  else
    local selected = vim.api.nvim_buf_get_text(bufnr, start_line - 1, start_col, end_line - 1, end_col + 1, {})
    text = table.concat(selected, "\n")
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then return nil end
  local root = normalize(project_root(path))
  local project_relative = path:sub(#root + 2)
  if project_relative == "" or project_relative == path then
    project_relative = vim.fn.fnamemodify(path, ":.")
  end
  return {
    bufnr = bufnr,
    path = normalize(path),
    relative_path = project_relative,
    working_directory = vim.fn.getcwd(),
    project_root = root,
    directory = normalize(vim.fn.fnamemodify(path, ":h")),
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

local function payload(selection, opts)
  opts = opts or {}
  local instruction = opts.instruction or ""
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
  }

  if instruction ~= "" then
    vim.list_extend(lines, { "", "## Instruction", "", instruction })
  end
  vim.list_extend(lines, {
    "",
    "## Selected text",
    "",
    fence .. (selection.filetype or ""),
    selection.text,
    fence,
  })

  if opts.annotation then
    table.insert(lines, "")
    table.insert(lines, "## New Mole annotation")
    table.insert(lines, "")
    table.insert(lines, "- Sidecar: " .. paths.annotation_file(selection.path))
    table.insert(lines, "")
    table.insert(lines, opts.annotation)
  end

  if opts.include_annotations then
    local sidecar, blocks = related_annotations(selection.path, selection.start_line, selection.end_line)
    table.insert(lines, "")
    table.insert(lines, "## Related Mole annotations")
    table.insert(lines, "")
    table.insert(lines, "- Sidecar: " .. sidecar)
    if #blocks == 0 then
      table.insert(lines, "- No Mole annotations overlap this selection.")
    else
      table.insert(lines, "")
      for index, block in ipairs(blocks) do
        table.insert(lines, "### Annotation " .. index)
        table.insert(lines, "")
        vim.list_extend(lines, block)
        table.insert(lines, "")
      end
    end
  end

  return table.concat(lines, "\n")
end

function M.copy_selection(selection, opts)
  opts = opts or {}
  if not selection then
    vim.notify("Select text from a named file first", vim.log.levels.WARN)
    return false
  end
  local value = payload(selection, opts)
  vim.fn.setreg("+", value)
  vim.notify("Copied selection context to the system clipboard")
  return true
end

function M.copy_visual(opts)
  return M.copy_selection(M.visual_selection(), opts)
end

function M.prompt_visual(opts)
  opts = opts or {}
  local selection = M.visual_selection()
  if not selection then
    vim.notify("Select text from a named file first", vim.log.levels.WARN)
    return false
  end

  vim.ui.input({ prompt = opts.prompt or "Context instruction: " }, function(input)
    input = input and vim.trim(input) or ""
    if input == "" then
      vim.notify("Context copy cancelled", vim.log.levels.INFO)
      return
    end
    M.copy_selection(selection, {
      instruction = input,
      include_annotations = opts.include_annotations,
    })
  end)
  return true
end

return M
