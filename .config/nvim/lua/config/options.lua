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
