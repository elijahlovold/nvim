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

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.suffixesadd:append({".md"})

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

function toggle_colorcolumn()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "80"  -- Set to 80 if not set
  else
    vim.wo.colorcolumn = ""    -- Clear if it's set
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.wo.relativenumber = true
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

vim.g.netrw_icons = 1       -- Enable icons for files/folders

vim.api.nvim_create_augroup('filetypedetect', { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
  pattern = '*.spec',
  command = 'set filetype=python',
  group = 'filetypedetect',
})

-- -- Ensure nvim-web-devicons is loaded before Netrw
-- require'nvim-web-devicons'.setup()

-- -- Function to show icons in Netrw
-- vim.cmd [[
--   augroup NetrwIcons
--     autocmd!
--     autocmd FileType netrw setlocal listchars+=icon
--   augroup END
-- ]]


-- -- Netrw settings
-- vim.g.netrw_liststyle = 0        -- Use tree view (directories nested with indentation)

-- vim.api.nvim_set_keymap('n', '<leader>tn', ':lua ToggleNetrwMode()<CR>', { noremap = true, silent = true })

-- function ToggleNetrwMode()
  --   if vim.g.netrw_liststyle == 3 then
  --       print("helllo")
  --       vim.g.netrw_liststyle = 0
  --   else
  --       print("goodbye")
  --       vim.g.netrw_liststyle = 3
  --   end
  -- end

  vim.keymap.set("n", "<leader>b", function()
    vim.ui.input({ prompt = "Bible passage: " }, function(input)
      if input == nil or input == "" then return end

      local output = vim.fn.system("bible " .. input)
      local lines = vim.split(output, "\n", { plain = true })
      vim.api.nvim_put(lines, "l", true, true)  -- put below cursor, move cursor
    end)
  end, { desc = "Fetch Bible verse and copy to register" })

  -- disable zip pugin
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_gzip = 1

  vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "*.docx",
    callback = function(args)
      local filepath = vim.fn.expand(args.file)
      local tmpfile = vim.fn.tempname() .. ".txt"
      local cmd = string.format("docx2txt '%s' > '%s'", filepath, tmpfile)
      os.execute(cmd)

      -- Read contents into current buffer
      vim.cmd("silent 0read " .. tmpfile)
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "hide"
      vim.bo.swapfile = false
      vim.bo.modifiable = false
      vim.bo.readonly = true
    end,
  })
