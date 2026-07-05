-- need to load to expose manual default lua functions
local theme = require("theme.defaults")

-- attempt to load wallust theme, if available
local ok = require("theme.wallust")

if not ok then
  theme.set_default()
end
