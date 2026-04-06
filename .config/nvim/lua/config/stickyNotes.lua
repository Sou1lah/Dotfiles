-- ============================================================================
-- STICKY NOTES SYSTEM
-- ============================================================================

local M = {}

local sticky_dir = vim.fn.stdpath("config") .. "/sticky_notes"

-- Ensure directory exists
vim.fn.mkdir(sticky_dir, "p")

-- Open sticky note for current project
function M.open_split_sticky_note()
  local cwd = vim.loop.cwd() or vim.fn.getcwd()
  local safe_name = cwd:gsub("[^%w%._-]", "%%")
  local sticky_file = sticky_dir .. "/" .. safe_name .. ".md"

  -- Default content if file doesn't exist
  local default_content = {
    "## Tasks",
    "- [ ] Task 1",
    "- [ ] Task 2",
    "",
    "----------------------------------------",
    "## Notes",
    "> Start typing here...",
    "",
  }

  if vim.fn.filereadable(sticky_file) == 1 then
    default_content = vim.fn.readfile(sticky_file)
  end

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, default_content)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  -- Floating window config
  local width = math.floor(vim.o.columns * 0.65)
  local height = math.floor(vim.o.lines * 0.45)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 📝 Sticky Note ",
    title_pos = "center",
  })

  vim.cmd("startinsert")

  -- Save & Close
  vim.keymap.set("n", "<leader>w", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.fn.writefile(lines, sticky_file)
    vim.notify("✅ Sticky note saved for this project", vim.log.levels.INFO)
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })

  -- Close without saving
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })
end

-- Browse all sticky notes
function M.toggle_sticky_note_picker()
  local files = vim.fn.globpath(sticky_dir, "*.md", false, true)
  if #files == 0 then
    vim.notify("No sticky notes found yet!", vim.log.levels.INFO)
    return
  end

  vim.ui.select(files, {
    prompt = "Select Sticky Note:",
    format_item = function(file)
      local name = vim.fn.fnamemodify(file, ":t:r")
      return name:gsub("%%", "/") -- restore readable path
    end,
  }, function(choice)
    if not choice then return end

    local lines = vim.fn.readfile(choice)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    local width = math.floor(vim.o.columns * 0.65)
    local height = math.floor(vim.o.lines * 0.45)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
      title = " 📝 Sticky Note ",
      title_pos = "center",
    })

    vim.cmd("startinsert")
  end)
end

-- Optional: Setup function for future
function M.setup()
  vim.keymap.set("n", "<leader>mn", M.open_split_sticky_note, { desc = "Open Sticky Note" })
  vim.keymap.set("n", "<leader>ms", M.toggle_sticky_note_picker, { desc = "Sticky Notes Picker" })
end

return M
