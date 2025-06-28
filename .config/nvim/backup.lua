
-- Neovim Configuration

-- 🧠 Keybind Help popup function
function _G.show_keybinds()
  local lines = {
    "╔═══════════════════════════════════════════════════╗",
    "║               🧠 Keybind Cheatsheet               ║",
    "╠═════════════════╬═════════════════════════════════╣",
    "║ Ctrl + o        ║ Save                            ║",
    "║ x (after o)     ║ Save & Exit                     ║",
    "║ Ctrl + q        ║ Quit                            ║",
    "║ Ctrl + c        ║ Force Quit (no save)            ║",
    "║ Ctrl + x        ║ Cut Line (to clipboard)         ║",
    "║ Ctrl + k        ║ Close side Pane                 ║",
    "║ Ctrl + y        ║ Redo                            ║",
    "║ Ctrl + z/_      ║ Undo                            ║",
    "║ Ctrl + a        ║ Select All                      ║",
    "║ Ctrl + c (V)    ║ Copy to Clipboard (visual)      ║",
    "║ Ctrl + v        ║ Paste from Clipboard            ║",
    "║ <C-n>           ║ Toggle Nvim Tree                ║",
    "║ <Tab>           ║ Cycle to Next Buffer            ║",
    "║ <S-Tab>         ║ Cycle to Previous Buffer        ║",
    "║ <C-p>           ║ Open Telescope Find Files       ║",
    "║ <C-l>           ║ Vertical Split                  ║",
    "║ <C-h>           ║ Horizontal Split                ║",
    "║ <C-k>           ║ Close Current Split Pane        ║",
    "║ <C-a>           ║ Select All                      ║",
    "║ <C-Left>        ║ Move to Previous Pane           ║",
    "║ <C-r>           ║ Open Recent Files (Telescope)   ║",
    "╚═════════════════╝═════════════════════════════════╝",
  }
  vim.cmd("botright new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false  -- Disable swap file for the help popup
  vim.bo.readonly = true
end

-- Prepend lazy.nvim
vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/lazy/lazy.nvim"))

-- Set termguicolors before loading plugins
vim.opt.termguicolors = true

-- Disable swap files globally
vim.opt.swapfile = false  -- Disable swap file creation completely

require("lazy").setup({
  -- Theme plugins (add as many as you want)
  { "folke/tokyonight.nvim", priority = 1000 },   -- Tokyo Night theme
  { "rebelot/kanagawa.nvim", priority = 1000 },   -- Kanagawa theme
  { "ellisonleao/gruvbox.nvim", priority = 1000 },-- Gruvbox theme

  -- File Tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
      vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          file_ignore_patterns = { "node_modules", "%.git/", "target", "build" },
        },
      })
      -- 🗂 Ctrl+P to search file names like VSCode
      vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "██╗    ██╗ █████╗  █████╗  █████╗ ███████╗███████╗███████╗██╗     ██╗     ██╗     ",
            "██║    ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██║     ██║     ██║     ",
            "██║ █╗ ██║███████║███████║███████║█████╗  █████╗  █████╗  ██║     ██║     ██║     ",
            "██║███╗██║██╔══██║██╔══██║██╔══██║██╔══╝  ██╔══╝  ██╔══╝  ██║     ██║     ██║     ",
            "╚███╔███╔╝██║  ██║██║  ██║██║  ██║███████╗███████╗███████╗███████╗███████╗███████╗",
            " ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝",
          },
          center = {
            { icon = "  ", desc = "New File", action = "enew", shortcut = "SPC n" },
            { icon = "  ", desc = "Find File", action = "Telescope find_files", shortcut = "SPC f f" },
            { icon = "  ", desc = "Recent Files", action = "Telescope oldfiles", shortcut = "SPC f r" },
            { icon = "  ", desc = "Last Session", action = "SessionManager load_last_session", shortcut = "SPC s l" },
            { icon = "  ", desc = "Keybind Cheatsheet", action = "lua show_keybinds()", shortcut = "SPC h" },
            { icon = "  ", desc = "Quit Neovim", action = "qa", shortcut = "SPC q" },
          },
          footer = {
            "🚀 Welcome back, Wael! Happy coding in Neovim ❤️",
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust", "bash", "html", "css", "javascript" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Session Manager
  {
    "Shatur/neovim-session-manager",
    config = function()
      local config = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.LastSession, -- Disable auto-load last session on startup
        autosave_last_session = true,                -- Do not auto-save session on exit
        autosave_only_in_session = true,             -- Save even if session not manually started
      })
    end,
  },

  -- Auto-pairing brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,  -- Enable treesitter integration
      })
    end
  },

  -- Auto-completion (VSCode-style)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP suggestions
      "hrsh7th/cmp-buffer",   -- buffer words
      "hrsh7th/cmp-path",     -- file paths
      "L3MON4D3/LuaSnip",     -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- use snippets in cmp
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
  },

  -- LSP support
  {  -- Line 116
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").ts_ls.setup({})      -- Updated to use ts_ls
      require("lspconfig").pyright.setup({})
    end
  },  -- Line 120

  -- Optional: Snippet Completion like VS Code
  {
    "rafamadriz/friendly-snippets",
    dependencies = "L3MON4D3/LuaSnip",
  },

  -- Easy LSP install
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
})

