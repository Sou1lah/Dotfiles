--------------------------------------------------------------------------------
--                           BASIC NEOVIM SETTINGS                           --
--------------------------------------------------------------------------------

-- Add LuaRocks Lua 5.1 paths
local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.1/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath
-- Show keybind cheatsheet in a new tab
function _G.show_keybinds()
    -- ============================================================================
    -- KEYBIND CHEATSHEET POPUP FUNCTION
    -- ============================================================================
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
    vim.cmd("tabnew")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.readonly = true
end

vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/lazy/lazy.nvim"))
-- ============================================================================
-- ADD LAZY.NVIM TO RUNTIME PATH
-- ============================================================================

vim.opt.termguicolors = true
-- ============================================================================
-- ENABLE TRUE COLOR SUPPORT
-- ============================================================================

vim.opt.swapfile = false
-- ============================================================================
-- DISABLE SWAPFILE
-- ============================================================================

--------------------------------------------------------------------------------
--                                 PLUGINS                                   --
--------------------------------------------------------------------------------

require("lazy").setup({
    -- ============================================================================
    -- THEMES: COLORSCHEME PLUGINS
    -- ============================================================================
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    { "folke/tokyonight.nvim",    priority = 1000 },
    { "shaunsingh/nord.nvim",     priority = 1000 },
    { "Mofiqul/dracula.nvim",     priority = 1000 },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "mocha" })
        end,
    },
    { "sainnhe/everforest",           priority = 1000 },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({ style = "deep" })
        end,
    },
    { "ishan9299/nvim-solarized-lua", priority = 1000 },
    { "tanvirtin/monokai.nvim",       priority = 1000 },
    { "Shatur/neovim-ayu",            priority = 1000 },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("rose-pine").setup({ variant = "main" })
        end,
    },
    { "marko-cerovac/material.nvim", priority = 1000 },
    { "rebelot/kanagawa.nvim",       priority = 1000 },
    { "cocopon/iceberg.vim",         priority = 1000 },
    { "glepnir/zephyr-nvim",         priority = 1000 },
    -- Zen Mode + Twilight
    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      opts = {
        window = {
          backdrop = 0.95,
          width = 80,
          options = {
            number = false,
            relativenumber = false,
          },
        },
        plugins = {
          twilight = { enabled = true }, -- auto dim inactive code
          gitsigns = { enabled = false },
          tmux = { enabled = false },
          kitty = { enabled = false },
        },
      },
      keys = {
        { "<leader>zz", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
      },
    },

    {
      "folke/twilight.nvim",
      opts = {
        dimming = {
          alpha = 0.25, -- how much to dim
          color = { "Normal", "#ffffff" },
        },
        context = 20, -- lines of context to keep visible
        treesitter = true,
      },
      cmd = "Twilight",
    },
    { "RRethy/nvim-base16",          priority = 1000 },
    { "sonph/onehalf",               rtp = "vim",                                priority = 1000 },
    { "lalitmee/cobalt2.nvim",       dependencies = "tjdevries/colorbuddy.nvim", priority = 1000 },
    { "nanotech/jellybeans.vim",     priority = 1000 },

    -- ============================================================================
    -- FILE EXPLORER: NVIM-TREE
    -- ============================================================================
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
            -- Toggle file explorer
        end,
    },

    -- ============================================================================
    -- BUFFERLINE: TAB/BUTTONS FOR BUFFERS
    -- ============================================================================
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

    -- ============================================================================
    -- TELESCOPE: FUZZY FINDER
    -- ============================================================================
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
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension("file_browser")
        end,
    },

    -- ============================================================================
    -- DASHBOARD: STARTUP SCREEN
    -- ============================================================================
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
        config = function()
            -- Dashboard theme and config
            local themes = {
                { name = "Gruvbox",     value = "gruvbox" },
                { name = "Tokyo Night", value = "tokyonight" },
                { name = "Nord",        value = "nord" },
                { name = "Dracula",     value = "dracula" },
                { name = "Catppuccin",  value = "catppuccin-mocha" },
                { name = "Everforest",  value = "everforest" },
                { name = "OneDark",     value = "onedark" },
                { name = "Solarized",   value = "solarized" },
                { name = "Monokai",     value = "monokai" },
                { name = "Ayu",         value = "ayu-dark" },
                { name = "Rose Pine",   value = "rose-pine" },
                { name = "Material",    value = "material" },
                { name = "Kanagawa",    value = "kanagawa" },
                { name = "Iceberg",     value = "iceberg" },
                { name = "Base16",      value = "base16-default-dark" },
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
                        { icon = "  ", desc = "Open Folder", action = "lua open_folder()", shortcut = "Ctrl+Alt+K+O" },
                        { icon = "  ", desc = "Find File ", action = "Telescope find_files", shortcut = "Ctrl+p" },
                        { icon = "  ", desc = "Find Word ", action = "Telescope live_grep", shortcut = "Ctrl+j" },
                        { icon = "  ", desc = "Bookmarks ", action = "lua open_bookmark()", shortcut = "Ctrl+Alt+d" },
                        { icon = "  ", desc = "Recent Files", action = "Telescope oldfiles", shortcut = "Ctrl+r" },
                        { icon = "  ", desc = "Recent Projects", action = "lua open_recent_project()", shortcut = "SPC p" },
                        { icon = "  ", desc = "Keybind Cheatsheet ", action = "tabnew ~/.config/nvim/keybinds.md", shortcut = "SPC d" },
                        { icon = "  ", desc = "Theme Selector ", action = "lua theme_selector_popup()", shortcut = "SPC t" },
                        { icon = "  ", desc = "Config ", action = "edit ~/.config/nvim/init.lua", shortcut = "SPC c" },
                        { icon = "  ", desc = "Store", action = "Store", shortcut = "SPC s" },
                        { icon = "  ", desc = "Quit Neovim ", action = "qa", shortcut = "SPC q" },
                    },
                    footer = {
                        "🚀 Welcome back, Wael! Happy coding in Neovim ❤️",
                    },
                }
            })
        end,

    },

    -- ============================================================================
    -- TREESITTER: SYNTAX HIGHLIGHTING & MORE
    -- ============================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "rust", "bash", "html", "css", "javascript", "python" }, -- add "python"
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- ============================================================================
    -- SESSION MANAGER: AUTOLOAD/RESTORE SESSIONS
    -- ============================================================================
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

    -- ============================================================================
    -- AUTO PAIRS: AUTOMATICALLY CLOSE BRACKETS, PARENTHESES, ETC.
    -- ============================================================================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    -- ============================================================================
    -- AUTO COMPLETION: INTELLISENSE FOR NEOVIM
    -- ============================================================================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "Exafunction/codeium.nvim", 
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
                    { name = "codeium" },
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                experimental = {
                    ghost_text = true, -- Enable ghost text like VSCode
                },
            })
        end,
    },


    -- ============================================================================
    -- SNIPPETS: PREDEFINED CODE SNIPPETS
    -- ============================================================================
    {
        "rafamadriz/friendly-snippets",
        dependencies = "L3MON4D3/LuaSnip",
    },

    -- ============================================================================
    -- MASON: LSP SERVER MANAGEMENT
    -- ============================================================================
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- ============================================================================
    -- NOTIFICATIONS: POPUP NOTIFICATIONS
    -- ============================================================================
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#1e1e2e",
            })
        end,
    },

    -- ============================================================================
    -- UI ENHANCEMENTS: IMPROVE NEOVIM UI
    -- ============================================================================
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
    { "numToStr/Comment.nvim" },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          map("n", "]g", gs.next_hunk, "Next Git hunk")
          map("n", "[g", gs.prev_hunk, "Prev Git hunk")
          map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        end,
      },
    },

    {
      "tpope/vim-fugitive",
      cmd = { "Git", "G" },
      keys = {
        { "<leader>gg", "<cmd>Git<cr>", desc = "Open Git status (fugitive)" },
      },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_x = {
                        function()
                            local ok, status = pcall(require, "copilot.api").status
                            if ok and status and status.data and status.data.status == "Normal" then
                                return " Copilot"
                            elseif ok and status and status.data and status.data.status == "InProgress" then
                                return " Copilot (…)"
                            end
                            -- Always show icon, even if inactive
                            return ""
                        end,
                    },
                },
            })
        end,
    },

    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview (All)" },
        { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File commit history" },
        { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Project commit history" },
      },
    },
    { "lukas-reineke/indent-blankline.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "windwp/nvim-ts-autotag" },
    { "andweeb/presence.nvim" },
    { "mfussenegger/nvim-dap" },
    { "folke/trouble.nvim" },
    -- FLOATING TERMINAL
{
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      float_opts = {
        border = "curved",
      },
      open_mapping = [[<leader>t]],
    })
  end,
},

    -- ============================================================================
    -- CODEIUM AI AUTOCOMPLETE
    -- ============================================================================
    {
        "Exafunction/codeium.nvim",
        event = "InsertEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({})
        end,
    },

    -- ============================================================================
    -- MINIMAP (VSCode-like minimap)
    -- ============================================================================
    {
        "wfxr/minimap.vim",
        build = "cargo install --locked code-minimap",
        cmd = { "Minimap", "MinimapToggle" },
        config = function()
            vim.g.minimap_width = 10
            vim.g.minimap_auto_start = 1
            vim.g.minimap_auto_start_win_enter = 1
            vim.g.minimap_highlight_range = 1
            vim.g.minimap_git_colors = 1
            vim.g.minimap_block_filetypes = { "dashboard", "alpha", "starter", "lazy" }
            vim.keymap.set("n", "<leader>m", ":MinimapToggle<CR>",
                { noremap = true, silent = true, desc = "Toggle Minimap" })
        end,
    },

    {
        -- TODO / FIXME / HACK highlights + sidebar
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" })
            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })
        end,
    },

    {
        -- Diagnostic/Issue Viewer (LSP + TODOs + Git + more)
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "TroubleToggle",
        config = function()
            require("trouble").setup()
            vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
            vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
                { desc = "Document Diagnostics" })
            vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
                { desc = "Workspace Diagnostics" })
            vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List" })
            vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List" })
            vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References" })
        end,
    },

    {
        "nvzone/timerly",
        dependencies = { "nvzone/volt" },
        cmd = "TimerlyToggle",
        opts = {
            layout = {
                anchor = "NE",    -- top right
                row = 1,
                col = vim.o.columns - 20,
            },
            timers = {
                pomodoro = { work = 25, short_break = 5, long_break = 15, intervals = 4 },
            },
        },
        keys = {
            { "<leader>tp", "<cmd>TimerlyToggle<CR>", desc = "Toggle Pomodoro Timer" },
            { "<leader>ts", "<cmd>TimerlyStop<CR>",   desc = "Stop Timer" },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        opts = {},
    },

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_start = 0         -- manual start
            vim.g.mkdp_auto_close = 1         -- close when buffer is closed
            vim.g.mkdp_refresh_slow = 0       -- live preview
            vim.g.mkdp_theme = "dark"         -- theme

            -- Keybind to toggle preview
            vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", {
                noremap = true,
                silent = true,
                desc = "Toggle Markdown Preview"
            })
        end,
    },
    {
        "alex-popov-tech/store.nvim",
        dependencies = {
            "OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
        },
        cmd = "Store",
        keys = {
            { "<leader>s", "<cmd>Store<cr>", desc = "Open Plugin Store" },
        },
        opts = {
            -- optional configuration here
        },
    },

    {
      "barrett-ruth/live-server.nvim",
      build = "npm install -g live-server",
      config = true,
      cmd = { "LiveServerStart", "LiveServerStop" }
    },

    {
      "monkoose/neocodeium",
      cmd = { "NeoCodeium" },
      config = function()
        -- no config needed
      end,
    },

