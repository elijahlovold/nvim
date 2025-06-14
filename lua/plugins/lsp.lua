return {
  'VonHeikemen/lsp-zero.nvim',
  dependencies = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'saadparwaiz1/cmp_luasnip'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},

    -- Snippets
    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},
  },
  config = function()
    require('mason').setup()

    local lsp_zero = require('lsp-zero')

    function ToggleDiagnostics()
      local current_config = vim.diagnostic.config()

      if current_config.virtual_text then
        -- Disable diagnostics
        vim.diagnostic.config({
          virtual_text = false,
          signs = false,
          underline = false,
          update_in_insert = false,
        })
        print("Diagnostics Disabled")
      else
        -- Enable diagnostics
        vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          underline = true,
          update_in_insert = true,
        })
        print("Diagnostics Enabled")
      end
    end

    local lsp_attach = function(client, bufnr)
      local opts = {buffer = bufnr}

      vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
      vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true, formatting_options = {tabSize = 4, insertSpaces = true}})<cr>', opts)
      vim.keymap.set('n', '<leader>vrs', '<cmd>LspRestart<cr>', opts)
      vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "<leader>td", '<cmd>lua ToggleDiagnostics()<CR>', opts)
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
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      }),
    })

    vim.api.nvim_set_keymap('n', '<leader>tl', [[<cmd>lua ToggleLsp()<CR>]], { noremap = true, silent = true })

    function ToggleLsp()
      local clients = vim.lsp.get_clients()
      if #clients > 0 then
        vim.cmd('LspStop')
        print("lsp Off")
      else
        vim.cmd('LspStart')
        print("lsp On")
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

    require('lspconfig').html.setup{
      capabilities=capabilities
    }

    require('lspconfig').ts_ls.setup{
      capabilities=capabilities
    }

    require('lspconfig').svlangserver.setup{
      capabilities=capabilities
    }
  end
}
