-- theme choice is saved in a file for persistence on restart
-- could use a plugin instead, but hey, this is more fun
-- lualine theme gets stored separately due to possible naming differences

local theme_file = vim.fn.stdpath("config") .. "/lua/config/saved_theme"

_G.load_theme = function()
    local file = io.open(theme_file, "r")
	if file then
		vim.cmd("colorscheme " .. file:read("*l"))
		require("lualine").setup({ options = { theme = file:read("*l") } })
	file:close() end
end

local themes = { --add more themes here, if installed
	{ "catppuccin", "catppuccin" },
	{ "gruvbox", "gruvbox" },
	{ "pywal16", "pywal16-nvim" },
}

local current_theme_index = 1

_G.switch_theme = function()
	current_theme_index = current_theme_index % #themes + 1
	local colorscheme, lualine = unpack(themes[current_theme_index])
	vim.cmd("colorscheme " .. colorscheme)
	require("lualine").setup({ options = { theme = lualine } })
	local file = io.open(theme_file, "w")
	if file then file:write(colorscheme .. "\n" .. lualine) file:close() end
end
