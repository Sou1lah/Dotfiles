-- ============================================================================
-- NEOVIM PLUGINS CONFIGURATION
-- ============================================================================

require("lazy").setup({
  -- Colorschemes
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
  { "sainnhe/everforest",     priority = 1000 },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "deep" })
    end,
  },
  { "tanvirtin/monokai.nvim", priority = 1000 },
  { "rebelot/kanagawa.nvim",  priority = 1000 },
  { "cocopon/iceberg.vim",    priority = 1000 },
  { "RRethy/nvim-base16",     priority = 1000 },
  -- 🔥 New themes added below 🔥 --

  -- VS Code theme
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        style = "dark" -- or "light"
      })
    end,
  },
  -- Neon colors
  { "rafamadriz/neon",            priority = 1000 },

  -- Soft edge variant by everforest dev
  { "sainnhe/edge",               priority = 1000 },

  -- Light theme (good balance)
  { "NLKNguyen/papercolor-theme", priority = 1000 },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
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
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
    config = function()
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
            { icon = "  ", desc = "New File ", action = "enew", shortcut = "Ctrl+t" },
            { icon = "  ", desc = "Open Folder", action = "lua open_folder()", shortcut = "Ctrl+Alt+K+O" },
            { icon = "󰱼  ", desc = "Find File ", action = "Telescope find_files", shortcut = "Ctrl+p" },
            { icon = "󰱽  ", desc = "Find Word ", action = "Telescope live_grep", shortcut = "Ctrl+j" },
            { icon = "  ", desc = "Bookmarks ", action = "lua open_bookmark()", shortcut = "Ctrl+Alt+d" },
            { icon = "  ", desc = "Recent Files", action = "Telescope oldfiles", shortcut = "Ctrl+r" },
            { icon = "  ", desc = "Recent Projects", action = "lua open_recent_project()", shortcut = "SPC p" },
            { icon = "🛈 ", desc = "Profile", action = "Triforce stats " },
            { icon = "  ", desc = "Theme Selector ", action = "lua theme_selector_popup()", shortcut = "SPC t" },
            { icon = "  ", desc = "Config ", action = "lua open_config_dir()", shortcut = "SPC c" },
            { icon = "󰓇  ", desc = "Store", action = "Store", shortcut = "SPC s" },
            { icon = "  ", desc = "PDF Viewer", action = "PDFview", shortcut = "SPC v" }, -- <--- PDF viewer
            { icon = "  ", desc = "Telescope", action = "Telescope", shortcut = "SPC f" }, -- <--- Telescope main menu
            { icon = "󰗼  ", desc = "Quit Neovim ", action = "qa", shortcut = "SPC q" },
          },
          footer = {
            "🚀 Welcome back, Wael! Happy coding in Neovim ❤️",
          },
        }
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust", "bash", "html", "css", "javascript", "python" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Session Management
  {
    "Shatur/neovim-session-manager",
    config = function()
      local config = require("session_manager.config")
      require("snacks").setup({
        dashboard = {
          sections = {
            { section = "header" },
            {
              pane = 2,
              section = "terminal",
              cmd = "colorscript -e square",
              height = 5,
              padding = 1,
            },
            { section = "keys",  gap = 1, padding = 1 },
            {
              pane = 2,
              icon = " ",
              desc = "Browse Repo",
              padding = 1,
              key = "b",
              action = function()
                Snacks.gitbrowse()
              end,
            },
            function()
              local in_git = Snacks.git.get_root() ~= nil
              local cmds = {
                {
                  title = "Notifications",
                  cmd = "gh notify -s -a -n5",
                  action = function()
                    vim.ui.open("https://github.com/notifications")
                  end,
                  key = "n",
                  icon = " ",
                  height = 5,
                  enabled = true,
                },
                {
                  title = "Open Issues",
                  cmd = "gh issue list -L 3",
                  key = "i",
                  action = function()
                    vim.fn.jobstart("gh issue list --web", { detach = true })
                  end,
                  icon = " ",
                  height = 7,
                },
                {
                  icon = " ",
                  title = "Open PRs",
                  cmd = "gh pr list -L 3",
                  key = "P",
                  action = function()
                    vim.fn.jobstart("gh pr list --web", { detach = true })
                  end,
                  height = 7,
                },
                {
                  icon = " ",
                  title = "Git Status",
                  cmd = "git --no-pager diff --stat -B -M -C",
                  height = 10,
                },
              }
              return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                  pane = 2,
                  section = "terminal",
                  enabled = in_git,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                }, cmd)
              end, cmds)
            end,
            { section = "startup" },
          },
        },
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Mason LSP
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  -- Notifications
  -- {
  --   "rcarriga/nvim-notify",
  --   config = function()
  --     require("notify").setup({
  --       background_colour = "#1e1e2e",
  --     })
  --   end,
  -- },

  -- UI Enhancements
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup({
        notify = { enabled = false },
        lsp = {
          progress = { enabled = true },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        routes = {
          {
            filter = { event = "notify" },
            opts = { skip = false },
          },
        },
      })
      -- Set vim.notify to use Noice
      vim.notify = require("noice").notify
    end,
  },
  { "MunifTanjim/nui.nvim" },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({})
    end,
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%R>",
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
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Open Diffview (All)" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File commit history" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>",   desc = "Project commit history" },
    },
  },

  -- Utilities
  { "numToStr/Comment.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "windwp/nvim-ts-autotag" },
  { "andweeb/presence.nvim" },
  { "mfussenegger/nvim-dap" },


  -- AI
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
  -- {
  --   "zbirenbaum/copilot.lua",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = {
  --         enabled = false,
  --         auto_trigger = false,
  --       },
  --       panel = {
  --         enabled = true,
  --         auto_refresh = true,
  --         keymap = {
  --           open = "<M-CR>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  --
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Minimap
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    event = "VimEnter", -- Load on VimEnter instead of cmd
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
  -- Trouble
  {
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

  -- Todo Comments
  {
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

  -- Zen Mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        width = 80,
        options = {
          number = true,
          relativenumber = true,
        },
      },
      plugins = {
        twilight = { enabled = true },
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        kitty = { enabled = true },
      },
      on_open = function()
        vim.g.lualine_hide = true
        -- Load lualine if not loaded yet
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.hide({ unhide = false })
        end
      end,
      on_close = function()
        vim.g.lualine_hide = false
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.hide({ unhide = true })
        end
      end,
    },
    keys = {
      { "<leader>zz", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
    },
  },

  -- Twilight
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.5,
        color = { "Normal", "#ffffff" },
      },
      context = 20,
      -- treesitter = true,
    },
    cmd = "Twilight",
  },

  -- Pomodoro Timer
  {
    "nvzone/timerly",
    dependencies = { "nvzone/volt" },
    cmd = "TimerlyToggle",
    opts = {
      layout = {
        anchor = "NE",
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

  -- Markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_theme = "dark"
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", {
        noremap = true,
        silent = true,
        desc = "Toggle Markdown Preview"
      })
    end,
  },

  -- Plugin Store
  {
    "alex-popov-tech/store.nvim",
    dependencies = {
      "OXY2DEV/markview.nvim",
    },
    cmd = "Store",
    keys = {
      { "<leader>s", "<cmd>Store<cr>", desc = "Open Plugin Store" },
    },
    opts = {},
  },

  -- Live Server
  {
    "barrett-ruth/live-server.nvim",
    build = "npm install -g live-server",
    config = true,
    cmd = { "LiveServerStart", "LiveServerStop" }
  },

  -- Lightbulb
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

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      exclude = {
        filetypes = { "dashboard", "alpha", "neo-tree", "NvimTree", "lazy", "mason" },
      },
    },
  },
  -- nvim-highlight-colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    config = function()
      vim.opt.termguicolors = true
      vim.filetype.add({
        extension = {
          rasi = "rasi",
          conf = "conf",
        },
      })
      require("nvim-highlight-colors").setup {
        render = "background",
        enable_named_colors = true,
        enable_tailwind = true,
        custom_filetypes = { "rasi", "conf", "text" },
      }
    end,
  },
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant", -- Matches Lualine style
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          color_icons = true,
          indicator = {
            style = "icon", -- also try "underline" if you prefer minimal
          },
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          modified_icon = "●",
          left_trunc_marker = "",
          right_trunc_marker = "",
          enforce_regular_tabs = true,
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 18,
        },
        -- highlights = require("catppuccin.groups.integrations.bufferline").get(), -- if you use catppuccin theme
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false, -- load on startup
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- or your preferred theme
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "", right = "" } } },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " }, -- Git icons
              colored = true,
            },
          },
          lualine_c = {},
          lualine_x = {
            "diagnostics",
            -- "encoding",
            -- "fileformat",
            "filetype"
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "" } } },
        },
        tabline = nil, -- leave tabline to bufferline
      })
    end,
  },
  { "EdenEast/nightfox.nvim"
  },
  {
    'uloco/bluloco.nvim',
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      -- your optional config goes here, see below.
    end,
  },
  {
    "basola21/PDFview",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" }
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = "curved",
        },
        open_mapping = [[<C-\>]],
        shade_terminals = true,
        start_in_insert = true,
        persist_size = true,
      })
      -- Optional: keymap to toggle terminal
      vim.keymap.set("n", "<leader>tt", function()
        local dir = vim.fn.expand("%:p:h")
        if dir ~= "" then
          vim.cmd("lcd " .. dir)
        end
        vim.cmd("ToggleTerm direction=float")
      end, { desc = "Toggle Floating Terminal in File Directory" })
    end,
  },

  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      arg = "leetcode.nvim",
      lang = "cpp,python3,javascript,c", -- change to your preferred language
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },
      -- optional settings for smoother experience:
      description = {
        position = "right",
        width = "40%",
      },
      keys = {
        toggle = "<leader>lt", -- open/close
        run = "<leader>lr",    -- run code
        submit = "<leader>ls", -- submit
      },
    },
  },

  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional but recommended
      'nvim-tree/nvim-web-devicons',     -- optional for icons
    },
    config = function()
      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          code_action = '💡',
        },
        symbol_in_winbar = {
          enable = false, -- disable if you already use something like navic
        },
      })

      -- Keymaps (VS Code–like)
      local keymap = vim.keymap.set
      keymap('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', { desc = 'Peek definition' })
      keymap('n', 'gr', '<cmd>Lspsaga finder<CR>', { desc = 'LSP references' })
      keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { desc = 'Hover doc' })
      keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { desc = 'Code action' })
      keymap('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { desc = 'Rename symbol' })
      keymap('n', 'gl', '<cmd>Lspsaga show_line_diagnostics<CR>', { desc = 'Show diagnostics' })
    end,
  },
  {
    "gisketch/triforce.nvim",
    dependencies = {
      "nvzone/volt",
    },
    config = function()
      require("triforce").setup({
        -- Optional: Add your configuration here
        keymap = {
          show_profile = "<leader>tp", -- Open profile with <leader>tp
        },
      })
    end,
  },
  { 'wakatime/vim-wakatime', lazy = false },
  {
    "Sou1lah/Sticky-Notes-for-Nvim-",
    event = "VeryLazy",
    config = function()
      require("sticky-notes").setup({
        keymaps = true,
      })
    end,
    keys = {
      { "<leader>mn", "<cmd>StickyNote<cr>",       desc = "Open Sticky Note" },
      { "<leader>ms", "<cmd>StickyNotePicker<cr>", desc = "Browse Sticky Notes" },
      { "<leader>md", "<cmd>StickyNoteDelete<cr>", desc = "Delete Sticky Note" },
    },
  },
  {
    "hmdfrds/focal.nvim",
    event = "VeryLazy",
    dependencies = {
      "3rd/image.nvim", -- optional if using chafa backend
    },
    opts = {
      -- See Configuration below
    },
  },

})
