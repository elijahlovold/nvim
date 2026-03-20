return {
  'tpope/vim-fugitive',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'tpope/vim-abolish',
  'stevearc/dressing.nvim',
  'RRethy/nvim-align',
  'eandrju/cellular-automaton.nvim',
  -- 'OXY2DEV/markview.nvim',
  'mbbill/undotree',
  config = function()
    require("Comment").setup({ignore = '^$'})
    vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle)
  end
}
