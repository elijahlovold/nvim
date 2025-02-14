vim.g.mapleader = " "

-- Map Alt + hjkl to navigate windows
vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', { noremap = true, silent = true })  -- Move left
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', { noremap = true, silent = true })  -- Move down
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', { noremap = true, silent = true })  -- Move up
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', { noremap = true, silent = true })  -- Move right

-- remaps when entering commands
vim.cmd('cnoremap <A-j> <Down>')
vim.cmd('cnoremap <A-k> <Up>')

vim.keymap.set("n", "<leader>pwd", "<cmd>echo expand('%:p')<CR>")

vim.keymap.set("n", "<leader>R", ":vsplit | terminal<CR>i", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<A-j>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("t", "<A-k>", "<Up>", { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>P", [[viw"_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- toggle controls
vim.api.nvim_set_keymap('n', '<leader>tc', ':lua toggle_colorcolumn()<CR>', { noremap = true, silent = true })

-- some quick common dirs
vim.api.nvim_set_keymap('n', '<leader>/h', ':Oil ~/<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/r', ':Oil ~/repos<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/c', ':Oil ~/.config<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/n', ':Oil ~/.config/nvim/lua/elovold<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/N', ':Oil ~/.config/nvim/after/plugin<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/i', ':e ~/.config/i3/config<CR>', { noremap = true, silent = true })

-- Function to add N spaces at column 60
function add_spaces_to_column_n()
    local n = vim.fn.input("Number of spaces: ")
    if n:match("^%d+$") then
        n = tonumber(n)
        local spaces = string.rep(" ", n)
        vim.cmd('normal! \"ad$')
        vim.cmd("normal! i" .. spaces .. "")

        vim.cmd("normal! " .. n .. "|d$")  -- Jump to column n and delete to the end of the line
        vim.cmd('normal! \"apb')
    else
        print("Please enter a valid number.")
    end
end

-- Mapping <leader>> to the function
vim.api.nvim_set_keymap('n', '<leader>>', ':lua add_spaces_to_column_n()<CR>', { noremap = true, silent = true })

-- vim.keymap.set({'n', 'i', 'v'}, '<A-j>', '<Down>', { noremap = true })
-- vim.keymap.set({'n', 'i', 'v'}, '<A-k>', '<Up>', { noremap = true })

-- Create a function to toggle wrap and remap j/k
function toggle_wrap_and_remap()
  -- Check if line wrap is currently enabled
  local wrap_enabled = vim.wo.wrap
  
  if wrap_enabled then
    -- If wrap is enabled, disable it and restore default behavior for j/k
    vim.wo.wrap = false
    vim.api.nvim_del_keymap('n', 'j')  -- Remove gj remap
    vim.api.nvim_del_keymap('v', 'j')  -- Remove gj remap

    vim.api.nvim_del_keymap('n', 'k')  -- Remove gk remap
    vim.api.nvim_del_keymap('v', 'k')  -- Remove gk remap

    vim.api.nvim_del_keymap('n', '0')
    vim.api.nvim_del_keymap('v', '0')

    vim.api.nvim_del_keymap('n', '$')
    vim.api.nvim_del_keymap('v', '$')
  else
    -- If wrap is disabled, enable wrap and remap j/k to gj/gk
    vim.wo.wrap = true
    vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', 'j', 'gj', { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', 'k', 'gk', { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', '0', 'g0', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '0', 'g0', { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', '$', 'g$', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '$', 'g$', { noremap = true, silent = true })
  end
end

-- Map the toggle function to a key shortcut
vim.api.nvim_set_keymap('n', '<leader>w', ':lua toggle_wrap_and_remap()<CR>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<leader>pl', '<CR>:!pdflatex %<CR>', { noremap = true, silent = true })
function CompileLaTeX()
  -- Check if the current file is a .tex file
  local filetype = vim.fn.expand('%:e')
  if filetype == 'tex' then
    -- Save the current file
    vim.cmd('write')
    -- Run pdflatex and suppress output
    vim.cmd('silent !pdflatex % > /dev/null 2>&1')
  else
    print("Not a LaTeX file!")
  end
end

-- Map the function to a keybinding (e.g., <leader>p)
vim.api.nvim_set_keymap('n', '<leader>pl', ':lua CompileLaTeX()<CR>', { noremap = true, silent = true })
