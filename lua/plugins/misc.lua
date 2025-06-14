return {
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'stevearc/dressing.nvim',
  'RRethy/nvim-align',
  'eandrju/cellular-automaton.nvim',
  'OXY2DEV/markview.nvim',
  'numToStr/Comment.nvim',
  'mbbill/undotree',
  config = function()
    require("Comment").setup({ignore = '^$'})
    vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle)
  end
}
