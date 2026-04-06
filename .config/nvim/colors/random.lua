local lush = require("lush")
local hsl = lush.hsl

math.randomseed(os.time())

-- Generate a random color (HSL)
local function rnd()
  return hsl(math.random(0, 360), math.random(40, 100), math.random(30, 90))
end

-- Create highlight groups
local theme = lush(function()
  return {
    Normal { fg = rnd(), bg = rnd() },
    Comment { fg = rnd(), gui = "italic" },
    Constant { fg = rnd() },
    String { fg = rnd() },
    Identifier { fg = rnd(), gui = "bold" },
    Statement { fg = rnd() },
    Function { fg = rnd(), gui = "bold" },
    Type { fg = rnd() },
    Keyword { fg = rnd() },
    Special { fg = rnd() },
    Visual { bg = rnd() },
    LineNr { fg = rnd() },
    CursorLineNr { fg = rnd(), gui = "bold" },
    StatusLine { fg = rnd(), bg = rnd() },
    VertSplit { fg = rnd() },
    -- Add more highlight groups as you like
  }
end)

return theme
