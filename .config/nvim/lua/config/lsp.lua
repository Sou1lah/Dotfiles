-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

-- Mason setup
require("mason").setup()

-- Mason-lspconfig setup
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "clangd",
        "html",
        "cssls",
        "jsonls",
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "jdtls",
        "intelephense",
    },
    automatic_installation = true,
})

-- LSP configuration
local lspconfig = require("lspconfig")

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    
    -- LSP Keybinds
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    
    -- LSP helper keybinds
    vim.keymap.set("n", "<leader>ih", function()
        local buf = vim.api.nvim_get_current_buf()
        local enabled = vim.lsp.inlay_hint.is_enabled(buf)
        vim.lsp.inlay_hint.enable(buf, not enabled)
        print("Inlay hints " .. (not enabled and "enabled" or "disabled"))
    end, { desc = "Toggle Inlay Hints", buffer = bufnr })
    
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
    end, { desc = "Show LSP keybinds", buffer = bufnr })
end

-- Server configurations
local servers = {
    "pyright",
    "clangd",
    "html",
    "cssls",
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
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
end

-- Lua LSP specific configuration
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- Diagnostic configuration
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

-- Show diagnostics popup on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