{
  -- Install LSP servers
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  config = true,
},

{
  -- Bridge Mason to lspconfig
  "williamboman/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "pyright",
      "clangd",
      "html",
      -- "tsserver",
      "cssls",
      "jsonls",
      "lua_ls",
      "rust_analyzer",
      "gopls",
      "jdtls",
      "intelephense",
    },
    automatic_installation = true,
  },
},

{
  -- Configure LSP servers
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    local on_attach = function(_, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      map("gd", vim.lsp.buf.definition, "Go to Definition")
      map("K", vim.lsp.buf.hover, "Hover")
      map("gr", vim.lsp.buf.references, "References")
      map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
      map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
      map("<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "Format Code")
    end

    local servers = {
      "pyright",
      "clangd",
      "html",
      "css",
      "jsonls",
      "lua_ls",
      "rust_analyzer",
      "gopls",
      "jdtls",
      "intelephense",
    }

    for _, server in ipairs(servers) do
      lspconfig[server].setup({
        on_attach = on_attach,
      })
    end

    -- 💬 Pretty diagnostics popup with border
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        focusable = false,
      },
    })

    -- Show popup on CursorHold
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end,
    })

    -- Faster CursorHold trigger
    vim.o.updatetime = 200
  end,
},

-- ============================================================================
-- LIGHTBULB: CODE ACTION INDICATOR
-- ============================================================================
{
        "kosayoda/nvim-lightbulb",
        event = "LspAttach",
        opts = {
            autocmd = {
                enabled = true,
                pattern = { "*" },
                events = { "CursorHold", "CursorHoldI" },
            },
            sign = {
                enabled = true,
                priority = 10,
            },
            virtual_text = {
                enabled = false,
            },
        },
    },
    -- lazy.nvim
{
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      -- your image configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
},
{
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,      -- keep ghost text
        auto_trigger = true,
      },
      panel = {
        enabled = true,      -- show popup panel
        auto_refresh = true,
        keymap = {
          open = "<M-CR>",   -- you can set your preferred key
        },
      },
    })
  end,
}

})
-- ============================================================================
-- WINDOW MANAGEMENT KEYBINDS
-- ============================================================================
vim.keymap.set("n", "<C-l>", function()
    vim.cmd("vsplit")
    vim.cmd(string.format("vertical resize %d", math.floor(vim.o.columns * 0.65)))
end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", function()
    vim.cmd("botright split | terminal")
    vim.cmd(string.format("resize %d", math.floor(vim.o.lines * 0.3)))
end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-k>", ":close<CR>", { noremap = true, silent = true })

-- Set colorscheme from last saved theme
local theme_file = vim.fn.stdpath("config") .. "/last_theme.txt"
local f = io.open(theme_file, "r")
if f then
    local theme = f:read("*l")
    if theme and #theme > 0 then vim.cmd("colorscheme " .. theme) end
    f:close()
else
    vim.cmd("colorscheme tokyonight")
end

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================
-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Wayland clipboard integration
vim.g.clipboard = {
    name = "wl-clipboard",
    copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
    paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --no-newline" },
    cache_enabled = true,
}

-- Editing Keymaps
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

--FLAOTING TERMINAL
vim.keymap.set("n","<leader>t",":ToggleTerm<CR>",{noremap = true , silent = true})
-- ============================================================================
-- MISCELLANEOUS KEYBINDS
-- ============================================================================
vim.keymap.set("n", "<C-d>", ":Dashboard<CR>", { noremap = true, silent = true })                                     -- Open dashboard
vim.keymap.set("n", "<C-Left>", "<C-w>W", { noremap = true, silent = true })                                          -- Move to previous pane
vim.keymap.set("n", "<C-r>", function() _G.open_recent_project() end,
    { noremap = true, silent = true, desc = "Open Recent Project" })                                              -- Open recent project
vim.keymap.set("n", "<C-R>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent Files" }) -- Recent files
vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true, desc = "New File" })                       -- New file
vim.keymap.set("n", "<leader><CR>", "o<Esc>", { noremap = true, silent = true })                                      -- Insert new line below
vim.keymap.set("n", "<C-j>", function()
    require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
end, { noremap = true, silent = true, desc = "Find Word (Current Dir)" }) -- Find word in current dir
vim.keymap.set("n", "*", "<cmd>SessionManager load_last_session<CR>",
    { noremap = true, silent = true, desc = "Last Session" })         -- Load last session

