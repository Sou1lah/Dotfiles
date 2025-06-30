--------------------------------------------------------------------------------
--                           BASIC NEOVIM SETTINGS                           --
--------------------------------------------------------------------------------

function _G.show_keybinds()
  local lines = {
    "                        ╔═══════════════════════════════════════════════════╗",
    "                        ║               🧠 Keybind Cheatsheet               ║",
    "                        ╠═════════════════╬═════════════════════════════════╣",
    "                        ║ Ctrl + o        ║ Save                            ║",
    "                        ║ x (after o)     ║ Save & Exit                     ║",
    "                        ║ Ctrl + q        ║ Quit                            ║",
    "                        ║ Ctrl + c        ║ Force Quit (no save)            ║",
    "                        ║ Ctrl + x        ║ Cut Line (to clipboard)         ║",
    "                        ║ Ctrl + k        ║ Close side Pane                 ║",
    "                        ║ Ctrl + y        ║ Redo                            ║",
    "                        ║ Ctrl + z/_      ║ Undo                            ║",
    "                        ║ Ctrl + a        ║ Select All                      ║",
    "                        ║ Ctrl + c (V)    ║ Copy to Clipboard (visual)      ║",
    "                        ║ Ctrl + v        ║ Paste from Clipboard            ║",
    "                        ║ <C-n>           ║ Toggle Nvim Tree                ║",
    "                        ║ <Tab>           ║ Cycle to Next Buffer            ║",
    "                        ║ <S-Tab>         ║ Cycle to Previous Buffer        ║",
    "                        ║ <C-p>           ║ Open Telescope Find Files       ║",
    "                        ║ <C-l>           ║ Vertical Split                  ║",
    "                        ║ <C-h>           ║ Horizontal Split                ║",
    "                        ║ <C-k>           ║ Close Current Split Pane        ║",
    "                        ║ <C-a>           ║ Select All                      ║",
    "                        ║ <C-Left>        ║ Move to Previous Pane           ║",
    "                        ║ <C-r>           ║ Open Recent Files (Telescope)   ║",
    "                        ╚═════════════════╝═════════════════════════════════╝",
  }
  -- Open a new full-screen tab for the cheatsheet
  vim.cmd("tabnew")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.readonly = true
end

vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/lazy/lazy.nvim"))
vim.opt.termguicolors = true
vim.opt.swapfile = false

--------------------------------------------------------------------------------
--                                 PLUGINS                                   --
--------------------------------------------------------------------------------

require("lazy").setup({
--------------------------------------------------------------------------------
--                                 THEMES                                    --
--------------------------------------------------------------------------------
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "folke/tokyonight.nvim", priority = 1000 },
  { "shaunsingh/nord.nvim", priority = 1000 },
  { "Mofiqul/dracula.nvim", priority = 1000 },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
    end,
  },
  { "sainnhe/everforest", priority = 1000 },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "deep" })
    end,
  },
  { "ishan9299/nvim-solarized-lua", priority = 1000 },
  { "tanvirtin/monokai.nvim", priority = 1000 },
  { "Shatur/neovim-ayu", priority = 1000 },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({ variant = "main" })
    end,
  },
  { "marko-cerovac/material.nvim", priority = 1000 },
  { "rebelot/kanagawa.nvim", priority = 1000 },
  { "cocopon/iceberg.vim", priority = 1000 },
  { "glepnir/zephyr-nvim", priority = 1000 },
  { "folke/twilight.nvim", priority = 1000 },
  { "RRethy/nvim-base16", priority = 1000 },
  { "sonph/onehalf", rtp = "vim", priority = 1000 },
  { "lalitmee/cobalt2.nvim", dependencies = "tjdevries/colorbuddy.nvim", priority = 1000 },
  { "nanotech/jellybeans.vim", priority = 1000 },
--------------------------------------------------------------------------------
--                              FILE EXPLORER                                --
--------------------------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },

--------------------------------------------------------------------------------
--                              BUFFERLINE UI                                --
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
--                              TELESCOPE                                    --
--------------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          file_ignore_patterns = { "node_modules", "%.git/", "target", "build" },
        },
      })
      vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true })
    end,
  },

