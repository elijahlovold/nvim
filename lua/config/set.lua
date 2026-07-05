vim.opt.clipboard = "unnamedplus"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.splitright = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
local cache = os.getenv("XDG_CACHE_HOME") or vim.fn.stdpath("cache")
vim.opt.undodir = cache .. "/nvim/undodir"
vim.opt.undofile = true

vim.opt.path:append("**")

vim.opt.listchars = { trail = "·" }

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'no'
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.suffixesadd:append({".md"})

-- disable zip pugin
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1

-- init diagnostics config
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
})


-- Function to highlight the yanked text
local function highlight_yank()
  vim.highlight.on_yank { timeout = 200 }  -- Highlight for 200ms
end

-- Set up the autocommand
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = highlight_yank,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.wo.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "en_us" }
    end,
})

vim.api.nvim_create_augroup("CloseQuickfixAfterSelection", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "CloseQuickfixAfterSelection",
  pattern = "qf",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
  end,
})

vim.api.nvim_create_augroup('filetypedetect', { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
  pattern = '*.spec',
  command = 'set filetype=python',
  group = 'filetypedetect',
})
