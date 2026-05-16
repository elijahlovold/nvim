return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    opts = {},
    config = function()
        require('render-markdown').setup({
            bullet = {
                icons = { '', '', '◆', '◇' },
            },
            checkbox = {
                bullet = true,
                left_pad = 1,
            },
            link = {
                custom = {
                    edu = { pattern = '%.edu', icon = '󰑴 ' },
                },

            },
            code = {
                border = 'thin'
            },
        })
    end
}