-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }) -- Disable space as key

--------------------------------------------------------------------------------
--                              BOOKMARK SYSTEM                              --
--------------------------------------------------------------------------------

local bookmark_file = vim.fn.stdpath("config") .. "/bookmarks.txt"

-- Open folder picker
vim.keymap.set("n", "<C-M-k><C-M-o>", function() _G.open_folder() end,
    { noremap = true, silent = true, desc = "Open Folder" })

-- Add current file to bookmarks
function _G.add_bookmark()
    local file = vim.fn.expand("%:p")
    if file == "" then return vim.notify("No file to bookmark!", vim.log.levels.WARN) end
    local lines = {}
    local f = io.open(bookmark_file, "r")
    if f then
        for line in f:lines() do lines[line] = true end
        f:close()
    end
    if not lines[file] then
        local f = io.open(bookmark_file, "a")
        if f then
            f:write(file .. "\n")
            f:close()
            vim.notify("Bookmarked: " .. file)
        end
    else
        vim.notify("Already bookmarked: " .. file)
    end
end

-- Get all bookmarks
function _G.get_bookmarks()
    local bookmarks = {}
    local f = io.open(bookmark_file, "r")
    if f then
        for line in f:lines() do if #line > 0 then table.insert(bookmarks, line) end end
        f:close()
    end
    return bookmarks
