vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Function to highlight the yanked text
local function highlight_yank()
    vim.highlight.on_yank { timeout = 200 }  -- Highlight for 200ms
end

-- Set up the autocommand
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = highlight_yank,
})


vim.api.nvim_set_keymap('n', '<leader>tc', ':lua toggle_colorcolumn()<CR>', { noremap = true, silent = true })

function toggle_colorcolumn()
    if vim.wo.colorcolumn == "" then
        vim.wo.colorcolumn = "80"  -- Set to 80 if not set
    else
        vim.wo.colorcolumn = ""    -- Clear if it's set
    end
end
