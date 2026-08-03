-- Full border (already had)
require("full-border"):setup()

-- Git integration
require("git"):setup()

-- Starship prompt in header
require("starship"):setup()

-- zoxide (keep your existing)
require("zoxide"):setup({
	update_db = true,
})

-- Optional: Show owner/group in status (your existing function)
function Status:owner()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end
	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
	})
end