end

-- Open bookmark picker
function _G.open_bookmark()
    local bookmarks = _G.get_bookmarks()
    if #bookmarks == 0 then return vim.notify("No bookmarks yet!", vim.log.levels.INFO) end
    vim.ui.select(bookmarks, { prompt = "Open bookmark:" }, function(choice)
        if choice then vim.cmd("edit " .. vim.fn.fnameescape(choice)) end
    end)
end

vim.keymap.set("n", "<C-M-d>", function() _G.add_bookmark() end, { noremap = true, silent = true, desc = "Add Bookmark" }) -- Add bookmark

-- ============================================================================
-- RECENT PROJECTS FUNCTIONS AND KEYBINDS
-- ============================================================================
-- Save a folder to recent_projects.txt (ignoring trash, putting on top)
function _G.save_recent_project(dir)
    local ignore = {
        "/Pictures", "/Videos", "/Music", "/Documents",
        "/.cache", "/.local"
    }
    for _, bad in ipairs(ignore) do
        if dir:find(bad, 1, true) then return end
    end
    local file = vim.fn.stdpath("config") .. "/recent_projects.txt"
    local abs_path = vim.fn.fnamemodify(dir, ":p")
    local lines = {}
    local seen = {}
    local f = io.open(file, "r")
    if f then
        for line in f:lines() do
            if line ~= abs_path and not seen[line] then
                table.insert(lines, line)
                seen[line] = true
            end
        end
        f:close()
    end
    table.insert(lines, 1, abs_path)
    local wf = io.open(file, "w")
    if wf then
        for i = 1, math.min(#lines, 15) do
            wf:write(lines[i] .. "\n")
        end
        wf:close()
    else
        vim.notify("❌ Failed to write recent project", vim.log.levels.ERROR)
    end
end

-- Folder picker using Telescope
function _G.open_folder()
    local ok, telescope = pcall(require, "telescope")
    if ok and telescope.extensions and telescope.extensions.file_browser then
        telescope.extensions.file_browser.file_browser({
            prompt_title = "Select Folder",
            cwd = vim.loop.os_homedir(),
            hidden = true,
            respect_gitignore = false,
            select_buffer = true,
            attach_mappings = function(_, map)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local function select_dir(prompt_bufnr)
                    local entry = action_state.get_selected_entry()
                    local dir = entry and (entry.path or entry[1])
                    if dir and vim.fn.isdirectory(dir) == 1 then
                        actions.close(prompt_bufnr)
                        local abs_path = vim.fn.fnamemodify(dir, ":p")
                        vim.cmd("cd " .. vim.fn.fnameescape(abs_path))
                        vim.cmd("Dashboard")
                        require("nvim-tree.api").tree.change_root(vim.loop.cwd())
                        _G.save_recent_project(abs_path)
                    end
                end
                map("i", "<C-y>", select_dir)
                map("n", "<C-y>", select_dir)
                return true
            end,
        })
        return
    end
    vim.ui.input({ prompt = "Enter folder path: " }, function(input)
        if input and #input > 0 and vim.fn.isdirectory(input) == 1 then
            local abs_path = vim.fn.fnamemodify(input, ":p")
            vim.cmd("cd " .. vim.fn.fnameescape(abs_path))
            vim.cmd("Dashboard")
            _G.save_recent_project(abs_path)
        end
    end)
end

-- Recent project picker
function _G.open_recent_project()
    local file = vim.fn.stdpath("config") .. "/recent_projects.txt"
    local projects = {}
    local f = io.open(file, "r")
    if f then
        for line in f:lines() do
            if vim.fn.isdirectory(line) == 1 then
                table.insert(projects, line)
            end
        end
        f:close()
    end
    if #projects == 0 then
        vim.notify("🚫 No recent projects found", vim.log.levels.INFO)
        return
    end
    vim.ui.select(projects, { prompt = "🗂 Open Recent Project:" }, function(choice)
        if choice then
            vim.cmd("cd " .. vim.fn.fnameescape(choice))
            vim.cmd("Dashboard")
            require("nvim-tree.api").tree.change_root(vim.loop.cwd())
            vim.notify("📂 Opened project:\n" .. choice, vim.log.levels.INFO)
            _G.save_recent_project(choice)
        end
    end)
end

vim.keymap.set("n", "<C-M-p>", function()
    _G.open_recent_project()
end, { noremap = true, silent = true, desc = "Open Recent Project" }) -- Open recent project

--------------------------------------------------------------------------------
--                              AUTOCOMMANDS                                 --
--------------------------------------------------------------------------------

-- ============================================================================
-- AUTOCOMMANDS FOR DASHBOARD, PROJECTS, UI, ETC.
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


-- ============================================================================
-- LSP KEYBINDS
-- ============================================================================
local opts = { buffer = bufnr }

vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)                                     -- Go to definition
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)                                    -- Go to declaration
 vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)                                 -- Go to implementation
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)                                     -- Go to references
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                                           -- Hover documentation
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)                                 -- Rename symbol
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)                            -- Code action
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts) -- Format
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)                                   -- Previous diagnostic
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)                                   -- Next diagnostic

