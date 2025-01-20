
-- require'alpha'.setup(require'alpha.themes.startify'.config)

local alpha = require('alpha')
local startify = require('alpha.themes.startify')

-- startify.section.header.val = {
--     "                                                     ",
--     "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
--     "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
--     "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
--     "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
--     "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
--     "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
--     "                                                     ",
-- }

startify.section.top_buttons.val = {
    startify.button( "e", "  > New file"   , ":ene <BAR> startinsert <CR>"),
    startify.button( "p", "󰙅  > netrw"      , ":Oil <CR>"),
    startify.button( "f", "  > Find file"  , ":cd $HOME/repos | Telescope find_files<CR>"),
    startify.button( "c", "  > Recent"     , ":Telescope oldfiles<CR>"),
    startify.button( "r", "  > Repos"      , ":cd $HOME/repos | :Ex<CR>"),
    startify.button( "x", "󰙨  > Extensions" , ":Oil " .. vim.fn.expand('$HOME') .. "/.config/nvim/after/plugin/<CR>"),
    startify.button( "P", "  > Packer"     , ":e $HOME/.config/nvim/lua/elovold/packer.lua | :cd %:p:h<CR>"),
    startify.button( "m", "  > Remaps"     , ":e $HOME/.config/nvim/lua/elovold/remap.lua | :cd %:p:h<CR>"),
    startify.button( "q", "󰅚  > Quit NVIM"  , ":qa<CR>"),
}

startify.section.bottom_buttons.val = {}
alpha.setup(startify.config)

vim.api.nvim_set_keymap('n', '<leader>i', ':Alpha<CR>', { noremap = true, silent = true })
