return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-calc'},
    {'hrsh7th/cmp-emoji'},
    {'saadparwaiz1/cmp_luasnip'},

    -- Snippets
    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},
  },
  config = function()
    vim.lsp.config("gdscript", {
      cmd = { "nc", "127.0.0.1", "6005" },
      filetypes = { "gd", "gdscript" },
      root_dir = vim.fs.root(0, { "project.godot", ".git" }),
    })

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

    vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local opts = { buffer = ev.buf }

      vim.keymap.set('n', 'K', function()
        local ft = vim.bo.filetype

        print("filetype: " .. ft)
        if ft ~= "markdown" then
            vim.lsp.buf.hover()
            return
        end

        local word = vim.fn.expand("<cword>")
        local def = vim.fn.system("wn " .. word .. " -over")

        if def == nil or def == "" then
            return
        end

        vim.lsp.util.open_floating_preview(
            vim.split(def, "\n"),
            "text",
            { border = "single" }
        )
      end, { buffer = ev.buf })

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- dep
      vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts) -- dep
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- dep
      vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 })  end, opts)
      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
      vim.keymap.set("n", "<leader>td", '<cmd>lua ToggleDiagnostics()<CR>', opts)
      end
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        callback = function()
            vim.lsp.buf.clear_references()
        end,
    })

    -- Load VSCode snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

    local cmp = require('cmp')
    local luasnip = require('luasnip')

    -- Setup nvim-cmp with the mappings
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
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
        ['<CR>'] = cmp.mapping.confirm(),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<M-l>'] = cmp.mapping.select_next_item(),
        ['<M-h>'] = cmp.mapping.select_prev_item(),

        -- snippets
        ['<C-l>'] = function()
            luasnip.change_choice(1)
        end,
        ['<C-h>'] = function()
            luasnip.change_choice(-1)
        end,
        ['<C-CR>'] = require("luasnip.extras.select_choice"),
      }),
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'nvim_lsp' },

        -- extras
        { name = 'calc' },
      }),
    })

    -- markdown + text: add dictionary + emoji + spell
    cmp.setup.filetype({ 'markdown', 'text', 'tex' }, {
      sources = cmp.config.sources({
        { name = 'buffer' },
        { name = 'minuet' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'spell' },

        { name = 'calc' },
        { name = 'emoji' },
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

    -- Define config for each server
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    -- Enable them
    vim.lsp.enable({
      "gdscript",
      "pyright",
      "clangd",
      "rust_analyzer",
      "lua_ls",
      "html",
      "ts_ls",
      "svlangserver",
      "marksman",
    })
  end
}
