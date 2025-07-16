-- ============================================================================
-- AUTOCOMMANDS CONFIGURATION
-- ============================================================================

-- Auto-open dashboard on startup (no files opened)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end
      vim.cmd("Dashboard")
    end
  end,
})

-- Auto-save folder opened from CLI as project
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      local stat = vim.loop.fs_stat(arg)
      if stat and stat.type == "directory" then
        _G.save_recent_project(arg)
      end
    end
  end,
})

-- Hide UI lines in dashboard and similar buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dashboard", "alpha", "starter", "lazy" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.statuscolumn = ""
    vim.opt_local.cursorline = false
    vim.opt_local.list = false
    vim.opt_local.colorcolumn = ""
    vim.b.miniindentscope_disable = true
    vim.b.indent_blankline_disable = true
    pcall(vim.cmd, "TSBufDisable highlight")
    pcall(vim.cmd, "TSBufDisable indent")
    pcall(vim.cmd, "syntax off")
  end,
})

-- Auto-format on save for certain file types
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.rs", "*.go", "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Auto-close certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help", "man", "notify", "lspinfo", "spectre_panel", "startuptime", "tsplayground", "PlenaryTestPopup" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-resize splits when Vim is resized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Check if file has been changed outside of Neovim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Save folds
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.*",
  callback = function()
    vim.cmd("mkview")
  end,
})

-- Load folds
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.*",
  callback = function()
    vim.cmd("silent! loadview")
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Don't auto-comment new lines
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
})

-- Close Neo-tree when opening a file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "neo-tree" then
      return
    end

    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "neo-tree" then
        vim.api.nvim_win_close(win, false)
        break
      end
    end
  end,
})

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})


-- refresh Copilot status on cursor hold
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    local ok, client = pcall(require, "copilot.client")
    if ok and client and client.check_status then
      client.check_status()
    end
  end,
})
