require "nvchad.mappings"

local bind = vim.keymap.set

-- Diagnostics and commands
bind({'n'}, '<leader>lf', function ()
  vim.diagnostic.open_float { border = "rounded" }
end, {desc = "Floating diagnostic"})

bind({'n'}, ';', ':', { desc = "CMD enter command mode" })
bind({'n', 'v'}, '<leader>sr', "<cmd>SnipRun<CR>", {desc = "Run snippet line"})
bind({'n'}, '<leader>sc', "<cmd>SnipClose<CR>", {desc = "Clear snippet output"})
bind({'n'}, '<leader>se', '<cmd>FeMaco<CR>', {desc = "Edit snippet" })
bind({'n'}, '<leader>fc', '<cmd>Telescope builtin<CR>', {desc = "Find command" })
bind({'n'}, '<leader>cf', '<cmd>next ~/.config/nvim/lua/*.lua<CR>', {desc = "Edit Config" })

-- Hop
bind("n", "<leader>jw", function() require'hop'.hint_words() end, {desc = "Jump to word"})
bind("n", "<leader>jl", function() require'hop'.hint_lines() end, {desc = "Jump to line"})
bind("n", "<leader>ja", function() require'hop'.hint_anywhere() end, {desc = "Jump anywhere"})
bind("n", "<leader>jcC", function() require'hop'.hint_camel_case() end, {desc = "Jump camel case"})

-- Move lines
bind({'n', 'i'}, '<A-Down>', '<cmd>move .+1<CR>')
bind({'n', 'i'}, '<A-Up>', '<cmd>move .-2<CR>')
bind({'n', 'i'}, '<A-j>', '<cmd>move .+1<CR>')
bind({'n', 'i'}, '<A-k>', '<cmd>move .-2<CR>')
bind('v', '<A-Up>', ":move -2<CR>gv=gv", {silent = true})
bind('v', '<A-Down>', ":move '>+1<CR>gv=gv", {silent = true})
bind('v', '<A-k>', ":move -2<CR>gv=gv", {silent = true})
bind('v', '<A-j>', ":move '>+1<CR>gv=gv", {silent = true})
bind("v", "<C-M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })
bind("v", "<C-M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })

-- IronRepl
bind("n", "<space>rs", "<cmd>IronRepl<cr>")
bind("n", "<space>rr", "<cmd>IronRestart<cr>")
bind("n", "<space>rF", "<cmd>IronFocus<cr>")
bind("n", "<space>rh", "<cmd>IronHide<cr>")

-- Insert mode editing
bind('i', '<C-BS>', '<C-W>')
bind('i', '<A-BS>', '<C-W>')

-- Font size
bind({'n', 'i', 'v'}, "<C-=>", "<cmd>FontIncrease<CR>")
bind({'n', 'i', 'v'}, "<C-->", "<cmd>FontDecrease<CR>")

-- Menu
bind("n", "<C-t>", function() require("menu").open("default") end, {})

-- Mouse menu
bind({"n", "i"}, "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'
  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true })
end, {})

-- Keybind Cheatsheet
bind("n", "<C-d>", ":lua show_keybinds()<CR>", { noremap = true, silent = true, desc = "Show keybind cheatsheet" })
("n", "<C-d>", ":Dashboard<CR>", { noremap = true, silent = true, desc = "Open Dashboard" })

-- Clipboard and editing (no duplicates)
bind("n", "<C-x>", '"+dd', { noremap = true, silent = true, desc = "Cut line to clipboard" })
bind("v", "<C-x>", '"+d', { noremap = true, silent = true, desc = "Cut selection to clipboard" })
bind("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy selection to clipboard" })
bind("n", "<C-c>", '"+yy', { noremap = true, silent = true, desc = "Copy line to clipboard" })
bind("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
bind("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true, desc = "Paste from clipboard" })
bind("v", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
bind("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo" })
bind("n", "<C-y>", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
bind("n", "<C-o>", ":w<CR>", { noremap = true, silent = true, desc = "Save" })
bind("n", "x", ":wq<CR>", { noremap = true, silent = true, desc = "Save & Exit" })
bind("n", "<C-q>", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })
bind("n", "<C-c>", ":q!<CR>", { noremap = true, silent = true, desc = "Force Quit" })
bind("n", "<C-w>", ":bd!<CR>", { noremap = true, silent = true, desc = "Close buffer" })
bind("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

-- Window and buffer navigation
bind('n', '<C-l>', function()
  vim.cmd('vsplit')
  local width = math.floor(vim.o.columns * 0.65)
  vim.cmd(string.format('vertical resize %d', width))
end, { noremap = true, silent = true, desc = "Vertical split" })

bind('n', '<C-h>', function()
  vim.cmd('botright split | terminal')
  local height = math.floor(vim.o.lines * 0.3)
  vim.cmd(string.format('resize %d', height))
end, { noremap = true, silent = true, desc = "Horizontal split with terminal" })

bind('n', '<C-k>', ':close<CR>', { noremap = true, silent = true, desc = "Close split" })

-- NvimTree toggle
bind("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })

-- Bufferline navigation
bind("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
bind("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

-- Telescope find files and recent files
bind("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
bind("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })

-- Move to previous pane
bind('n', '<C-Left>', '<C-w>W', { noremap = true, silent = true, desc = "Previous pane" })

