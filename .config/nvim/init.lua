--------------------------------------------------------------------------------
--                           BASIC NEOVIM SETTINGS                           --
--------------------------------------------------------------------------------

-- Show keybind cheatsheet in a new tab
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
	-- THEMES
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
	{ "folke/twilight.nvim",         priority = 1000 },
	{ "RRethy/nvim-base16",          priority = 1000 },
	{ "sonph/onehalf",               rtp = "vim",                                priority = 1000 },
	{ "lalitmee/cobalt2.nvim",       dependencies = "tjdevries/colorbuddy.nvim", priority = 1000 },
	{ "nanotech/jellybeans.vim",     priority = 1000 },

	-- FILE EXPLORER
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- Toggle file explorer
		end,
	},

	-- BUFFERLINE UI
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
			vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true }) -- Next buffer
			vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true }) -- Previous buffer
		end,
	},

	-- TELESCOPE
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
			vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true }) -- Find files
			vim.keymap.set("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true }) -- Recent files
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},

	-- DASHBOARD
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

	-- TREESITTER
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

	-- SESSION MANAGER
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

	-- AUTO PAIRS
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},

	-- AUTO COMPLETION
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"Exafunction/codeium.nvim", -- Ensure Codeium is loaded before cmp
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
					{ name = "codeium" }, -- Codeium AI completion
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

	-- LSPCONFIG
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").tsserver.setup({})
			require("lspconfig").pyright.setup({})
		end,
	},

	-- SNIPPETS
	{
		"rafamadriz/friendly-snippets",
		dependencies = "L3MON4D3/LuaSnip",
	},

	-- MASON
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- NOTIFICATIONS
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				background_colour = "#1e1e2e",
			})
		end,
	},

	-- UI ENHANCEMENTS
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
	{ "lewis6991/gitsigns.nvim" },
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
			})
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "windwp/nvim-ts-autotag" },
	{ "andweeb/presence.nvim" },
	{ "mfussenegger/nvim-dap" },
	{ "folke/trouble.nvim" },
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "pyright", "clangd" },
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({})
			lspconfig.clangd.setup({})
		end,
	},
	--{
	--	"lukas-reineke/indent-blankline.nvim",
	--	main = "ibl",
	--	opts = {
	--		indent = { char = "│" },
	--		scope = { enabled = true },
	--	},
	--},
	-- FLOATING TERMINAL
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "float", -- can be "horizontal", "vertical", or "float"
				open_mapping = [[<C-:>]],
				float_opts = {
					border = "curved",
				},
			})
		end,
	},

	-- CODEIUM AI AUTOCOMPLETE
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

	-- MINIMAP (VSCode-like minimap)
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
		-- Pomodoro + Focus Timer with notifications
		"wthollingsworth/pomodoro.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("pomodoro").setup({
				time_work = 25,
				time_break_short = 5,
				time_break_long = 20,
				timers_to_long_break = 4
			})

			vim.keymap.set("n", "<leader>fp", "<cmd>PomodoroStart<CR>", { desc = "Start Pomodoro" })
			vim.keymap.set("n", "<leader>fs", "<cmd>PomodoroStop<CR>", { desc = "Stop Pomodoro" })
			vim.keymap.set("n", "<leader>fr", "<cmd>PomodoroRestart<CR>", { desc = "Restart Pomodoro" })
		end,
	},
{
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
})

--------------------------------------------------------------------------------
--                                 KEYBINDS                                  --
--------------------------------------------------------------------------------

-- Window Management
vim.keymap.set("n", "<C-l>", function()
	vim.cmd("vsplit")
	vim.cmd(string.format("vertical resize %d", math.floor(vim.o.columns * 0.65)))
end, { noremap = true, silent = true }) -- Vertical split

vim.keymap.set("n", "<C-h>", function()
	vim.cmd("botright split | terminal")
	vim.cmd(string.format("resize %d", math.floor(vim.o.lines * 0.3)))
end, { noremap = true, silent = true })                                       -- Horizontal split with terminal

vim.keymap.set("n", "<C-k>", ":close<CR>", { noremap = true, silent = true }) -- Close current split

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

-- Miscellaneous Keymaps
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

--------------------------------------------------------------------------------
--                           RECENT PROJECTS SYSTEM                          --
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
--                                 LSP SHORTCUTS                             --
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
--      VERTICAL MULTI-CURSOR (VSCode-like Ctrl+Shift+Up/Down) for Neovim     --
--------------------------------------------------------------------------------

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

-- Usage:
-- 1. Select vertically with Ctrl+Shift+Up/Down.
-- 2. Press <leader><Space> to add space at start, <leader><Tab> to add tab at start.
--    Or <leader>s to add space at end, <leader>t to add tab at end.

--TODO System
function _G.open_split_sticky_note()
  local sticky_file = vim.fn.stdpath("config") .. "/sticky_split_note.md"

  local default_content = {
    "- [ ] Task 1",
    "- [ ] Task 2",
    "----------------------------------------",
    "> Start typing here...",
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
    title = "📝 Sticky Note",
    title_pos = "center",
  })

  vim.cmd("startinsert")

  -- Save and close
  vim.keymap.set("n", "<leader>w", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.fn.writefile(lines, sticky_file)
    vim.notify("✅ Sticky note saved!")
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
    vim.api.nvim_win_set_cursor(win, { insert_idx + 1, 6 }) -- cursor after "- [ ] "
    vim.cmd("startinsert")
  end, { buffer = buf })

  -- Jump to typing section (line starts with `>`)
  vim.keymap.set("n", "<leader>n", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, line in ipairs(lines) do
      if line:match("^>%s") then
        vim.api.nvim_win_set_cursor(win, { i, 2 }) -- after `> `
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
