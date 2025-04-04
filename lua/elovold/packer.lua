-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use ({
	'rose-pine/neovim',
	as = 'rose-pine', 
	config = function()
		vim.cmd('colorscheme rose-pine')
	end
  })

  use ({'Mofiqul/vscode.nvim', as = 'vscode'})
  use ({'folke/tokyonight.nvim', as = 'tokyonight'})
  use ({'EdenEast/nightfox.nvim', as = 'nightfox'})
  use ({'bluz71/vim-nightfly-colors', as = 'nightfly'})

    

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/nvim-treesitter-context')
  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use('lewis6991/gitsigns.nvim')

  use{
	  'VonHeikemen/lsp-zero.nvim', 
	  requires = {
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
	  }
  }

  use {'numToStr/Comment.nvim'}
  use {'tpope/vim-surround'}

  use {'nvim-tree/nvim-web-devicons'}
  use {"stevearc/oil.nvim"}

  use {
      'nvim-lualine/lualine.nvim',
      -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use {
      'goolord/alpha-nvim',
      requires = { 'echasnovski/mini.icons' },
      -- config = function ()
      --     require'alpha'.setup(require'alpha.themes.startify'.config)
      -- end
  }
  use "stevearc/dressing.nvim"
  use({
      "ziontee113/icon-picker.nvim",
      config = function()
          require("icon-picker").setup({
              disable_legacy_commands = true
          })
      end,
  })

  -- use {
  --     'nvim-tree/nvim-tree.lua',
  --     requires = {
  --         'nvim-tree/nvim-web-devicons', -- optional
  --     },
  -- }
  use 'RRethy/nvim-align'

  use 'eandrju/cellular-automaton.nvim'

  end)

