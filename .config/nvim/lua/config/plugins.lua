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
  { "RRethy/nvim-base16",          priority = 1000 },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end,
  },

  -- Telescope
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
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
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
            { icon = "  ", desc = "New File ",       action = "enew",                         shortcut = "Ctrl+t" },
            { icon = "  ", desc = "Open Folder",     action = "lua open_folder()",            shortcut = "Ctrl+Alt+K+O" },
            { icon = "  ", desc = "Find File ",      action = "Telescope find_files",         shortcut = "Ctrl+p" },
            { icon = "  ", desc = "Find Word ",      action = "Telescope live_grep",          shortcut = "Ctrl+j" },
            { icon = "  ", desc = "Bookmarks ",      action = "lua open_bookmark()",          shortcut = "Ctrl+Alt+d" },
            { icon = "  ", desc = "Recent Files",    action = "Telescope oldfiles",           shortcut = "Ctrl+r" },
            { icon = "  ", desc = "Recent Projects", action = "lua open_recent_project()",    shortcut = "SPC p" },
            { icon = "  ", desc = "Theme Selector ", action = "lua theme_selector_popup()",   shortcut = "SPC t" },
            { icon = "  ", desc = "Config ",         action = "edit ~/.config/nvim/init.lua", shortcut = "SPC c" },
            { icon = "  ", desc = "Store",           action = "Store",                        shortcut = "SPC s" },
            { icon = "  ", desc = "Quit Neovim ",    action = "qa",                           shortcut = "SPC q" },
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
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.LastSession,
        autosave_last_session = true,
        autosave_only_in_session = true,
      })
    end,
  },

  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  -- Completion
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
          ghost_text = true,
        },
      })
    end,
  },

  -- Snippets
  {
    "rafamadriz/friendly-snippets",
    dependencies = "L3MON4D3/LuaSnip",
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
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#1e1e2e",
      })
    end,
  },

  -- UI Enhancements
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

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_x = {
            function()
              local ok, client = pcall(require, "copilot.client")
              if not ok then return " OFF" end

              local status = client.status.data.status
              if status == "Normal" then
                return " ON"
              elseif status == "InProgress" then
                return " ..."
              else
                return " OFF"
              end
            end,
          },
        },
      })
    end,
  },

  -- Utilities
  { "numToStr/Comment.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "windwp/nvim-ts-autotag" },
  { "andweeb/presence.nvim" },
  { "mfussenegger/nvim-dap" },

  -- Terminal
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
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
        },
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            open = "<M-CR>",
          },
        },
      })
    end,
  },

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
          number = false,
          relativenumber = false,
        },
      },
      plugins = {
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = { enabled = false },
      },
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
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
      },
      context = 20,
      treesitter = true,
    },
    cmd = "Twilight",
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")

      -- local colors = {
      --   bg       = "#202328",
      --   fg       = "#bbc2cf",
      --   yellow   = "#ECBE7B",
      --   cyan     = "#008080",
      --   darkblue = "#081633",
      --   green    = "#98be65",
      --   orange   = "#FF8800",
      --   violet   = "#a9a1e1",
      --   magenta  = "#c678dd",
      --   blue     = "#51afef",
      --   red      = "#ec5f67",
      -- }
      -- gruvbox colors
      local colors = {
        bg = "#282828",
        fg = "#ebdbb2",
        red = "#fb4934",
        green = "#b8bb26",
        yellow = "#fabd2f",
        blue = "#83a598",
        magenta = "#d3869b",
        cyan = "#8ec07c",
        orange = "#fe8019",
        violet = "#d3869b",
      }
      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      local config = {
        options = {
          theme = {
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      -- Left components
      ins_left {
        function() return "▊" end,
        color = { fg = colors.blue },
        padding = { left = 0, right = 1 },
      }

      ins_left {
        function() return "" end,
        color = function()
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      }

      ins_left { "filesize", cond = conditions.buffer_not_empty }
      ins_left {
        "filename",
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = "bold" },
      }

      ins_left { "location" }
      ins_left { "progress", color = { fg = colors.fg, gui = "bold" } }

      ins_left {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.cyan },
        },
      }

      ins_left {
        function() return "%=" end
      }

      ins_left {
        function()
          local msg = "No Active Lsp"
          local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then return msg end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = " LSP:",
        color = { fg = "#ffffff", gui = "bold" },
      }

      -- Right components
      ins_right {
        "o:encoding",
        fmt = string.upper,
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = "bold" },
      }

      ins_right {
        "fileformat",
        fmt = string.upper,
        icons_enabled = false,
        color = { fg = colors.green, gui = "bold" },
      }

      ins_right {
        "branch",
        icon = "",
        color = { fg = colors.violet, gui = "bold" },
      }

      ins_right {
        "diff",
        symbols = { added = " ", modified = "󰝤 ", removed = " " },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      }

      ins_right {
        function() return "▊" end,
        color = { fg = colors.blue },
        padding = { left = 1 },
      }

      -- Init lualine
      lualine.setup(config)
    end,
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
  }
})
