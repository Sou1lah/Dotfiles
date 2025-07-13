-- ============================================================================
-- NEOVIM HELPER FUNCTIONS
-- ============================================================================

local bookmark_file = vim.fn.stdpath("config") .. "/bookmarks.txt"

-- Bookmark system functions
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

function _G.get_bookmarks()
    local bookmarks = {}
    local f = io.open(bookmark_file, "r")
    if f then
        for line in f:lines() do if #line > 0 then table.insert(bookmarks, line) end end
        f:close()
    end
    return bookmarks
end

function _G.open_bookmark()
    local bookmarks = _G.get_bookmarks()
    if #bookmarks == 0 then return vim.notify("No bookmarks yet!", vim.log.levels.INFO) end
    vim.ui.select(bookmarks, { prompt = "Open bookmark:" }, function(choice)
        if choice then vim.cmd("edit " .. vim.fn.fnameescape(choice)) end
    end)
end

-- Recent projects functions
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

-- Theme selector function
function _G.theme_selector_popup()
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
    
    vim.ui.select(themes, {
        prompt = "Select a theme:",
        format_item = function(item) return item.name end,
    }, function(choice)
        if choice then
            set_theme(choice.value)
        end
    end)
end

-- Sticky notes system
function _G.open_split_sticky_note()
    local cwd = vim.loop.cwd()
    local sticky_dir = vim.fn.stdpath("config") .. "/sticky_notes"
    vim.fn.mkdir(sticky_dir, "p")
    local sticky_file = sticky_dir .. "/" .. cwd:gsub("/", "%%") .. ".md"

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
end

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

-- Keybinds cheatsheet
function _G.show_keybinds_telescope()
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
