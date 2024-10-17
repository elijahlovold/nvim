vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- some quick common dirs
vim.api.nvim_set_keymap('n', '<leader>/h', ':Ex ~/<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/r', ':Ex ~/repos<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/c', ':Ex ~/.config<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/n', ':Ex ~/.config/nvim/lua/elovold<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/N', ':Ex ~/.config/nvim/after/plugin<CR>', { noremap = true, silent = true })
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

-- Mapping <leader>i to the function
vim.api.nvim_set_keymap('n', '<leader>>', ':lua add_spaces_to_column_n()<CR>', { noremap = true, silent = true })

vim.keymap.set({'n', 'i', 'v'}, '<A-j>', '<Down>', { noremap = true })
vim.keymap.set({'n', 'i', 'v'}, '<A-k>', '<Up>', { noremap = true })
