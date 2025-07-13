-- ============================================================================
-- NEOVIM KEYBINDS CONFIGURATION
-- ============================================================================

-- Basic editing keybinds
vim.keymap.set("n", "<C-x>", '"+dd', { noremap = true, silent = true })                  -- Cut line
vim.keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })                   -- Cut selection
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })                   -- Copy selection
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })                  -- Copy line
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })                   -- Paste
vim.keymap.set("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })             -- Paste in insert mode
vim.keymap.set("v", "<C-v>", '"+p', { noremap = true, silent = true })                   -- Paste in visual mode
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true })                     -- Undo
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true })                 -- Redo
vim.keymap.set("n", "<C-o>", ":w<CR>", { noremap = true, silent = true })                -- Save
vim.keymap.set("n", "x", ":wq<CR>", { noremap = true, silent = true })                   -- Save & Exit
vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })                -- Quit
vim.keymap.set("n", "<C-c>", ":q!<CR>", { noremap = true, silent = true })               -- Force Quit
vim.keymap.set("n", "<C-w>", ":bd!<CR>", { noremap = true, silent = true })              -- Close buffer
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })                  -- Select all
vim.keymap.set("v", "<C-M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })   -- Move selection up
vim.keymap.set("v", "<C-M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Move selection down

-- Window management keybinds
vim.keymap.set("n", "<C-l>", function()
    vim.cmd("vsplit")
    vim.cmd(string.format("vertical resize %d", math.floor(vim.o.columns * 0.65)))
end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", function()
    vim.cmd("botright split | terminal")
    vim.cmd(string.format("resize %d", math.floor(vim.o.lines * 0.3)))
end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-k>", ":close<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", "<C-w>W", { noremap = true, silent = true })             -- Move to previous pane

-- File and project management
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })   -- Toggle file explorer
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", ":Dashboard<CR>", { noremap = true, silent = true })        -- Open dashboard
vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true })             -- New file

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

-- Multi-cursor keybinds
vim.keymap.set("n", "<C-S-Down>", "<C-v>j", { noremap = true, silent = true, desc = "Block select down" })
vim.keymap.set("v", "<C-S-Down>", "j", { noremap = true, silent = true, desc = "Block select down" })
vim.keymap.set("n", "<C-S-Up>", "<C-v>k", { noremap = true, silent = true, desc = "Block select up" })
vim.keymap.set("v", "<C-S-Up>", "k", { noremap = true, silent = true, desc = "Block select up" })
vim.keymap.set("v", "<leader><Space>", "I <Esc>", { noremap = true, silent = true, desc = "Insert space at start" })
vim.keymap.set("v", "<leader><Tab>", "I<Tab><Esc>", { noremap = true, silent = true, desc = "Insert tab at start" })
vim.keymap.set("v", "<leader>s", "A <Esc>", { noremap = true, silent = true, desc = "Append space at end" })
vim.keymap.set("v", "<leader>t", "A<Tab><Esc>", { noremap = true, silent = true, desc = "Append tab at end" })

-- Miscellaneous keybinds
vim.keymap.set("n", "<leader><CR>", "o<Esc>", { noremap = true, silent = true })          -- Insert new line below
vim.keymap.set("n", "<C-j>", function()
    require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
end, { noremap = true, silent = true, desc = "Find Word (Current Dir)" })

vim.keymap.set("n", "*", "<cmd>SessionManager load_last_session<CR>", { noremap = true, silent = true, desc = "Last Session" })

-- Bookmark system keybinds
vim.keymap.set("n", "<C-M-d>", function() _G.add_bookmark() end, { noremap = true, silent = true, desc = "Add Bookmark" })
vim.keymap.set("n", "<C-M-k><C-M-o>", function() _G.open_folder() end, { noremap = true, silent = true, desc = "Open Folder" })

-- Recent project keybinds
vim.keymap.set("n", "<C-M-p>", function() _G.open_recent_project() end, { noremap = true, silent = true, desc = "Open Recent Project" })

-- Plugin specific keybinds
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>mn", function() _G.open_split_sticky_note() end, { desc = "Sticky Note" })
vim.keymap.set("n", "<leader>ms", function() _G.toggle_sticky_note_picker() end, { desc = "Sticky Notes Picker" })
vim.keymap.set("n", "<leader>d", function() _G.show_keybinds_telescope() end, { desc = "Show Keybinds Cheatsheet" })

-- Load helper functions
require("config.helpers")
