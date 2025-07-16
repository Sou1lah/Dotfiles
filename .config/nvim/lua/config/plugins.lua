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
							local ok, status = pcall(require, "copilot.api")
							if ok and status and status.status and status.status.data and status.status.data.status == "Normal" then
								return " Copilot"
							elseif ok and status and status.status and status.status.data and status.status.data.status == "InProgress" then
								return " Copilot (…)"
							end
							return ""
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

	-- Image support
	{
		"folke/snacks.nvim",
		opts = {
			image = {},
		}
	},
})
