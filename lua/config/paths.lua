local M = {}

local home = vim.loop.os_homedir()

-- list all the necessary file paths here
M.vault = home .. "/vault"
M.vault_tags = M.vault .. "/README.md"

return M