-- ============================================================================
-- MULTI-CURSOR KEYBINDS
-- ============================================================================
-- Blockwise visual selection (vertical selection)
vim.keymap.set("n", "<C-S-Down>", "<C-v>j", { noremap = true, silent = true, desc = "Block select down" }) -- Start/extend block selection down
vim.keymap.set("v", "<C-S-Down>", "j", { noremap = true, silent = true, desc = "Block select down" })      -- Extend block selection down
vim.keymap.set("n", "<C-S-Up>", "<C-v>k", { noremap = true, silent = true, desc = "Block select up" })     -- Start/extend block selection up
vim.keymap.set("v", "<C-S-Up>", "k", { noremap = true, silent = true, desc = "Block select up" })          -- Extend block selection up

-- Insert space or tab at start of block selection
vim.keymap.set("v", "<leader><Space>", "I <Esc>",
    { noremap = true, silent = true, desc = "Insert space at start of block selection" }) -- Insert space
vim.keymap.set("v", "<leader><Tab>", "I<Tab><Esc>",
    { noremap = true, silent = true, desc = "Insert tab at start of block selection" }) -- Insert tab

-- Append space or tab at end of block selection
vim.keymap.set("v", "<leader>s", "A <Esc>",
    { noremap = true, silent = true, desc = "Append space at end of block selection" }) -- Append space
