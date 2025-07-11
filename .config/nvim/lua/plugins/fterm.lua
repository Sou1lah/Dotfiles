local fterm = require("FTerm")

_G.htop = fterm:new({
	ft = 'fterm_htop',
	cmd = "htop"
})
