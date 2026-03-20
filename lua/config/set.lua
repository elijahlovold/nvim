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

vim.g.netrw_icons = 1       -- Enable icons for files/folders

vim.api.nvim_create_augroup('filetypedetect', { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
  pattern = '*.spec',
  command = 'set filetype=python',
  group = 'filetypedetect',
})

-- function to grab tags from the vault location
local function get_tags()
    local paths = require("config.paths")
    local file = vim.fn.expand(paths.vault_tags)
    local lines = vim.fn.readfile(file)

    local tags = {}
    local in_section = false

    for _, line in ipairs(lines) do
        -- read until we find the # Tags section
        if not in_section then
            if line:match("^# Tags") then
                in_section = true
            end
        else
            if line:match("^%* ") then
                local tag = line:gsub("^%* ", "")
                table.insert(tags, tag)
            end
        end
    end

    return tags
end

vim.keymap.set('i', '<C-y>', function()
    local tags = get_tags()
    require('telescope.pickers').new({}, {
        prompt_title = "Select tag",
        finder = require('telescope.finders').new_table { results = tags },
        sorter = require('telescope.config').values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.api.nvim_put({selection[1]}, 'c', true, true)
                vim.cmd('startinsert!')
            end)
            return true
        end
    }):find()
end, { desc = "Pick tag" })

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

-- vim.api.nvim_create_autocmd("VimEnter", {
--   once = true,
--   callback = function()
--     if vim.fn.argc() == 0 and vim.v.oldfiles[1] and vim.fn.filereadable(vim.v.oldfiles[1]) == 1 then
--       local f = vim.fn.fnameescape(vim.v.oldfiles[1])
--       vim.cmd("edit " .. f)
--       -- signal to Lazy that we opened a file
--       vim.cmd("doautocmd BufReadPre")
--       vim.cmd("doautocmd BufReadPost")
--     end
--   end,
-- })
