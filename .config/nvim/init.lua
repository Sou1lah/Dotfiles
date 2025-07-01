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
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
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
 -- { "folke/which-key.nvim" },
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

-- ─────────────────────────────────────────────────────────────────────────────
--                                  KEYBINDS
-- ─────────────────────────────────────────────────────────────────────────────

-- Block all keymaps if needed
-- vim.keymap.set = function() end

-- Window Management
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

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Wayland clipboard
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
  paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --no-newline" },
  cache_enabled = true,
}

-- Keymaps: Cut/Copy/Paste/Undo/Redo/Write/Quit/Select All/Move Lines
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
vim.keymap.set("n", "<C-w>", ":bd!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("v", "<C-M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Misc
vim.keymap.set("n", "<C-d>", ":Dashboard<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", "<C-w>W", { noremap = true, silent = true })
vim.keymap.set("n", "<C-r>", function() _G.open_recent_project() end, { noremap = true, silent = true, desc = "Open Recent Project" })
vim.keymap.set("n", "<C-R>", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent Files" })vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true, desc = "New File" })
vim.keymap.set("n", "<leader><CR>", "o<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", function()
  require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
end, { noremap = true, silent = true, desc = "Find Word (Current Dir)" })
vim.keymap.set("n", "*", "<cmd>SessionManager load_last_session<CR>", { noremap = true, silent = true, desc = "Last Session" })

-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Bookmark system
local bookmark_file = vim.fn.stdpath("config") .. "/bookmarks.txt"

vim.keymap.set("n", "<C-M-k><C-M-o>", function() _G.open_folder() end, { noremap = true, silent = true, desc = "Open Folder" })

function _G.add_bookmark()
  local file = vim.fn.expand("%:p")
  if file == "" then return vim.notify("No file to bookmark!", vim.log.levels.WARN) end

  local lines = {}
  local f = io.open(bookmark_file, "r")
  if f then for line in f:lines() do lines[line] = true end f:close() end

  if not lines[file] then
    local f = io.open(bookmark_file, "a")
    if f then f:write(file .. "\n") f:close() vim.notify("Bookmarked: " .. file) end
  else
    vim.notify("Already bookmarked: " .. file)
  end
end

function _G.get_bookmarks()
  local bookmarks = {}
  local f = io.open(bookmark_file, "r")
  if f then for line in f:lines() do if #line > 0 then table.insert(bookmarks, line) end end f:close() end
  return bookmarks
end

function _G.open_bookmark()
  local bookmarks = _G.get_bookmarks()
  if #bookmarks == 0 then return vim.notify("No bookmarks yet!", vim.log.levels.INFO) end
  vim.ui.select(bookmarks, { prompt = "Open bookmark:" }, function(choice)
    if choice then vim.cmd("edit " .. vim.fn.fnameescape(choice)) end
  end)
end

vim.keymap.set("n", "<C-M-d>", function() _G.add_bookmark() end, { noremap = true, silent = true, desc = "Add Bookmark" })

-- ⬇️ Save a folder to recent_projects.txt (ignoring trash, putting on top)
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

  -- Read existing paths (excluding current one)
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

  -- Always insert new one at top
  table.insert(lines, 1, abs_path)

  -- Write to file (up to 15 entries)
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

-- ⬇️ Telescope picker for opening folders and saving them
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

  -- Fallback input
  vim.ui.input({ prompt = "Enter folder path: " }, function(input)
    if input and #input > 0 and vim.fn.isdirectory(input) == 1 then
      local abs_path = vim.fn.fnamemodify(input, ":p")
      vim.cmd("cd " .. vim.fn.fnameescape(abs_path))
      vim.cmd("Dashboard")
      _G.save_recent_project(abs_path)
    end
  end)
end

-- ⬇️ Show recent projects using vim.ui.select
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
      _G.save_recent_project(choice) -- will only move to top if not already there, no extra notification
    end
  end)
end

-- ⬇️ Keybinding to open recent projects
vim.keymap.set("n", "<C-M-p>", function()
  _G.open_recent_project()
end, { noremap = true, silent = true, desc = "Open Recent Project" })

-- ⬇️ Auto-open dashboard on startup (no files opened)
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

-- ⬇️ Auto-save folder opened from CLI as project
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
