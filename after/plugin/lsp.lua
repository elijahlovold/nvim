---
-- LSP configuration
---
require('mason').setup()

local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set('n', '<leader>vca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vd", function() vim.lsp.diagnostic.open_float() end, opts)
  -- vim.keymap.set("n", "[d", function() vim.lsp.diagnostic.goto_next() end, opts)
  -- vim.keymap.set("n", "]d", function() vim.lsp.diagnostic.goto_prev() end, opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Load VSCode snippets
require('luasnip.loaders.from_vscode').lazy_load()
-- Optionally, you can also load snippets from friendly-snippets
require('luasnip.loaders.from_vscode').load({include = {'*'}})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_action = require('lsp-zero').cmp_action()

-- Setup nvim-cmp with the mappings
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
    }),
})

vim.api.nvim_set_keymap('n', '<leader>tl', [[<cmd>lua ToggleLsp()<CR>]], { noremap = true, silent = true })

function ToggleLsp()
    local clients = vim.lsp.get_active_clients()
    if #clients > 0 then
        vim.cmd('LspStop')
    else
        vim.cmd('LspStart')
    end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- setup language servers
require('lspconfig').pyright.setup{
    capabilities=capabilities
}
require('lspconfig').clangd.setup{
    capabilities=capabilities
}
require('lspconfig').lua_ls.setup{
    settings = {
        Lua = {
            -- Diagnostics settings
            diagnostics = {
                globals = {'vim'},  -- Add 'vim' as a global to avoid diagnostics warnings
            },
            -- Runtime settings
            runtime = {
                version = 'LuaJIT',  -- LuaJIT is the most common version for Neovim
                path = vim.split(package.path, ';'),  -- Ensure Lua can find required modules
            },
            -- Workspace settings (including Neovim's runtime)
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),  -- Include Neovim's runtime files
            },
            -- Completion settings (optional)
            completion = {
                callSnippet = "Replace",  -- Defines how snippets are handled
            },
        },
    },
    capabilities=capabilities
}

require('lspconfig').ltex.setup{
    capabilities=capabilities
}

require('lspconfig').html.setup{
    capabilities=capabilities
}

require('lspconfig').ts_ls.setup{
    capabilities=capabilities
}
