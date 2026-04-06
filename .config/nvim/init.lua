-- ============================================================================
-- CLEAN NEOVIM CONFIGURATION
-- ============================================================================

-- Always block cursor in all modes
vim.opt.guicursor = ""


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
require("config.sound_commands")

-- Load theme
-- Theme loading
-- To enable Noctalia auto-theme: set vim.g.noctalia_theme = true in a local config
local theme_file = vim.fn.stdpath("config") .. "/last_theme.txt"
local f = io.open(theme_file, "r")
if f then
  local theme = f:read("*l")
  if theme and #theme > 0 then vim.cmd("colorscheme " .. theme) end
  f:close()
else
  vim.cmd("colorscheme tokyonight")
end
