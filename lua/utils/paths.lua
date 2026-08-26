-- Shared path helpers for annotation sidecars and external commands.
local M = {}

function M.current_file()
  local path = vim.fn.expand("%:p")
  if path == "" then return nil end
  return path
end

function M.annotation_file(path)
  return path .. ".review.md"
end

return M