--------------------------------------------------------------------------------
--                                DASHBOARD                                  --
--------------------------------------------------------------------------------
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
    config = function()
      local themes = {
        { name = "Gruvbox", value = "gruvbox" },
        { name = "Tokyo Night", value = "tokyonight" },
        { name = "Nord", value = "nord" },
        { name = "Dracula", value = "dracula" },
        { name = "Catppuccin", value = "catppuccin-mocha" },
        { name = "Everforest", value = "everforest" },
        { name = "OneDark", value = "onedark" },
        { name = "Solarized", value = "solarized" },
        { name = "Monokai", value = "monokai" },
        { name = "Ayu", value = "ayu-dark" },
        { name = "Rose Pine", value = "rose-pine" },
        { name = "Material", value = "material" },
        { name = "Kanagawa", value = "kanagawa" },
        { name = "Iceberg", value = "iceberg" },
        { name = "Base16", value = "base16-default-dark" },
      }

      local theme_file = vim.fn.stdpath("config") .. "/last_theme.txt"

      local function set_theme(theme)
        vim.cmd("colorscheme " .. theme)
        local f = io.open(theme_file, "w")
        if f then
          f:write(theme)
          f:close()
        end
      end

      function _G.theme_selector_popup()
        vim.ui.select(themes, {
          prompt = "Select a theme:",
          format_item = function(item) return item.name end,
        }, function(choice)
          if choice then
            set_theme(choice.value)
          end
        end)
      end

      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "                                                                                  ",
            "                                                                                  ",
            "                                                                                  ",
            "██╗    ██╗ █████╗  █████╗  █████╗ ███████╗███████╗███████╗██╗     ██╗     ██╗     ",
            "██║    ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██║     ██║     ██║     ",
            "██║ █╗ ██║███████║███████║███████║█████╗  █████╗  █████╗  ██║     ██║     ██║     ",
            "██║███╗██║██╔══██║██╔══██║██╔══██║██╔══╝  ██╔══╝  ██╔══╝  ██║     ██║     ██║     ",
            "╚███╔███╔╝██║  ██║██║  ██║██║  ██║███████╗███████╗███████╗███████╗███████╗███████╗",
            " ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝",
            "                                                                                  ",
            "                                                                                  ",
          },
          center = {
            { icon = "  ", desc = "New File ", action = "enew", shortcut = "Ctrl+t" },
            { icon = "  ", desc = "Find File ", action = "Telescope find_files", shortcut = "Ctrl+p" },
            { icon = "  ", desc = "Find Word ", action = "Telescope live_grep", shortcut = "Ctrl+j" },
            { icon = "  ", desc = "Recent Files", action = "Telescope oldfiles", shortcut = "Ctrl+r" },
            { icon = "  ", desc = "Recent Projects", action = "Telescope projects", shortcut = "SPC p" },
            { icon = "  ", desc = "Last Session", action = "SessionManager load_last_session", shortcut = "*" },
            { icon = "  ", desc = "Keybind Cheatsheet ", action = "lua show_keybinds()", shortcut = "SPC h" },
            { icon = "  ", desc = "Theme Selector ", action = "lua theme_selector_popup()", shortcut = "SPC t" },
            { icon = "  ", desc = "Config ", action = "edit ~/.config/nvim/init.lua", shortcut = "SPC c" },
            { icon = "  ", desc = "Quit Neovim ", action = "qa", shortcut = "SPC q" },
          },
          footer = {
            "🚀 Welcome back, Wael! Happy coding in Neovim ❤️",
          },
        }
      })
    end,
  },

--------------------------------------------------------------------------------
--                              TREESITTER                                   --
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
--                            SESSION MANAGER                               --
--------------------------------------------------------------------------------
  {
    "Shatur/neovim-session-manager",
    config = function()
      local config = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.LastSession,
        autosave_last_session = true,
        autosave_only_in_session = true,
      })
    end,
  },

--------------------------------------------------------------------------------
--                              AUTO PAIRS                                   --
--------------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

--------------------------------------------------------------------------------
--                            AUTO COMPLETION                                --
--------------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
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
    end,
  },

--------------------------------------------------------------------------------
--                                 LSPCONFIG                                --
--------------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").tsserver.setup({})
      require("lspconfig").pyright.setup({})
    end,
  },

--------------------------------------------------------------------------------
--                               SNIPPETS                                    --
--------------------------------------------------------------------------------
  {
    "rafamadriz/friendly-snippets",
    dependencies = "L3MON4D3/LuaSnip",
  },

--------------------------------------------------------------------------------
--                                 MASON                                     --
--------------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

--------------------------------------------------------------------------------
--                              NOTIFICATIONS                                --
--------------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({})
    end,
  },

--------------------------------------------------------------------------------
--                            UI ENHANCEMENTS                               --
--------------------------------------------------------------------------------
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup({})
    end,
  },
  { "MunifTanjim/nui.nvim" },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({})
    end,
  },
  { "folke/which-key.nvim" },
  { "numToStr/Comment.nvim" },
  { "lewis6991/gitsigns.nvim" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- You can set this to any lualine-supported theme, e.g. "gruvbox", "tokyonight", etc.
          -- theme = "gruvbox", -- Uncomment and set your preferred theme here
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })
    end,
  },
  { "lukas-reineke/indent-blankline.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "windwp/nvim-ts-autotag" },
  { "andweeb/presence.nvim" },
  { "mfussenegger/nvim-dap" },
  { "folke/trouble.nvim" },
})

--------------------------------------------------------------------------------
--                                 KEYBINDS                                 --
--------------------------------------------------------------------------------

-- Window Management
vim.keymap.set('n', '<C-l>', function()
  vim.cmd('vsplit')
  local width = math.floor(vim.o.columns * 0.65)
  vim.cmd(string.format('vertical resize %d', width))
end, { noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', function()
  vim.cmd('botright split | terminal')
  local height = math.floor(vim.o.lines * 0.3)
  vim.cmd(string.format('resize %d', height))
end, { noremap = true, silent = true })

vim.keymap.set('n', '<C-k>', ':close<CR>', { noremap = true, silent = true })

-- Set the colorscheme
local theme_file = vim.fn.stdpath("config") .. "/last_theme.txt"
local f = io.open(theme_file, "r")
if f then
  local theme = f:read("*l")
  if theme and #theme > 0 then
    vim.cmd("colorscheme " .. theme)
  end
  f:close()
else
  vim.cmd("colorscheme tokyonight") -- fallback default
end

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

-- Key Mappings for cut, copy, paste, undo, redo, file operations, select all, move lines
vim.keymap.set("n", "<C-x>", '"+dd', { noremap = true, silent = true })
vim.keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })
vim.keymap.set("v", "<C-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true })
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-o>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "x", ":wq<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<C-w>', ':bd!<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("v", "<C-M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", ":Dashboard<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>', '<C-w>W', { noremap = true, silent = true })
vim.keymap.set("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true, desc = "New File" })
vim.keymap.set("n", "<C-j>", function()
  require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
end, { noremap = true, silent = true, desc = "Find Word (Current Dir)" })
vim.keymap.set("n", "*", "<cmd>SessionManager load_last_session<CR>", { noremap = true, silent = true, desc = "Last Session" })

-- Set Space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable default Space behavior
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