vim.keymap.set("v", "<leader>t", "A<Tab><Esc>",
    { noremap = true, silent = true, desc = "Append tab at end of block selection" }) -- Append tab

-- Usage:
-- 1. Select vertically with Ctrl+Shift+Up/Down.
-- 2. Press <leader><Space> to add space at start, <leader><Tab> to add tab at start.
--    Or <leader>s to add space at end, <leader>t to add tab at end.

--TODO System
function _G.open_split_sticky_note()
    -- Get current working directory and sanitize for filename
    local cwd = vim.loop.cwd()
    local sticky_dir = vim.fn.stdpath("config") .. "/sticky_notes"
    vim.fn.mkdir(sticky_dir, "p")
    local sticky_file = sticky_dir .. "/" .. cwd:gsub("/", "%%") .. ".md" -- Unique per directory

    local default_content = {
        "## Tasks",
        "- [ ] Example task: Review config",
        "- [ ] Example task: Update plugins",
        "",
        "----------------------------------------",
        "## Notes",
        "> Start typing your notes here...",
    }

    if vim.fn.filereadable(sticky_file) == 1 then
        default_content = vim.fn.readfile(sticky_file)
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, default_content)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.4)
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
        title = "📝 Sticky Note (" .. cwd .. ")",
        title_pos = "center",
    })

    vim.cmd("startinsert")

    -- Save and close
    vim.keymap.set("n", "<leader>w", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        vim.fn.writefile(lines, sticky_file)
        vim.notify("✅ Sticky note saved for " .. cwd)
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })

    -- Close without saving
    vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })

    -- Add new task above the divider and jump to it
    vim.keymap.set("n", "<leader>tsk", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local insert_idx = 1
        for i, line in ipairs(lines) do
            if line:match("^%-+") then
                insert_idx = i
                break
            end
        end
        table.insert(lines, insert_idx, "- [ ] ")
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_win_set_cursor(win, { insert_idx + 1, 6 })
        vim.cmd("startinsert")
    end, { buffer = buf })

    -- Jump to typing section (line starts with `>`)
    vim.keymap.set("n", "<leader>n", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for i, line in ipairs(lines) do
            if line:match("^>%s") then
                vim.api.nvim_win_set_cursor(win, { i, 2 })
                vim.cmd("startinsert")
                return
            end
        end
        vim.notify("❌ Typing section not found", vim.log.levels.WARN)
    end, { buffer = buf })

    -- Toggle task done/undone
    vim.keymap.set("n", "<leader>d", function()
        local row, _ = unpack(vim.api.nvim_win_get_cursor(win))
        local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
        if line:match("^%- %[ %]") then
            line = line:gsub("%[ %]", "[x]")
        elseif line:match("^%- %[x%]") then
            line = line:gsub("%[x%]", "[ ]")
        else
            vim.notify("Not a task line", vim.log.levels.WARN)
            return
        end
        vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { line })
    end, { buffer = buf })
