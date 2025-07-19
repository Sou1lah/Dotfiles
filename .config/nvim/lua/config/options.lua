-- ============================================================================
-- NEOVIM OPTIONS CONFIGURATION
-- ============================================================================

-- Basic Settings
vim.opt.termguicolors = true  -- Enable true color support
vim.opt.swapfile = false      -- Disable swapfile
vim.opt.number = true         -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.updatetime = 200      -- Faster CursorHold trigger

-- Wayland clipboard integration
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
  paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --no-newline" },
  cache_enabled = true,
}

-- Disable space as key (we use it as leader)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/lazy/lazy.nvim"))


vim.opt.tabstop = 2      -- number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2   -- number of spaces for each indentation
vim.opt.expandtab = true -- use spaces instead of tabs


local opt = vim.opt
local api = vim.api

-- ========== UI/Behavior Enhancements ==========

opt.incsearch = true                                          -- Highlight matches while typing search
opt.ignorecase = true                                         -- Ignore case in searches...
opt.smartcase = true                                          -- ...unless uppercase letters are used
opt.cursorline = true                                         -- Highlight the current line
opt.cursorlineopt = "line,number"                             -- Highlight both line and number column
opt.scrolloff = 10                                            -- Keep 10 lines above/below cursor when scrolling
opt.sidescrolloff = 10                                        -- Keep 10 columns left/right when scrolling horizontally
opt.splitright = true                                         -- Vertical splits open to the right
opt.title = true                                              -- Set terminal title to filename
opt.wrap = false                                              -- Disable line wrapping
opt.wildignore = "*.zip,*.tar.gz,*.jpg,*.mp4,*.exe,*.pyc,*.o" -- Ignore clutter in file completion

-- ========== Yank Highlight ==========

-- Highlight text when yanked (copied)
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 }) -- Use IncSearch highlight for 200ms
  end,
})

-- ========== AutoSave on Focus Lost / Insert Leave ==========

-- Automatically save when focus is lost or leaving insert mode
api.nvim_create_autocmd({ "FocusLost", "InsertLeave" }, {
  desc = "Auto save on focus lost or insert leave",
  callback = function()
    if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly and vim.bo.buftype == "" then
      vim.schedule(function()
        vim.cmd("silent! write") -- Silent write to disk
      end)
    end
  end,
})
