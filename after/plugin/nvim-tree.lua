-- local function my_on_attach(bufnr)
--     local api = require "nvim-tree.api"

--     local function opts(desc)
--         return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
--     end

--     -- default mappings
--     api.config.mappings.default_on_attach(bufnr)

--     -- custom mappings
--     vim.keymap.set('n', '<C-CR>', function()
--         local node = api.tree.get_node_under_cursor()
--         api.tree.change_root_to_node(node)
--     end, { desc = 'Change root to selected node' })

--     -- vim.keymap.set('n', '<C-q>', function()
--     --     local buffer_path = vim.fn.expand('%:p:h')  -- Get the directory of the currently open buffer
--     --     print(buffer_path)
--     --     api.tree.change_root(buffer_path)  -- Change root to buffer's directory
--     -- end, { desc = 'Change root to current buffer directory' })

--     vim.keymap.set('n', '?',  api.tree.toggle_help,  opts('Help'))
-- end

-- require("nvim-tree").setup({
--     on_attach = my_on_attach,
--     diagnostics = {
--         enable = true,

--     },
--     view = {
--         number = true, 
--         relativenumber = true,
--     },
-- })

-- vim.keymap.set('n', '<leader>tp', '<cmd>NvimTreeToggle<CR>')

-- vim.cmd('highlight NvimTreeNormal guibg=none')
-- vim.cmd('highlight NvimTreeNormalNC guibg=#070d26')