end

vim.keymap.set("n", "<leader>mn", _G.open_split_sticky_note, { desc = "Sticky Note" })


vim.keymap.set("n", "<leader>ih", function()
  local buf = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled(buf)
  vim.lsp.inlay_hint.enable(buf, not enabled)
  print("Inlay hints " .. (not enabled and "enabled" or "disabled"))
end, { desc = "Toggle Inlay Hints" })


vim.o.updatetime = 200  -- Add this to your options so CursorHold triggers faster


vim.keymap.set("n", "<leader>lh", function()
  local hints = {
    "LSP Shortcuts:",
    "  gd           → Go to definition",
    "  gD           → Go to declaration",
    "  gi           → Go to implementation",
    "  gr           → Find references",
    "  K            → Hover documentation",
    "  <leader>rn   → Rename symbol",
    "  <leader>ca   → Code action (💡)",
    "  <leader>f    → Format buffer",
    "  <leader>ih   → Toggle inlay hints",
    "  <leader>lh   → Show this list",
  }

  vim.notify(table.concat(hints, "\n"), vim.log.levels.INFO, { title = "LSP Hints" })
end, { desc = "Show LSP keybinds" })

-- Shortcut: Open floating terminal with <leader>ft
vim.keymap.set("n", "<leader>t", function()
  require("toggleterm").toggle(1, nil, nil, "float")
end, { noremap = true, silent = true, desc = "Open Floating Terminal" })

function _G.toggle_sticky_note_picker()
    local sticky_dir = vim.fn.stdpath("config") .. "/sticky_notes"
    local files = vim.fn.globpath(sticky_dir, "*.md", false, true)
    if #files == 0 then
        vim.notify("No sticky notes found!", vim.log.levels.INFO)
        return
    end
    vim.ui.select(files, { prompt = "Select a sticky note to open:" }, function(choice)
        if choice then
            local lines = vim.fn.readfile(choice)
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

            local width = math.floor(vim.o.columns * 0.6)
            local height = math.floor(vim.o.lines * 0.4)
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
                title = "📝 Sticky Note (" .. choice:gsub(".*/", "") .. ")",
                title_pos = "center",
            })
            vim.cmd("startinsert")
        end
    end)
end

vim.keymap.set("n", "<leader>ms", _G.toggle_sticky_note_picker, { desc = "Toggle Sticky Notes Picker" })

