-- ============================================================================
-- CLEAN NEOVIM CONFIGURATION
-- ============================================================================

-- Add LuaRocks paths
local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.1/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

-- Leader key (must be set before loading plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load configuration modules
require("config.options")
require("config.keybinds")
require("config.plugins")
require("config.lsp")
require("config.autocommands")
require("config.abbr")

-- Load theme
local theme_file = vim.fn.stdpath("config") .. "/last_theme.txt"
local f = io.open(theme_file, "r")
if f then
  local theme = f:read("*l")
  if theme and #theme > 0 then vim.cmd("colorscheme " .. theme) end
  f:close()
else
  vim.cmd("colorscheme tokyonight")
end
