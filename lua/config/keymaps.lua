-- Global keymaps. Plugin-specific lazy-loading maps live with their plugin.
local map = vim.keymap.set
local function telescope(action)
  return function() require("telescope.builtin")[action]() end
end

local function notify_copy(label, value)
  if value == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", value)
  vim.notify("Copied " .. label .. ": " .. value)
end

-- Display: <leader>d*
map("n", "<leader>dn", function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end,
  { desc = "Toggle relative numbers" })
map("n", "<leader>dz", function()
  local visible = vim.opt.number:get() or vim.opt.relativenumber:get()
  vim.opt.number = not visible
  vim.opt.relativenumber = false
end, { desc = "Toggle all line numbers" })
map("n", "<leader>dv", function() vim.opt.list = not vim.opt.list:get() end,
  { desc = "Toggle visible characters" })

-- Project and search: <leader>p*
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file browser (netrw)" })
map("n", "<leader>pf", telescope("find_files"), { desc = "Find files" })
map("n", "<leader>pg", telescope("live_grep"), { desc = "Search project text" })
map("n", "<leader>ps", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Search > ") }) end,
  { desc = "Search with prompt" })
map("n", "<leader>pl", vim.cmd.Lazy, { desc = "Open Lazy" })

-- Copy paths: <leader>y*
map("n", "<leader>yp", function() notify_copy("full path", vim.fn.expand("%:p")) end,
  { desc = "Copy full path" })
map("n", "<leader>yr", function()
  local path = vim.fn.expand("%:p")
  notify_copy("relative path", vim.fn.fnamemodify(path, ":."))
end, { desc = "Copy relative path" })
map("n", "<leader>yd", function() notify_copy("containing folder", vim.fn.expand("%:p:h")) end,
  { desc = "Copy containing folder" })

-- Copy a temporary request context for Codex or any other application.
local context = require("utils.context")
map("v", "<leader>yc", function() context.prompt_visual() end,
  { desc = "Copy selection with request" })
map("v", "<leader>ym", function() context.prompt_visual_multiline() end,
  { desc = "Copy selection with multiline request" })

-- Window navigation and sizing. These are native Neovim operations with
-- convenient direct shortcuts; the <leader>v* aliases keep them discoverable.
local window_directions = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(window_directions) do
  map("n", "<C-" .. key .. ">", "<C-w>" .. key, { desc = "Focus " .. direction .. " window" })
  map("n", "<leader>v" .. key, "<C-w>" .. key, { desc = "Focus " .. direction .. " window" })
end
map("n", "<leader>vH", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<leader>vL", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<leader>vJ", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<leader>vK", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<leader>v=", "<C-w>=", { desc = "Equalize window sizes" })

local maximized_layouts = {}
local function toggle_maximize()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local saved_layout = maximized_layouts[tabpage]
  if saved_layout then
    vim.cmd(saved_layout)
    maximized_layouts[tabpage] = nil
    vim.notify("Restored window layout")
    return
  end

  if #vim.api.nvim_tabpage_list_wins(tabpage) < 2 then
    vim.notify("Only one window is open", vim.log.levels.INFO)
    return
  end

  maximized_layouts[tabpage] = vim.fn.winrestcmd()
  vim.cmd("wincmd _")
  vim.cmd("wincmd |")
  vim.notify("Maximized current window")
end
map("n", "<leader>vx", toggle_maximize, { desc = "Maximize/restore current window" })

-- Markdown navigation: <leader>m*
map("n", "<leader>mt", function()
  local count = #vim.api.nvim_list_wins()
  vim.cmd("lclose")
  if #vim.api.nvim_list_wins() == count then
    local ok = pcall(vim.cmd, [[lvimgrep /^#\+ /j %]])
    if ok then vim.cmd("lopen") end
  end
end, { desc = "Toggle Markdown table of contents" })

-- External applications: <leader>o*
local function open_external(app)
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("Save the buffer before opening it externally", vim.log.levels.WARN)
    return
  end
  local args = { "open" }
  if app then vim.list_extend(args, { "-a", app }) end
  table.insert(args, path)
  vim.fn.jobstart(args, { detach = true })
end
map("n", "<leader>of", function() open_external(nil) end, { desc = "Open in default application" })
map("n", "<leader>ov", function() open_external("Visual Studio Code") end, { desc = "Open in VS Code" })
map("n", "<leader>oc", function() open_external("Cursor") end, { desc = "Open in Cursor" })
map("n", "<leader>on", function() open_external("Neovide") end, { desc = "Open in Neovide" })

-- Writing: <leader>w*
map("n", "<leader>ws", function() vim.opt.spell = not vim.opt.spell:get() end, { desc = "Toggle spell check" })
map("n", "<leader>ww", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle word wrap" })
map("n", "<leader>wz", "<cmd>ZenMode<cr>", { desc = "Toggle distraction-free mode" })

-- Themes: <leader>c*
local themes = {
  ct = "tokyonight-night", co = "onedark", cc = "catppuccin-mocha", ck = "kanagawa-wave",
  cg = "gruvbox", cr = "rose-pine", ce = "everforest", cn = "nightfox",
}
for key, theme in pairs(themes) do
  map("n", "<leader>" .. key, function() vim.cmd.colorscheme(theme) end, { desc = "Use " .. theme })
end
map("n", "<leader>cs", function()
  vim.ui.select(vim.tbl_values(themes), { prompt = "Choose colorscheme" }, function(choice)
    if choice then vim.cmd.colorscheme(choice) end
  end)
end, { desc = "Choose colorscheme" })