vim.keymap.set("n", "<leader>d", function()
  require("telescope.builtin").live_grep({
    prompt_title = "🔑 Search Keybinds Cheatsheet",
    cwd = vim.fn.stdpath("config"),
    default_text = "",
    search_dirs = { vim.fn.stdpath("config") .. "/keybinds.md" },
  })
end, { noremap = true, silent = true, desc = "Search Keybinds Cheatsheet" })

local keybinds = {
  { "General", {
    { "<C-o>", "Save" },
    { "x", "Save & Exit" },
    { "<C-q>", "Quit" },
    { "<C-c>", "Force Quit (no save)" },
    { "<C-x>", "Cut Line (clipboard)" },
    { "<C-k>", "Close side Pane" },
    { "<C-y>", "Redo" },
    { "<C-z>", "Undo" },
    { "<C-a>", "Select All" },
    { "<C-c> (V)", "Copy (visual mode)" },
    { "<C-v>", "Paste" },
    { "<C-n>", "Toggle Nvim Tree" },
    { "<Tab>", "Next Buffer" },
    { "<S-Tab>", "Prev Buffer" },
    { "<C-p>", "Telescope Find Files" },
    { "<C-l>", "Vertical Split" },
    { "<C-h>", "Horizontal Split" },
    { "<C-k>", "Close Split Pane" },
    { "<C-Left>", "Previous Pane" },
    { "<C-r>", "Telescope Recent Files" },
  }},
  { "Plugins", {
    { "<leader>t", "Floating Terminal" },
    { "<leader>mn", "Sticky Note" },
    { "<leader>ms", "Sticky Notes Picker" },
    { "<leader>mp", "Markdown Preview" },
    { "<leader>zz", "Zen Mode" },
    { "<leader>tw", "Twilight" },
    { "<leader>xx", "Trouble Toggle" },
    { "<leader>xd", "Document Diagnostics" },
    { "<leader>xw", "Workspace Diagnostics" },
    { "<leader>xl", "Location List" },
    { "<leader>xq", "Quickfix List" },
    { "gR", "LSP References" },
    { "<leader>gd", "Diffview Open" },
    { "<leader>gf", "Diffview File History (File)" },
    { "<leader>gh", "Diffview File History (Project)" },
    { "<leader>s", "Plugin Store" },
    { "<leader>tp", "Pomodoro Timer" },
    { "<leader>ts", "Stop Timer" },
  }},
  { "LSP", {
    { "gd", "Go to Definition" },
    { "gD", "Go to Declaration" },
    { "gi", "Go to Implementation" },
    { "gr", "Find References" },
    { "K", "Hover Documentation" },
    { "<leader>rn", "Rename Symbol" },
    { "<leader>ca", "Code Action" },
    { "<leader>f", "Format Buffer" },
    { "[d", "Previous Diagnostic" },
    { "]d", "Next Diagnostic" },
    { "<leader>lh", "Show LSP Keybinds" },
    { "<leader>ih", "Toggle Inlay Hints" },
  }},
  { "Bookmarks & Projects", {
    { "<C-M-d>", "Add Bookmark" },
    { "<C-M-k><C-M-o>", "Open Folder" },
    { "<C-M-p>", "Open Recent Project" },
    { "*", "Load Last Session" },
  }},
  { "Multi-Cursor", {
    { "<C-S-Up>", "Block Select Up" },
    { "<C-S-Down>", "Block Select Down" },
    { "<leader><Space>", "Insert Space at Block Start" },
    { "<leader><Tab>", "Insert Tab at Block Start" },
    { "<leader>s", "Space at Block End" },
    { "<leader>t", "Tab at Block End" },
  }},
}

function _G.show_keybinds_telescope()
  local entries = {}
  for _, section in ipairs(keybinds) do
    table.insert(entries, "󰌌  " .. section[1])
    for _, item in ipairs(section[2]) do
      table.insert(entries, string.format("   %-18s 󰁯 %s", item[1], item[2]))
    end
    table.insert(entries, "")
  end
  require("telescope.pickers").new({}, {
    prompt_title = "🧠 Keybinds Cheatsheet",
    finder = require("telescope.finders").new_table {
      results = entries,
    },
    sorter = require("telescope.config").values.generic_sorter({}),
    previewer = nil,
  }):find()
end

vim.keymap.set("n", "<leader>d", _G.show_keybinds_telescope, { desc = "Show Keybinds Cheatsheet" })
