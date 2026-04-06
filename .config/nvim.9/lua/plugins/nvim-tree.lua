require("nvim-tree").setup({
renderer = {
--note on icons:
--in some terminals, some patched fonts cut off glyphs if not given extra space
--either add extra space, disable icons, or change font
	icons = {
		show = {
		file = false,
		folder = false,
		folder_arrow = true,
		git = true,
		},
	},
},
	view = {
		width = 25,
		side = 'left',
	},
	sync_root_with_cwd = true, --fix to open cwd with tree
	respect_buf_cwd = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
		update_root = true,
	},
})

vim.g.nvim_tree_respect_buf_cwd = 1

-- use g? for bindings help while in tree