-- Vertical split with 30% width left pane
vim.keymap.set('n', '<C-l>', function()
  vim.cmd('vsplit')
  local width = math.floor(vim.o.columns * 0.65)
  vim.cmd(string.format('vertical resize %d', width))
end, { noremap = true, silent = true })

-- Horizontal split with 30% height top pane
vim.keymap.set('n', '<C-h>', function()
  vim.cmd('botright split | terminal')                             -- horizontal split with terminal
  local height = math.floor(vim.o.lines * 0.3)
  vim.cmd(string.format('resize %d', height))
end, { noremap = true, silent = true })

-- Close current split pane with Ctrl+k
vim.keymap.set('n', '<C-k>', ':close<CR>', { noremap = true, silent = true })

-- Set the colorscheme
vim.cmd("colorscheme gruvbox")  -- << Gruvbox is active theme

-- To use another theme, change the line above to:
-- vim.cmd("colorscheme kanagawa")      -- for Kanagawa
-- vim.cmd("colorscheme tokyonight")    -- for Tokyo Night

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Clipboard for Wayland
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
  paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --no-newline" },
  cache_enabled = true,
}

-- Key Mappings
-- CUT
vim.keymap.set("n", "<C-x>", '"+dd', { noremap = true, silent = true })           -- Cut line
vim.keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })            -- Cut selection

-- COPY
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })            -- Copy selection
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })           -- Copy line

-- PASTE
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })            -- Paste after cursor
vim.keymap.set("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })      -- Paste in insert mode
vim.keymap.set("v", "<C-v>", '"+p', { noremap = true, silent = true })            -- Paste over selection

-- UNDO / REDO
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true })              -- Undo
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true })          -- Redo

-- FILE
vim.keymap.set("n", "<C-o>", ":w<CR>", { noremap = true, silent = true })         -- Save
vim.keymap.set("n", "x", ":wq<CR>", { noremap = true, silent = true })            -- Save & Quit
vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })         -- Quit
vim.keymap.set("n", "<C-c>", ":q!<CR>", { noremap = true, silent = true })        -- Force Quit
vim.keymap.set('n', '<C-w>', ':bd!<CR>', { noremap = true, silent = true })

-- SELECT ALL
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })           -- Select all

-- MOVE LINES
vim.keymap.set("v", "<C-M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- OTHERS
vim.keymap.set("n", "<C-d>", ":Dashboard<CR>", { noremap = true, silent = true })

-- Ctrl + Left Arrow: move to the previous pane
vim.keymap.set('n', '<C-Left>', '<C-w>W', { noremap = true, silent = true })
-- Ctrl+r: Open recent files Telescope picker
vim.keymap.set("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true })
